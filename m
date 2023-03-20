Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E516C1808
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjCTPTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjCTPTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:19:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A6516897
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD60D6158F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1A8C433D2;
        Mon, 20 Mar 2023 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325227;
        bh=hRCGny6RTst0Quh3CPsdx1tjLZSo1tA48HZCKGXoM2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyQvn7JWWb89RBy3HTdK80wVYh3c+5T6Tk4/f5vdfQ0lOzXN9ps2MAkPrv8Atfv4i
         31TIWegHM0br9e/WhfqLCCfp8aE778nmyHfPZaBnLWZ4ZNNdFmGMTWnXS7CqtOj8ZS
         611ojGiaueW1CO2iYxazlI394fX8lXS9kG/VWq0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.15 080/115] interconnect: exynos: fix node leak in probe PM QoS error path
Date:   Mon, 20 Mar 2023 15:54:52 +0100
Message-Id: <20230320145452.779257488@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 3aab264875bf3c915ea2517fae1eec213e0b4987 upstream.

Make sure to add the newly allocated interconnect node to the provider
before adding the PM QoS request so that the node is freed on errors.

Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
Cc: stable@vger.kernel.org      # 5.11
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-15-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/samsung/exynos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -149,6 +149,9 @@ static int exynos_generic_icc_probe(stru
 				 &priv->bus_clk_ratio))
 		priv->bus_clk_ratio = EXYNOS_ICC_DEFAULT_BUS_CLK_RATIO;
 
+	icc_node->data = priv;
+	icc_node_add(icc_node, provider);
+
 	/*
 	 * Register a PM QoS request for the parent (devfreq) device.
 	 */
@@ -157,9 +160,6 @@ static int exynos_generic_icc_probe(stru
 	if (ret < 0)
 		goto err_node_del;
 
-	icc_node->data = priv;
-	icc_node_add(icc_node, provider);
-
 	icc_parent_node = exynos_icc_get_parent(bus_dev->of_node);
 	if (IS_ERR(icc_parent_node)) {
 		ret = PTR_ERR(icc_parent_node);


