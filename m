Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49D0C15A2
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbfI2N5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbfI2N5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D21121920;
        Sun, 29 Sep 2019 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765455;
        bh=NWxVUz+p90O6wni9NhbjPikNGrVOFR+nVmLUqFhIDn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZw6+PwJERkyxNSBe2cqexN9gtd108F4BQQBHCKjH4PO/aLxJLc/857DyqDqP8JhV
         uHCG9bR5sIj9GPytyPK80B4JgUpeyr/xeEG5rZ7FuE4WDW0X+4AsQ7zYQtINM1WPSg
         o8owceU4RVaINA9AAKcF/9Giz9WWY02uPhwvTjXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mogens Jensen <mogens-jensen@protonmail.com>,
        Dean Wallace <duffydack73@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 25/63] ASoC: Intel: cht_bsw_max98090_ti: Enable codec clock once and keep it enabled
Date:   Sun, 29 Sep 2019 15:53:58 +0200
Message-Id: <20190929135036.909328956@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 4bcdec39c454c4e8f9512115bdcc3efec1ba5f55 upstream.

Users have been seeing sound stability issues with max98090 codecs since:
commit 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")

At first that commit broke sound for Chromebook Swanky and Clapper models,
the problem was that the machine-driver has been controlling the wrong
clock on those models since support for them was added. This was hidden by
clk-pmc-atom.c keeping the actual clk on unconditionally.

With the machine-driver controlling the proper clock, sound works again
but we are seeing bug reports describing it as: low volume,
"sounds like played at 10x speed" and instable.

When these issues are hit the following message is seen in dmesg:
"max98090 i2c-193C9890:00: PLL unlocked".

Attempts have been made to fix this by inserting a delay between enabling
the clk and enabling and checking the pll, but this has not helped.

It seems that at least on boards which use pmc_plt_clk_0 as clock,
if we ever disable the clk, the pll looses its lock and after that we get
various issues.

This commit fixes this by enabling the clock once at probe time on
these boards. In essence this restores the old behavior of clk-pmc-atom.c
always keeping the clk on on these boards.

Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Reported-by: Mogens Jensen <mogens-jensen@protonmail.com>
Reported-by: Dean Wallace <duffydack73@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/boards/cht_bsw_max98090_ti.c |   47 +++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 6 deletions(-)

--- a/sound/soc/intel/boards/cht_bsw_max98090_ti.c
+++ b/sound/soc/intel/boards/cht_bsw_max98090_ti.c
@@ -42,6 +42,7 @@ struct cht_mc_private {
 	struct clk *mclk;
 	struct snd_soc_jack jack;
 	bool ts3a227e_present;
+	int quirks;
 };
 
 static int platform_clock_control(struct snd_soc_dapm_widget *w,
@@ -53,6 +54,10 @@ static int platform_clock_control(struct
 	struct cht_mc_private *ctx = snd_soc_card_get_drvdata(card);
 	int ret;
 
+	/* See the comment in snd_cht_mc_probe() */
+	if (ctx->quirks & QUIRK_PMC_PLT_CLK_0)
+		return 0;
+
 	codec_dai = snd_soc_card_get_codec_dai(card, CHT_CODEC_DAI);
 	if (!codec_dai) {
 		dev_err(card->dev, "Codec dai not found; Unable to set platform clock\n");
@@ -222,6 +227,10 @@ static int cht_codec_init(struct snd_soc
 			"jack detection gpios not added, error %d\n", ret);
 	}
 
+	/* See the comment in snd_cht_mc_probe() */
+	if (ctx->quirks & QUIRK_PMC_PLT_CLK_0)
+		return 0;
+
 	/*
 	 * The firmware might enable the clock at
 	 * boot (this information may or may not
@@ -420,16 +429,15 @@ static int snd_cht_mc_probe(struct platf
 	int ret_val = 0;
 	struct cht_mc_private *drv;
 	const char *mclk_name;
-	int quirks = 0;
-
-	dmi_id = dmi_first_match(cht_max98090_quirk_table);
-	if (dmi_id)
-		quirks = (unsigned long)dmi_id->driver_data;
 
 	drv = devm_kzalloc(&pdev->dev, sizeof(*drv), GFP_KERNEL);
 	if (!drv)
 		return -ENOMEM;
 
+	dmi_id = dmi_first_match(cht_max98090_quirk_table);
+	if (dmi_id)
+		drv->quirks = (unsigned long)dmi_id->driver_data;
+
 	drv->ts3a227e_present = acpi_dev_found("104C227E");
 	if (!drv->ts3a227e_present) {
 		/* no need probe TI jack detection chip */
@@ -446,7 +454,7 @@ static int snd_cht_mc_probe(struct platf
 	snd_soc_card_cht.dev = &pdev->dev;
 	snd_soc_card_set_drvdata(&snd_soc_card_cht, drv);
 
-	if (quirks & QUIRK_PMC_PLT_CLK_0)
+	if (drv->quirks & QUIRK_PMC_PLT_CLK_0)
 		mclk_name = "pmc_plt_clk_0";
 	else
 		mclk_name = "pmc_plt_clk_3";
@@ -459,6 +467,21 @@ static int snd_cht_mc_probe(struct platf
 		return PTR_ERR(drv->mclk);
 	}
 
+	/*
+	 * Boards which have the MAX98090's clk connected to clk_0 do not seem
+	 * to like it if we muck with the clock. If we disable the clock when
+	 * it is unused we get "max98090 i2c-193C9890:00: PLL unlocked" errors
+	 * and the PLL never seems to lock again.
+	 * So for these boards we enable it here once and leave it at that.
+	 */
+	if (drv->quirks & QUIRK_PMC_PLT_CLK_0) {
+		ret_val = clk_prepare_enable(drv->mclk);
+		if (ret_val < 0) {
+			dev_err(&pdev->dev, "MCLK enable error: %d\n", ret_val);
+			return ret_val;
+		}
+	}
+
 	ret_val = devm_snd_soc_register_card(&pdev->dev, &snd_soc_card_cht);
 	if (ret_val) {
 		dev_err(&pdev->dev,
@@ -469,11 +492,23 @@ static int snd_cht_mc_probe(struct platf
 	return ret_val;
 }
 
+static int snd_cht_mc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+	struct cht_mc_private *ctx = snd_soc_card_get_drvdata(card);
+
+	if (ctx->quirks & QUIRK_PMC_PLT_CLK_0)
+		clk_disable_unprepare(ctx->mclk);
+
+	return 0;
+}
+
 static struct platform_driver snd_cht_mc_driver = {
 	.driver = {
 		.name = "cht-bsw-max98090",
 	},
 	.probe = snd_cht_mc_probe,
+	.remove = snd_cht_mc_remove,
 };
 
 module_platform_driver(snd_cht_mc_driver)


