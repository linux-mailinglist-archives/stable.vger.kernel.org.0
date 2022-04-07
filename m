Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB654F6FC8
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbiDGBOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbiDGBOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:14:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8BB182D85;
        Wed,  6 Apr 2022 18:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D21A561DB6;
        Thu,  7 Apr 2022 01:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D4CC385B8;
        Thu,  7 Apr 2022 01:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293881;
        bh=rakinzJkTv08OHWnz7KdolfEfKQVaCBbzM4XlCooYVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsQqIrGwEDguYDG/nI3RHmzE9F94fvulJC3B/HgFUqogXUdsnU7k1I642MXCCG6qV
         60jPd6P5PYYELBcBPhtdfIBvCuLBo2sUqTKad9cAQi3Uj6ciw1YpVUmE8thLbfhPuw
         CprESrO+LtA8T4xJ/tB/nJI7dOZt1deKzxjLkHBJD0+se97oaojFobl+Zle+tFZG4v
         5+94uKaa49PIyoJ7POcescwyqMLyYchA1Y3YR9brKwtiEZMHPEbYSwUmMix+G1uCJV
         kqm1VRinK1VpwARya+hDZ0OslVy1pIjLZ7f6hxgpmhunUOJJG35NzICFKYxuhVIkCg
         /iEBFkmjR+20A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Jinke Fan <fanjinke@hygon.cn>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Raul E Rangel <rrangel@chromium.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        mat.jonczyk@o2.pl, dan.carpenter@oracle.com,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 24/31] rtc: mc146818-lib: Fix the AltCentury for AMD platforms
Date:   Wed,  6 Apr 2022 21:10:22 -0400
Message-Id: <20220407011029.113321-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011029.113321-1-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 3ae8fd41573af4fb3a490c9ed947fc936ba87190 ]

Setting the century forward has been failing on AMD platforms.
There was a previous attempt at fixing this for family 0x17 as part of
commit 7ad295d5196a ("rtc: Fix the AltCentury value on AMD/Hygon
platform") but this was later reverted due to some problems reported
that appeared to stem from an FW bug on a family 0x17 desktop system.

The same comments mentioned in the previous commit continue to apply
to the newer platforms as well.

```
MC146818 driver use function mc146818_set_time() to set register
RTC_FREQ_SELECT(RTC_REG_A)'s bit4-bit6 field which means divider stage
reset value on Intel platform to 0x7.

While AMD/Hygon RTC_REG_A(0Ah)'s bit4 is defined as DV0 [Reference]:
DV0 = 0 selects Bank 0, DV0 = 1 selects Bank 1. Bit5-bit6 is defined
as reserved.

DV0 is set to 1, it will select Bank 1, which will disable AltCentury
register(0x32) access. As UEFI pass acpi_gbl_FADT.century 0x32
(AltCentury), the CMOS write will be failed on code:
CMOS_WRITE(century, acpi_gbl_FADT.century).

Correct RTC_REG_A bank select bit(DV0) to 0 on AMD/Hygon CPUs, it will
enable AltCentury(0x32) register writing and finally setup century as
expected.
```

However in closer examination the change previously submitted was also
modifying bits 5 & 6 which are declared reserved in the AMD documentation.
So instead modify just the DV0 bank selection bit.

Being cognizant that there was a failure reported before, split the code
change out to a static function that can also be used for exclusions if
any regressions such as Mikhail's pop up again.

Cc: Jinke Fan <fanjinke@hygon.cn>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://lore.kernel.org/all/CABXGCsMLob0DC25JS8wwAYydnDoHBSoMh2_YLPfqm3TTvDE-Zw@mail.gmail.com/
Link: https://www.amd.com/system/files/TechDocs/51192_Bolton_FCH_RRG.pdf
Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220111225750.1699-1-mario.limonciello@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 16 +++++++++++++++-
 include/linux/mc146818rtc.h    |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index ae9f131b43c0..05f251ba6a3a 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -176,6 +176,17 @@ int mc146818_get_time(struct rtc_time *time)
 }
 EXPORT_SYMBOL_GPL(mc146818_get_time);
 
+/* AMD systems don't allow access to AltCentury with DV1 */
+static bool apply_amd_register_a_behavior(void)
+{
+#ifdef CONFIG_X86
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
+		return true;
+#endif
+	return false;
+}
+
 /* Set the current date and time in the real time clock. */
 int mc146818_set_time(struct rtc_time *time)
 {
@@ -247,7 +258,10 @@ int mc146818_set_time(struct rtc_time *time)
 	save_control = CMOS_READ(RTC_CONTROL);
 	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
 	save_freq_select = CMOS_READ(RTC_FREQ_SELECT);
-	CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
+	if (apply_amd_register_a_behavior())
+		CMOS_WRITE((save_freq_select & ~RTC_AMD_BANK_SELECT), RTC_FREQ_SELECT);
+	else
+		CMOS_WRITE((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
 
 #ifdef CONFIG_MACH_DECSTATION
 	CMOS_WRITE(real_yrs, RTC_DEC_YEAR);
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index 808bb4cee230..b0da04fe087b 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -86,6 +86,8 @@ struct cmos_rtc_board_info {
    /* 2 values for divider stage reset, others for "testing purposes only" */
 #  define RTC_DIV_RESET1	0x60
 #  define RTC_DIV_RESET2	0x70
+   /* In AMD BKDG bit 5 and 6 are reserved, bit 4 is for select dv0 bank */
+#  define RTC_AMD_BANK_SELECT	0x10
   /* Periodic intr. / Square wave rate select. 0=none, 1=32.8kHz,... 15=2Hz */
 # define RTC_RATE_SELECT 	0x0F
 
-- 
2.35.1

