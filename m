Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399D453A7F4
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354500AbiFAOEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354429AbiFAOEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:04:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A5D880C7;
        Wed,  1 Jun 2022 06:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 368C1CE1A1F;
        Wed,  1 Jun 2022 13:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23E3C34119;
        Wed,  1 Jun 2022 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091910;
        bh=AztLQTwV6c2/ORAaTr9VKJzhEhFLOmaLcCN74dgSRZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V84uAh+aNF9OnqZY7BuwqaarKVEUqQq8Z+Jal/C6aXZwb0nUesG/aWR+dMk172QFR
         xJ2/5alg57emxQSTDfuuD5f6HvQPtB3zkjtzSOJJI7IPGW8cGSxzKYyFz6P9kMFbaS
         6YpWvyvo1GYl/kDkEmSUpvU68QglzAB0UprekPAvTMTVkM/O30hMUghtPOLIN0QO3F
         HYWQwAXT8I6H67DMcOXz3jnOSx3tZy9doSknzvMNK3NSsUH0b2RIe7T7fSNLeACL4O
         89fErLKTdSGtBKRg7X3hoPJwjvtl3i9FrC2llOpj9bI47kit0hFdxO7qc21LdUf932
         240tCAx+qW/eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Wu <wupeng58@huawei.com>, Wei Xu <xuwei5@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 17/26] ARM: hisi: Add missing of_node_put after of_find_compatible_node
Date:   Wed,  1 Jun 2022 09:57:50 -0400
Message-Id: <20220601135759.2004435-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135759.2004435-1-sashal@kernel.org>
References: <20220601135759.2004435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Peng Wu <wupeng58@huawei.com>

[ Upstream commit 9bc72e47d4630d58a840a66a869c56b29554cfe4 ]

of_find_compatible_node  will increment the refcount of the returned
device_node. Calling of_node_put() to avoid the refcount leak

Signed-off-by: Peng Wu <wupeng58@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-hisi/platsmp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-hisi/platsmp.c b/arch/arm/mach-hisi/platsmp.c
index da7a09c1dae5..1cd1d9b0aabf 100644
--- a/arch/arm/mach-hisi/platsmp.c
+++ b/arch/arm/mach-hisi/platsmp.c
@@ -67,14 +67,17 @@ static void __init hi3xxx_smp_prepare_cpus(unsigned int max_cpus)
 		}
 		ctrl_base = of_iomap(np, 0);
 		if (!ctrl_base) {
+			of_node_put(np);
 			pr_err("failed to map address\n");
 			return;
 		}
 		if (of_property_read_u32(np, "smp-offset", &offset) < 0) {
+			of_node_put(np);
 			pr_err("failed to find smp-offset property\n");
 			return;
 		}
 		ctrl_base += offset;
+		of_node_put(np);
 	}
 }
 
@@ -160,6 +163,7 @@ static int hip01_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	if (WARN_ON(!node))
 		return -1;
 	ctrl_base = of_iomap(node, 0);
+	of_node_put(node);
 
 	/* set the secondary core boot from DDR */
 	remap_reg_value = readl_relaxed(ctrl_base + REG_SC_CTRL);
-- 
2.35.1

