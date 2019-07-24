Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B549173B16
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404686AbfGXT4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404404AbfGXT4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:56:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4242D205C9;
        Wed, 24 Jul 2019 19:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998199;
        bh=jrSnnPc5i3Z5aArqF4vIMzM7X95AH+aS2uXtSjz8qVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYtJFiTVf421FtDbf6Gb0uMAwyvSQf43VM/uJp1HSDRC/0aQ6hw5Mhu3PmVC6YVRc
         5SZ1tuIhl3Q+D69ylNvdgJ6ay5huUk5gc8lGDmnv0MN+BSKnLrzvcGbvq4/fCXB/r7
         ge/royKEc+0yZWb4ojFd87JVIrYebiS4byZjoiqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.1 254/371] cifs: flush before set-info if we have writeable handles
Date:   Wed, 24 Jul 2019 21:20:06 +0200
Message-Id: <20190724191743.730187293@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit aa081859b10c5d8b19f5c525c78883a59d73c2b8 upstream.

Servers can defer destaging any data and updating the mtime until close().
This means that if we do a setinfo to modify the mtime while other handles
are open for write the server may overwrite our setinfo timestamps when
if flushes the file on close() of the writeable handle.

To solve this we add an explicit flush when the mtime is about to
be updated.

This fixes "cp -p" to preserve mtime when copying a file onto an SMB2 share.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2371,6 +2371,8 @@ cifs_setattr_nounix(struct dentry *diren
 	struct inode *inode = d_inode(direntry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	struct cifsFileInfo *wfile;
+	struct cifs_tcon *tcon;
 	char *full_path = NULL;
 	int rc = -EACCES;
 	__u32 dosattr = 0;
@@ -2417,6 +2419,20 @@ cifs_setattr_nounix(struct dentry *diren
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


