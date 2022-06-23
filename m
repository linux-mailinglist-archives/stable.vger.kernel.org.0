Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BDA5586C7
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbiFWSRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbiFWSQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:16:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C9D7664;
        Thu, 23 Jun 2022 10:22:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4B8EB824B9;
        Thu, 23 Jun 2022 17:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7113C3411B;
        Thu, 23 Jun 2022 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004976;
        bh=OR3RQNyE27ZIpiYht6F5EFvIBUfv9fN4ckMXp3vcjGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uu2Zxo+fRWo39NyQuxFIsvpeP7ex9gnsQlSPdZnaL/n4Kt/q9VLf95K2aOg1qT5Fu
         c1vwR+jSOV73nXob2hYfsGYpdu4RugIwdiEmN3S5x6QXqVqB52jxDtKm2r9JWU5a0a
         2EQ1VIiXADQDxgUgXRMjhKxOg4CCgvtyHqfTkj38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/234] irqchip/gic/realview: Fix refcount leak in realview_gic_of_init
Date:   Thu, 23 Jun 2022 18:44:36 +0200
Message-Id: <20220623164348.964864622@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

[ Upstream commit f4b98e314888cc51486421bcf6d52852452ea48b ]

of_find_matching_node_and_match() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 82b0a434b436 ("irqchip/gic/realview: Support more RealView DCC variants")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220601080930.31005-2-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-realview.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic-realview.c b/drivers/irqchip/irq-gic-realview.c
index b4c1924f0255..38fab02ffe9d 100644
--- a/drivers/irqchip/irq-gic-realview.c
+++ b/drivers/irqchip/irq-gic-realview.c
@@ -57,6 +57,7 @@ realview_gic_of_init(struct device_node *node, struct device_node *parent)
 
 	/* The PB11MPCore GIC needs to be configured in the syscon */
 	map = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (!IS_ERR(map)) {
 		/* new irq mode with no DCC */
 		regmap_write(map, REALVIEW_SYS_LOCK_OFFSET,
-- 
2.35.1



