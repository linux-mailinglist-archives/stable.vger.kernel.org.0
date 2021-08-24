Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB34B3F643D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238686AbhHXRCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238603AbhHXRAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11F8D6152B;
        Tue, 24 Aug 2021 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824267;
        bh=IBS659XqIUQKtV/xJFd6tq5k6v9GnO8pnjpKLmyx/g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZ0fuZGJBguDtfcY17TWVJ7lq7wbH+dbaP/p/2l8sfyYyD2L0D7EWApk9dFMiVnEz
         63ZKENnCnC6sDtAVlLPFUzZmQXAMq/GWTmxEX0dNwO3XliQKLqzoSR7XHa7G87hZUw
         vgi5hWq3DuaEWA3OR4e57ycGsSb+Ds1jiRERf5yWHXNpMcAnriw6OpQhIbu1Gv8lLl
         nJrC6kHLQawqm+24qs6K2YruFw7Jv5akyKz+mpwphESMtaBzybhec//NCkF4w6iJpQ
         cB7Zrry2Vkf92NK0b4daVEBbUweqhdLy65cYP+dy77jojuLW4hR+ocX/dBPBiKOvwS
         ejB6T2zt6vT/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 101/127] ipack: tpci200: fix memory leak in the tpci200_register
Date:   Tue, 24 Aug 2021 12:55:41 -0400
Message-Id: <20210824165607.709387-102-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index 33a1b17a2628..c1098f40e03f 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -256,7 +256,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_disable_pci;
+		goto err_disable_device;
 	}
 
 	/* Request IO ID INT space (Bar 3) */
@@ -268,7 +268,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 3 !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ip_space;
+		goto err_ip_interface_bar;
 	}
 
 	/* Request MEM8 space (Bar 5) */
@@ -279,7 +279,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 5!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
+		goto err_io_id_int_spaces_bar;
 	}
 
 	/* Request MEM16 space (Bar 4) */
@@ -290,7 +290,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_mem8_space;
+		goto err_mem8_space_bar;
 	}
 
 	/* Map internal tpci200 driver user space */
@@ -304,7 +304,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
 		res = -ENOMEM;
-		goto out_release_mem8_space;
+		goto err_mem16_space_bar;
 	}
 
 	/* Initialize lock that protects interface_regs */
@@ -343,18 +343,22 @@ static int tpci200_register(struct tpci200_board *tpci200)
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

