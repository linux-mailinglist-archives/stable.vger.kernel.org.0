Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392795796B
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 04:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfF0CV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 22:21:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfF0CV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 22:21:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 10DDA3082AF2;
        Thu, 27 Jun 2019 02:21:56 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-99.bne.redhat.com [10.64.54.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 643A160856;
        Thu, 27 Jun 2019 02:21:55 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix crash for querying symlinks stored as reparse-points
Date:   Thu, 27 Jun 2019 12:21:47 +1000
Message-Id: <20190627022147.5723-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 27 Jun 2019 02:21:56 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We never parsed/returned any data from .get_link() when the object is a windows reparse-point
containing a symlink. This results in the VFS layer oopsing accessing an uninitialized buffer:

...
[  171.407172] Call Trace:
[  171.408039]  readlink_copy+0x29/0x70
[  171.408872]  vfs_readlink+0xc1/0x1f0
[  171.409709]  ? readlink_copy+0x70/0x70
[  171.410565]  ? simple_attr_release+0x30/0x30
[  171.411446]  ? getname_flags+0x105/0x2a0
[  171.412231]  do_readlinkat+0x1b7/0x1e0
[  171.412938]  ? __ia32_compat_sys_newfstat+0x30/0x30
...

Fix this by adding code to handle these buffers and make sure we do return a valid buffer
to .get_link()

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/smb2pdu.h | 14 +++++++++++-
 2 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e921e6511728..f59758edd0f7 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2385,6 +2385,41 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	kfree(dfs_rsp);
 	return rc;
 }
+
+static int
+parse_reparse_symlink(struct reparse_symlink_data_buffer *symlink_buf,
+		      u32 plen, char **target_path,
+		      struct cifs_sb_info *cifs_sb)
+{
+	unsigned int sub_len;
+	unsigned int sub_offset;
+
+	/* We only handle Symbolic Link : MS-FSCC 2.1.2.4 */
+	if (!(le32_to_cpu(symlink_buf->ReparseTag) & 0x80000000)) {
+		cifs_dbg(VFS, "srv returned invalid symlink buffer\n");
+		return -EIO;
+	}
+
+	sub_offset = le16_to_cpu(symlink_buf->SubstituteNameOffset);
+	sub_len = le16_to_cpu(symlink_buf->SubstituteNameLength);
+	if (sub_offset + 20 > plen ||
+	    sub_offset + sub_len + 20 > plen) {
+		cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
+		return -EIO;
+	}
+
+	*target_path = cifs_strndup_from_utf16(
+				symlink_buf->PathBuffer + sub_offset,
+				sub_len, true, cifs_sb->local_nls);
+	if (!(*target_path))
+		return -ENOMEM;
+
+	convert_delimiter(*target_path, '/');
+	cifs_dbg(FYI, "%s: target path: %s\n", __func__, *target_path);
+
+	return 0;
+}
+
 #define SMB2_SYMLINK_STRUCT_SIZE \
 	(sizeof(struct smb2_err_rsp) - 1 + sizeof(struct smb2_symlink_err_rsp))
 
@@ -2414,11 +2449,13 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec close_iov[1];
 	struct smb2_create_rsp *create_rsp;
 	struct smb2_ioctl_rsp *ioctl_rsp;
-	char *ioctl_buf;
+	struct reparse_data_buffer *reparse_buf;
 	u32 plen;
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
+	*target_path = NULL;
+
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
@@ -2496,17 +2533,36 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	if ((rc == 0) && (is_reparse_point)) {
 		/* See MS-FSCC 2.3.23 */
 
-		ioctl_buf = (char *)ioctl_rsp + le32_to_cpu(ioctl_rsp->OutputOffset);
+		reparse_buf = (struct reparse_data_buffer *)
+			((char *)ioctl_rsp +
+			 le32_to_cpu(ioctl_rsp->OutputOffset));
 		plen = le32_to_cpu(ioctl_rsp->OutputCount);
 
 		if (plen + le32_to_cpu(ioctl_rsp->OutputOffset) >
 		    rsp_iov[1].iov_len) {
-			cifs_dbg(VFS, "srv returned invalid ioctl length: %d\n", plen);
+			cifs_dbg(VFS, "srv returned invalid ioctl len: %d\n",
+				 plen);
+			rc = -EIO;
+			goto querty_exit;
+		}
+
+		if (plen < 8) {
+			cifs_dbg(VFS, "reparse buffer is too small. Must be "
+				 "at least 8 bytes but was %d\n", plen);
+			rc = -EIO;
+			goto querty_exit;
+		}
+
+		if (plen < le16_to_cpu(reparse_buf->ReparseDataLength) + 8) {
+			cifs_dbg(VFS, "srv returned invalid reparse buf "
+				 "length: %d\n", plen);
 			rc = -EIO;
 			goto querty_exit;
 		}
 
-		/* Do stuff with ioctl_buf/plen */
+		rc = parse_reparse_symlink(
+			(struct reparse_symlink_data_buffer *)reparse_buf,
+			plen, target_path, cifs_sb);
 		goto querty_exit;
 	}
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index c7d5813bebd8..858353d20c39 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -914,7 +914,19 @@ struct reparse_mount_point_data_buffer {
 	__u8	PathBuffer[0]; /* Variable Length */
 } __packed;
 
-/* See MS-FSCC 2.1.2.4 and cifspdu.h for struct reparse_symlink_data */
+#define SYMLINK_FLAG_RELATIVE 0x00000001
+
+struct reparse_symlink_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__le16	SubstituteNameOffset;
+	__le16	SubstituteNameLength;
+	__le16	PrintNameOffset;
+	__le16	PrintNameLength;
+	__le32	Flags;
+	__u8	PathBuffer[0]; /* Variable Length */
+} __packed;
 
 /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
 
-- 
2.13.6

