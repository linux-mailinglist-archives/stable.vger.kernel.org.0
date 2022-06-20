Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AAF551E56
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245117AbiFTOCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351965AbiFTNzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:55:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B83C17046;
        Mon, 20 Jun 2022 06:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0180CB80E7A;
        Mon, 20 Jun 2022 13:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61959C3411C;
        Mon, 20 Jun 2022 13:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731310;
        bh=gVahp5tonq9RJ5FdHyURYWvE6umwriI1sVXeOZSSzR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTruDUo5OOSzdxzrMkTX365BsWvRN06o7buD3iA+/3GheYuJSeULRE3nTbrJe8rv5
         FsbMJwBkxMMhq3G7lKqQPvd4nIGk0VrY3sg7wgnCFMU95YJUAnOvbpMpTxwY9MTa8l
         UByE1Y67mT4p6rAuICIAq3Keo4F6Y9BUuDsyKqFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/240] irqchip/gic-v3: Fix error handling in gic_populate_ppi_partitions
Date:   Mon, 20 Jun 2022 14:51:59 +0200
Message-Id: <20220620124745.286569550@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

[ Upstream commit ec8401a429ffee34ccf38cebf3443f8d5ae6cb0d ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
When kcalloc fails, it missing of_node_put() and results in refcount
leak. Fix this by goto out_put_node label.

Fixes: 52085d3f2028 ("irqchip/gic-v3: Dynamically allocate PPI partition descriptors")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220601080930.31005-5-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index f589ca2480a1..8ce4a2925e92 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1616,7 +1616,7 @@ static void __init gic_populate_ppi_partitions(struct device_node *gic_node)
 
 	gic_data.ppi_descs = kcalloc(gic_data.ppi_nr, sizeof(*gic_data.ppi_descs), GFP_KERNEL);
 	if (!gic_data.ppi_descs)
-		return;
+		goto out_put_node;
 
 	nr_parts = of_get_child_count(parts_node);
 
-- 
2.35.1



