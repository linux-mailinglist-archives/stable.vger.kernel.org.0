Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95E56B48A5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbjCJPFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbjCJPEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:04:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD002E0C6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC4176195A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF746C4339C;
        Fri, 10 Mar 2023 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459856;
        bh=EfApmi97cQVa9ECE4OGwfohfXtAm3uIYZ+xNFXCVkAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHEfrYw/RSoif5sxytpjzsGoT5hT8Vf2TmPf+v8PqZ6wsnXVjEqimTrX0IpV3zz1+
         XnMzR83CcGFJu6MxcvW+LjF7qaFgpb4ocSHP52OdFx3p+xrRqzYDiB0pYT0CIBxVls
         J8bMWvyxwAjjdeYMZGg6FUSRAhLmN9JjZw+s/3eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/529] irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts
Date:   Fri, 10 Mar 2023 14:34:45 +0100
Message-Id: <20230310133811.549552121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index c7c9e976acbb9..7d776c905b7d2 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -273,7 +273,8 @@ static int __init bcm7120_l2_intc_probe(struct device_node *dn,
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



