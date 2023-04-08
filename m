Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8046DBA2E
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 12:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjDHKr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 06:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjDHKrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 06:47:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A817E10278;
        Sat,  8 Apr 2023 03:46:30 -0700 (PDT)
Date:   Sat, 08 Apr 2023 10:45:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1680950715;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cMtI9clwksFwmfU99cUxd1FKJjtpezVFXrLAVOKGMwg=;
        b=gkFf8NpevtNWjMhpZTNyHpvIhBWQyX3WIs+PhSPi2mzBzx4fNFKOwLrY7Zvn1ykBD6DWoU
        T9Q31dwbq0gw95oHVh7h/KrLwPBB4yXgbw24BaRPVmjvwUjuno91HAXN4TbQcwPxm7xEPf
        4miYa3u6hk7pexSevMqGIgJy0TaEA5LRMkHPMfwuo3dI0ojUea4yv5utx9ZEjjzmqJYLWU
        XUQjMvdTNEvY7W/1Sre+Ro4KAt86CX2XiPmA4mn6GrSuDKZkNBbD/QE8pTviYLP26FRCYV
        gnoacnHsOjBqaAWQzr2Su89CkJCskeZv+OfuGwDspir2ZeWvbEaTILNiwsNlsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1680950715;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cMtI9clwksFwmfU99cUxd1FKJjtpezVFXrLAVOKGMwg=;
        b=Ztw2C8RbA42o930Wj7NT7/O9RqA0SSjzv7IyddMf/zGARRKU40ZmeAJLXn70fDa0iS9KKy
        oL8CQKzLxadt1GBg==
From:   "irqchip-bot for Jianmin Lv" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/loongson-eiointc: Fix
 registration of syscore_ops
Cc:     stable@vger.kernel.org, Jianmin Lv <lvjianmin@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20230407083453.6305-4-lvjianmin@loongson.cn>
References: <20230407083453.6305-4-lvjianmin@loongson.cn>
MIME-Version: 1.0
Message-ID: <168095071504.404.12753554986819287245.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     bdd60211eebb43ba1c4c14704965f4d4b628b931
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/bdd60211eebb43ba1c4c14704965f4d4b628b931
Author:        Jianmin Lv <lvjianmin@loongson.cn>
AuthorDate:    Fri, 07 Apr 2023 16:34:51 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Sat, 08 Apr 2023 11:29:18 +01:00

irqchip/loongson-eiointc: Fix registration of syscore_ops

When support suspend/resume for loongson-eiointc, the syscore_ops
is registered twice in dual-bridges machines where there are two
eiointc IRQ domains. Repeated registration of an same syscore_ops
broke syscore_ops_list. Also, cpuhp_setup_state_nocalls is only
needed to call for once. So the patch will corret them.

Fixes: a90335c2dfb4 ("irqchip/loongson-eiointc: Add suspend/resume support")
Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230407083453.6305-4-lvjianmin@loongson.cn
---
 drivers/irqchip/irq-loongson-eiointc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index d16ed64..90181c4 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -422,10 +422,12 @@ int __init eiointc_acpi_init(struct irq_domain *parent,
 	parent_irq = irq_create_mapping(parent, acpi_eiointc->cascade);
 	irq_set_chained_handler_and_data(parent_irq, eiointc_irq_dispatch, priv);
 
-	register_syscore_ops(&eiointc_syscore_ops);
-	cpuhp_setup_state_nocalls(CPUHP_AP_IRQ_LOONGARCH_STARTING,
+	if (nr_pics == 1) {
+		register_syscore_ops(&eiointc_syscore_ops);
+		cpuhp_setup_state_nocalls(CPUHP_AP_IRQ_LOONGARCH_STARTING,
 				  "irqchip/loongarch/intc:starting",
 				  eiointc_router_init, NULL);
+	}
 
 	if (cpu_has_flatmode)
 		node = cpu_to_node(acpi_eiointc->node * CORES_PER_EIO_NODE);
