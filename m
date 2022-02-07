Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D609B4ABB76
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359180AbiBGL2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383502AbiBGLWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:22:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317FCC043181;
        Mon,  7 Feb 2022 03:22:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C851961380;
        Mon,  7 Feb 2022 11:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F0BC004E1;
        Mon,  7 Feb 2022 11:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232965;
        bh=fQ6HmfmTWZIJTOD7EvLAW2lH/Y8C1gMM3DzkQZuDHbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjPnq30qzdSm/XPVr1VECdL8S1zvh+/1iJhUtWxY0Qquq5eEk5r9InXGOptuMs2xg
         UzuI4YlyebEfTeqvMD3uQQCKN6yeKFSpPQHaaq6Iw0T0Ksa5Fj7NIMK0GT4AJUzqzk
         jLLu+ScPnyIZ4OTsudi4vEIOk6VnixUrTITxfnKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Devarsh Thakkar <devarsh.thakkar@xilinx.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 46/74] ASoC: xilinx: xlnx_formatter_pcm: Make buffer bytes multiple of period bytes
Date:   Mon,  7 Feb 2022 12:06:44 +0100
Message-Id: <20220207103758.733259813@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit e958b5884725dac86d36c1e7afe5a55f31feb0b2 upstream.

This patch is based on one in the Xilinx kernel tree, "ASoc: xlnx: Make
buffer bytes multiple of period bytes" by Devarsh Thakkar. The same
issue exists in the mainline version of the driver. The original
patch description is as follows:

"The Xilinx Audio Formatter IP has a constraint on period
bytes to be multiple of 64. This leads to driver changing
the period size to suitable frames such that period bytes
are multiple of 64.

Now since period bytes and period size are updated but not
the buffer bytes, this may make the buffer bytes unaligned
and not multiple of period bytes.

When this happens we hear popping noise as while DMA is being
done the buffer bytes are not enough to complete DMA access
for last period of frame within the application buffer boundary.

To avoid this, align buffer bytes too as multiple of 64, and
set another constraint to always enforce number of periods as
integer. Now since, there is already a rule in alsa core
to enforce Buffer size = Number of Periods * Period Size
this automatically aligns buffer bytes as multiple of period
bytes."

Fixes: 6f6c3c36f091 ("ASoC: xlnx: add pcm formatter platform driver")
Cc: Devarsh Thakkar <devarsh.thakkar@xilinx.com>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220107214711.1100162-2-robert.hancock@calian.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -37,6 +37,7 @@
 #define XLNX_AUD_XFER_COUNT	0x28
 #define XLNX_AUD_CH_STS_START	0x2C
 #define XLNX_BYTES_PER_CH	0x44
+#define XLNX_AUD_ALIGN_BYTES	64
 
 #define AUD_STS_IOC_IRQ_MASK	BIT(31)
 #define AUD_STS_CH_STS_MASK	BIT(29)
@@ -368,12 +369,32 @@ static int xlnx_formatter_pcm_open(struc
 	snd_soc_set_runtime_hwparams(substream, &xlnx_pcm_hardware);
 	runtime->private_data = stream_data;
 
-	/* Resize the period size divisible by 64 */
+	/* Resize the period bytes as divisible by 64 */
 	err = snd_pcm_hw_constraint_step(runtime, 0,
-					 SNDRV_PCM_HW_PARAM_PERIOD_BYTES, 64);
+					 SNDRV_PCM_HW_PARAM_PERIOD_BYTES,
+					 XLNX_AUD_ALIGN_BYTES);
 	if (err) {
 		dev_err(component->dev,
-			"unable to set constraint on period bytes\n");
+			"Unable to set constraint on period bytes\n");
+		return err;
+	}
+
+	/* Resize the buffer bytes as divisible by 64 */
+	err = snd_pcm_hw_constraint_step(runtime, 0,
+					 SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
+					 XLNX_AUD_ALIGN_BYTES);
+	if (err) {
+		dev_err(component->dev,
+			"Unable to set constraint on buffer bytes\n");
+		return err;
+	}
+
+	/* Set periods as integer multiple */
+	err = snd_pcm_hw_constraint_integer(runtime,
+					    SNDRV_PCM_HW_PARAM_PERIODS);
+	if (err < 0) {
+		dev_err(component->dev,
+			"Unable to set constraint on periods to be integer\n");
 		return err;
 	}
 


