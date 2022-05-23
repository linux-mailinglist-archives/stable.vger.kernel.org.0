Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A458531B54
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbiEWRXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240966AbiEWRVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB9C74DC2;
        Mon, 23 May 2022 10:18:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 782856090C;
        Mon, 23 May 2022 17:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D361C34115;
        Mon, 23 May 2022 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326290;
        bh=STWB5UiG9tuaEqTPAITD9W4owrvJ7wIU/bfNuc4ee9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKOdtRuQ0nQWuGUeHVS4bXjNMZN1xX9IVztoyD5D0lyeyzXoqQGtgxn4dPwmoAHGm
         ffQtay84gSQbaPLRVYM2mU8gyMtamaop4mqwYUa/dVlQiLz95qcVEDbXRuquMDBbgl
         f/UwZVwaz/ZWFwzCMOEKNHoxbDDSzWicJJc3FlQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinke Fan <fanjinke@hygon.cn>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Raul E Rangel <rrangel@chromium.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/132] rtc: mc146818-lib: Fix the AltCentury for AMD platforms
Date:   Mon, 23 May 2022 19:04:05 +0200
Message-Id: <20220523165829.425486130@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 8abac672f3cb..f3f5a87fe376 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -146,6 +146,17 @@ int mc146818_get_time(struct rtc_time *time)
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
@@ -219,7 +230,10 @@ int mc146818_set_time(struct rtc_time *time)
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
index 37c74e25f53d..3038124c6115 100644
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



