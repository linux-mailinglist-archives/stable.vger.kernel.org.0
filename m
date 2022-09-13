Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB85B70DD
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbiIMOdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbiIMOcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:32:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC9C5E65A;
        Tue, 13 Sep 2022 07:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CEE4B80EF8;
        Tue, 13 Sep 2022 14:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1380BC433C1;
        Tue, 13 Sep 2022 14:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078733;
        bh=ZwfKnGUADHDGj49UxtZZDTGFRgxd+FqsVmw7TCJYypg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2i9aoE4T2CnmmPWsrh3d74V87lt9V2fqF6rzmDAQ211F/WYWkkuLyHt03tlZitQb
         jbM/9OhEqjMSsEokM1DeoRViYKFeoFE5xpJRLCsw3FI8/MYl5IHgBK+dNvQcNCvU0Y
         wUKBOFA5pKA4VL/DICVcMt+zaj0b69gwXDHTNHa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frederic Schumacher <frederic.schumacher@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Cristian Birsan <cristian.birsan@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/121] ARM: at91: pm: fix self-refresh for sama7g5
Date:   Tue, 13 Sep 2022 16:04:12 +0200
Message-Id: <20220913140359.985143405@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit a02875c4cbd6f3d2f33d70cc158a19ef02d4b84f ]

It has been discovered that on some parts, from time to time, self-refresh
procedure doesn't work as expected. Debugging and investigating it proved
that disabling AC DLL introduce glitches in RAM controllers which
leads to unexpected behavior. This is confirmed as a hardware bug. DLL
bypass disables 3 DLLs: 2 DX DLLs and AC DLL. Thus, keep only DX DLLs
disabled. This introduce 6mA extra current consumption on VDDCORE when
switching to any ULP mode or standby mode but the self-refresh procedure
still works.

Fixes: f0bbf17958e8 ("ARM: at91: pm: add self-refresh support for sama7g5")
Suggested-by: Frederic Schumacher <frederic.schumacher@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Tested-by: Cristian Birsan <cristian.birsan@microchip.com>
Link: https://lore.kernel.org/r/20220826083927.3107272-3-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm_suspend.S | 24 +++++++++++++++++-------
 include/soc/at91/sama7-ddr.h    |  4 ++++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index fdb4f63ecde4b..65cfcc19a936c 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -172,9 +172,15 @@ sr_ena_2:
 	/* Put DDR PHY's DLL in bypass mode for non-backup modes. */
 	cmp	r7, #AT91_PM_BACKUP
 	beq	sr_ena_3
-	ldr	tmp1, [r3, #DDR3PHY_PIR]
-	orr	tmp1, tmp1, #DDR3PHY_PIR_DLLBYP
-	str	tmp1, [r3, #DDR3PHY_PIR]
+
+	/* Disable DX DLLs. */
+	ldr	tmp1, [r3, #DDR3PHY_DX0DLLCR]
+	orr	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
+	str	tmp1, [r3, #DDR3PHY_DX0DLLCR]
+
+	ldr	tmp1, [r3, #DDR3PHY_DX1DLLCR]
+	orr	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
+	str	tmp1, [r3, #DDR3PHY_DX1DLLCR]
 
 sr_ena_3:
 	/* Power down DDR PHY data receivers. */
@@ -221,10 +227,14 @@ sr_ena_3:
 	bic	tmp1, tmp1, #DDR3PHY_DSGCR_ODTPDD_ODT0
 	str	tmp1, [r3, #DDR3PHY_DSGCR]
 
-	/* Take DDR PHY's DLL out of bypass mode. */
-	ldr	tmp1, [r3, #DDR3PHY_PIR]
-	bic	tmp1, tmp1, #DDR3PHY_PIR_DLLBYP
-	str	tmp1, [r3, #DDR3PHY_PIR]
+	/* Enable DX DLLs. */
+	ldr	tmp1, [r3, #DDR3PHY_DX0DLLCR]
+	bic	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
+	str	tmp1, [r3, #DDR3PHY_DX0DLLCR]
+
+	ldr	tmp1, [r3, #DDR3PHY_DX1DLLCR]
+	bic	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
+	str	tmp1, [r3, #DDR3PHY_DX1DLLCR]
 
 	/* Enable quasi-dynamic programming. */
 	mov	tmp1, #0
diff --git a/include/soc/at91/sama7-ddr.h b/include/soc/at91/sama7-ddr.h
index f6542584ca139..f47a933df82ea 100644
--- a/include/soc/at91/sama7-ddr.h
+++ b/include/soc/at91/sama7-ddr.h
@@ -41,6 +41,10 @@
 
 #define DDR3PHY_ZQ0SR0				(0x188)		/* ZQ status register 0 */
 
+#define	DDR3PHY_DX0DLLCR			(0x1CC)		/* DDR3PHY DATX8 DLL Control Register */
+#define	DDR3PHY_DX1DLLCR			(0x20C)		/* DDR3PHY DATX8 DLL Control Register */
+#define		DDR3PHY_DXDLLCR_DLLDIS		(1 << 31)	/* DLL Disable */
+
 /* UDDRC */
 #define UDDRC_STAT				(0x04)		/* UDDRC Operating Mode Status Register */
 #define		UDDRC_STAT_SELFREF_TYPE_DIS	(0x0 << 4)	/* SDRAM is not in Self-refresh */
-- 
2.35.1



