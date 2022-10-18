Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEC4601EDE
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiJRAOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiJRANr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743E0186C6;
        Mon, 17 Oct 2022 17:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20A2461344;
        Tue, 18 Oct 2022 00:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EF1C433D7;
        Tue, 18 Oct 2022 00:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051804;
        bh=McN9O2o1UNCpoK0PfvvQuJZXnDfT8W1ELvLkWHRzfGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjwJY7pVgAgtm00AOQLbQMoqvBEZzb/IipJjvOtfF5eoJiEPpQP6fWBkSASl7F+Gb
         2TvG0M/7FAeRaU4DZe4p258uJlqlsubfigX4exxPTX0nWVDakImVi722D9Wh7WHp5y
         ePLFUscoL+StfSRtoOo7oo+bNVaYuqvPt6JKbHSxCgMtbkP5qrHUqrXX44ENnP4o//
         bkl2TMCgH/Kc5IIE81RXLWIZlsYKdfMCXQMzAht3gBx+fReO639lLJM05vuCGGrG1h
         IvepAONN9KiNIsOi61igWO3dPMY8Qc26YExx4LKEC+agE3hKgtBo6yBo/3We5Y+Fxn
         bBpOOHs13AE0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, frowand.list@gmail.com,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/21] of: Fix "dma-ranges" handling for bus controllers
Date:   Mon, 17 Oct 2022 20:09:32 -0400
Message-Id: <20221018000940.2731329-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000940.2731329-1-sashal@kernel.org>
References: <20221018000940.2731329-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit f1ad5338a4d57fe1fe6475003acb8c70bf9d1bdf ]

Commit 951d48855d86 ("of: Make of_dma_get_range() work on bus nodes")
relaxed the handling of "dma-ranges" for any leaf node on the assumption
that it would still represent a usage error for the property to be
present on a non-bus leaf node. However there turns out to be a fiddly
case where a bus also represents a DMA-capable device in its own right,
such as a PCIe root complex with an integrated DMA engine on its
platform side. In such cases, "dma-ranges" translation is entirely valid
for devices discovered behind the bus, but should not be erroneously
applied to the bus controller device itself which operates in its
parent's address space. Fix this by restoring the previous behaviour for
the specific case where a device is configured via its own OF node,
since it is logical to assume that a device should never represent its
own parent bus.

Reported-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/112e8f3d3e7c054ecf5e12b5ac0aa5596ec00681.1664455433.git.robin.murphy@arm.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/address.c    | 4 +++-
 drivers/of/device.c     | 9 ++++++++-
 drivers/of/of_private.h | 5 +++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 94f017d808c4..d6f5a427a329 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -579,7 +579,8 @@ u64 of_translate_address(struct device_node *dev, const __be32 *in_addr)
 }
 EXPORT_SYMBOL(of_translate_address);
 
-static struct device_node *__of_get_dma_parent(const struct device_node *np)
+#ifdef CONFIG_HAS_DMA
+struct device_node *__of_get_dma_parent(const struct device_node *np)
 {
 	struct of_phandle_args args;
 	int ret, index;
@@ -596,6 +597,7 @@ static struct device_node *__of_get_dma_parent(const struct device_node *np)
 
 	return of_node_get(args.np);
 }
+#endif
 
 static struct device_node *of_get_next_dma_parent(struct device_node *np)
 {
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 45335fe523f7..31fddce3aa2d 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -116,12 +116,19 @@ int of_dma_configure_id(struct device *dev, struct device_node *np,
 {
 	const struct iommu_ops *iommu;
 	const struct bus_dma_region *map = NULL;
+	struct device_node *bus_np;
 	u64 dma_start = 0;
 	u64 mask, end, size = 0;
 	bool coherent;
 	int ret;
 
-	ret = of_dma_get_range(np, &map);
+	if (np == dev->of_node)
+		bus_np = __of_get_dma_parent(np);
+	else
+		bus_np = of_node_get(np);
+
+	ret = of_dma_get_range(bus_np, &map);
+	of_node_put(bus_np);
 	if (ret < 0) {
 		/*
 		 * For legacy reasons, we have to assume some devices need
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 631489f7f8c0..f38301075416 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -163,12 +163,17 @@ struct bus_dma_region;
 #if defined(CONFIG_OF_ADDRESS) && defined(CONFIG_HAS_DMA)
 int of_dma_get_range(struct device_node *np,
 		const struct bus_dma_region **map);
+struct device_node *__of_get_dma_parent(const struct device_node *np);
 #else
 static inline int of_dma_get_range(struct device_node *np,
 		const struct bus_dma_region **map)
 {
 	return -ENODEV;
 }
+static inline struct device_node *__of_get_dma_parent(const struct device_node *np)
+{
+	return of_get_parent(np);
+}
 #endif
 
 void fdt_init_reserved_mem(void);
-- 
2.35.1

