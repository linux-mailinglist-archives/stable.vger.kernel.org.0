Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F62268D7F9
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjBGNE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbjBGNEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:04:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095F565A4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:04:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE64DB8198D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DB2C433EF;
        Tue,  7 Feb 2023 13:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775079;
        bh=NlNbKI1aSnjFsFNw+bdIQ7e3MMKfeMKa4iDwodiGN2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cP5mGfmdOUuqOWBQxgvXzpZPfvjw+04LYbQsxHkBSfBzQdZ/OpPXij22lDG30+OZR
         WxWdg225BeLeOD4hq5G15uBsgEPiIuXjFdQfKV5k2Hrkfj0FzSdo+/bCHA7HmmVIrB
         mUy0RlH+kuTtoM1XkutiI031ZIHK2beVoSp1ACrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 131/208] rtc: efi: Enable SET/GET WAKEUP services as optional
Date:   Tue,  7 Feb 2023 13:56:25 +0100
Message-Id: <20230207125640.350055475@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Shanker Donthineni <sdonthineni@nvidia.com>

commit 101ca8d05913b7d1e6e8b9dd792193d4082fff86 upstream.

The current implementation of rtc-efi is expecting all the 4
time services GET{SET}_TIME{WAKEUP} must be supported by UEFI
firmware. As per the EFI_RT_PROPERTIES_TABLE, the platform
specific implementations can choose to enable selective time
services based on the RTC device capabilities.

This patch does the following changes to provide GET/SET RTC
services on platforms that do not support the WAKEUP feature.

1) Relax time services cap check when creating a platform device.
2) Clear RTC_FEATURE_ALARM bit in the absence of WAKEUP services.
3) Conditional alarm entries in '/proc/driver/rtc'.

Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Link: https://lore.kernel.org/r/20230102230630.192911-1-sdonthineni@nvidia.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-efi.c |   48 +++++++++++++++++++++++++++---------------------
 include/linux/efi.h   |    3 ++-
 2 files changed, 29 insertions(+), 22 deletions(-)

--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -188,9 +188,10 @@ static int efi_set_time(struct device *d
 
 static int efi_procfs(struct device *dev, struct seq_file *seq)
 {
-	efi_time_t      eft, alm;
-	efi_time_cap_t  cap;
-	efi_bool_t      enabled, pending;
+	efi_time_t        eft, alm;
+	efi_time_cap_t    cap;
+	efi_bool_t        enabled, pending;
+	struct rtc_device *rtc = dev_get_drvdata(dev);
 
 	memset(&eft, 0, sizeof(eft));
 	memset(&alm, 0, sizeof(alm));
@@ -213,23 +214,25 @@ static int efi_procfs(struct device *dev
 		/* XXX fixme: convert to string? */
 		seq_printf(seq, "Timezone\t: %u\n", eft.timezone);
 
-	seq_printf(seq,
-		   "Alarm Time\t: %u:%u:%u.%09u\n"
-		   "Alarm Date\t: %u-%u-%u\n"
-		   "Alarm Daylight\t: %u\n"
-		   "Enabled\t\t: %s\n"
-		   "Pending\t\t: %s\n",
-		   alm.hour, alm.minute, alm.second, alm.nanosecond,
-		   alm.year, alm.month, alm.day,
-		   alm.daylight,
-		   enabled == 1 ? "yes" : "no",
-		   pending == 1 ? "yes" : "no");
-
-	if (eft.timezone == EFI_UNSPECIFIED_TIMEZONE)
-		seq_puts(seq, "Timezone\t: unspecified\n");
-	else
-		/* XXX fixme: convert to string? */
-		seq_printf(seq, "Timezone\t: %u\n", alm.timezone);
+	if (test_bit(RTC_FEATURE_ALARM, rtc->features)) {
+		seq_printf(seq,
+			   "Alarm Time\t: %u:%u:%u.%09u\n"
+			   "Alarm Date\t: %u-%u-%u\n"
+			   "Alarm Daylight\t: %u\n"
+			   "Enabled\t\t: %s\n"
+			   "Pending\t\t: %s\n",
+			   alm.hour, alm.minute, alm.second, alm.nanosecond,
+			   alm.year, alm.month, alm.day,
+			   alm.daylight,
+			   enabled == 1 ? "yes" : "no",
+			   pending == 1 ? "yes" : "no");
+
+		if (eft.timezone == EFI_UNSPECIFIED_TIMEZONE)
+			seq_puts(seq, "Timezone\t: unspecified\n");
+		else
+			/* XXX fixme: convert to string? */
+			seq_printf(seq, "Timezone\t: %u\n", alm.timezone);
+	}
 
 	/*
 	 * now prints the capabilities
@@ -269,7 +272,10 @@ static int __init efi_rtc_probe(struct p
 
 	rtc->ops = &efi_rtc_ops;
 	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, rtc->features);
-	set_bit(RTC_FEATURE_ALARM_WAKEUP_ONLY, rtc->features);
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_WAKEUP_SERVICES))
+		set_bit(RTC_FEATURE_ALARM_WAKEUP_ONLY, rtc->features);
+	else
+		clear_bit(RTC_FEATURE_ALARM, rtc->features);
 
 	return devm_rtc_register_device(rtc);
 }
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -668,7 +668,8 @@ extern struct efi {
 
 #define EFI_RT_SUPPORTED_ALL					0x3fff
 
-#define EFI_RT_SUPPORTED_TIME_SERVICES				0x000f
+#define EFI_RT_SUPPORTED_TIME_SERVICES				0x0003
+#define EFI_RT_SUPPORTED_WAKEUP_SERVICES			0x000c
 #define EFI_RT_SUPPORTED_VARIABLE_SERVICES			0x0070
 
 extern struct mm_struct efi_mm;


