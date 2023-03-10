Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D416B4813
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbjCJO6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbjCJO56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:57:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDCB129707
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D15761A2D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAA3C4339E;
        Fri, 10 Mar 2023 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459873;
        bh=PtBprJ9XsFi/ywJ6L7Ncb08ObdmaseqEDbAtl1kEXP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCaENa1cVEVno7ZpXWDLDLf8mTde51DLlcxUp2G9DRubvHFX3j6vV5UO3hDiHeaQf
         UVP/L+jmeKSutCWmz1hWFtjptqEdeTcE9k0qG5cSd1ziHL7l2/tvNxj2poSWzMeOz/
         PdizAKwkeUsM6F3OVwmtc+3GYzqiW2WxA2cxZ1rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/529] irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains
Date:   Fri, 10 Mar 2023 14:34:21 +0100
Message-Id: <20230310133810.448236064@linuxfoundation.org>
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
index ede02dc2bcd0b..1819bb1d27230 100644
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



