Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7384E950B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiC1Lj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241500AbiC1Lbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:31:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A57E574B6;
        Mon, 28 Mar 2022 04:24:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E356A611D2;
        Mon, 28 Mar 2022 11:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CC2C34115;
        Mon, 28 Mar 2022 11:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466664;
        bh=HAjsokNLpm1BGeHXA8hl2TeS4FY5QiuvnC9KI1mxvmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=danXERLx4+IMqrcG3UppWPmoOXV8LLouEmFzUZCBgqP6hBwoUtOljZe89oXatxBDe
         0stLf/5MGYf2EZ9avwdyxO7qPPy5y5/vuNy14HEBiBiFr9kiKT5M0ZYQ2S3bqO78QQ
         YGTwQa81iY21VrsqNDFoCGRY3frfbc1BBBikQsUEwzvfby7VKFdsqoRuOrkUbKiMzR
         2vrt7E17UwkxodMoW2omPwzSGbzSStpAljyg3AVeA8La8+ITVIk0GxPj8GRCTgomp4
         hCATFjICflCVb83PSWrPAhu57JcQiLTWC5qSXv8f7Rnv3STVYURMVDzfZaOuyAEAbA
         WQ1MQBG9jiPzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Maulik Shah <quic_mkshah@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, tglx@linutronix.de,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/12] irqchip/qcom-pdc: Fix broken locking
Date:   Mon, 28 Mar 2022 07:24:09 -0400
Message-Id: <20220328112417.1556946-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112417.1556946-1-sashal@kernel.org>
References: <20220328112417.1556946-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit a6aca2f460e203781dc41391913cc5b54f4bc0ce ]

pdc_enable_intr() serves as a primitive to qcom_pdc_gic_{en,dis}able,
and has a raw spinlock for mutual exclusion, which is uses with
interruptible primitives.

This means that this critical section can itself be interrupted.
Should the interrupt also be a PDC interrupt, and the endpoint driver
perform an irq_disable() on that interrupt, we end-up in a deadlock.

Fix this by using the irqsave/irqrestore variants of the locking
primitives.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Maulik Shah <quic_mkshah@quicinc.com>
Link: https://lore.kernel.org/r/20220224101226.88373-5-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/qcom-pdc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/qcom-pdc.c b/drivers/irqchip/qcom-pdc.c
index faa7d61b9d6c..239a889df608 100644
--- a/drivers/irqchip/qcom-pdc.c
+++ b/drivers/irqchip/qcom-pdc.c
@@ -50,17 +50,18 @@ static u32 pdc_reg_read(int reg, u32 i)
 static void pdc_enable_intr(struct irq_data *d, bool on)
 {
 	int pin_out = d->hwirq;
+	unsigned long flags;
 	u32 index, mask;
 	u32 enable;
 
 	index = pin_out / 32;
 	mask = pin_out % 32;
 
-	raw_spin_lock(&pdc_lock);
+	raw_spin_lock_irqsave(&pdc_lock, flags);
 	enable = pdc_reg_read(IRQ_ENABLE_BANK, index);
 	enable = on ? ENABLE_INTR(enable, mask) : CLEAR_INTR(enable, mask);
 	pdc_reg_write(IRQ_ENABLE_BANK, index, enable);
-	raw_spin_unlock(&pdc_lock);
+	raw_spin_unlock_irqrestore(&pdc_lock, flags);
 }
 
 static void qcom_pdc_gic_mask(struct irq_data *d)
-- 
2.34.1

