Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87F55051F
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 15:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiFRNhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 09:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRNhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 09:37:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AD217ABC;
        Sat, 18 Jun 2022 06:37:23 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t2so6045846pld.4;
        Sat, 18 Jun 2022 06:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wGZn6FgCwazjQXz0vpa56+s306nfaS2CZ0bzi8dbZZg=;
        b=IW9icgEbNXH5VLqNWoTl2VsDFsxe4egTcAoSDRsgkjuMUMxlwMBC+YpYnp7ilhT/IL
         Mj8IcOf2beu1xe6PFC1D7OrBh4g3HKLrvlPIS1hkQfq27xl0gUuWv990ciET5hhDxzG7
         athbbbEOd90RUDX0XYVzBFLMSkcOFKKBQBnrFUI/iWxJiphyPrRUYqpBNCVUY0Eyq8+V
         eCKCdmJPTVx7rzNlGF73k0qquMWdBOGYphCsOrMJb60tmah51TIbz/328sbsfaTHxbKu
         cEEmEqWyCRzTt46wZCuOwtgPwPLZXnIjsahpNnmKOH3l1rvfXZ2TPACT3ahAc5tqn/G6
         CzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wGZn6FgCwazjQXz0vpa56+s306nfaS2CZ0bzi8dbZZg=;
        b=O52Yb0LHB+VMfd0ZgEeyqwxDwP5PPCkdwBSa4tXjZFLmzEXJUqWUq5YztyvS+jy45J
         pTlvpXVWQzNJG9n+WdRh0EC6MCSCKXV6r018dbqbyxJf6if8qyouDJYErOyyL98J9la6
         tPD6NYizPr8frGYskIN30GhF+EFW/ctjBGXTUbO22N7PLOev+WmJaPwIMpoTs+SSDkVb
         XAvwNQHdSYhaxyy8Ev5JD8tQz8yYdpHc58rEZMpXHYOxrC9UwiHA5rlk8VicL+2cH8uP
         XDfKW8iru5r5jwY4ZWcZIOgtyxJRo76qLO6RasdQTeqnNuUfQ9LwfEGlIqIm3pkqgBst
         q0Ng==
X-Gm-Message-State: AJIora+kmpZASfL6gtIjRsVjCOjUbUOc0P1/p/e8OcMAgX0x6AvuKUXa
        TIa6CtT79symudT+2pM1Ugh1JMv2m/z2zw==
X-Google-Smtp-Source: AGRyM1vK8OYzov2v6wh9nIzlwQWTPyJlW91AXhZwHliy5cnNHSvekMY8hxCtR6SByGlPk7N+IACMTA==
X-Received: by 2002:a17:902:cccf:b0:168:e13c:5cd9 with SMTP id z15-20020a170902cccf00b00168e13c5cd9mr14702567ple.53.1655559442595;
        Sat, 18 Jun 2022 06:37:22 -0700 (PDT)
Received: from guoguo-omen.lan ([2401:c080:1400:4da2:b701:47d5:9291:4cf9])
        by smtp.gmail.com with ESMTPSA id t29-20020a62d15d000000b0050dc7628150sm5668258pfl.42.2022.06.18.06.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 06:37:21 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-acpi@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ACPI: skip IRQ1 override on Lenovo ThinkBook 14G4+ ARA
Date:   Sat, 18 Jun 2022 21:37:12 +0800
Message-Id: <20220618133712.8788-1-gch981213@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The IRQ is described as (Edge, ActiveLow, Shared, ) in ACPI DSDT and
it's correct. The override makes the keyboard interrupt polarity
inverted, resulting in non-functional keyboard.
Add an entry for skipping the override.

Cc: <stable@vger.kernel.org>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
It seems that this issue present on several other Ryzen 6000 laptops.
The dmi table is named genericly because I'm expecting this list to
get filled with laptops from other vendors.

 drivers/acpi/resource.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index c2d494784425..3f6a290a1060 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -399,6 +399,17 @@ static const struct dmi_system_id medion_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id irq1_edge_low_shared[] = {
+	{
+		.ident = "Lenovo ThinkBook 14 G4+ ARA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_BOARD_NAME, "LNVNB161216"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -409,6 +420,7 @@ struct irq_override_cmp {
 
 static const struct irq_override_cmp skip_override_table[] = {
 	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+	{ irq1_edge_low_shared, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1 },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.36.1

