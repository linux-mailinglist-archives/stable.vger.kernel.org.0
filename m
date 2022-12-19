Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8754A6512E5
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiLSTYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiLSTXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:23:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118A62BE8
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:23:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E8D560FA8
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4780C433EF;
        Mon, 19 Dec 2022 19:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477823;
        bh=/Pldpmzlcy5Qw8pDeCjbAU2AHTtkanDviipFsOndU+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKUFixQw8TDRD5Vky2Tb64G94EtYEpG2av6QWWzDBXxD+/Y5uFvrNn2kBis+tBpW0
         KdWz4+Z9g/1xIKyNZnGu+ELnD3LFDdxVFOeZSYoAqBHTJHo3eakxFF8YFYnulSg3nh
         r6WI9uKCiQATw5ccjGC41FwR9vibArkEeyrJ524A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Anderson <sean.anderson@seco.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 07/25] irqchip/ls-extirq: Fix endianness detection
Date:   Mon, 19 Dec 2022 20:22:46 +0100
Message-Id: <20221219182943.712549304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <sean.anderson@seco.com>

commit 3ae977d0e4e3a2a2ccc912ca2d20c9430508ecdd upstream.

parent is the interrupt parent, not the parent of node. Use
node->parent. This fixes endianness detection on big-endian platforms.

Fixes: 1b00adce8afd ("irqchip/ls-extirq: Fix invalid wait context by avoiding to use regmap")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221201212807.616191-1-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-ls-extirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-ls-extirq.c
+++ b/drivers/irqchip/irq-ls-extirq.c
@@ -203,7 +203,7 @@ ls_extirq_of_init(struct device_node *no
 	if (ret)
 		goto err_parse_map;
 
-	priv->big_endian = of_device_is_big_endian(parent);
+	priv->big_endian = of_device_is_big_endian(node->parent);
 	priv->is_ls1021a_or_ls1043a = of_device_is_compatible(node, "fsl,ls1021a-extirq") ||
 				      of_device_is_compatible(node, "fsl,ls1043a-extirq");
 	raw_spin_lock_init(&priv->lock);


