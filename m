Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBE46C191B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbjCTPam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbjCTPaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:30:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2112E3253B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 655E7CE12E9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F42FC433EF;
        Mon, 20 Mar 2023 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325772;
        bh=XXgsjh20dOOAVU9aBn8zTTQ9u5yTkBonbr3FD3pyifw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5j+xx4cm1ajRcnGMykDyGzdTkldQfLAbV4VfO3M2QuZ0Ox48kYskd4VYlbgPMCJA
         P8U7Vnqxk+CYBvyW/RUKnSQduanOGC8WejWICYGugBk2nsxbOlaMji+1ugYn6mT0wL
         5LE0zr0tFXKGhrKM5u+Ss5/Z+gAaJFcLO+mDECWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.1 140/198] interconnect: exynos: fix registration race
Date:   Mon, 20 Mar 2023 15:54:38 +0100
Message-Id: <20230320145513.418422689@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

commit c9e46ca612cfbb0cf890f7ae7389b742e90efe64 upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to trigger a NULL-pointer
deference when either a NULL pointer or not fully initialised node is
returned from exynos_generic_icc_xlate().

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
Cc: stable@vger.kernel.org      # 5.11
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-16-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/samsung/exynos.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,12 +98,13 @@ static int exynos_generic_icc_remove(str
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
 	struct icc_node *parent_node, *node = priv->node;
 
+	icc_provider_deregister(&priv->provider);
+
 	parent_node = exynos_icc_get_parent(priv->dev->parent->of_node);
 	if (parent_node && !IS_ERR(parent_node))
 		icc_link_destroy(node, parent_node);
 
 	icc_nodes_remove(&priv->provider);
-	icc_provider_del(&priv->provider);
 
 	return 0;
 }
@@ -132,15 +133,11 @@ static int exynos_generic_icc_probe(stru
 	provider->inter_set = true;
 	provider->data = priv;
 
-	ret = icc_provider_add(provider);
-	if (ret < 0)
-		return ret;
+	icc_provider_init(provider);
 
 	icc_node = icc_node_create(pdev->id);
-	if (IS_ERR(icc_node)) {
-		ret = PTR_ERR(icc_node);
-		goto err_prov_del;
-	}
+	if (IS_ERR(icc_node))
+		return PTR_ERR(icc_node);
 
 	priv->node = icc_node;
 	icc_node->name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%pOFn",
@@ -171,14 +168,17 @@ static int exynos_generic_icc_probe(stru
 			goto err_pmqos_del;
 	}
 
+	ret = icc_provider_register(provider);
+	if (ret < 0)
+		goto err_pmqos_del;
+
 	return 0;
 
 err_pmqos_del:
 	dev_pm_qos_remove_request(&priv->qos_req);
 err_node_del:
 	icc_nodes_remove(provider);
-err_prov_del:
-	icc_provider_del(provider);
+
 	return ret;
 }
 


