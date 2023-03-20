Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D9A6C0DEB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCTJ6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCTJ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:58:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72E5902D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F36661311
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E6EC433D2;
        Mon, 20 Mar 2023 09:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679306277;
        bh=JlRaqKoxvsNgUFQdmb8f/nyfS3dKxEOs2+eXUYa74y0=;
        h=Subject:To:Cc:From:Date:From;
        b=GAdvcAWiqV9B/jNK1JbwiWRzHGq5cRkqEtPuRKUnEu+QU3ItkIBjtkVVOaOhIxmgp
         5X7kI82+Dzw/dqbjlw3pibWIEHjM73bOrUNkvEMZu1MNZsiSkTlFshuvnf3UdfYBB1
         frMo5QsfaQGXKcDOMqkAoh/CXVw4lfuXgwTSew2w=
Subject: FAILED: patch "[PATCH] interconnect: exynos: fix registration race" failed to apply to 5.15-stable tree
To:     johan+linaro@kernel.org, djakov@kernel.org,
        krzysztof.kozlowski@linaro.org, s.nawrocki@samsung.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:57:54 +0100
Message-ID: <1679306274128133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x c9e46ca612cfbb0cf890f7ae7389b742e90efe64
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679306274128133@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

c9e46ca612cf ("interconnect: exynos: fix registration race")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c9e46ca612cfbb0cf890f7ae7389b742e90efe64 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:43 +0100
Subject: [PATCH] interconnect: exynos: fix registration race

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

diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index e70665899482..72e42603823b 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,12 +98,13 @@ static int exynos_generic_icc_remove(struct platform_device *pdev)
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
@@ -132,15 +133,11 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
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
@@ -171,14 +168,17 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
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
 

