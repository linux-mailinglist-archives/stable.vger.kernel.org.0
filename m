Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECEF412F19
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 09:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhIUHL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 03:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230130AbhIUHLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 03:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB847611BD;
        Tue, 21 Sep 2021 07:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632208174;
        bh=7ofNlL3c4lP/13hjqf6zGzKc6uN3SMTyvPXBvJqrjBE=;
        h=Subject:To:From:Date:From;
        b=ddhaE0d+13y03rQRxVnG1P6jCkCF4ebq1UVpNLdt+PuXR7/szWHrJ8McwLFySxF//
         pNb366l9iMBJTNnyEhyJIB94MxDmBTUDG4Uv5n2SVDRFeQVJDxev/DU/GHv9g8zP0V
         PuJUcyOikvj+KensFsR1mFWVpIZOsloXI+FTRbrE=
Subject: patch "debugfs: debugfs_create_file_size(): use IS_ERR to check for error" added to driver-core-linus
To:     nirmoy.das@amd.com, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 09:09:26 +0200
Message-ID: <1632208166104180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    debugfs: debugfs_create_file_size(): use IS_ERR to check for error

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From af505cad9567f7a500d34bf183696d570d7f6810 Mon Sep 17 00:00:00 2001
From: Nirmoy Das <nirmoy.das@amd.com>
Date: Thu, 2 Sep 2021 12:29:17 +0200
Subject: debugfs: debugfs_create_file_size(): use IS_ERR to check for error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

debugfs_create_file() returns encoded error so use IS_ERR for checking
return value.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Fixes: ff9fb72bc077 ("debugfs: return error values, not NULL")
Cc: stable <stable@vger.kernel.org>
References: https://gitlab.freedesktop.org/drm/amd/-/issues/1686
Link: https://lore.kernel.org/r/20210902102917.2233-1-nirmoy.das@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 8129a430d789..2f117c57160d 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -528,7 +528,7 @@ void debugfs_create_file_size(const char *name, umode_t mode,
 {
 	struct dentry *de = debugfs_create_file(name, mode, parent, data, fops);
 
-	if (de)
+	if (!IS_ERR(de))
 		d_inode(de)->i_size = file_size;
 }
 EXPORT_SYMBOL_GPL(debugfs_create_file_size);
-- 
2.33.0


