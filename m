Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FC46B40D5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjCJNqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjCJNq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:46:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE277112593
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:46:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 895CF617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FA2C433A0;
        Fri, 10 Mar 2023 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455987;
        bh=MBeUSj+/Dfp0K3q/zSJkEDfkSpX8tvHFK+9uWM0GJ94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P107czhSXx8eMT/qxZdVhRlOv1CkPb+zMjaW6tAQ+yi+EzXctp0nmGXqEjP0DCrfB
         LmFn/NPD9g3mpfC4HgRRCLYAKC5TfHLzjGxW1qv01xvLZrH4puWZ9TzRtmt6k3TFPY
         VVPdaeZerwMo4bfcNzzG+pNEer+iZxS0X4E/r29Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 043/193] irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains
Date:   Fri, 10 Mar 2023 14:37:05 +0100
Message-Id: <20230310133712.419528888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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

[ Upstream commit 071d068b89e95d1b078aa6bbcb9d0961b77d6aa1 ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: e6b78f2c3e14 ("irqchip: Add the Alpine MSIX interrupt controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230102082811.3947760-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-alpine-msi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-alpine-msi.c b/drivers/irqchip/irq-alpine-msi.c
index ac431697ebe1c..5e03574e1c5fb 100644
--- a/drivers/irqchip/irq-alpine-msi.c
+++ b/drivers/irqchip/irq-alpine-msi.c
@@ -199,6 +199,7 @@ static int alpine_msix_init_domains(struct alpine_msix_data *priv,
 	}
 
 	gic_domain = irq_find_host(gic_node);
+	of_node_put(gic_node);
 	if (!gic_domain) {
 		pr_err("Failed to find the GIC domain\n");
 		return -ENXIO;
-- 
2.39.2



