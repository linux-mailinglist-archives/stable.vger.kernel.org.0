Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9027A6A7307
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCASLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCASLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:11:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A5D4AFE0
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:11:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C4FAB810DD
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82139C4339C;
        Wed,  1 Mar 2023 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694308;
        bh=U9PmzKr2eX4knF7rwI3V5e5EUP5F/De1180ePJyKP9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBsw44RHiuptbuFFXCE6byI7qMbUxE3mGA4s/skfw1adDHUeW1zUK3IYmkpKkUy1Q
         OAhnLsEufctQBZpbcnloE7Rrf8o/az5/5g05nshR2C9lc+3zF7rZttS7LpiIC1zK24
         ZEbx9R6Q9NApUzHz7PWiXdflOkRv2WA/jfAzT6xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        V sujith kumar Reddy <Vsujithkumar.Reddy@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/42] ASoC: SOF: amd: Fix for handling spurious interrupts from DSP
Date:   Wed,  1 Mar 2023 19:08:37 +0100
Message-Id: <20230301180657.788314985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: V sujith kumar Reddy <Vsujithkumar.Reddy@amd.com>

[ Upstream commit 2e7c6652f9b86c01cbd4e988057a746a3a461969 ]

As interrupts are Level-triggered,unless and until we deassert the register
the interrupts are generated which causes spurious interrupts unhandled.

Now we deasserted the interrupt at top half which solved the below
"nobody cared" warning.

warning reported in dmesg:
	irq 80: nobody cared (try booting with the "irqpoll" option)
	CPU: 5 PID: 2735 Comm: irq/80-AudioDSP
		Not tainted 5.15.86-15817-g4c19f3e06d49 #1 1bd3fd932cf58caacc95b0504d6ea1e3eab22289
	Hardware name: Google Skyrim/Skyrim, BIOS Google_Skyrim.15303.0.0 01/03/2023
	Call Trace:
	<IRQ>
	dump_stack_lvl+0x69/0x97
	 __report_bad_irq+0x3a/0xae
	note_interrupt+0x1a9/0x1e3
	handle_irq_event_percpu+0x4b/0x6e
	handle_irq_event+0x36/0x5b
	handle_fasteoi_irq+0xae/0x171
	 __common_interrupt+0x48/0xc4
	</IRQ>

	handlers:
	acp_irq_handler [snd_sof_amd_acp] threaded [<000000007e089f34>] acp_irq_thread [snd_sof_amd_acp]
	Disabling IRQ #80

Signed-off-by: V sujith kumar Reddy <Vsujithkumar.Reddy@amd.com>
Link: https://lore.kernel.org/r/20230203123254.1898794-1-Vsujithkumar.Reddy@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 36966643e36ab..8afd67ba1e5a3 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -316,7 +316,6 @@ static irqreturn_t acp_irq_thread(int irq, void *context)
 {
 	struct snd_sof_dev *sdev = context;
 	const struct sof_amd_acp_desc *desc = get_chip_info(sdev->pdata);
-	unsigned int base = desc->dsp_intr_base;
 	unsigned int val, count = ACP_HW_SEM_RETRY_COUNT;
 
 	val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, desc->ext_intr_stat);
@@ -326,28 +325,20 @@ static irqreturn_t acp_irq_thread(int irq, void *context)
 		return IRQ_HANDLED;
 	}
 
-	val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, base + DSP_SW_INTR_STAT_OFFSET);
-	if (val & ACP_DSP_TO_HOST_IRQ) {
-		while (snd_sof_dsp_read(sdev, ACP_DSP_BAR, desc->hw_semaphore_offset)) {
-			/* Wait until acquired HW Semaphore lock or timeout */
-			count--;
-			if (!count) {
-				dev_err(sdev->dev, "%s: Failed to acquire HW lock\n", __func__);
-				return IRQ_NONE;
-			}
+	while (snd_sof_dsp_read(sdev, ACP_DSP_BAR, desc->hw_semaphore_offset)) {
+		/* Wait until acquired HW Semaphore lock or timeout */
+		count--;
+		if (!count) {
+			dev_err(sdev->dev, "%s: Failed to acquire HW lock\n", __func__);
+			return IRQ_NONE;
 		}
-
-		sof_ops(sdev)->irq_thread(irq, sdev);
-		val |= ACP_DSP_TO_HOST_IRQ;
-		snd_sof_dsp_write(sdev, ACP_DSP_BAR, base + DSP_SW_INTR_STAT_OFFSET, val);
-
-		/* Unlock or Release HW Semaphore */
-		snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->hw_semaphore_offset, 0x0);
-
-		return IRQ_HANDLED;
 	}
 
-	return IRQ_NONE;
+	sof_ops(sdev)->irq_thread(irq, sdev);
+	/* Unlock or Release HW Semaphore */
+	snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->hw_semaphore_offset, 0x0);
+
+	return IRQ_HANDLED;
 };
 
 static irqreturn_t acp_irq_handler(int irq, void *dev_id)
@@ -358,8 +349,11 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
 	unsigned int val;
 
 	val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, base + DSP_SW_INTR_STAT_OFFSET);
-	if (val)
+	if (val) {
+		val |= ACP_DSP_TO_HOST_IRQ;
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, base + DSP_SW_INTR_STAT_OFFSET, val);
 		return IRQ_WAKE_THREAD;
+	}
 
 	return IRQ_NONE;
 }
-- 
2.39.0



