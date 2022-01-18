Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487F4492A89
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347132AbiARQLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:11:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40656 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347144AbiARQJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:09:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED6E61295;
        Tue, 18 Jan 2022 16:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57069C00446;
        Tue, 18 Jan 2022 16:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522180;
        bh=hTRDEN/X1rHYkMuWknx8N7RQeDUfodJ/6qtI+kqvAZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0MukKC2KRz8TTnqAKOpGfJE9Ivtggva9Ote3zEkQgL9BDkmMyut1qOcO8oPqISwJ
         gy/IUVy5xB8g1PYh56vCeYpQUIn9NnDQjghDQBfw6JJ05/rWGECmEJX9zIyslLO/JY
         LW+WfaUgJyPekwQY11PprHiy+uDWm8L/R6+/3kIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 25/28] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
Date:   Tue, 18 Jan 2022 17:06:11 +0100
Message-Id: <20220118160452.719044943@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit d278dc9151a034674b31ffeda24cdfb0073570f3 upstream.

HDA regression is recently reported on Tegra194 based platforms.
This happens because "hda2codec_2x" reset does not really exist
in Tegra194 and it causes probe failure. All the HDA based audio
tests fail at the moment. This underlying issue is exposed by
commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
response") which now checks return code of BPMP command response.
Fix this issue by skipping unavailable reset on Tegra194.

Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/1640260431-11613-2-git-send-email-spujar@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_tegra.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -68,14 +68,20 @@
  */
 #define TEGRA194_NUM_SDO_LINES	  4
 
+struct hda_tegra_soc {
+	bool has_hda2codec_2x_reset;
+};
+
 struct hda_tegra {
 	struct azx chip;
 	struct device *dev;
-	struct reset_control *reset;
+	struct reset_control_bulk_data resets[3];
 	struct clk_bulk_data clocks[3];
+	unsigned int nresets;
 	unsigned int nclocks;
 	void __iomem *regs;
 	struct work_struct probe_work;
+	const struct hda_tegra_soc *soc;
 };
 
 #ifdef CONFIG_PM
@@ -170,7 +176,7 @@ static int __maybe_unused hda_tegra_runt
 	int rc;
 
 	if (!chip->running) {
-		rc = reset_control_assert(hda->reset);
+		rc = reset_control_bulk_assert(hda->nresets, hda->resets);
 		if (rc)
 			return rc;
 	}
@@ -187,7 +193,7 @@ static int __maybe_unused hda_tegra_runt
 	} else {
 		usleep_range(10, 100);
 
-		rc = reset_control_deassert(hda->reset);
+		rc = reset_control_bulk_deassert(hda->nresets, hda->resets);
 		if (rc)
 			return rc;
 	}
@@ -427,9 +433,17 @@ static int hda_tegra_create(struct snd_c
 	return 0;
 }
 
+static const struct hda_tegra_soc tegra30_data = {
+	.has_hda2codec_2x_reset = true,
+};
+
+static const struct hda_tegra_soc tegra194_data = {
+	.has_hda2codec_2x_reset = false,
+};
+
 static const struct of_device_id hda_tegra_match[] = {
-	{ .compatible = "nvidia,tegra30-hda" },
-	{ .compatible = "nvidia,tegra194-hda" },
+	{ .compatible = "nvidia,tegra30-hda", .data = &tegra30_data },
+	{ .compatible = "nvidia,tegra194-hda", .data = &tegra194_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, hda_tegra_match);
@@ -449,6 +463,8 @@ static int hda_tegra_probe(struct platfo
 	hda->dev = &pdev->dev;
 	chip = &hda->chip;
 
+	hda->soc = of_device_get_match_data(&pdev->dev);
+
 	err = snd_card_new(&pdev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
 			   THIS_MODULE, 0, &card);
 	if (err < 0) {
@@ -456,11 +472,20 @@ static int hda_tegra_probe(struct platfo
 		return err;
 	}
 
-	hda->reset = devm_reset_control_array_get_exclusive(&pdev->dev);
-	if (IS_ERR(hda->reset)) {
-		err = PTR_ERR(hda->reset);
+	hda->resets[hda->nresets++].id = "hda";
+	hda->resets[hda->nresets++].id = "hda2hdmi";
+	/*
+	 * "hda2codec_2x" reset is not present on Tegra194. Though DT would
+	 * be updated to reflect this, but to have backward compatibility
+	 * below is necessary.
+	 */
+	if (hda->soc->has_hda2codec_2x_reset)
+		hda->resets[hda->nresets++].id = "hda2codec_2x";
+
+	err = devm_reset_control_bulk_get_exclusive(&pdev->dev, hda->nresets,
+						    hda->resets);
+	if (err)
 		goto out_free;
-	}
 
 	hda->clocks[hda->nclocks++].id = "hda";
 	hda->clocks[hda->nclocks++].id = "hda2hdmi";


