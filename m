Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9F04D348B
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiCIQZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238471AbiCIQWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:22:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB687E10;
        Wed,  9 Mar 2022 08:21:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78E346194C;
        Wed,  9 Mar 2022 16:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F1BC340F4;
        Wed,  9 Mar 2022 16:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842883;
        bh=CHblr8NWTGcnGBYCwMJgLGnlDhamOLYtaCJlu/aYA1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hg3v7PGriZg/HLLSMz2q5PvW65i0iBu/Ms9ypNEHtr05GJOmcW7SnP3QFq8qduXru
         qbgmkD/T7bMEe7XU6GhJYc59JyxnMT+ctLJ7N7x7gp2tIypKnkaiKXGpp33xVKufiP
         0gDN4jDnEdZ4z6qe95oILoevXawzYuqxGHT6BJ9Svai+SGopn7RhnOgm+ipH8DxBpZ
         GQ+MgTFcJzdXqu2FEFOF3MKW4XzoTZOmqoM0rBVgAIGRU1/8RDeowQ2JTKT64XVoq0
         yCLt9lVeqs7/C9pBC1h2nPcg3orXwxYoP59v+4fIKXlPaZ6pkK/ZZZyZU3cOElh1qN
         YtA8roNPdHYGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hadess@hadess.net,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/24] Input: goodix - workaround Cherry Trail devices with a bogus ACPI Interrupt() resource
Date:   Wed,  9 Mar 2022 11:19:36 -0500
Message-Id: <20220309161946.136122-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161946.136122-1-sashal@kernel.org>
References: <20220309161946.136122-1-sashal@kernel.org>
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
index 5051a1766aac..18021ae8183d 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -784,7 +784,7 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 	const struct acpi_gpio_mapping *gpio_mapping = NULL;
 	struct device *dev = &ts->client->dev;
 	LIST_HEAD(resources);
-	int ret;
+	int irq, ret;
 
 	ts->gpio_count = 0;
 	ts->gpio_int_idx = -1;
@@ -797,6 +797,20 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 
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

