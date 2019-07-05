Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E9A602B0
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfGEIyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 04:54:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55061 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfGEIyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 04:54:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AAEFE21BBA;
        Fri,  5 Jul 2019 04:54:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 05 Jul 2019 04:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9OywUw
        1WhW02N7nYBNimxCTpWuy3xzDakDRbG4EcuLQ=; b=efdka5lqusHXzSzN3Zi4qQ
        5UnSNq9wo7Mq1JrbuQ5n47UunNtmWUk6facGuUzzrtmcvQmkZnIGSzzktvYTjzq3
        EkJ4Xv6U/Sy5DZym+ssrj6kSkuu9OxzWrHxsXnwTwlsipdWtgbNI/XYJROAfYD8M
        ZbfTt8wdmiTny101YGQmE9zSCbKmmqDsgT5OZSOl2zTYfeXyxjjQoXn0zpHY+viQ
        AeMerYrmWUiGg48qAfWKt48AojYD67TgBmKQ3QEap2ZjoNS0hoCb8PAnDN6+yz2S
        Sz9na56fHGjUBRUKVqFZoYuNhC0MiVJiJeuPrapPanEsF1i/1TZ9VTnMCnEuR6Dw
        ==
X-ME-Sender: <xms:VBAfXaERR28TLK5OGuNgcCmkOvG-NpQxDjohKY7EZZ6it6CFXp27RA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeeggddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekgedruddviedrvdegvdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:VBAfXRqoZhGzHfT0HZtgYHrASh9aFXYKGsaY5_iXZpIzKUaEqvrUdg>
    <xmx:VBAfXU4EV0M2Uw7Hdi4vVOSKRff8YD5BiD4XVowisB4xNwyGPjsEtQ>
    <xmx:VBAfXc7qthM7toWytCRlo_RupsZlVeMNZ3DSZNl6Bk7rKBqsv4m88g>
    <xmx:VBAfXYzfqDNXIXyHgEPAOptFSuJ8MiWmhbMpJRmTKTiKp8D_tT-qCA>
Received: from localhost (83-84-126-242.cable.dynamic.v4.ziggo.nl [83.84.126.242])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DC23380075;
        Fri,  5 Jul 2019 04:54:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs: fix crash querying symlinks stored as reparse-points" failed to apply to 5.1-stable tree
To:     lsahlber@redhat.com, stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 05 Jul 2019 10:54:41 +0200
Message-ID: <156231688110593@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5de254dca87ab614b9c058246ee94c58a840e358 Mon Sep 17 00:00:00 2001
From: Ronnie Sahlberg <lsahlber@redhat.com>
Date: Thu, 27 Jun 2019 14:57:02 +1000
Subject: [PATCH] cifs: fix crash querying symlinks stored as reparse-points

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
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3fdc6a41b304..9fd56b0acd7e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2372,6 +2372,41 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
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
+	if (le32_to_cpu(symlink_buf->ReparseTag) != IO_REPARSE_TAG_SYMLINK) {
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
 
@@ -2401,11 +2436,13 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
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
 
@@ -2483,17 +2520,36 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
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
 

