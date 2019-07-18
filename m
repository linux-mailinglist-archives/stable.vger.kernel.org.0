Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5636D6C2
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 00:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfGRWMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 18:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbfGRWMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 18:12:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7AB47E421;
        Thu, 18 Jul 2019 22:12:20 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-77.bne.redhat.com [10.64.54.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0862E1001B35;
        Thu, 18 Jul 2019 22:12:19 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] cifs: flush before set-info if we have writeable handles
Date:   Fri, 19 Jul 2019 08:12:11 +1000
Message-Id: <20190718221211.22429-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 18 Jul 2019 22:12:20 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Servers can defer destaging any data and updating the mtime until close().
This means that if we do a setinfo to modify the mtime while other handles
are open for write the server may overwrite our setinfo timestamps when
if flushes the file on close() of the writeable handle.

To solve this we add an explicit flush when the mtime is about to
be updated.

This fixes "cp -p" to preserve mtime when copying a file onto an SMB2 share.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 1bffe029fb66..56ca4b8ccaba 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2406,6 +2406,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	struct inode *inode = d_inode(direntry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	struct cifsFileInfo *wfile;
+	struct cifs_tcon *tcon;
 	char *full_path = NULL;
 	int rc = -EACCES;
 	__u32 dosattr = 0;
@@ -2452,6 +2454,20 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	mapping_set_error(inode->i_mapping, rc);
 	rc = 0;
 
+	if (attrs->ia_valid & ATTR_MTIME) {
+		rc = cifs_get_writable_file(cifsInode, false, &wfile);
+		if (!rc) {
+			tcon = tlink_tcon(wfile->tlink);
+			rc = tcon->ses->server->ops->flush(xid, tcon, &wfile->fid);
+			cifsFileInfo_put(wfile);
+			if (rc)
+				return rc;
+		} else if (rc != -EBADF)
+			return rc;
+		else
+			rc = 0;
+	}
+
 	if (attrs->ia_valid & ATTR_SIZE) {
 		rc = cifs_set_file_size(inode, attrs, xid, full_path);
 		if (rc != 0)
-- 
2.13.6

