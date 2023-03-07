Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BEE6AE9C6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjCGR1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjCGR1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:27:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288829C9B1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0690B819AE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069A9C4339B;
        Tue,  7 Mar 2023 17:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209741;
        bh=613B8kDUkCc7hhICIDXxRQLQICvxMvkmU72C1AMTlEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhxbEvn3aFYEn8FjJRLNz5/MBzqZs1n8n4rV4NG0W2o9MkS1DjEuhBUXxwJAf97Dq
         S2iHpi+65kjIYdrsI2qyZOY+hC6KKluzVxKYE5Z0t+OWSU24ZanBGL/sA5YOlib2m4
         a01/yxhxjnbdTOVvBZvR1rDzbQuYiExHP274vCJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0316/1001] irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts
Date:   Tue,  7 Mar 2023 17:51:28 +0100
Message-Id: <20230307170035.268694095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 13a157b38ca5b4f9eed81442b8821db293755961 ]

When support for the interrupt controller was added with a5042de2688d,
we forgot to update the flags to be set to contain IRQ_LEVEL. While the
flow handler is correct, the output from /proc/interrupts does not show
such interrupts as being level triggered when they are, correct that.

Fixes: a5042de2688d ("irqchip: bcm7120-l2: Add Broadcom BCM7120-style Level 2 interrupt controller")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221216230934.2478345-3-f.fainelli@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm7120-l2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index bb6609cebdbce..1e9dab6e0d86f 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -279,7 +279,8 @@ static int __init bcm7120_l2_intc_probe(struct device_node *dn,
 		flags |= IRQ_GC_BE_IO;
 
 	ret = irq_alloc_domain_generic_chips(data->domain, IRQS_PER_WORD, 1,
-				dn->full_name, handle_level_irq, clr, 0, flags);
+				dn->full_name, handle_level_irq, clr,
+				IRQ_LEVEL, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
-- 
2.39.2



