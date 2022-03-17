Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4EF4DC6A5
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiCQMzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbiCQMy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:54:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDCB1EC6D;
        Thu, 17 Mar 2022 05:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E74B2B81E5C;
        Thu, 17 Mar 2022 12:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5026AC340E9;
        Thu, 17 Mar 2022 12:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521589;
        bh=OHgK3l61XigknepnxkAHN1zj8F8/Ze2Ht/Z9K6dhxxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1+KA7QMXq9T7Sn/HVR87ME0zcnmfvzxKRWDY6kVkT+5eHXw5/TKGIR2Fkejrhchb
         h85SDsWaIx7Uomm5/35UPgOpW9FrdclTmGhyv6nZNUhOpEsp19PSc+72fk7Snsd/Ov
         qqp8SRiYzdy6mNsSqQY2cec2gjBmPQJ/1XSwS3aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 19/28] Input: goodix - use the new soc_intel_is_byt() helper
Date:   Thu, 17 Mar 2022 13:46:10 +0100
Message-Id: <20220317124527.312793322@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d176708ffc20332d1c730098d2b111e0b77ece82 ]

Use the new soc_intel_is_byt() helper from linux/platform_data/x86/soc.h.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220131143539.109142-5-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index aaa3c455e01e..e053aadea3c9 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/platform_data/x86/soc.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/of.h>
@@ -686,21 +687,6 @@ static int goodix_reset(struct goodix_ts_data *ts)
 }
 
 #ifdef ACPI_GPIO_SUPPORT
-#include <asm/cpu_device_id.h>
-#include <asm/intel-family.h>
-
-static const struct x86_cpu_id baytrail_cpu_ids[] = {
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_ATOM_SILVERMONT, X86_FEATURE_ANY, },
-	{}
-};
-
-static inline bool is_byt(void)
-{
-	const struct x86_cpu_id *id = x86_match_cpu(baytrail_cpu_ids);
-
-	return !!id;
-}
-
 static const struct acpi_gpio_params first_gpio = { 0, 0, false };
 static const struct acpi_gpio_params second_gpio = { 1, 0, false };
 
@@ -784,7 +770,7 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 		dev_info(dev, "Using ACPI INTI and INTO methods for IRQ pin access\n");
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_METHOD;
 		gpio_mapping = acpi_goodix_reset_only_gpios;
-	} else if (is_byt() && ts->gpio_count == 2 && ts->gpio_int_idx == -1) {
+	} else if (soc_intel_is_byt() && ts->gpio_count == 2 && ts->gpio_int_idx == -1) {
 		dev_info(dev, "No ACPI GpioInt resource, assuming that the GPIO order is reset, int\n");
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_GPIO;
 		gpio_mapping = acpi_goodix_int_last_gpios;
-- 
2.34.1



