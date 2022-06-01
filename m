Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448C953A73D
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354101AbiFAN65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353735AbiFAN6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:58:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994068B08F;
        Wed,  1 Jun 2022 06:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66E9DB81A79;
        Wed,  1 Jun 2022 13:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26267C385B8;
        Wed,  1 Jun 2022 13:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091719;
        bh=djdQ9S61mfxn5Qroahz8b0fLg9sK1orzkaSB+oH7BUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a081PHeC0TmLzkQNVH/ESkXWm+FyQOkAvFUmF2nzrJXIDUPYAObnGPVpZf/tNX2xP
         z9Jlgp6+rcOkUlelo+9uDUcMzbvdBi7QEYYIaIwrxGOQtGXZMii8Y6yoSvGUljh+UV
         na7Zp5NfAhFL9XWrF3AtKQR8ikXaRPMUeB8iul9+KWCAaNcLkXWOnfXohY0XxpLa9h
         VjgIGo/rMy6+YtIjDkrd96mhPFPdYEUbXkRRBqHKQ//tYJCgcLVW5znVrqc006yeLh
         3W64fNihVmNInVFK5YJc6wamVHmIwNQa8+4Thc/3O9ammBgSodDwtHvWiOYk3BxBue
         EbVteIoA36IPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Wu <wupeng58@huawei.com>, Wei Xu <xuwei5@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 26/48] ARM: hisi: Add missing of_node_put after of_find_compatible_node
Date:   Wed,  1 Jun 2022 09:53:59 -0400
Message-Id: <20220601135421.2003328-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
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
index a56cc64deeb8..9ce93e0b6cdc 100644
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

