Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F788551CE5
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345047AbiFTN0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346459AbiFTNYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:24:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702B01ADA1;
        Mon, 20 Jun 2022 06:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C52FACE139A;
        Mon, 20 Jun 2022 13:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7830C3411B;
        Mon, 20 Jun 2022 13:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730561;
        bh=HR7GqMWbL932M9kWU/TdhBn86PFa6YN1adQ5FdOgz6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXO/sgRGa+PVOhX7vzghBD/rfbQwd1aweRnpbU1ZuJ67DmA376bfuCli5Aa6ds44g
         Rx2F9Rfm4NfR5YrOVQN63N6O5gMEPabB5Im4jPwYlOfhEovD9lcGOzq58idxJQw5D4
         xelg7LMYyr4csIbyMg/weo0k2xmXR3WD3EbseDAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/106] irqchip/realtek-rtl: Fix refcount leak in map_interrupts
Date:   Mon, 20 Jun 2022 14:51:37 +0200
Message-Id: <20220620124726.703911237@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
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

[ Upstream commit eff4780f83d0ae3e5b6c02ff5d999dc4c1c5c8ce ]

of_find_node_by_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
This function doesn't call of_node_put() in error path.
Call of_node_put() directly after of_property_read_u32() to cover
both normal path and error path.

Fixes: 9f3a0f34b84a ("irqchip: Add support for Realtek RTL838x/RTL839x interrupt controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220601080930.31005-7-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 50a56820c99b..56bf502d9c67 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -134,9 +134,9 @@ static int __init map_interrupts(struct device_node *node, struct irq_domain *do
 		if (!cpu_ictl)
 			return -EINVAL;
 		ret = of_property_read_u32(cpu_ictl, "#interrupt-cells", &tmp);
+		of_node_put(cpu_ictl);
 		if (ret || tmp != 1)
 			return -EINVAL;
-		of_node_put(cpu_ictl);
 
 		cpu_int = be32_to_cpup(imap + 2);
 		if (cpu_int > 7 || cpu_int < 2)
-- 
2.35.1



