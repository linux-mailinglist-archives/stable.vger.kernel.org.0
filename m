Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD026649ED
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjAJS2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbjAJS13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:27:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3098A4C55
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:22:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E08061864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35391C433D2;
        Tue, 10 Jan 2023 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374965;
        bh=eMbtnRokf0RxuSXdwZQODT4noF7DAEu9zrF7G2tC1TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzVWiSkj3v7r2NQVu3Ffjddqu0lqMSQSnd+PbUjg1W9Qw+KGj01YGqTbooto5XuA2
         mLQWuzw6pGFtzqKB95zG8A4bXfT7I525C99jYuaZqHWNrlaSfcUOhRvz2cN2MyQvUY
         kFj+5OCub/IFApEj//BngaW3UxkRLBy0+X0volhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/290] ACPI: resource: do IRQ override on LENOVO IdeaPad
Date:   Tue, 10 Jan 2023 19:01:40 +0100
Message-Id: <20230110180031.914806885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit bfcdf58380b1d9be564a78a9370da722ed1a9965 ]

LENOVO IdeaPad Flex 5 is ryzen-5 based and the commit below removed IRQ
overriding for those. This broke touchscreen and trackpad:
 i2c_designware AMDI0010:00: controller timed out
 i2c_designware AMDI0010:03: controller timed out
 i2c_hid_acpi i2c-MSFT0001:00: failed to reset device: -61
 i2c_designware AMDI0010:03: controller timed out
 ...
 i2c_hid_acpi i2c-MSFT0001:00: can't add hid device: -61
 i2c_hid_acpi: probe of i2c-MSFT0001:00 failed with error -61

White-list this specific model in the override_table.

For this to work, the ZEN test needs to be put below the table walk.

Fixes: 37c81d9f1d1b (ACPI: resource: skip IRQ override on AMD Zen platforms)
Link: https://bugzilla.suse.com/show_bug.cgi?id=1203794
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f3cb9b740869 ("ACPI: resource: do IRQ override on Lenovo 14ALC7")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 42 +++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 596ca9fae389..5154c9861ece 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -417,17 +417,31 @@ static const struct dmi_system_id asus_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id lenovo_82ra[] = {
+	{
+		.ident = "LENOVO IdeaPad Flex 5 16ALC7",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82RA"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
 	unsigned char triggering;
 	unsigned char polarity;
 	unsigned char shareable;
+	bool override;
 };
 
-static const struct irq_override_cmp skip_override_table[] = {
-	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
-	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+static const struct irq_override_cmp override_table[] = {
+	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ lenovo_82ra, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ lenovo_82ra, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
@@ -435,6 +449,17 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 {
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(override_table); i++) {
+		const struct irq_override_cmp *entry = &override_table[i];
+
+		if (dmi_check_system(entry->system) &&
+		    entry->irq == gsi &&
+		    entry->triggering == triggering &&
+		    entry->polarity == polarity &&
+		    entry->shareable == shareable)
+			return entry->override;
+	}
+
 #ifdef CONFIG_X86
 	/*
 	 * IRQ override isn't needed on modern AMD Zen systems and
@@ -445,17 +470,6 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 		return false;
 #endif
 
-	for (i = 0; i < ARRAY_SIZE(skip_override_table); i++) {
-		const struct irq_override_cmp *entry = &skip_override_table[i];
-
-		if (dmi_check_system(entry->system) &&
-		    entry->irq == gsi &&
-		    entry->triggering == triggering &&
-		    entry->polarity == polarity &&
-		    entry->shareable == shareable)
-			return false;
-	}
-
 	return true;
 }
 
-- 
2.35.1



