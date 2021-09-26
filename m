Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8D94188A3
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhIZMfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIZMe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A6E61019;
        Sun, 26 Sep 2021 12:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632659603;
        bh=UZl24eJoWhaXtsVuTcKFuSQ3kLNwYIz2FIo6x/UML0I=;
        h=Subject:To:Cc:From:Date:From;
        b=XXed8+ctOzMLAWjEkbRI8W8cYc4sXxCd+yc/QEdtbOqdGwI6E4Fo9FOhHloiuer2B
         2TgmF6ajVPV3CpcCK5aBzpuwE4BDEmDJlAE4RwtuFjEURWTGpMt1VwVeCZ40QtXtt9
         jCOY8nDmbchpM+vFDCFcZOu+xg2le70/7PZsQbAo=
Subject: FAILED: patch "[PATCH] cifs: Clear modified attribute bit from inode flags" failed to apply to 5.14-stable tree
To:     stfrench@microsoft.com, lsahlber@redhat.com, pc@cjr.nz,
        rohiths@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 14:33:20 +0200
Message-ID: <1632659600195108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4f22262280ccb5c0a18a42029313938aabfaff12 Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Thu, 23 Sep 2021 12:42:35 -0500
Subject: [PATCH] cifs: Clear modified attribute bit from inode flags

Clear CIFS_INO_MODIFIED_ATTR bit from inode flags after
updating mtime and ctime

Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0ab5bb24b8ca..13f3182cf796 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -884,7 +884,7 @@ int cifs_close(struct inode *inode, struct file *file)
 		    cinode->lease_granted &&
 		    !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags) &&
 		    dclose) {
-			if (test_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {
+			if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {
 				inode->i_ctime = inode->i_mtime = current_time(inode);
 				cifs_fscache_update_inode_cookie(inode);
 			}

