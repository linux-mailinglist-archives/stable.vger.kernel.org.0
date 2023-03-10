Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502346B48A2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbjCJPFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbjCJPEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:04:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA362132AB1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:57:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41D5E61A32
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E17C433D2;
        Fri, 10 Mar 2023 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459879;
        bh=mx/3ElLRUgkpbzx8APLXS+aNwjRF5FuzYkqql+gdVbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ni/S4E7yEvF+ZJkhE7oJ+aOLA8i+eu0u92yExTgF9QYPRL8pX1LZSbkmpp0/TcoI9
         Y88yCvxe6j5okN/FX4OeaqkzAd4QrvuLq3571+a9TejzQfGokOvItv94tXJ7pMmW3U
         kt7CICIMRkUexQLhGFKdWrDAvAYSsE85u7XM16QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/529] irqchip/ti-sci: Fix refcount leak in ti_sci_intr_irq_domain_probe
Date:   Fri, 10 Mar 2023 14:34:23 +0100
Message-Id: <20230310133810.534838198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 02298b7bae12936ca313975b02e7f98b06670d37 ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: cd844b0715ce ("irqchip/ti-sci-intr: Add support for Interrupt Router driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230102085611.3955984-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ti-sci-intr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-ti-sci-intr.c b/drivers/irqchip/irq-ti-sci-intr.c
index fe8fad22bcf96..020ddf29efb80 100644
--- a/drivers/irqchip/irq-ti-sci-intr.c
+++ b/drivers/irqchip/irq-ti-sci-intr.c
@@ -236,6 +236,7 @@ static int ti_sci_intr_irq_domain_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(parent_node);
+	of_node_put(parent_node);
 	if (!parent_domain) {
 		dev_err(dev, "Failed to find IRQ parent domain\n");
 		return -ENODEV;
-- 
2.39.2



