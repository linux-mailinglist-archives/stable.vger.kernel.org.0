Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E31B6AEE8D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjCGSNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjCGSMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:12:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43504AFF5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0C21CE1C7C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95EDC433EF;
        Tue,  7 Mar 2023 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212488;
        bh=adfI7gkBjRPe8wcG6BmEMiI08lGy4cdEBvKMLwubp/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0xiDrPXFrD9s8TihY6CaTD80HIotJpM2wYFtQtKEB//TTCCOgKPOMD+JlyWPgUuf
         BG5OzqUxQr/IYvcqtl/+6kBCfYFbUR66p1bbTEMFgfbZ1zA7Go9+mZvHnfSQLj0UWv
         rf8hi6XhBxtlmqHcJuzZ+/vQrRGqm7t8xmPFN9gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/885] irqchip: Fix refcount leak in platform_irqchip_probe
Date:   Tue,  7 Mar 2023 17:52:13 +0100
Message-Id: <20230307170010.676394000@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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



