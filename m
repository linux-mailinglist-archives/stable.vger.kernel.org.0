Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DBFB8582
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393077AbfISWVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394093AbfISWVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:21:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9502E21929;
        Thu, 19 Sep 2019 22:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931710;
        bh=bRsAxFnPqRa/ULryThKuGPhEruKmIEKhenR1lgj5BM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVLxWenULCxvlcCo5GvKokJp7bwm/vtrjcghlzbXmADekdCMGMnhWEK+r5hv+oUIU
         BDNYllNd/7aQY9IgsfkmBIH9YLr5QqoQJZUd1ZKDhb3gr7tyjC7+EteZn+ruMHEF9P
         05TRkVJ4smQO9M9R4ZgDMKgKZ/hBetHtny6wZSr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        Christoph Hellwig <hch@lst.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/56] Revert "MIPS: SiByte: Enable swiotlb for SWARM, LittleSur and BigSur"
Date:   Fri, 20 Sep 2019 00:03:53 +0200
Message-Id: <20190919214750.343452262@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c890a458e27210d1a749a18941047a9e4209fa93 which is
commit e4849aff1e169b86c561738daf8ff020e9de1011 upstream

Guenter writes:
	Upstream commit e4849aff1e16 ("MIPS: SiByte: Enable swiotlb for SWARM,
	LittleSur and BigSur") results in build failures in v4.4.y and v4.14.y.

	make bigsur_defconfig:

	warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
	warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)

	and the actual build:

	lib/swiotlb.o: In function `swiotlb_tbl_map_single':
	(.text+0x1c0): undefined reference to `iommu_is_span_boundary'
	Makefile:1021: recipe for target 'vmlinux' failed

Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Kconfig                |    3 ---
 arch/mips/sibyte/common/Makefile |    1 -
 arch/mips/sibyte/common/dma.c    |   14 --------------
 3 files changed, 18 deletions(-)
 delete mode 100644 arch/mips/sibyte/common/dma.c

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -761,7 +761,6 @@ config SIBYTE_SWARM
 	select SYS_SUPPORTS_HIGHMEM
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select ZONE_DMA32 if 64BIT
-	select SWIOTLB if ARCH_DMA_ADDR_T_64BIT && PCI
 
 config SIBYTE_LITTLESUR
 	bool "Sibyte BCM91250C2-LittleSur"
@@ -784,7 +783,6 @@ config SIBYTE_SENTOSA
 	select SYS_HAS_CPU_SB1
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
-	select SWIOTLB if ARCH_DMA_ADDR_T_64BIT && PCI
 
 config SIBYTE_BIGSUR
 	bool "Sibyte BCM91480B-BigSur"
@@ -798,7 +796,6 @@ config SIBYTE_BIGSUR
 	select SYS_SUPPORTS_HIGHMEM
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select ZONE_DMA32 if 64BIT
-	select SWIOTLB if ARCH_DMA_ADDR_T_64BIT && PCI
 
 config SNI_RM
 	bool "SNI RM200/300/400"
--- a/arch/mips/sibyte/common/Makefile
+++ b/arch/mips/sibyte/common/Makefile
@@ -1,5 +1,4 @@
 obj-y := cfe.o
-obj-$(CONFIG_SWIOTLB)			+= dma.o
 obj-$(CONFIG_SIBYTE_BUS_WATCHER)	+= bus_watcher.o
 obj-$(CONFIG_SIBYTE_CFE_CONSOLE)	+= cfe_console.o
 obj-$(CONFIG_SIBYTE_TBPROF)		+= sb_tbprof.o
--- a/arch/mips/sibyte/common/dma.c
+++ /dev/null
@@ -1,14 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- *	DMA support for Broadcom SiByte platforms.
- *
- *	Copyright (c) 2018  Maciej W. Rozycki
- */
-
-#include <linux/swiotlb.h>
-#include <asm/bootinfo.h>
-
-void __init plat_swiotlb_setup(void)
-{
-	swiotlb_init(1);
-}


