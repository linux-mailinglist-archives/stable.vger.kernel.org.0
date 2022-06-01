Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD85A53A6D2
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353855AbiFAN4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353764AbiFANzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433E38FD77;
        Wed,  1 Jun 2022 06:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC04615AA;
        Wed,  1 Jun 2022 13:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFC9C36AF8;
        Wed,  1 Jun 2022 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091674;
        bh=ysGPMCEE6zTrrAwWhMonkdrC5EuSx87LJP4/nYS+s1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oytYFRzq5R4OuWbwLD5cdAmY7s3jXvTMTVUK6jm+/sk4Lq0ZLPGDzbt0exCu3qKFJ
         9gNq/ZjOyluK6HnpXyCZSiLDL3qvHd4gt1UxaJTDIjoMTLqDY/+BDytb3Z4qDX9U+9
         Xxakqu2IKEc/2WMzcQ3j8+NA5/RxlSGFSMtYkVfLagKx2iXt3/sv/ugCyNK2jenf8g
         sz+X4ZE4iHAMDNWWpJEJqRGcoy9biQNcyG9gHfnbGPZq+aIUv6eOJGVZnD+3jOlLNS
         r00d3q77O8L9eoUmpRwbMmVx3c1p14FKe8ZXiuLHKdwP8KFqZIfDzVXUWYHqolt3tM
         v6hIz3OyNuanw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, Vijendar.Mukunda@amd.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 06/48] ASoC: amd: Add driver data to acp6x machine driver
Date:   Wed,  1 Jun 2022 09:53:39 -0400
Message-Id: <20220601135421.2003328-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e521f087780d07731e8c950f2f34d08358c86bc9 ]

Currently all of the quirked systems use the same card and so the
DMI quirk list doesn't contain driver data.

Add driver data to these quirks and then check the data was present
or not.  This will allow potentially setting quirks for systems with
faulty firmware that claims to have a DMIC but doesn't really.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220411134532.13538-2-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 9a767f47b89f..959b70e8baf2 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,108 +45,126 @@ static struct snd_soc_card acp6x_card = {
 
 static const struct dmi_system_id yc_acp_quirk_table[] = {
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D2"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D3"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D4"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D5"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CF"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CG"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CQ"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CR"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21AW"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21AX"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21BN"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21BQ"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CH"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CJ"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CK"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21CL"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D8"),
 		}
 	},
 	{
+		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21D9"),
@@ -157,18 +175,21 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 
 static int acp6x_probe(struct platform_device *pdev)
 {
+	const struct dmi_system_id *dmi_id;
 	struct acp6x_pdm *machine = NULL;
 	struct snd_soc_card *card;
 	int ret;
-	const struct dmi_system_id *dmi_id;
 
+	/* check for any DMI overrides */
 	dmi_id = dmi_first_match(yc_acp_quirk_table);
-	if (!dmi_id)
+	if (dmi_id)
+		platform_set_drvdata(pdev, dmi_id->driver_data);
+
+	card = platform_get_drvdata(pdev);
+	if (!card)
 		return -ENODEV;
-	card = &acp6x_card;
 	acp6x_card.dev = &pdev->dev;
 
-	platform_set_drvdata(pdev, card);
 	snd_soc_card_set_drvdata(card, machine);
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 	if (ret) {
-- 
2.35.1

