Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14F74D37ED
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbiCIQeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiCIQ3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:29:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF01774866;
        Wed,  9 Mar 2022 08:23:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3366F61961;
        Wed,  9 Mar 2022 16:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A68BC340F6;
        Wed,  9 Mar 2022 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842981;
        bh=ztggQNCgkWYRyJgw2WTJKBa0/fddztGD/fdjgSay18U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExIBgZ984p3mBN0KpO642+q3n5hh1I7M+GrpEGpPbbG4LmWtvrAzElRutHiiIkvd7
         3Z+pVsi1WE26Biv7zuexa/KxreltCzZtC3noG8EcJIxOghsHTs4NtqcyDNFO45kUgw
         cK8NWo3zZaHIzRXzhu2GQpm345WC9C0H3a7ZlQdRmTzLvZCyvh6+vbuG99xUhb97Vn
         H2c+PcUBsYnxjbWUbqb7cE6GFoQIl/7Vjkp9FcS2JBI9r5NYpRCCXQV5SwX0WVT5JG
         CP2Lh3e+umJAMaV1E/LkhlVyuW3zSybQs7JLRZ3BuTCOtVS2mkaoZyQQAr4ynbNifn
         hxmNSHRgGOt2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hadess@hadess.net,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/20] Input: goodix - workaround Cherry Trail devices with a bogus ACPI Interrupt() resource
Date:   Wed,  9 Mar 2022 11:21:51 -0500
Message-Id: <20220309162158.136467-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162158.136467-1-sashal@kernel.org>
References: <20220309162158.136467-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d982992669733dd75520000c6057d8ee0725a363 ]

ACPI/x86 devices with a Cherry Trail SoC should have a GpioInt + a regular
GPIO ACPI resource in their ACPI tables.

Some CHT devices have a bug, where the also is bogus interrupt resource
(likely copied from a previous Bay Trail based generation of the device).

The i2c-core-acpi code will assign the bogus, non-working, interrupt
resource to client->irq. Add a workaround to fix this up.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=2043960
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220228111613.363336-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 5fc789f717c8..f6c92365d327 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -782,7 +782,7 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 	const struct acpi_gpio_mapping *gpio_mapping = NULL;
 	struct device *dev = &ts->client->dev;
 	LIST_HEAD(resources);
-	int ret;
+	int irq, ret;
 
 	ts->gpio_count = 0;
 	ts->gpio_int_idx = -1;
@@ -795,6 +795,20 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 
 	acpi_dev_free_resource_list(&resources);
 
+	/*
+	 * CHT devices should have a GpioInt + a regular GPIO ACPI resource.
+	 * Some CHT devices have a bug (where the also is bogus Interrupt
+	 * resource copied from a previous BYT based generation). i2c-core-acpi
+	 * will use the non-working Interrupt resource, fix this up.
+	 */
+	if (soc_intel_is_cht() && ts->gpio_count == 2 && ts->gpio_int_idx != -1) {
+		irq = acpi_dev_gpio_irq_get(ACPI_COMPANION(dev), 0);
+		if (irq > 0 && irq != ts->client->irq) {
+			dev_warn(dev, "Overriding IRQ %d -> %d\n", ts->client->irq, irq);
+			ts->client->irq = irq;
+		}
+	}
+
 	if (ts->gpio_count == 2 && ts->gpio_int_idx == 0) {
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_GPIO;
 		gpio_mapping = acpi_goodix_int_first_gpios;
-- 
2.34.1

