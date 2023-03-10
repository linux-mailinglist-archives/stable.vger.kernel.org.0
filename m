Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D996B43C2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjCJOR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjCJORI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:17:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2664711BB1E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEF86B8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484F0C433EF;
        Fri, 10 Mar 2023 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457769;
        bh=fVg5T/di/f/pkK7TX69srjkUk/zAxCGI9v7LEm9B5Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+R9QyknxZHqJE+eRzHWCo4GPT2K6l4FJxO4fy++EGJ5Y5Hy9jalvzlOTfrAnbZvW
         am2y1n04q1tOBHoAs11b/c68bgm1mEADn3O8TmUv5QqvSlcmgktE1JuQU40hmMs+Dl
         Did0HJ9voSvkNlWp2AqGpQs/6Flq3O8XA9JnnIFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/252] irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe
Date:   Fri, 10 Mar 2023 14:37:00 +0100
Message-Id: <20230310133720.327968937@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

[ Upstream commit 9419e700021a393f67be36abd0c4f3acc6139041 ]

of_irq_find_parent() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: a68a63cb4dfc ("irqchip/irq-mvebu-gicp: Add new driver for Marvell GICP")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230102084208.3951758-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mvebu-gicp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-mvebu-gicp.c b/drivers/irqchip/irq-mvebu-gicp.c
index 3be5c5dba1dab..5caec411059f5 100644
--- a/drivers/irqchip/irq-mvebu-gicp.c
+++ b/drivers/irqchip/irq-mvebu-gicp.c
@@ -223,6 +223,7 @@ static int mvebu_gicp_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(irq_parent_dn);
+	of_node_put(irq_parent_dn);
 	if (!parent_domain) {
 		dev_err(&pdev->dev, "failed to find parent IRQ domain\n");
 		return -ENODEV;
-- 
2.39.2



