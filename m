Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030CC553CC5
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355789AbiFUVBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355619AbiFUU6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:58:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D3113D52;
        Tue, 21 Jun 2022 13:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5A7261881;
        Tue, 21 Jun 2022 20:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A12C341C4;
        Tue, 21 Jun 2022 20:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844692;
        bh=OS6MEuR2j6tecmiPEZ5ZVVAUFVQAjV+wZkZo9Lbcuzo=;
        h=From:To:Cc:Subject:Date:From;
        b=BdMUv+Ek/X9laiviVKxogwFzkPJcWJ7QeVcFBl04PcrTl6hLPqqQIPzaxDT0D/gaE
         L/9SP6r0R74S51bC2FBJfwcUNBWKpWri/tnj7k4fuUc4w91VzwlDDQBckZOVAVi1K3
         xjCJ9tQBzSOsqf7fVcgOccPlhpIVFqCVtKUSugAAPjRvvQ3jW/MZZXGibIAA+RJ6py
         nGUloMAYN3AhHOwP+TNVt2f6GX/CL+GvvIxnht6+/grahYaE17jVwVSV7Eh0mv6VYh
         2scZg52T+hYoV9qCjmuYkCucsZlOpTeOFSnzbWGAi3GdJc5eb94Qsg/L5ft5vby68c
         B1SCHMN8yA6QA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Liu Ying <victor.liu@nxp.com>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 4.19 1/7] genirq: PM: Use runtime PM for chained interrupts
Date:   Tue, 21 Jun 2022 16:51:23 -0400
Message-Id: <20220621205130.250874-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 668a9fe5c6a1bcac6b65d5e9b91a9eca86f782a3 ]

When requesting an interrupt, we correctly call into the runtime
PM framework to guarantee that the underlying interrupt controller
is up and running.

However, we fail to do so for chained interrupt controllers, as
the mux interrupt is not requested along the same path.

Augment __irq_do_set_handler() to call into the runtime PM code
in this case, making sure the PM flow is the same for all interrupts.

Reported-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/26973cddee5f527ea17184c0f3fccb70bc8969a0.camel@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/chip.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 9afbd89b6096..356b289b8086 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -964,8 +964,10 @@ __irq_do_set_handler(struct irq_desc *desc, irq_flow_handler_t handle,
 		if (desc->irq_data.chip != &no_irq_chip)
 			mask_ack_irq(desc);
 		irq_state_set_disabled(desc);
-		if (is_chained)
+		if (is_chained) {
 			desc->action = NULL;
+			WARN_ON(irq_chip_pm_put(irq_desc_get_irq_data(desc)));
+		}
 		desc->depth = 1;
 	}
 	desc->handle_irq = handle;
@@ -991,6 +993,7 @@ __irq_do_set_handler(struct irq_desc *desc, irq_flow_handler_t handle,
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
 		desc->action = &chained_action;
+		WARN_ON(irq_chip_pm_get(irq_desc_get_irq_data(desc)));
 		irq_activate_and_startup(desc, IRQ_RESEND);
 	}
 }
-- 
2.35.1

