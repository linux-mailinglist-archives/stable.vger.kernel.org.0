Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056FB63DDEB
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiK3Sb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiK3Sbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:31:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ABE8D660
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:31:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8567EB81B41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9783C433D6;
        Wed, 30 Nov 2022 18:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833109;
        bh=aKC9hZOqhJWUGlNzBIdHbqfof6/ONGfpYE4azo60RhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrTkv8nYslGUwYwah3yXTH0hw7KZ6yuwFor57vPo9TkGo1GvWQVzy61zitmOdicCX
         C63GCdcF7ltLFHeroalSf18wd7BjjMShu32QmnaOFDwxOl2M9XSfFo60p0pESKwm2k
         KcL0CVAhmAXkWbua4ID2EfeFWq1kAZiJF3VX6RdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.10 153/162] genirq: Always limit the affinity to online CPUs
Date:   Wed, 30 Nov 2022 19:23:54 +0100
Message-Id: <20221130180532.624355718@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Luiz Capitulino <luizcap@amazon.com>

From: Marc Zyngier <maz@kernel.org>

commit 33de0aa4bae982ed6f7c777f86b5af3e627ac937 upstream.

[ Fixed small conflicts due to the HK_FLAG_MANAGED_IRQ flag been
  renamed on upstream ]

When booting with maxcpus=<small number> (or even loading a driver
while most CPUs are offline), it is pretty easy to observe managed
affinities containing a mix of online and offline CPUs being passed
to the irqchip driver.

This means that the irqchip cannot trust the affinity passed down
from the core code, which is a bit annoying and requires (at least
in theory) all drivers to implement some sort of affinity narrowing.

In order to address this, always limit the cpumask to the set of
online CPUs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220405185040.206297-3-maz@kernel.org

Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/manage.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -223,11 +223,16 @@ int irq_do_set_affinity(struct irq_data
 {
 	struct irq_desc *desc = irq_data_to_desc(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
+	const struct cpumask  *prog_mask;
 	int ret;
 
+	static DEFINE_RAW_SPINLOCK(tmp_mask_lock);
+	static struct cpumask tmp_mask;
+
 	if (!chip || !chip->irq_set_affinity)
 		return -EINVAL;
 
+	raw_spin_lock(&tmp_mask_lock);
 	/*
 	 * If this is a managed interrupt and housekeeping is enabled on
 	 * it check whether the requested affinity mask intersects with
@@ -249,24 +254,28 @@ int irq_do_set_affinity(struct irq_data
 	 */
 	if (irqd_affinity_is_managed(data) &&
 	    housekeeping_enabled(HK_FLAG_MANAGED_IRQ)) {
-		const struct cpumask *hk_mask, *prog_mask;
-
-		static DEFINE_RAW_SPINLOCK(tmp_mask_lock);
-		static struct cpumask tmp_mask;
+		const struct cpumask *hk_mask;
 
 		hk_mask = housekeeping_cpumask(HK_FLAG_MANAGED_IRQ);
 
-		raw_spin_lock(&tmp_mask_lock);
 		cpumask_and(&tmp_mask, mask, hk_mask);
 		if (!cpumask_intersects(&tmp_mask, cpu_online_mask))
 			prog_mask = mask;
 		else
 			prog_mask = &tmp_mask;
-		ret = chip->irq_set_affinity(data, prog_mask, force);
-		raw_spin_unlock(&tmp_mask_lock);
 	} else {
-		ret = chip->irq_set_affinity(data, mask, force);
+		prog_mask = mask;
 	}
+
+	/* Make sure we only provide online CPUs to the irqchip */
+	cpumask_and(&tmp_mask, prog_mask, cpu_online_mask);
+	if (!cpumask_empty(&tmp_mask))
+		ret = chip->irq_set_affinity(data, &tmp_mask, force);
+	else
+		ret = -EINVAL;
+
+	raw_spin_unlock(&tmp_mask_lock);
+
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 	case IRQ_SET_MASK_OK_DONE:


