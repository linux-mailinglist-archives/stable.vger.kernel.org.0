Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0969C6512E0
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbiLSTYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiLSTXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:23:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E40101B
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 972D36111A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95164C433F0;
        Mon, 19 Dec 2022 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477805;
        bh=cJmINEy4D30ha3tppFiCOaYoDk1uowRgBwxqQLzpsbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eysNPgjbcxplir37xbpmTBSet7ruM1ZM3LkEs1ridPMCJ0Qy96M6QnC4h4FTYNTBH
         i9QwHhyxYOIrczvWHDtYc9o3720m9ax6BBQmD0jFBOl1sLaWEJZMP9PUySz13OC0rQ
         mjWmp9qTSn83uwdRDHPU1ebDoZIhlup0YlMiWUZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        John Thomson <git@johnthomson.fastmail.com.au>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 04/25] mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem
Date:   Mon, 19 Dec 2022 20:22:43 +0100
Message-Id: <20221219182943.592687776@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
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

commit a2cab953b4c077cc02878d424466d3a6eac32aaf upstream.

So that MT7621_SYSC_BASE can be used later in multiple functions without
needing to repeat this __iomem declaration each time

Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mach-ralink/mt7621.h |    4 +++-
 arch/mips/ralink/mt7621.c                  |    7 +++----
 2 files changed, 6 insertions(+), 5 deletions(-)

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
--- a/arch/mips/ralink/mt7621.c
+++ b/arch/mips/ralink/mt7621.c
@@ -126,7 +126,6 @@ static void soc_dev_init(struct ralink_s
 
 void __init prom_soc_init(struct ralink_soc_info *soc_info)
 {
-	void __iomem *sysc = (void __iomem *) KSEG1ADDR(MT7621_SYSC_BASE);
 	unsigned char *name = NULL;
 	u32 n0;
 	u32 n1;
@@ -154,8 +153,8 @@ void __init prom_soc_init(struct ralink_
 		__sync();
 	}
 
-	n0 = __raw_readl(sysc + SYSC_REG_CHIP_NAME0);
-	n1 = __raw_readl(sysc + SYSC_REG_CHIP_NAME1);
+	n0 = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME0);
+	n1 = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_NAME1);
 
 	if (n0 == MT7621_CHIP_NAME0 && n1 == MT7621_CHIP_NAME1) {
 		name = "MT7621";
@@ -164,7 +163,7 @@ void __init prom_soc_init(struct ralink_
 		panic("mt7621: unknown SoC, n0:%08x n1:%08x\n", n0, n1);
 	}
 	ralink_soc = MT762X_SOC_MT7621AT;
-	rev = __raw_readl(sysc + SYSC_REG_CHIP_REV);
+	rev = __raw_readl(MT7621_SYSC_BASE + SYSC_REG_CHIP_REV);
 
 	snprintf(soc_info->sys_type, RAMIPS_SYS_TYPE_LEN,
 		"MediaTek %s ver:%u eco:%u",


