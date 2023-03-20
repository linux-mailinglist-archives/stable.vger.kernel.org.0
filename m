Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FB56C1916
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjCTPaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbjCTP37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:29:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF27713501
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A40B614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A02AC433EF;
        Mon, 20 Mar 2023 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325764;
        bh=hRCGny6RTst0Quh3CPsdx1tjLZSo1tA48HZCKGXoM2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jM0ZQedD/DV34i2MvRnUXDrFJSu1Got8kJmWOwu9Zny30EfZz4W2fJ0VLUIaOvFX9
         4sLJ4BaCfl29jNLRzgZHT9iX6ARjnqu4nywcIMpYUxGQRJ6djwRQ+7RiMuBZvahycF
         t3IEXg67wRiCVAFENQZncYlrNdTeZkLZyl3dWEFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.1 139/198] interconnect: exynos: fix node leak in probe PM QoS error path
Date:   Mon, 20 Mar 2023 15:54:37 +0100
Message-Id: <20230320145513.375043713@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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


