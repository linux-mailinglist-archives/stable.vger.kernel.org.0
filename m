Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1545157906
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 03:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfF0Boy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 21:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfF0Boy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 21:44:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4C1730860A5;
        Thu, 27 Jun 2019 01:44:53 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-99.bne.redhat.com [10.64.54.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44CAF5D719;
        Thu, 27 Jun 2019 01:44:53 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix crash for querying symlinks stored as reparse-points
Date:   Thu, 27 Jun 2019 11:44:31 +1000
Message-Id: <20190627014431.12685-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 27 Jun 2019 01:44:53 +0000 (UTC)
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
 fs/cifs/smb2ops.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h | 14 ++++++++++++-
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e921e6511728..69feb8c27dea 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2385,6 +2385,46 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
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
+		cifs_dbg(VFS, "srv returned invalid sublink buffer\n");
+		return -EIO;
+	}
+
+	if (!(le32_to_cpu(symlink_buf->Flags) & SYMLINK_FLAG_RELATIVE)) {
+		cifs_dbg(VFS, "srv returned absolute symlink\n");
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
 
@@ -2414,11 +2454,13 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
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
 
@@ -2496,7 +2538,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	if ((rc == 0) && (is_reparse_point)) {
 		/* See MS-FSCC 2.3.23 */
 
-		ioctl_buf = (char *)ioctl_rsp + le32_to_cpu(ioctl_rsp->OutputOffset);
+		reparse_buf = (struct reparse_data_buffer *)((char *)ioctl_rsp + le32_to_cpu(ioctl_rsp->OutputOffset));
 		plen = le32_to_cpu(ioctl_rsp->OutputCount);
 
 		if (plen + le32_to_cpu(ioctl_rsp->OutputOffset) >
@@ -2506,7 +2548,19 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 			goto querty_exit;
 		}
 
-		/* Do stuff with ioctl_buf/plen */
+		if (plen < 8) {
+			cifs_dbg(VFS, "reparse buffer is too small. Must be at least 8 bytes but was %d\n", plen);
+			rc = -EIO;
+			goto querty_exit;
+		}
+
+		if (plen < le16_to_cpu(reparse_buf->ReparseDataLength) + 8) {
+			cifs_dbg(VFS, "srv returned invalid reparse buf length: %d\n", plen);
+			rc = -EIO;
+			goto querty_exit;
+		}
+
+		rc = parse_reparse_symlink((struct reparse_symlink_data_buffer *)reparse_buf, plen, target_path, cifs_sb);
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

