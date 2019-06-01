Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0D631E90
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfFANgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbfFANW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:22:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C96224A4A;
        Sat,  1 Jun 2019 13:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395349;
        bh=hLBL/cTHOcBMN1lQNxNHw35JZMtVPsn+wl0AUg4NFh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aB89DbCu5U7yi9c0qBLqpkSRxBgBZIoZ/zLtAFdonYebTCNEOP/1EiJQHlieYuyDc
         +WMv1An/ITc+M4vmNQnhq2sgUNC0Ji7WxMg7fCy3wLNydcMu3LtPJ7Lv+II15708Tq
         jk0JJOtobNSyHmzEZjf40B/OmgeLDv9JZ3UywrRc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Steven Price <steven.price@arm.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Guan Xuetao <gxt@pku.edu.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 011/141] initramfs: free initrd memory if opening /initrd.image fails
Date:   Sat,  1 Jun 2019 09:19:47 -0400
Message-Id: <20190601132158.25821-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

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
index f6f4a1e4cd547..cd5fb00fcb549 100644
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
 	/*
 	 * Try loading default modules from initramfs.  This gives
-- 
2.20.1

