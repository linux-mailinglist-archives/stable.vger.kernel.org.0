Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E14664A5B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbjAJScd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239443AbjAJSbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:31:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024879B2B6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98DFCB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D762AC433EF;
        Tue, 10 Jan 2023 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375218;
        bh=y5DniMxNRtSzu9TC3krROfIIsCP56drbQKlJIOx3htg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfUd3592jvHI7yWsz60xqD970IFj8Jdew5V73njjQXdA3RgLk6/ev2kXwMRaRhMx7
         pDMJJ/5wYsSIHJt1Ph//dcwuDaU/A+vvxqa+gPL/PXwpayDajhsEYfRifVohhtab2H
         DwvDwHCeqDrxXUMgL3+MbLWyCT+FjAT2amtaKUAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Cercueil <paul@crapouillou.net>,
        Aidan MacDonald <aidanmacdonald.0x0@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 117/290] ASoC: jz4740-i2s: Handle independent FIFO flush bits
Date:   Tue, 10 Jan 2023 19:03:29 +0100
Message-Id: <20230110180035.837166507@linuxfoundation.org>
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

From: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>

commit 8b3a9ad86239f80ed569e23c3954a311f66481d6 upstream.

On the JZ4740, there is a single bit that flushes (empties) both
the transmit and receive FIFO. Later SoCs have independent flush
bits for each FIFO.

Independent FIFOs can be flushed before the snd_soc_dai_active()
check because it won't disturb other active streams. This ensures
that the FIFO we're about to use is always flushed before starting
up. With shared FIFOs we can't do that because if another substream
is active, flushing its FIFO would cause underrun errors.

This also fixes a bug: since we were only setting the JZ4740's
flush bit, which corresponds to the TX FIFO flush bit on other
SoCs, other SoCs were not having their RX FIFO flushed at all.

Fixes: 967beb2e8777 ("ASoC: jz4740: Add jz4780 support")
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
Signed-off-by: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
Link: https://lore.kernel.org/r/20221023143328.160866-2-aidanmacdonald.0x0@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/jz4740/jz4740-i2s.c |   39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -56,7 +56,8 @@
 #define JZ_AIC_CTRL_MONO_TO_STEREO BIT(11)
 #define JZ_AIC_CTRL_SWITCH_ENDIANNESS BIT(10)
 #define JZ_AIC_CTRL_SIGNED_TO_UNSIGNED BIT(9)
-#define JZ_AIC_CTRL_FLUSH		BIT(8)
+#define JZ_AIC_CTRL_TFLUSH		BIT(8)
+#define JZ_AIC_CTRL_RFLUSH		BIT(7)
 #define JZ_AIC_CTRL_ENABLE_ROR_INT BIT(6)
 #define JZ_AIC_CTRL_ENABLE_TUR_INT BIT(5)
 #define JZ_AIC_CTRL_ENABLE_RFS_INT BIT(4)
@@ -91,6 +92,8 @@ enum jz47xx_i2s_version {
 struct i2s_soc_info {
 	enum jz47xx_i2s_version version;
 	struct snd_soc_dai_driver *dai;
+
+	bool shared_fifo_flush;
 };
 
 struct jz4740_i2s {
@@ -119,19 +122,44 @@ static inline void jz4740_i2s_write(cons
 	writel(value, i2s->base + reg);
 }
 
+static inline void jz4740_i2s_set_bits(const struct jz4740_i2s *i2s,
+	unsigned int reg, uint32_t bits)
+{
+	uint32_t value = jz4740_i2s_read(i2s, reg);
+	value |= bits;
+	jz4740_i2s_write(i2s, reg, value);
+}
+
 static int jz4740_i2s_startup(struct snd_pcm_substream *substream,
 	struct snd_soc_dai *dai)
 {
 	struct jz4740_i2s *i2s = snd_soc_dai_get_drvdata(dai);
-	uint32_t conf, ctrl;
+	uint32_t conf;
 	int ret;
 
+	/*
+	 * When we can flush FIFOs independently, only flush the FIFO
+	 * that is starting up. We can do this when the DAI is active
+	 * because it does not disturb other active substreams.
+	 */
+	if (!i2s->soc_info->shared_fifo_flush) {
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_TFLUSH);
+		else
+			jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_RFLUSH);
+	}
+
 	if (snd_soc_dai_active(dai))
 		return 0;
 
-	ctrl = jz4740_i2s_read(i2s, JZ_REG_AIC_CTRL);
-	ctrl |= JZ_AIC_CTRL_FLUSH;
-	jz4740_i2s_write(i2s, JZ_REG_AIC_CTRL, ctrl);
+	/*
+	 * When there is a shared flush bit for both FIFOs, the TFLUSH
+	 * bit flushes both FIFOs. Flushing while the DAI is active would
+	 * cause FIFO underruns in other active substreams so we have to
+	 * guard this behind the snd_soc_dai_active() check.
+	 */
+	if (i2s->soc_info->shared_fifo_flush)
+		jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_TFLUSH);
 
 	ret = clk_prepare_enable(i2s->clk_i2s);
 	if (ret)
@@ -462,6 +490,7 @@ static struct snd_soc_dai_driver jz4740_
 static const struct i2s_soc_info jz4740_i2s_soc_info = {
 	.version = JZ_I2S_JZ4740,
 	.dai = &jz4740_i2s_dai,
+	.shared_fifo_flush = true,
 };
 
 static const struct i2s_soc_info jz4760_i2s_soc_info = {


