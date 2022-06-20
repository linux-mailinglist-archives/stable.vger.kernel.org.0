Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8628C551A24
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243628AbiFTNCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243643AbiFTNBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:01:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524AC1D339;
        Mon, 20 Jun 2022 05:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8841761538;
        Mon, 20 Jun 2022 12:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E16C3411B;
        Mon, 20 Jun 2022 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729842;
        bh=f4ierFhYKiIg4w0A3habm5TSCOLZQu2deHCWmz73H3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wu7iSQsBAxdp4yL3p+SzKvbFMCYych3yiNw2zGEwkbrcFpTuK2YNnKcn0kLmFkYbm
         NQSVDxMzzcRxj6sHSItLWHHWWsWHrko9GPiuHxE8yKFKIgD/br0eHzW9G911mNOjtN
         i4pXstiS4Nkg/mQXOcNogV8M6aX633tlopj9uNUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 093/141] irqchip/apple-aic: Fix refcount leak in aic_of_ic_init
Date:   Mon, 20 Jun 2022 14:50:31 +0200
Message-Id: <20220620124732.294192757@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 3d45670fab3c25a7452721e4588cc95c51cda134 ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: a5e8801202b3 ("irqchip/apple-aic: Parse FIQ affinities from device-tree")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220601080930.31005-4-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-apple-aic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index 478d0af16d9f..5ac83185ff47 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -1144,6 +1144,7 @@ static int __init aic_of_ic_init(struct device_node *node, struct device_node *p
 		for_each_child_of_node(affs, chld)
 			build_fiq_affinity(irqc, chld);
 	}
+	of_node_put(affs);
 
 	set_handle_irq(aic_handle_irq);
 	set_handle_fiq(aic_handle_fiq);
-- 
2.35.1



