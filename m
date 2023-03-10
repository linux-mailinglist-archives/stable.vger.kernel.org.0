Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117EF6B4314
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbjCJOKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjCJOKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:10:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B77864B15
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:09:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2B860D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF856C4339B;
        Fri, 10 Mar 2023 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457372;
        bh=qgBWcSuqsd86vyiJtME/EBTG/dZrfhB4LIYVvAuMZL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doUDJQckr0+mKi9gnqRZWr6TyTiW9XDdhRu2H7UGL4zAG+3o58ZljztyBQnC2sDOf
         H7t74tb9zJN/MAcrLgHyjdJ8ngLPcN1Lrnjfp4xE5iBN4vJMRRVuy0x0HgUrNufTn6
         W4IwOIeLV6hqAY34WITbRZFWK/LuSvq1GvyR6Vog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/200] genirq/ipi: Fix NULL pointer deref in irq_data_get_affinity_mask()
Date:   Fri, 10 Mar 2023 14:38:24 +0100
Message-Id: <20230310133720.093864809@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit feabecaff5902f896531dde90646ca5dfa9d4f7d ]

If ipi_send_{mask|single}() is called with an invalid interrupt number, all
the local variables there will be NULL. ipi_send_verify() which is invoked
from these functions does verify its 'data' parameter, resulting in a
kernel oops in irq_data_get_affinity_mask() as the passed NULL pointer gets
dereferenced.

Add a missing NULL pointer check in ipi_send_verify()...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Fixes: 3b8e29a82dd1 ("genirq: Implement ipi_send_mask/single()")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/b541232d-c2b6-1fe9-79b4-a7129459e4d0@omp.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/ipi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/ipi.c b/kernel/irq/ipi.c
index bbd945bacef08..961d4af76af37 100644
--- a/kernel/irq/ipi.c
+++ b/kernel/irq/ipi.c
@@ -188,9 +188,9 @@ EXPORT_SYMBOL_GPL(ipi_get_hwirq);
 static int ipi_send_verify(struct irq_chip *chip, struct irq_data *data,
 			   const struct cpumask *dest, unsigned int cpu)
 {
-	const struct cpumask *ipimask = irq_data_get_affinity_mask(data);
+	const struct cpumask *ipimask;
 
-	if (!chip || !ipimask)
+	if (!chip || !data)
 		return -EINVAL;
 
 	if (!chip->ipi_send_single && !chip->ipi_send_mask)
@@ -199,6 +199,10 @@ static int ipi_send_verify(struct irq_chip *chip, struct irq_data *data,
 	if (cpu >= nr_cpu_ids)
 		return -EINVAL;
 
+	ipimask = irq_data_get_affinity_mask(data);
+	if (!ipimask)
+		return -EINVAL;
+
 	if (dest) {
 		if (!cpumask_subset(dest, ipimask))
 			return -EINVAL;
-- 
2.39.2



