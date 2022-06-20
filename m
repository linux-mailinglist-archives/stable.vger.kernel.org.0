Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E655519FF
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243615AbiFTNC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243622AbiFTNBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:01:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339AB1A805;
        Mon, 20 Jun 2022 05:57:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71472B811B3;
        Mon, 20 Jun 2022 12:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09BEC3411B;
        Mon, 20 Jun 2022 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729839;
        bh=0NiU3q04Yw7ZAx4tls9RQONgYiwgPEBbj0htnP3IXHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gikJ4s+gkI3NjHhaxKF5kQfolC0UMqPQPtkZRGV9wuJRZw3f0QNercwYD7cHWpHDd
         8gyHysfT0W+b69UXfklhHiDGTH7UykzF1T+n9XAj/UgyF0/Rv+nWwUKQou715SiYYy
         lmvco4ee1qzDP6+LnZvInTTz+G9nEI1KjZD7kMdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 092/141] irqchip/apple-aic: Fix refcount leak in build_fiq_affinity
Date:   Mon, 20 Jun 2022 14:50:30 +0200
Message-Id: <20220620124732.264561958@linuxfoundation.org>
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

[ Upstream commit b1ac803f47cb1615468f35cf1ccb553c52087301 ]

of_find_node_by_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: a5e8801202b3 ("irqchip/apple-aic: Parse FIQ affinities from device-tree")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220601080930.31005-3-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-apple-aic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index 12dd48727a15..478d0af16d9f 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -1035,6 +1035,7 @@ static void build_fiq_affinity(struct aic_irq_chip *ic, struct device_node *aff)
 			continue;
 
 		cpu = of_cpu_node_to_id(cpu_node);
+		of_node_put(cpu_node);
 		if (WARN_ON(cpu < 0))
 			continue;
 
-- 
2.35.1



