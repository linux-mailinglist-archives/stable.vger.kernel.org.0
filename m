Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4285217D2
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243230AbiEJN2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243967AbiEJN1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:27:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F55B140AC;
        Tue, 10 May 2022 06:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55021CE1E73;
        Tue, 10 May 2022 13:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D80C385A6;
        Tue, 10 May 2022 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188847;
        bh=pz8zjZPWrbsGCPy0NPZ+4qZXWpmaB0sZuWf9cMya9uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeltMjU/7eppVCfh6nJUDIcIMMpHodI7+LCvAicGoKE0vkC3wGu3et9BgmAiSeanh
         Yh4YG5JDPhJcPdLzVGMFbnSTbfUky8209j0TNViHtbnIQMqYgZeUtGApp/tN7UxihW
         3vMPztfpPrBK86Ke19OVjNLqB8vdYNG3SO1Sm/Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/88] phy: samsung: Fix missing of_node_put() in exynos_sata_phy_probe
Date:   Tue, 10 May 2022 15:07:10 +0200
Message-Id: <20220510130734.477403714@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 388ec8f079f2f20d5cd183c3bc6f33cbc3ffd3ef ]

The device_node pointer is returned by of_parse_phandle() with refcount
incremented. We should use of_node_put() on it when done.

Fixes: bcff4cba41bc ("PHY: Exynos: Add Exynos5250 SATA PHY driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220407091857.230386-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/samsung/phy-exynos5250-sata.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/samsung/phy-exynos5250-sata.c b/drivers/phy/samsung/phy-exynos5250-sata.c
index 60e13afcd9b8..7960c69d09a6 100644
--- a/drivers/phy/samsung/phy-exynos5250-sata.c
+++ b/drivers/phy/samsung/phy-exynos5250-sata.c
@@ -193,6 +193,7 @@ static int exynos_sata_phy_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	sata_phy->client = of_find_i2c_device_by_node(node);
+	of_node_put(node);
 	if (!sata_phy->client)
 		return -EPROBE_DEFER;
 
-- 
2.35.1



