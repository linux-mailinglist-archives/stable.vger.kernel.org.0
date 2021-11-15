Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E764F450BF6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbhKORcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:32:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237451AbhKORah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:30:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C7D263296;
        Mon, 15 Nov 2021 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996784;
        bh=F0+Zb4KxsOJHT0DIgWzdi/fAc8CXnSmGh8O6Vv6jp8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kb7WedV4/H2+tfR3xWUK9MxafkG2jEs9Nvs8NsoDZSpeE/ocoPdOImlolTqDupcNc
         yYPr8H0qsNKy0RA4emo0py87rDPZXenH8jyUhEuHYOcQdf3R1OGGAp6nZKtLaxgrco
         ZqgmxuOC044PZcgL22j1vQhIk7OUyQySObFMNyrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 266/355] JFS: fix memleak in jfs_mount
Date:   Mon, 15 Nov 2021 18:03:10 +0100
Message-Id: <20211115165322.345621150@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit c48a14dca2cb57527dde6b960adbe69953935f10 ]

In jfs_mount, when diMount(ipaimap2) fails, it goes to errout35. However,
the following code does not free ipaimap2 allocated by diReadSpecial.

Fix this by refactoring the error handling code of jfs_mount. To be
specific, modify the lable name and free ipaimap2 when the above error
ocurrs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_mount.c | 51 ++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index 616de103dccc5..d41733540df91 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -80,14 +80,14 @@ int jfs_mount(struct super_block *sb)
 	 * (initialize mount inode from the superblock)
 	 */
 	if ((rc = chkSuper(sb))) {
-		goto errout20;
+		goto out;
 	}
 
 	ipaimap = diReadSpecial(sb, AGGREGATE_I, 0);
 	if (ipaimap == NULL) {
 		jfs_err("jfs_mount: Failed to read AGGREGATE_I");
 		rc = -EIO;
-		goto errout20;
+		goto out;
 	}
 	sbi->ipaimap = ipaimap;
 
@@ -98,7 +98,7 @@ int jfs_mount(struct super_block *sb)
 	 */
 	if ((rc = diMount(ipaimap))) {
 		jfs_err("jfs_mount: diMount(ipaimap) failed w/rc = %d", rc);
-		goto errout21;
+		goto err_ipaimap;
 	}
 
 	/*
@@ -107,7 +107,7 @@ int jfs_mount(struct super_block *sb)
 	ipbmap = diReadSpecial(sb, BMAP_I, 0);
 	if (ipbmap == NULL) {
 		rc = -EIO;
-		goto errout22;
+		goto err_umount_ipaimap;
 	}
 
 	jfs_info("jfs_mount: ipbmap:0x%p", ipbmap);
@@ -119,7 +119,7 @@ int jfs_mount(struct super_block *sb)
 	 */
 	if ((rc = dbMount(ipbmap))) {
 		jfs_err("jfs_mount: dbMount failed w/rc = %d", rc);
-		goto errout22;
+		goto err_ipbmap;
 	}
 
 	/*
@@ -138,7 +138,7 @@ int jfs_mount(struct super_block *sb)
 		if (!ipaimap2) {
 			jfs_err("jfs_mount: Failed to read AGGREGATE_I");
 			rc = -EIO;
-			goto errout35;
+			goto err_umount_ipbmap;
 		}
 		sbi->ipaimap2 = ipaimap2;
 
@@ -150,7 +150,7 @@ int jfs_mount(struct super_block *sb)
 		if ((rc = diMount(ipaimap2))) {
 			jfs_err("jfs_mount: diMount(ipaimap2) failed, rc = %d",
 				rc);
-			goto errout35;
+			goto err_ipaimap2;
 		}
 	} else
 		/* Secondary aggregate inode table is not valid */
@@ -167,7 +167,7 @@ int jfs_mount(struct super_block *sb)
 		jfs_err("jfs_mount: Failed to read FILESYSTEM_I");
 		/* open fileset secondary inode allocation map */
 		rc = -EIO;
-		goto errout40;
+		goto err_umount_ipaimap2;
 	}
 	jfs_info("jfs_mount: ipimap:0x%p", ipimap);
 
@@ -177,41 +177,34 @@ int jfs_mount(struct super_block *sb)
 	/* initialize fileset inode allocation map */
 	if ((rc = diMount(ipimap))) {
 		jfs_err("jfs_mount: diMount failed w/rc = %d", rc);
-		goto errout41;
+		goto err_ipimap;
 	}
 
-	goto out;
+	return rc;
 
 	/*
 	 *	unwind on error
 	 */
-      errout41:		/* close fileset inode allocation map inode */
+err_ipimap:
+	/* close fileset inode allocation map inode */
 	diFreeSpecial(ipimap);
-
-      errout40:		/* fileset closed */
-
+err_umount_ipaimap2:
 	/* close secondary aggregate inode allocation map */
-	if (ipaimap2) {
+	if (ipaimap2)
 		diUnmount(ipaimap2, 1);
+err_ipaimap2:
+	/* close aggregate inodes */
+	if (ipaimap2)
 		diFreeSpecial(ipaimap2);
-	}
-
-      errout35:
-
-	/* close aggregate block allocation map */
+err_umount_ipbmap:	/* close aggregate block allocation map */
 	dbUnmount(ipbmap, 1);
+err_ipbmap:		/* close aggregate inodes */
 	diFreeSpecial(ipbmap);
-
-      errout22:		/* close aggregate inode allocation map */
-
+err_umount_ipaimap:	/* close aggregate inode allocation map */
 	diUnmount(ipaimap, 1);
-
-      errout21:		/* close aggregate inodes */
+err_ipaimap:		/* close aggregate inodes */
 	diFreeSpecial(ipaimap);
-      errout20:		/* aggregate closed */
-
-      out:
-
+out:
 	if (rc)
 		jfs_err("Mount JFS Failure: %d", rc);
 
-- 
2.33.0



