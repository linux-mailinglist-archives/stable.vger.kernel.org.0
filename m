Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB2258BEF0
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbiHHBe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242193AbiHHBdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:33:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD28DEB2;
        Sun,  7 Aug 2022 18:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28ACBB80DDF;
        Mon,  8 Aug 2022 01:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D372EC433D7;
        Mon,  8 Aug 2022 01:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922358;
        bh=8FaatRZzs5J89s4nJSmm66AsNZkhJ2K5cP0SUBU4jF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jK71UIXLqmDCO06QzcuLIsAYRCgHptwSkj4Bf8ernCyU8hKQ0COU5OSRiIpiaWUcE
         pvBFFuTPP+NzZsPD3EOy5nEKBFlZS87XUnprFyofMf8O4SRZIFXc3uss8KlTHs7jbg
         Yi9Z/jeRwkls8yI8co7TRiKM0LakdcfvNhfmIi7lOVBiaqUPb5Ra+y1qS7hKvkwMU0
         sjNNylU47yi5r5GVpy6iSTSvbP0N8cpqgzJLVhcnJz5/KPy1wq0J2Irr9JOkzOa6FA
         lwVx2AweywEzx6JCnlZ5PQY7SabKqPQR/ICj3Ehf+5h+1wn0oQ0d6XCvdFH5ukjJfh
         xyelPEelDncww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     William Dean <williamsukatube@163.com>,
        Hacash Robot <hacashRobot@santino.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tsbogend@alpha.franken.de, fancer.lancer@gmail.com,
        tglx@linutronix.de, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 22/58] irqchip/mips-gic: Check the return value of ioremap() in gic_of_init()
Date:   Sun,  7 Aug 2022 21:30:40 -0400
Message-Id: <20220808013118.313965-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
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

From: William Dean <williamsukatube@163.com>

[ Upstream commit 71349cc85e5930dce78ed87084dee098eba24b59 ]

The function ioremap() in gic_of_init() can fail, so
its return value should be checked.

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@163.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220723100128.2964304-1-williamsukatube@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 8a9efb6ae587..1ba0f1555c80 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -783,6 +783,10 @@ static int __init gic_of_init(struct device_node *node,
 	}
 
 	mips_gic_base = ioremap(gic_base, gic_len);
+	if (!mips_gic_base) {
+		pr_err("Failed to ioremap gic_base\n");
+		return -ENOMEM;
+	}
 
 	gicconfig = read_gic_config();
 	gic_shared_intrs = FIELD_GET(GIC_CONFIG_NUMINTERRUPTS, gicconfig);
-- 
2.35.1

