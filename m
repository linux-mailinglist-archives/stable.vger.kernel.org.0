Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D48A11B569
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732732AbfLKPxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732156AbfLKPSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF859208C3;
        Wed, 11 Dec 2019 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077526;
        bh=M+PwNQzuveidtj1eQr2mJ7oxxe8QVAPPPn7zHYICVf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No1X3xm0cdRPmeqr9ofu6ZHrZy9JNky6B9mekYmGi5MKqbn9bJcXUyY6pdttQIE4o
         8PsMyuLf6MBZNQLp3bSVammFHVJDnM+JuTOqi6CYu5n2gTnvQiZ4/Y4jk322BrLPhC
         VWsPC5ZKo1R6VKkayneIxIwY3KEfC14e1Q2XvW3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/243] ARC: IOC: panic if kernel was started with previously enabled IOC
Date:   Wed, 11 Dec 2019 16:03:17 +0100
Message-Id: <20191211150341.613335129@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>

[ Upstream commit 3624379d90ad2b65f9dbb30d7f7ce5498d2fe322 ]

If IOC was already enabled (due to bootloader) it technically needs to
be reconfigured with aperture base,size corresponding to Linux memory map
which will certainly be different than uboot's. But disabling and
reenabling IOC when DMA might be potentially active is tricky business.
To avoid random memory issues later, just panic here and ask user to
upgrade bootloader to one which doesn't enable IOC

This was actually seen as issue on some of the HSDK board with a version
of uboot which enabled IOC. There were random issues later with starting
of X or peripherals etc.

Also while I'm at it, replace hardcoded bits in ARC_REG_IO_COH_PARTIAL
and ARC_REG_IO_COH_ENABLE registers by definitions.

Inspired by: https://lkml.org/lkml/2018/1/19/557
Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/cache.h |  2 ++
 arch/arc/mm/cache.c          | 20 +++++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arc/include/asm/cache.h b/arch/arc/include/asm/cache.h
index db681cf4959c8..2ad77fb43639c 100644
--- a/arch/arc/include/asm/cache.h
+++ b/arch/arc/include/asm/cache.h
@@ -124,7 +124,9 @@ extern unsigned long perip_base, perip_end;
 
 /* IO coherency related Auxiliary registers */
 #define ARC_REG_IO_COH_ENABLE	0x500
+#define ARC_IO_COH_ENABLE_BIT	BIT(0)
 #define ARC_REG_IO_COH_PARTIAL	0x501
+#define ARC_IO_COH_PARTIAL_BIT	BIT(0)
 #define ARC_REG_IO_COH_AP0_BASE	0x508
 #define ARC_REG_IO_COH_AP0_SIZE	0x509
 
diff --git a/arch/arc/mm/cache.c b/arch/arc/mm/cache.c
index f2701c13a66b2..cf9619d4efb4f 100644
--- a/arch/arc/mm/cache.c
+++ b/arch/arc/mm/cache.c
@@ -1144,6 +1144,20 @@ noinline void __init arc_ioc_setup(void)
 {
 	unsigned int ioc_base, mem_sz;
 
+	/*
+	 * If IOC was already enabled (due to bootloader) it technically needs to
+	 * be reconfigured with aperture base,size corresponding to Linux memory map
+	 * which will certainly be different than uboot's. But disabling and
+	 * reenabling IOC when DMA might be potentially active is tricky business.
+	 * To avoid random memory issues later, just panic here and ask user to
+	 * upgrade bootloader to one which doesn't enable IOC
+	 */
+	if (read_aux_reg(ARC_REG_IO_COH_ENABLE) & ARC_IO_COH_ENABLE_BIT)
+		panic("IOC already enabled, please upgrade bootloader!\n");
+
+	if (!ioc_enable)
+		return;
+
 	/*
 	 * As for today we don't support both IOC and ZONE_HIGHMEM enabled
 	 * simultaneously. This happens because as of today IOC aperture covers
@@ -1187,8 +1201,8 @@ noinline void __init arc_ioc_setup(void)
 		panic("IOC Aperture start must be aligned to the size of the aperture");
 
 	write_aux_reg(ARC_REG_IO_COH_AP0_BASE, ioc_base >> 12);
-	write_aux_reg(ARC_REG_IO_COH_PARTIAL, 1);
-	write_aux_reg(ARC_REG_IO_COH_ENABLE, 1);
+	write_aux_reg(ARC_REG_IO_COH_PARTIAL, ARC_IO_COH_PARTIAL_BIT);
+	write_aux_reg(ARC_REG_IO_COH_ENABLE, ARC_IO_COH_ENABLE_BIT);
 
 	/* Re-enable L1 dcache */
 	__dc_enable();
@@ -1265,7 +1279,7 @@ void __init arc_cache_init_master(void)
 	if (is_isa_arcv2() && l2_line_sz && !slc_enable)
 		arc_slc_disable();
 
-	if (is_isa_arcv2() && ioc_enable)
+	if (is_isa_arcv2() && ioc_exists)
 		arc_ioc_setup();
 
 	if (is_isa_arcv2() && l2_line_sz && slc_enable) {
-- 
2.20.1



