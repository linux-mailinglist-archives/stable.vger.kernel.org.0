Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310FB553CB7
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355122AbiFUU5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355123AbiFUU4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:56:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F391F31900;
        Tue, 21 Jun 2022 13:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0250AB81B47;
        Tue, 21 Jun 2022 20:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1316EC3411C;
        Tue, 21 Jun 2022 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844612;
        bh=HybSNgxAqWPIYE+OjXn6sumEAN4hWRD1Ra0CL5xuTak=;
        h=From:To:Cc:Subject:Date:From;
        b=CxSLALsqZomrdG1wxo4MkLKDxjnhwcJKBwpmuant2USu3rFgb9GEzzErliR4rtwMk
         ztlnZK9T7H41QGjg3h06xt7brmePvEb9Ej9/vlgHoIexYSsyFBigXr9TqxmvAD/kHY
         wJURoV9VbUqHPjyse6XMmSVeXmBFa4g++jIs55mwHVqDqiDJ+CywIoGNSCwfyGyKI6
         gNIWCoTJ32d2CWvzhOMiC+FhJZbB5+H6vOkg0ObXXyiDSY6tmsHx82LENWdqHcLm1r
         ltcdQmcyzUwtu3cMb1Y+76k0oTh6IB7Tm5kNOYANEOpupwjCsAngcegDqxvGCKNkRf
         47m1vdo8p0/lQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Liu Ying <victor.liu@nxp.com>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.17 01/20] genirq: PM: Use runtime PM for chained interrupts
Date:   Tue, 21 Jun 2022 16:49:51 -0400
Message-Id: <20220621205010.250185-1-sashal@kernel.org>
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
index c09324663088..b171355eb57e 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -1009,8 +1009,10 @@ __irq_do_set_handler(struct irq_desc *desc, irq_flow_handler_t handle,
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
@@ -1036,6 +1038,7 @@ __irq_do_set_handler(struct irq_desc *desc, irq_flow_handler_t handle,
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
 		desc->action = &chained_action;
+		WARN_ON(irq_chip_pm_get(irq_desc_get_irq_data(desc)));
 		irq_activate_and_startup(desc, IRQ_RESEND);
 	}
 }
-- 
2.35.1

