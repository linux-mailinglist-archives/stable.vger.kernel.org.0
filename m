Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8425B7140
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiIMOfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbiIMOeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:34:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF66BC2B;
        Tue, 13 Sep 2022 07:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62F686149A;
        Tue, 13 Sep 2022 14:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECE6C433D6;
        Tue, 13 Sep 2022 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078735;
        bh=ktxErZz43iB8qesudctyKI8eIJIjDE+yqoXMuOXV9Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufKbEFt3Ij5zL4Qhl7LBJrelxhShWd7oR34JvnbB+W6P7LtrN6kJq4OKRXpUj1Irf
         TI8vGBp5wtPWtaU6+/lfYvNZUSJdIG/oG2dlK5mfVGgqmaQ7a6RglpYIWtSfV4XLdi
         4zr26DdSsCtWTcuRKGE5X6WlAFji4ruh0TkaZewk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frederic Schumacher <frederic.schumacher@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/121] ARM: at91: pm: fix DDR recalibration when resuming from backup and self-refresh
Date:   Tue, 13 Sep 2022 16:04:13 +0200
Message-Id: <20220913140400.028569571@linuxfoundation.org>
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

[ Upstream commit 7a94b83a7dc551607b6c4400df29151e6a951f07 ]

On SAMA7G5, when resuming from backup and self-refresh, the bootloader
performs DDR PHY recalibration by restoring the value of ZQ0SR0 (stored
in RAM by Linux before going to backup and self-refresh). It has been
discovered that the current procedure doesn't work for all possible values
that might go to ZQ0SR0 due to hardware bug. The workaround to this is to
avoid storing some values in ZQ0SR0. Thus Linux will read the ZQ0SR0
register and cache its value in RAM after processing it (using
modified_gray_code array). The bootloader will restore the processed value.

Fixes: d2d4716d8384 ("ARM: at91: pm: save ddr phy calibration data to securam")
Suggested-by: Frederic Schumacher <frederic.schumacher@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220826083927.3107272-4-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c      | 36 ++++++++++++++++++++++++++++++++----
 include/soc/at91/sama7-ddr.h |  4 ++++
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index ed1050404ef0a..c8cc993ca8ca1 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -350,9 +350,41 @@ extern u32 at91_pm_suspend_in_sram_sz;
 
 static int at91_suspend_finish(unsigned long val)
 {
+	unsigned char modified_gray_code[] = {
+		0x00, 0x01, 0x02, 0x03, 0x06, 0x07, 0x04, 0x05, 0x0c, 0x0d,
+		0x0e, 0x0f, 0x0a, 0x0b, 0x08, 0x09, 0x18, 0x19, 0x1a, 0x1b,
+		0x1e, 0x1f, 0x1c, 0x1d, 0x14, 0x15, 0x16, 0x17, 0x12, 0x13,
+		0x10, 0x11,
+	};
+	unsigned int tmp, index;
 	int i;
 
 	if (soc_pm.data.mode == AT91_PM_BACKUP && soc_pm.data.ramc_phy) {
+		/*
+		 * Bootloader will perform DDR recalibration and will try to
+		 * restore the ZQ0SR0 with the value saved here. But the
+		 * calibration is buggy and restoring some values from ZQ0SR0
+		 * is forbidden and risky thus we need to provide processed
+		 * values for these (modified gray code values).
+		 */
+		tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
+
+		/* Store pull-down output impedance select. */
+		index = (tmp >> DDR3PHY_ZQ0SR0_PDO_OFF) & 0x1f;
+		soc_pm.bu->ddr_phy_calibration[0] = modified_gray_code[index];
+
+		/* Store pull-up output impedance select. */
+		index = (tmp >> DDR3PHY_ZQ0SR0_PUO_OFF) & 0x1f;
+		soc_pm.bu->ddr_phy_calibration[0] |= modified_gray_code[index];
+
+		/* Store pull-down on-die termination impedance select. */
+		index = (tmp >> DDR3PHY_ZQ0SR0_PDODT_OFF) & 0x1f;
+		soc_pm.bu->ddr_phy_calibration[0] |= modified_gray_code[index];
+
+		/* Store pull-up on-die termination impedance select. */
+		index = (tmp >> DDR3PHY_ZQ0SRO_PUODT_OFF) & 0x1f;
+		soc_pm.bu->ddr_phy_calibration[0] |= modified_gray_code[index];
+
 		/*
 		 * The 1st 8 words of memory might get corrupted in the process
 		 * of DDR PHY recalibration; it is saved here in securam and it
@@ -841,10 +873,6 @@ static int __init at91_pm_backup_init(void)
 		of_scan_flat_dt(at91_pm_backup_scan_memcs, &located);
 		if (!located)
 			goto securam_fail;
-
-		/* DDR3PHY_ZQ0SR0 */
-		soc_pm.bu->ddr_phy_calibration[0] = readl(soc_pm.data.ramc_phy +
-							  0x188);
 	}
 
 	return 0;
diff --git a/include/soc/at91/sama7-ddr.h b/include/soc/at91/sama7-ddr.h
index f47a933df82ea..72d19887ab810 100644
--- a/include/soc/at91/sama7-ddr.h
+++ b/include/soc/at91/sama7-ddr.h
@@ -40,6 +40,10 @@
 #define		DDR3PHY_DSGCR_ODTPDD_ODT0	(1 << 20)	/* ODT[0] Power Down Driver */
 
 #define DDR3PHY_ZQ0SR0				(0x188)		/* ZQ status register 0 */
+#define DDR3PHY_ZQ0SR0_PDO_OFF			(0)		/* Pull-down output impedance select offset */
+#define DDR3PHY_ZQ0SR0_PUO_OFF			(5)		/* Pull-up output impedance select offset */
+#define DDR3PHY_ZQ0SR0_PDODT_OFF		(10)		/* Pull-down on-die termination impedance select offset */
+#define DDR3PHY_ZQ0SRO_PUODT_OFF		(15)		/* Pull-up on-die termination impedance select offset */
 
 #define	DDR3PHY_DX0DLLCR			(0x1CC)		/* DDR3PHY DATX8 DLL Control Register */
 #define	DDR3PHY_DX1DLLCR			(0x20C)		/* DDR3PHY DATX8 DLL Control Register */
-- 
2.35.1



