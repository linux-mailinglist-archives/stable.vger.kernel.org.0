Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EE063AE8A
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiK1RJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiK1RJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:09:28 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12202793D
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669655349; x=1701191349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w9SjS+iw7M8drU3t92ZZRiL6laP6OEv4xoCOf+H8mf8=;
  b=csp714qtzSVV35FOapk5iDHwCUJ2zMC/wU+K6Qf0hT5XxntC85R9oDeh
   G/xuOW3G2/8RKJgYGZe988+xv0Kz9eM1nq5y/nmjbUqkRDqbb8rPkvRpC
   9SGL8nRZkcbdyzOWQVnjHDv/HmlQpD8t8ZTn9trowB6a/3QYGVuDKtofp
   s=;
X-IronPort-AV: E=Sophos;i="5.96,200,1665446400"; 
   d="scan'208";a="244308613"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 17:09:08 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id 61990341E05;
        Mon, 28 Nov 2022 17:09:06 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 28 Nov 2022 17:09:05 +0000
Received: from dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com
 (10.43.160.223) by EX19D028UEC003.ant.amazon.com (10.252.137.159) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Mon, 28 Nov
 2022 17:09:03 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     <stable@vger.kernel.org>, <maz@kernel.org>
CC:     <tglx@linutronix.de>, <lcapitulino@gmail.com>,
        Luiz Capitulino <luizcap@amazon.com>
Subject: [PATH stable 5.15,5.10 2/4] genirq: Always limit the affinity to online CPUs
Date:   Mon, 28 Nov 2022 17:08:33 +0000
Message-ID: <9a311a850001dc60bf1f83a21f43f9567d658c15.1669655291.git.luizcap@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1669655291.git.luizcap@amazon.com>
References: <cover.1669655291.git.luizcap@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D31UWC002.ant.amazon.com (10.43.162.220) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 kernel/irq/manage.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0c3c26fb054f..a1727cdaebed 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -222,11 +222,16 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
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
@@ -248,24 +253,28 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
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
-- 
2.37.1

