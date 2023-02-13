Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47626950DA
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 20:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjBMTlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 14:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjBMTlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 14:41:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4D220690;
        Mon, 13 Feb 2023 11:40:48 -0800 (PST)
Date:   Mon, 13 Feb 2023 19:40:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676317247;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3jTWrjYelcPw63MQBlHs5ntZf9rizrcUMbbhzyWiwY=;
        b=r4P442MMJpPx86Pe0jndlL97Uk3DgtN6QQYJpcjH5zcR2iWdZGAlkctjSmRv4rDiq1jZfX
        hXzqany3xgIPCLRJxi1i6ai76Fd3Nl9q0ogP77l1z0+dKxSAAzQAjpSUJEjbq4ma6ItW4x
        mCwRzpN+xXEzvs52k5TjoedahVNJNHF+9bf3QnH94iJjVqTPVO92XcAa/pMOork+t1EkVK
        RuLvBVwpGutpdeV39ARsSAKLHlEO0lLmUY0kWB+/0vFYgQOyuZkwbSn63pGLp14aqb0o82
        KOuP6iVU2jXNn7SaodoCsihybYTWo5iKYoCUQX6vzA9Poazqv8IBTf8gtHNjHg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676317247;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3jTWrjYelcPw63MQBlHs5ntZf9rizrcUMbbhzyWiwY=;
        b=+q6E7bFPxRnBO8A7sOutNVRs3OnssDbUDfCkOA/wz+SGUATx4p0jjBaoAtWFzyjBUmsGkx
        hNvvjhQV0PNM/XCA==
From:   "irqchip-bot for Johan Hovold" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqdomain: Drop bogus fwspec-mapping
 error handling
Cc:     stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        4.8@tip-bot2.tec.linutronix.de,
        "Hsin-Yi Wang" <hsinyi@chromium.org>,
        "Mark-PK Tsai" <mark-pk.tsai@mediatek.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20230213104302.17307-4-johan+linaro@kernel.org>
References: <20230213104302.17307-4-johan+linaro@kernel.org>
MIME-Version: 1.0
Message-ID: <167631724697.4906.5044974422442004026.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     e3b7ab025e931accdc2c12acf9b75c6197f1c062
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/e3b7ab025e931accdc2c12acf9b75c6197f1c062
Author:        Johan Hovold <johan+linaro@kernel.org>
AuthorDate:    Mon, 13 Feb 2023 11:42:45 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Mon, 13 Feb 2023 19:31:24 

irqdomain: Drop bogus fwspec-mapping error handling

In case a newly allocated IRQ ever ends up not having any associated
struct irq_data it would not even be possible to dispose the mapping.

Replace the bogus disposal with a WARN_ON().

This will also be used to fix a shared-interrupt mapping race, hence the
CC-stable tag.

Fixes: 1e2a7d78499e ("irqdomain: Don't set type when mapping an IRQ")
Cc: stable@vger.kernel.org      # 4.8
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-4-johan+linaro@kernel.org
---
 kernel/irq/irqdomain.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index f77549a..9f5b96c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -847,13 +847,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 	}
 
 	irq_data = irq_get_irq_data(virq);
-	if (!irq_data) {
-		if (irq_domain_is_hierarchy(domain))
-			irq_domain_free_irqs(virq, 1);
-		else
-			irq_dispose_mapping(virq);
+	if (WARN_ON(!irq_data))
 		return 0;
-	}
 
 	/* Store trigger type */
 	irqd_set_trigger_type(irq_data, type);
