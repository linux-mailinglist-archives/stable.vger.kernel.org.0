Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D636E657A9B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiL1PNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiL1PNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:13:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ADB13F25
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88966B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71B9C433D2;
        Wed, 28 Dec 2022 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240367;
        bh=vF7dIDsxRKUinwUzLAPAM/q2wFrKGIKprKCftQHse+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/FtbCc1oeKuLM/a3MJ4gkC7EJS1XuYU/QIPLDGe3X6haSdY3Wu1K8x0oBHnIavHJ
         eNFTi41HTezw2gsiKGC69Wyf2i3ir4PDxsvQj+lJ8pPi4k88+n0RnYTc8HmZUtk8Fo
         onfbSh1nANAmVHduhJ7MqpGm2LPFCbG0D+htYGVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Thomson <git@johnthomson.fastmail.com.au>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0152/1073] mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem
Date:   Wed, 28 Dec 2022 15:29:00 +0100
Message-Id: <20221228144332.150822676@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Thomson <git@johnthomson.fastmail.com.au>

[ Upstream commit a2cab953b4c077cc02878d424466d3a6eac32aaf ]

So that MT7621_SYSC_BASE can be used later in multiple functions without
needing to repeat this __iomem declaration each time

Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 7c18b64bba3b ("mips: ralink: mt7621: do not use kzalloc too early")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mach-ralink/mt7621.h | 4 +++-
 arch/mips/ralink/mt7621.c                  | 7 +++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/mach-ralink/mt7621.h b/arch/mips/include/asm/mach-ralink/mt7621.h
index 6bbf082dd149..79d5bb0e06d6 100644
--- a/arch/mips/include/asm/mach-ralink/mt7621.h
+++ b/arch/mips/include/asm/mach-ralink/mt7621.h
@@ -7,10 +7,12 @@
 #ifndef _MT7621_REGS_H_
 #define _MT7621_REGS_H_
 
+#define IOMEM(x)			((void __iomem *)(KSEG1ADDR(x)))
+
 #define MT7621_PALMBUS_BASE		0x1C000000
 #define MT7621_PALMBUS_SIZE		0x03FFFFFF
 
-#define MT7621_SYSC_BASE		0x1E000000
+#define MT7621_SYSC_BASE		IOMEM(0x1E000000)
 
 #define SYSC_REG_CHIP_NAME0		0x00
 #define SYSC_REG_CHIP_NAME1		0x04
diff --git a/arch/mips/ralink/mt7621.c b/arch/mips/ralink/mt7621.c
index fb0565bc34fd..17dbf28897e0 100644
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -126,7 +126,6 @@ static void soc_dev_init(struct ralink_soc_info *soc_info, u32 rev)
 
 void __init prom_soc_init(struct ralink_soc_info *soc_info)
 {
-	void __iomem *sysc = (void __iomem *) KSEG1ADDR(MT7621_SYSC_BASE);
 	unsigned char *name = NULL;
 	u32 n0;
 	u32 n1;
@@ -154,8 +153,8 @@ void __init prom_soc_init(struct ralink_soc_info *soc_info)
 		__sync();
 	}
 
-	n0 = __raw_readl(sysc + SYSC_REG_CHIP_NAME0);
-	n1 = __raw_readl(sysc + SYSC_REG_CHIP_NAME1);
+	n0 = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME0);
+	n1 = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME1);
 
 	if (n0 == MT7621_CHIP_NAME0 && n1 == MT7621_CHIP_NAME1) {
 		name = "MT7621";
@@ -164,7 +163,7 @@ void __init prom_soc_init(struct ralink_soc_info *soc_info)
 		panic("mt7621: unknown SoC, n0:%08x n1:%08x\n", n0, n1);
 	}
 	ralink_soc = MT762X_SOC_MT7621AT;
-	rev = __raw_readl(sysc + SYSC_REG_CHIP_REV);
+	rev = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_REV);
 
 	snprintf(soc_info->sys_type, RAMIPS_SYS_TYPE_LEN,
 		"MediaTek %s ver:%u eco:%u",
-- 
2.35.1



