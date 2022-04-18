Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC45D5057E3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244231AbiDRN5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244520AbiDRN4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:56:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11350B84D;
        Mon, 18 Apr 2022 06:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E6D60F16;
        Mon, 18 Apr 2022 13:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F35C385A1;
        Mon, 18 Apr 2022 13:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287114;
        bh=wMNVF021LBL6XlxaibP3h0LlARBOuPXuyFPyS+lytso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfQ2jJLNJ6YTSF8xmWGmgXcAnyCjIgj8zN3evE4jG2Nnulkc+Lz9bVjxlbxt7aTQT
         CHH9GrXVG67Zc8S4i32nPR4sYrnjAJVv8N7Ar0tmvMeNfWd3Xez2YpATqJbrjOSYxG
         mH5MGuz23tyhYUJfh2y768wtq1bvtdlXa/5QMXdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 061/218] ALSA: spi: Add check for clk_enable()
Date:   Mon, 18 Apr 2022 14:12:07 +0200
Message-Id: <20220418121201.358407522@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit ca1697eb09208f0168d94b88b72f57505339cbe5 ]

As the potential failure of the clk_enable(),
it should be better to check it and return error
if fails.

Fixes: 3568459a5113 ("ALSA: at73c213: manage SSC clock")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220228022839.3547266-1-jiasheng@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/spi/at73c213.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index fac7e6eb9529..671b4516d930 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -221,7 +221,9 @@ static int snd_at73c213_pcm_open(struct snd_pcm_substream *substream)
 	runtime->hw = snd_at73c213_playback_hw;
 	chip->substream = substream;
 
-	clk_enable(chip->ssc->clk);
+	err = clk_enable(chip->ssc->clk);
+	if (err)
+		return err;
 
 	return 0;
 }
@@ -787,7 +789,9 @@ static int snd_at73c213_chip_init(struct snd_at73c213 *chip)
 		goto out;
 
 	/* Enable DAC master clock. */
-	clk_enable(chip->board->dac_clk);
+	retval = clk_enable(chip->board->dac_clk);
+	if (retval)
+		goto out;
 
 	/* Initialize at73c213 on SPI bus. */
 	retval = snd_at73c213_write_reg(chip, DAC_RST, 0x04);
@@ -900,7 +904,9 @@ static int snd_at73c213_dev_init(struct snd_card *card,
 	chip->card = card;
 	chip->irq = -1;
 
-	clk_enable(chip->ssc->clk);
+	retval = clk_enable(chip->ssc->clk);
+	if (retval)
+		return retval;
 
 	retval = request_irq(irq, snd_at73c213_interrupt, 0, "at73c213", chip);
 	if (retval) {
@@ -1019,7 +1025,9 @@ static int snd_at73c213_remove(struct spi_device *spi)
 	int retval;
 
 	/* Stop playback. */
-	clk_enable(chip->ssc->clk);
+	retval = clk_enable(chip->ssc->clk);
+	if (retval)
+		goto out;
 	ssc_writel(chip->ssc->regs, CR, SSC_BIT(CR_TXDIS));
 	clk_disable(chip->ssc->clk);
 
@@ -1099,9 +1107,16 @@ static int snd_at73c213_resume(struct device *dev)
 {
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct snd_at73c213 *chip = card->private_data;
+	int retval;
 
-	clk_enable(chip->board->dac_clk);
-	clk_enable(chip->ssc->clk);
+	retval = clk_enable(chip->board->dac_clk);
+	if (retval)
+		return retval;
+	retval = clk_enable(chip->ssc->clk);
+	if (retval) {
+		clk_disable(chip->board->dac_clk);
+		return retval;
+	}
 	ssc_writel(chip->ssc->regs, CR, SSC_BIT(CR_TXEN));
 
 	return 0;
-- 
2.34.1



