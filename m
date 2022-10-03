Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BF95F2AA7
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiJCHjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiJCHhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:37:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A4953D14;
        Mon,  3 Oct 2022 00:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79A3F60FB7;
        Mon,  3 Oct 2022 07:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891F1C433C1;
        Mon,  3 Oct 2022 07:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781688;
        bh=Rr2N7WBa1tJ1NjO4kwPNhoQu3hwa15+g06TfnPPbKrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsSgrkOAML2PA1BriMABjwMHjRpG/xOofM3yyxpjJNz02lNSH4qSwgWzFaX5+ss2b
         yasAAulTgl/fDU+nf3ERSP8v0B5kNMV3hD3jR6AUGM/z8VCPRfR68SU7O7aLkTj4Oh
         SUsA8xIF8Rq+iu8BhxhWaNG5UYg0fMOn7j9CVWrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Matt Merhar <mattmerhar@protonmail.com>,
        Nicolas Chauvet <kwizart@gmail.com>
Subject: [PATCH 5.10 03/52] ALSA: hda/tegra: Use clk_bulk helpers
Date:   Mon,  3 Oct 2022 09:11:10 +0200
Message-Id: <20221003070718.803751253@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 3a465f027a33cbd2af74f882ad41729583195e8f ]

Use clk_bulk helpers to make code cleaner. Note that this patch changed
the order in which clocks are enabled to make code look nicer, but this
doesn't matter in terms of hardware.

Tested-by: Peter Geis <pgwipeout@gmail.com> # Ouya T30 audio works
Tested-by: Matt Merhar <mattmerhar@protonmail.com> # Ouya T30 boot-tested
Tested-by: Nicolas Chauvet <kwizart@gmail.com> # TK1 boot-tested
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210120003154.26749-2-digetx@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: f89e409402e2 ("ALSA: hda: Fix Nvidia dp infoframe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_tegra.c | 68 ++++++---------------------------------
 1 file changed, 9 insertions(+), 59 deletions(-)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index 1e44e337986e..957a7a9aaab0 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -70,9 +70,8 @@
 struct hda_tegra {
 	struct azx chip;
 	struct device *dev;
-	struct clk *hda_clk;
-	struct clk *hda2codec_2x_clk;
-	struct clk *hda2hdmi_clk;
+	struct clk_bulk_data clocks[3];
+	unsigned int nclocks;
 	void __iomem *regs;
 	struct work_struct probe_work;
 };
@@ -113,36 +112,6 @@ static void hda_tegra_init(struct hda_tegra *hda)
 	writel(v, hda->regs + HDA_IPFS_INTR_MASK);
 }
 
-static int hda_tegra_enable_clocks(struct hda_tegra *data)
-{
-	int rc;
-
-	rc = clk_prepare_enable(data->hda_clk);
-	if (rc)
-		return rc;
-	rc = clk_prepare_enable(data->hda2codec_2x_clk);
-	if (rc)
-		goto disable_hda;
-	rc = clk_prepare_enable(data->hda2hdmi_clk);
-	if (rc)
-		goto disable_codec_2x;
-
-	return 0;
-
-disable_codec_2x:
-	clk_disable_unprepare(data->hda2codec_2x_clk);
-disable_hda:
-	clk_disable_unprepare(data->hda_clk);
-	return rc;
-}
-
-static void hda_tegra_disable_clocks(struct hda_tegra *data)
-{
-	clk_disable_unprepare(data->hda2hdmi_clk);
-	clk_disable_unprepare(data->hda2codec_2x_clk);
-	clk_disable_unprepare(data->hda_clk);
-}
-
 /*
  * power management
  */
@@ -186,7 +155,7 @@ static int __maybe_unused hda_tegra_runtime_suspend(struct device *dev)
 		azx_stop_chip(chip);
 		azx_enter_link_reset(chip);
 	}
-	hda_tegra_disable_clocks(hda);
+	clk_bulk_disable_unprepare(hda->nclocks, hda->clocks);
 
 	return 0;
 }
@@ -198,7 +167,7 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
 	struct hda_tegra *hda = container_of(chip, struct hda_tegra, chip);
 	int rc;
 
-	rc = hda_tegra_enable_clocks(hda);
+	rc = clk_bulk_prepare_enable(hda->nclocks, hda->clocks);
 	if (rc != 0)
 		return rc;
 	if (chip && chip->running) {
@@ -268,29 +237,6 @@ static int hda_tegra_init_chip(struct azx *chip, struct platform_device *pdev)
 	return 0;
 }
 
-static int hda_tegra_init_clk(struct hda_tegra *hda)
-{
-	struct device *dev = hda->dev;
-
-	hda->hda_clk = devm_clk_get(dev, "hda");
-	if (IS_ERR(hda->hda_clk)) {
-		dev_err(dev, "failed to get hda clock\n");
-		return PTR_ERR(hda->hda_clk);
-	}
-	hda->hda2codec_2x_clk = devm_clk_get(dev, "hda2codec_2x");
-	if (IS_ERR(hda->hda2codec_2x_clk)) {
-		dev_err(dev, "failed to get hda2codec_2x clock\n");
-		return PTR_ERR(hda->hda2codec_2x_clk);
-	}
-	hda->hda2hdmi_clk = devm_clk_get(dev, "hda2hdmi");
-	if (IS_ERR(hda->hda2hdmi_clk)) {
-		dev_err(dev, "failed to get hda2hdmi clock\n");
-		return PTR_ERR(hda->hda2hdmi_clk);
-	}
-
-	return 0;
-}
-
 static int hda_tegra_first_init(struct azx *chip, struct platform_device *pdev)
 {
 	struct hda_tegra *hda = container_of(chip, struct hda_tegra, chip);
@@ -499,7 +445,11 @@ static int hda_tegra_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	err = hda_tegra_init_clk(hda);
+	hda->clocks[hda->nclocks++].id = "hda";
+	hda->clocks[hda->nclocks++].id = "hda2hdmi";
+	hda->clocks[hda->nclocks++].id = "hda2codec_2x";
+
+	err = devm_clk_bulk_get(&pdev->dev, hda->nclocks, hda->clocks);
 	if (err < 0)
 		goto out_free;
 
-- 
2.35.1



