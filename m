Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5268C6AF3C1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjCGTJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjCGTIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:08:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284B3A2C32
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:53:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C199061522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C54C433EF;
        Tue,  7 Mar 2023 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215218;
        bh=Cn7gMTpOCmB9U0SzE4mZ87PzeeRQ8YJhQK5yYQIy9XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSEPkJq38fmWh0J7WuWukSjioZuxK2wntRh+e5KoUDmPlWNhu6RnCo3GAZgoQkI4t
         b0J2kO3NuZnfqovbonZ74Ac6+M5k0PTkHfBBC0C3OWFk23kDKNzw0XmpwVHRay3Sdk
         VFV1A6RcGj1y/6M5EL+/Ncn9DKJodTBIIS4R+Sjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/567] irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts
Date:   Tue,  7 Mar 2023 17:58:13 +0100
Message-Id: <20230307165912.737937137@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 94debe03e8afa1267f95a9001786a6aa506b9ff3 ]

When support for the level triggered interrupt controller flavor was
added with c0ca7262088e, we forgot to update the flags to be set to
contain IRQ_LEVEL. While the flow handler is correct, the output from
/proc/interrupts does not show such interrupts as being level triggered
when they are, correct that.

Fixes: c0ca7262088e ("irqchip/brcmstb-l2: Add support for the BCM7271 L2 controller")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221216230934.2478345-2-f.fainelli@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-brcmstb-l2.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index 8e0911561f2d1..fddea72272464 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -161,6 +161,7 @@ static int __init brcmstb_l2_intc_of_init(struct device_node *np,
 					  *init_params)
 {
 	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	unsigned int set = 0;
 	struct brcmstb_l2_intc_data *data;
 	struct irq_chip_type *ct;
 	int ret;
@@ -208,9 +209,12 @@ static int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		flags |= IRQ_GC_BE_IO;
 
+	if (init_params->handler == handle_level_irq)
+		set |= IRQ_LEVEL;
+
 	/* Allocate a single Generic IRQ chip for this node */
 	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
-			np->full_name, init_params->handler, clr, 0, flags);
+			np->full_name, init_params->handler, clr, set, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
-- 
2.39.2



