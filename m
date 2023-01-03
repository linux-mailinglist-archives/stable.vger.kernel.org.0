Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF98365C670
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbjACSkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238138AbjACSkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:40:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8B313EA7;
        Tue,  3 Jan 2023 10:39:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38FAD614E3;
        Tue,  3 Jan 2023 18:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D826FC433F1;
        Tue,  3 Jan 2023 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672771190;
        bh=I9Rh/SZX3YTnclAjYVPhj0Dc88rt5FKaiQgfc9H6olY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSzLTtSEXBnw02kl4FTlRZ1ktBdr7w/6m9O9IbSGiOpOQlm/jN2XC2vsPQ+t5JoQv
         5PFMmco1TUiYW+CxtEZaKwbf/0l01SXMkRgeRu5tF8BXOGV0zTNQ3zxpT1mnXA2DA8
         mXHqnh8jZUPHE1yBDoPNlTdu7cZbyqg7ejREGUqfOShLHF+ftAi3OAJK2SuyIHr00V
         Wr5dCFX2dhg/7Fw7dYzda8evzU4zO8KJrQwsvw936cesIEw6ZP0tN4sd+0Npmoh4W7
         3AS+Yrnu2zxhWzmoxtiuCg86ml0eSVOGZYAZyRRLLUXujTQDN/iOHFoFtWuo659rpC
         TD4WHH2qt8Qrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erik Schumacher <ofenfisch@googlemail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/10] ACPI: resource: do IRQ override on XMG Core 15
Date:   Tue,  3 Jan 2023 13:39:30 -0500
Message-Id: <20230103183934.2022663-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103183934.2022663-1-sashal@kernel.org>
References: <20230103183934.2022663-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Schumacher <ofenfisch@googlemail.com>

[ Upstream commit 7592b79ba4a91350b38469e05238308bcfe1019b ]

The Schenker XMG CORE 15 (M22) is Ryzen-6 based and needs IRQ overriding
for the keyboard to work. Adding an entry for this laptop to the
override_table makes the internal keyboard functional again.

Signed-off-by: Erik Schumacher <ofenfisch@googlemail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index f27914aedbd5..037d1aa10357 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -446,6 +446,17 @@ static const struct dmi_system_id lenovo_82ra[] = {
 	{ }
 };
 
+static const struct dmi_system_id schenker_gm_rg[] = {
+	{
+		.ident = "XMG CORE 15 (M22)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -460,6 +471,7 @@ static const struct irq_override_cmp override_table[] = {
 	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 	{ lenovo_82ra, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ lenovo_82ra, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.35.1

