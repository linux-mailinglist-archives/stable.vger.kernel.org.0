Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCAC4E937F
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240650AbiC1LY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241130AbiC1LXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:23:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB892580E8;
        Mon, 28 Mar 2022 04:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF4A7B80D13;
        Mon, 28 Mar 2022 11:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F259C34100;
        Mon, 28 Mar 2022 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466409;
        bh=mP7yVkWymwe1Bg1ZwxWju12O4lA9WkWvgZ0XNh+ZUsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geT6WG3gBY5UDcppnRog/iORSimnnEXCd9iAIiQVDdwNSbvVGfYysmj6mBt58SHmp
         iJ04t1TYMsjA5Jfg7Mv1lwAzUEaRNVK38GujWrzzqNCtvK2r2ZgtWnCqvnpBYyH/c0
         ppt1i28FAb05n2Yu6CaKMVdm2LlDLElOiXz/a42rObhkwzmV+kfe9Oo47nozbOHMjF
         gQTRlWe6PVyjfYhFAEYTuLjRTxwByDJVQh3Yl5ZhSkySDmmaPBdrPI1is08gvjQMjw
         O/YJk3pUTZIAsTJefMHvAuN7Jdd4qSS7egHMQ3Tq2RTPzxQ7YZ3mRz2o97lTUpjVo1
         JNEn1U6+5Tg5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mario Limonciello <Mario.Limonciello@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 42/43] Revert "ACPI: Pass the same capabilities to the _OSC regardless of the query flag"
Date:   Mon, 28 Mar 2022 07:18:26 -0400
Message-Id: <20220328111828.1554086-42-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 2ca8e6285250c07a2e5a22ecbfd59b5a4ef73484 ]

Revert commit 159d8c274fd9 ("ACPI: Pass the same capabilities to the
_OSC regardless of the query flag") which caused legitimate usage
scenarios (when the platform firmware does not want the OS to control
certain platform features controlled by the system bus scope _OSC) to
break and was misguided by some misleading language in the _OSC
definition in the ACPI specification (in particular, Section 6.2.11.1.3
"Sequence of _OSC Calls" that contradicts other perts of the _OSC
definition).

Link: https://lore.kernel.org/linux-acpi/CAJZ5v0iStA0JmO0H3z+VgQsVuQONVjKPpw0F5HKfiq=Gb6B5yw@mail.gmail.com
Reported-by: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 07f604832fd6..079b952ab59f 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -332,21 +332,32 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
 		return;
 
-	kfree(context.ret.pointer);
+	capbuf_ret = context.ret.pointer;
+	if (context.ret.length <= OSC_SUPPORT_DWORD) {
+		kfree(context.ret.pointer);
+		return;
+	}
 
-	/* Now run _OSC again with query flag clear */
+	/*
+	 * Now run _OSC again with query flag clear and with the caps
+	 * supported by both the OS and the platform.
+	 */
 	capbuf[OSC_QUERY_DWORD] = 0;
+	capbuf[OSC_SUPPORT_DWORD] = capbuf_ret[OSC_SUPPORT_DWORD];
+	kfree(context.ret.pointer);
 
 	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
 		return;
 
 	capbuf_ret = context.ret.pointer;
-	osc_sb_apei_support_acked =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
-	osc_pc_lpi_support_confirmed =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
-	osc_sb_native_usb4_support_confirmed =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
+	if (context.ret.length > OSC_SUPPORT_DWORD) {
+		osc_sb_apei_support_acked =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
+		osc_pc_lpi_support_confirmed =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
+		osc_sb_native_usb4_support_confirmed =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
+	}
 
 	kfree(context.ret.pointer);
 }
-- 
2.34.1

