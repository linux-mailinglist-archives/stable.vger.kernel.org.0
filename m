Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526671ACAD1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395448AbgDPPkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897598AbgDPNh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:37:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03DCC20732;
        Thu, 16 Apr 2020 13:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044276;
        bh=zHhjz7bAC4lCz9BDYxtMEQD9e9rotebVujj8UYfL8g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llXKZZ1uBEG3U56TLRovf9rFYcDdYx+pbs7xCJ9Ms2MVOmvQtr4t8KQkfaeTs4U3d
         th579LuJTLCIEIi6bipnwl1lvEow5FKxH19deWx+jJn/BrFXxEofCDfjOKuBj64MZf
         vCKGtNTYGj7AxgTvRQus6272GpDj27bdLPJW8JcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.5 151/257] smb3: fix performance regression with setting mtime
Date:   Thu, 16 Apr 2020 15:23:22 +0200
Message-Id: <20200416131345.391321329@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit cf5371ae460eb8e484e4884747af270c86c3c469 upstream.

There are cases when we don't want to send the SMB2 flush operation
(e.g. when user specifies mount parm "nostrictsync") and it can be
a very expensive operation on the server.  In most cases in order
to set mtime, we simply need to flush (write) the dirtry pages from
the client and send the writes to the server not also send a flush
protocol operation to the server.

Fixes: aa081859b10c ("cifs: flush before set-info if we have writeable handles")
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2517,25 +2517,26 @@ cifs_setattr_nounix(struct dentry *diren
 
 	/*
 	 * Attempt to flush data before changing attributes. We need to do
-	 * this for ATTR_SIZE and ATTR_MTIME for sure, and if we change the
-	 * ownership or mode then we may also need to do this. Here, we take
-	 * the safe way out and just do the flush on all setattr requests. If
-	 * the flush returns error, store it to report later and continue.
+	 * this for ATTR_SIZE and ATTR_MTIME.  If the flush of the data
+	 * returns error, store it to report later and continue.
 	 *
 	 * BB: This should be smarter. Why bother flushing pages that
 	 * will be truncated anyway? Also, should we error out here if
-	 * the flush returns error?
+	 * the flush returns error? Do we need to check for ATTR_MTIME_SET flag?
 	 */
-	rc = filemap_write_and_wait(inode->i_mapping);
-	if (is_interrupt_error(rc)) {
-		rc = -ERESTARTSYS;
-		goto cifs_setattr_exit;
+	if (attrs->ia_valid & (ATTR_MTIME | ATTR_SIZE | ATTR_CTIME)) {
+		rc = filemap_write_and_wait(inode->i_mapping);
+		if (is_interrupt_error(rc)) {
+			rc = -ERESTARTSYS;
+			goto cifs_setattr_exit;
+		}
+		mapping_set_error(inode->i_mapping, rc);
 	}
 
-	mapping_set_error(inode->i_mapping, rc);
 	rc = 0;
 
-	if (attrs->ia_valid & ATTR_MTIME) {
+	if ((attrs->ia_valid & ATTR_MTIME) &&
+	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
 		rc = cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wfile);
 		if (!rc) {
 			tcon = tlink_tcon(wfile->tlink);


