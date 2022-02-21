Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206B54BE726
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352314AbiBUJx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:53:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352323AbiBUJxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:53:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8754A1D33A;
        Mon, 21 Feb 2022 01:23:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2729860F6E;
        Mon, 21 Feb 2022 09:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118A7C340E9;
        Mon, 21 Feb 2022 09:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435420;
        bh=TYuvVS3fFqWieGFmsqv7QYOngtgAFJf28ruJSp8ojrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xM7tF3S59AZJ6vOM2f2GeN/ngr3ST6NtCRX1kfn4JdnDT2BWRkR3xXR7cA/lQfukH
         bAh8QaR9gxt0coHVe41yXapMizT+S2NMZHMWefRAi96xp8j/BJr2YZRrrGWCyYx07H
         2AoWttPUpj7jTDTSZ87P1HkLmGg1VKu6OKW0xQSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 158/227] ASoC: qcom: Actually clear DMA interrupt register for HDMI
Date:   Mon, 21 Feb 2022 09:49:37 +0100
Message-Id: <20220221084940.074411279@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

commit c8d251f51ee61df06ee0e419348d8c9160bbfb86 upstream.

In commit da0363f7bfd3 ("ASoC: qcom: Fix for DMA interrupt clear reg
overwriting") we changed regmap_write() to regmap_update_bits() so that
we can avoid overwriting bits that we didn't intend to modify.
Unfortunately this change breaks the case where a register is writable
but not readable, which is exactly how the HDMI irq clear register is
designed (grep around LPASS_HDMITX_APP_IRQCLEAR_REG to see how it's
write only). That's because regmap_update_bits() tries to read the
register from the hardware and if it isn't readable it looks in the
regmap cache to see what was written there last time to compare against
what we want to write there. Eventually, we're unable to modify this
register at all because the bits that we're trying to set are already
set in the cache.

This is doubly bad for the irq clear register because you have to write
the bit to clear an interrupt. Given the irq is level triggered, we see
an interrupt storm upon plugging in an HDMI cable and starting audio
playback. The irq storm is so great that performance degrades
significantly, leading to CPU soft lockups.

Fix it by using regmap_write_bits() so that we really do write the bits
in the clear register that we want to. This brings the number of irqs
handled by lpass_dma_interrupt_handler() down from ~150k/sec to ~10/sec.

Fixes: da0363f7bfd3 ("ASoC: qcom: Fix for DMA interrupt clear reg overwriting")
Cc: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20220209232520.4017634-1-swboyd@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-platform.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -524,7 +524,7 @@ static int lpass_platform_pcmops_trigger
 			return -EINVAL;
 		}
 
-		ret = regmap_update_bits(map, reg_irqclr, val_irqclr, val_irqclr);
+		ret = regmap_write_bits(map, reg_irqclr, val_irqclr, val_irqclr);
 		if (ret) {
 			dev_err(soc_runtime->dev, "error writing to irqclear reg: %d\n", ret);
 			return ret;
@@ -665,7 +665,7 @@ static irqreturn_t lpass_dma_interrupt_h
 	return -EINVAL;
 	}
 	if (interrupts & LPAIF_IRQ_PER(chan)) {
-		rv = regmap_update_bits(map, reg, mask, (LPAIF_IRQ_PER(chan) | val));
+		rv = regmap_write_bits(map, reg, mask, (LPAIF_IRQ_PER(chan) | val));
 		if (rv) {
 			dev_err(soc_runtime->dev,
 				"error writing to irqclear reg: %d\n", rv);
@@ -676,7 +676,7 @@ static irqreturn_t lpass_dma_interrupt_h
 	}
 
 	if (interrupts & LPAIF_IRQ_XRUN(chan)) {
-		rv = regmap_update_bits(map, reg, mask, (LPAIF_IRQ_XRUN(chan) | val));
+		rv = regmap_write_bits(map, reg, mask, (LPAIF_IRQ_XRUN(chan) | val));
 		if (rv) {
 			dev_err(soc_runtime->dev,
 				"error writing to irqclear reg: %d\n", rv);
@@ -688,7 +688,7 @@ static irqreturn_t lpass_dma_interrupt_h
 	}
 
 	if (interrupts & LPAIF_IRQ_ERR(chan)) {
-		rv = regmap_update_bits(map, reg, mask, (LPAIF_IRQ_ERR(chan) | val));
+		rv = regmap_write_bits(map, reg, mask, (LPAIF_IRQ_ERR(chan) | val));
 		if (rv) {
 			dev_err(soc_runtime->dev,
 				"error writing to irqclear reg: %d\n", rv);


