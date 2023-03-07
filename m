Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAD46AF3A0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbjCGTHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbjCGTGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:06:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB75C9AA20
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:52:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85E226152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5B5C433D2;
        Tue,  7 Mar 2023 18:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215122;
        bh=adfI7gkBjRPe8wcG6BmEMiI08lGy4cdEBvKMLwubp/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu4b+ppZKBC2mDn/JLuJ5yx1ucKllFJtsxQxQXcS0CgFWx97O4dDnSB4/Y30g/xBZ
         FKW7O2EVH344S/c+vWfpxgt9Pe9epooVqgiqBGTGf3pQiJ51pPn7Bp7W9PUJYygLQP
         mp7qH+mq282z1jjxRj+JYsugjgYecwlhm0uLiU5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/567] irqchip: Fix refcount leak in platform_irqchip_probe
Date:   Tue,  7 Mar 2023 17:57:43 +0100
Message-Id: <20230307165911.394298392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6caa5a2b78f5f53c433d3a3781e53325da22f0ac ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: f8410e626569 ("irqchip: Add IRQCHIP_PLATFORM_DRIVER_BEGIN/END and IRQCHIP_MATCH helper macros")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230102121318.3990586-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irqchip.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index 3570f0a588c4b..7899607fbee8d 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -38,8 +38,10 @@ int platform_irqchip_probe(struct platform_device *pdev)
 	struct device_node *par_np = of_irq_find_parent(np);
 	of_irq_init_cb_t irq_init_cb = of_device_get_match_data(&pdev->dev);
 
-	if (!irq_init_cb)
+	if (!irq_init_cb) {
+		of_node_put(par_np);
 		return -EINVAL;
+	}
 
 	if (par_np == np)
 		par_np = NULL;
@@ -52,8 +54,10 @@ int platform_irqchip_probe(struct platform_device *pdev)
 	 * interrupt controller. The actual initialization callback of this
 	 * interrupt controller can check for specific domains as necessary.
 	 */
-	if (par_np && !irq_find_matching_host(par_np, DOMAIN_BUS_ANY))
+	if (par_np && !irq_find_matching_host(par_np, DOMAIN_BUS_ANY)) {
+		of_node_put(par_np);
 		return -EPROBE_DEFER;
+	}
 
 	return irq_init_cb(np, par_np);
 }
-- 
2.39.2



