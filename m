Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FB1551982
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbiFTNEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243762AbiFTNCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:02:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984421DA64;
        Mon, 20 Jun 2022 05:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22FDD61535;
        Mon, 20 Jun 2022 12:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0074C3411B;
        Mon, 20 Jun 2022 12:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729849;
        bh=H8rmEyrVTKLzJ7QSvB+TXXUSK8ndpboB0UP/6+u9+Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ed9xWTk2OMqXFoYnP1Ml1UD17yszVLFaQAt43d1/tBdF2Ss1Mlkdfy5LhUSoIpLKG
         iWTjlnTJBH/PEveZqsKeVyXlZyxxa90gDobeDrYedluc8eWOZrtB7znAuM+0wZL4HK
         6ob/ZhiS1oDk387eT31WvR6rv5lkttGWJJsoTm1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 095/141] irqchip/gic-v3: Fix refcount leak in gic_populate_ppi_partitions
Date:   Mon, 20 Jun 2022 14:50:33 +0200
Message-Id: <20220620124732.353647343@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit fa1ad9d4cc47ca2470cd904ad4519f05d7e43a2b ]

of_find_node_by_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: e3825ba1af3a ("irqchip/gic-v3: Add support for partitioned PPIs")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220601080930.31005-6-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 7855a2d7499e..d5420f9d6219 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1963,12 +1963,15 @@ static void __init gic_populate_ppi_partitions(struct device_node *gic_node)
 				continue;
 
 			cpu = of_cpu_node_to_id(cpu_node);
-			if (WARN_ON(cpu < 0))
+			if (WARN_ON(cpu < 0)) {
+				of_node_put(cpu_node);
 				continue;
+			}
 
 			pr_cont("%pOF[%d] ", cpu_node, cpu);
 
 			cpumask_set_cpu(cpu, &part->mask);
+			of_node_put(cpu_node);
 		}
 
 		pr_cont("}\n");
-- 
2.35.1



