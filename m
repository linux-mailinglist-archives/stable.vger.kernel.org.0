Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015C04D3444
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbiCIQYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238131AbiCIQVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386681520EF;
        Wed,  9 Mar 2022 08:19:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C857A6194C;
        Wed,  9 Mar 2022 16:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507BBC340E8;
        Wed,  9 Mar 2022 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842743;
        bh=o0lMoPtysunsKgbgzC3/md5VDCnp60LnkLkLaYxOo7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqY5eBpyTvQqJ1hEFURU1omp4VGiTnhny/wtSA/PD0v74+j+VMsZD3wmE5RJvsmNH
         H1AcNitD5u2ufwHCsDtUpqADgTVyyJNm4fYOfn8KgovrnUi1BNhTyMeGdNZ1dZv/6m
         /JR1LXtIEdsGKtmbVL3H1QPmczWeHXQQNQC1RE6Ez8HW7jTax88YBJDdyqxItDHsZY
         7B1VAt2dky5FIlcPYI6vAx1yP76RgATv55pwNaqUnhwpzlIvlqT22ELqrXH8UI7v1T
         z+SJ3BEhhjnpjo4v9fIkWEdthJwWyI6PNt0h1LvGdVCuKgf6MAtiRTtspQHPfdbF1s
         5JIn7OTPySkeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hadess@hadess.net,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 20/27] Input: goodix - workaround Cherry Trail devices with a bogus ACPI Interrupt() resource
Date:   Wed,  9 Mar 2022 11:16:57 -0500
Message-Id: <20220309161711.135679-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
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
index e053aadea3c9..d3136842b717 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -745,7 +745,7 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 	const struct acpi_gpio_mapping *gpio_mapping = NULL;
 	struct device *dev = &ts->client->dev;
 	LIST_HEAD(resources);
-	int ret;
+	int irq, ret;
 
 	ts->gpio_count = 0;
 	ts->gpio_int_idx = -1;
@@ -758,6 +758,20 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 
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

