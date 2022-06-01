Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D18553A8B1
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355135AbiFAOLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354655AbiFAOJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:09:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DFBF59E;
        Wed,  1 Jun 2022 07:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9733615B9;
        Wed,  1 Jun 2022 14:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718A6C3411F;
        Wed,  1 Jun 2022 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092074;
        bh=zNPkcQOyShqLbV+xa1BwXlT08Aj8LMQ7Mr3OHGehq1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jv0K/ZUSRvM6KwX5tTORi6Lq6wdz0I3gL2KR8fWCmGQ6v2f5SRdSNdpurQApTT43A
         Pv3BzRd5qXSB30vnvRK6KVI7MVS5k3Tdh/2UhoGC2a7R+LO+IZUOKAdpYpGQ96utDr
         QGryjM8ZL8zmQ8x2R6nsyKKVM2bwOhQoNstL4WUXJ6pXgne7a1EwWr2i6xNxNBLFHk
         iYun0osRGpnX9u+Wcl/XfrpLBqR4gK2+HEaom1RDwy3P4meMl8pNNBYRpOXhPNyK/M
         qShapf8ftl0d+uEoqH1nXo3OToRFKc94KU74W3iiGBKRx71XeqTIVUf6SHEasEjdmj
         Qjx85cHKA7Mcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Wu <wupeng58@huawei.com>, Wei Xu <xuwei5@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 07/11] ARM: hisi: Add missing of_node_put after of_find_compatible_node
Date:   Wed,  1 Jun 2022 10:00:56 -0400
Message-Id: <20220601140100.2005469-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601140100.2005469-1-sashal@kernel.org>
References: <20220601140100.2005469-1-sashal@kernel.org>
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
index e1d67648d5d0..fccceab33325 100644
--- a/arch/arm/mach-hisi/platsmp.c
+++ b/arch/arm/mach-hisi/platsmp.c
@@ -70,14 +70,17 @@ static void __init hi3xxx_smp_prepare_cpus(unsigned int max_cpus)
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
 
@@ -163,6 +166,7 @@ static int hip01_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	if (WARN_ON(!node))
 		return -1;
 	ctrl_base = of_iomap(node, 0);
+	of_node_put(node);
 
 	/* set the secondary core boot from DDR */
 	remap_reg_value = readl_relaxed(ctrl_base + REG_SC_CTRL);
-- 
2.35.1

