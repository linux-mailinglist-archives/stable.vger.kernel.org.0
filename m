Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F054F4318
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382491AbiDEMPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbiDEKfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661F14AE19;
        Tue,  5 Apr 2022 03:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91556B81BC5;
        Tue,  5 Apr 2022 10:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72CDC385A1;
        Tue,  5 Apr 2022 10:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154099;
        bh=vYsMLDYVMr0DTK/i9DNXbMo0fVtarin0N+Axfv9aNdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhUJXBcpKhaZf/ljG4jgsnezmajVcY5ohtatF2bWTGXPj+hSAet6sI+S0r5htoVVM
         WrvXAYqa13gBqV8sYKG4NuwhCcM9Pb1veOaO6kOpHB3c93ek/nGL1SP8z7xnfit73s
         cN8xhjoKKxNJzaskAKsmFDYSRe5GCRM75gZ8n6lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Maulik Shah <quic_mkshah@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/599] irqchip/qcom-pdc: Fix broken locking
Date:   Tue,  5 Apr 2022 09:32:32 +0200
Message-Id: <20220405070312.458810745@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 5dc63c20b67e..fc747b7f4983 100644
--- a/drivers/irqchip/qcom-pdc.c
+++ b/drivers/irqchip/qcom-pdc.c
@@ -74,17 +74,18 @@ static int qcom_pdc_gic_set_irqchip_state(struct irq_data *d,
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
 
 static void qcom_pdc_gic_disable(struct irq_data *d)
-- 
2.34.1



