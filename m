Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E2F3F66CC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbhHXR10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239780AbhHXRZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4625961371;
        Tue, 24 Aug 2021 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824645;
        bh=RY9B9PnT2nmYguFTNFdS5JiDp9YawCsTPsaJ/DLOTZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1hd0ArkFprCr8hSvf6eEtyPWDjb3cNzSn8iUJRKBuj56BadPj7LmHmO+f+RmRrEC
         sqepo3yB4x4PmvxXDsm9By8Bzr3yTsrOOJ+0bVuOsVGxGvfxS0eQbSTzvjuRSPWGyx
         T4KiR+0WhtLEPl3pKw9HCLfvgdAa2MLuOhU0SH1LiJ8bUlnZJ3ryatX78EjrZGVVQ2
         PxuXb++BylKy1R3Fegq/JzlL6LZYfHTh+z7yDhFCwYC5CmjOHgbfhb2VzxTyZhdxNr
         RhMgIj7Ud7Q3C8oZEqPcHGgPAZpZHGiAH8uEx8pQaDkXZ7hpR6ZwNicLQtvThOJF/Z
         4uq5+5IocrrVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 77/84] ipack: tpci200: fix memory leak in the tpci200_register
Date:   Tue, 24 Aug 2021 13:02:43 -0400
Message-Id: <20210824170250.710392-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 50f05bd114a46a74726e432bf81079d3f13a55b7 ]

The error handling code in tpci200_register does not free interface_regs
allocated by ioremap and the current version of error handling code is
problematic.

Fix this by refactoring the error handling code and free interface_regs
when necessary.

Fixes: 43986798fd50 ("ipack: add error handling for ioremap_nocache")
Cc: stable@vger.kernel.org
Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Link: https://lore.kernel.org/r/20210810100323.3938492-2-mudongliangabcd@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ipack/carriers/tpci200.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 2172d1efa71e..4c8da6af2516 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -259,7 +259,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_disable_pci;
+		goto err_disable_device;
 	}
 
 	/* Request IO ID INT space (Bar 3) */
@@ -271,7 +271,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 3 !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ip_space;
+		goto err_ip_interface_bar;
 	}
 
 	/* Request MEM8 space (Bar 5) */
@@ -282,7 +282,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 5!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
+		goto err_io_id_int_spaces_bar;
 	}
 
 	/* Request MEM16 space (Bar 4) */
@@ -293,7 +293,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_mem8_space;
+		goto err_mem8_space_bar;
 	}
 
 	/* Map internal tpci200 driver user space */
@@ -307,7 +307,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
 		res = -ENOMEM;
-		goto out_release_mem8_space;
+		goto err_mem16_space_bar;
 	}
 
 	/* Initialize lock that protects interface_regs */
@@ -346,18 +346,22 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) unable to register IRQ !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
+		goto err_interface_regs;
 	}
 
 	return 0;
 
-out_release_mem8_space:
+err_interface_regs:
+	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
+err_mem16_space_bar:
+	pci_release_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR);
+err_mem8_space_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
-out_release_ioid_int_space:
+err_io_id_int_spaces_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
-out_release_ip_space:
+err_ip_interface_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
-out_disable_pci:
+err_disable_device:
 	pci_disable_device(tpci200->info->pdev);
 	return res;
 }
-- 
2.30.2

