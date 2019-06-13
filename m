Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B351E44072
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390863AbfFMQG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731311AbfFMIpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:45:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2036820851;
        Thu, 13 Jun 2019 08:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415549;
        bh=DauZ1dZsajBuY1y4EhU7kcsZhNdUjqC0GJmgfMcq2oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IX2AGhMkMmz5Vr9gItfEnYLyVrptkxSfKsaNQLEBDv+lC6SdZOzus7GFqmc8coxZI
         bT4NUSte7dc2QpuNrMHv1eWf0q2HCUzhQxxwulF4ClipL/NZeS8QdXTm4UC0qTwLVT
         AyZ8AWQVW2KSjYg1raTTIqbgx6mCsWh9pF7wKeUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Steven Price <steven.price@arm.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Guan Xuetao <gxt@pku.edu.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.1 017/155] initramfs: free initrd memory if opening /initrd.image fails
Date:   Thu, 13 Jun 2019 10:32:09 +0200
Message-Id: <20190613075653.729085755@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 54c7a8916a887f357088f99e9c3a7720cd57d2c8 ]

Patch series "initramfs tidyups".

I've spent some time chasing down behavior in initramfs and found
plenty of opportunity to improve the code.  A first stab on that is
contained in this series.

This patch (of 7):

We free the initrd memory for all successful or error cases except for the
case where opening /initrd.image fails, which looks like an oversight.

Steven said:

: This also changes the behaviour when CONFIG_INITRAMFS_FORCE is enabled
: - specifically it means that the initrd is freed (previously it was
: ignored and never freed).  But that seems like reasonable behaviour and
: the previous behaviour looks like another oversight.

Link: http://lkml.kernel.org/r/20190213174621.29297-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 4749e1115eef..c322e1099f43 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -612,13 +612,12 @@ static int __init populate_rootfs(void)
 		printk(KERN_INFO "Trying to unpack rootfs image as initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start);
-		if (!err) {
-			free_initrd();
+		if (!err)
 			goto done;
-		} else {
-			clean_rootfs();
-			unpack_to_rootfs(__initramfs_start, __initramfs_size);
-		}
+
+		clean_rootfs();
+		unpack_to_rootfs(__initramfs_start, __initramfs_size);
+
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
 		fd = ksys_open("/initrd.image",
@@ -632,7 +631,6 @@ static int __init populate_rootfs(void)
 				       written, initrd_end - initrd_start);
 
 			ksys_close(fd);
-			free_initrd();
 		}
 	done:
 		/* empty statement */;
@@ -642,9 +640,9 @@ static int __init populate_rootfs(void)
 			initrd_end - initrd_start);
 		if (err)
 			printk(KERN_EMERG "Initramfs unpacking failed: %s\n", err);
-		free_initrd();
 #endif
 	}
+	free_initrd();
 	flush_delayed_fput();
 	return 0;
 }
-- 
2.20.1



