Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAC56C1979
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjCTPeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbjCTPdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:33:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F22C66D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D36D3B80EAB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8EDC433D2;
        Mon, 20 Mar 2023 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325986;
        bh=O1djjdNeVrIxkJtJm314G+XmCPCTgsiaGGv1SQJOA3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8503njEAxhA4NzV/DFn5SxOqFn4FVT43F14TSIJaZ9rhmziA5HyV21zSGGlsYYRL
         tsSrjGJMvzGWQUzxVRDDmZRnE739DaFwocTI6hYypopnPszqnN78PjFUWkjW2XdBbS
         sMp3MX03HCBIkrCss8jQC11kFVQzV3LyT1zEZHIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Jun Nie <jun.nie@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.2 136/211] interconnect: qcom: rpm: fix registration race
Date:   Mon, 20 Mar 2023 15:54:31 +0100
Message-Id: <20230320145519.137538212@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

commit 90ae93d8affc1061cd87ca8ddd9a838c7d31a158 upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 62feb14ee8a3 ("interconnect: qcom: Consolidate interconnect RPM support")
Fixes: 30c8fa3ec61a ("interconnect: qcom: Add MSM8916 interconnect provider driver")
Cc: stable@vger.kernel.org	# 5.7
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Jun Nie <jun.nie@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-9-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/icc-rpm.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -503,7 +503,6 @@ regmap_done:
 	}
 
 	provider = &qp->provider;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->dev = dev;
 	provider->set = qcom_icc_set;
 	provider->pre_aggregate = qcom_icc_pre_bw_aggregate;
@@ -511,12 +510,7 @@ regmap_done:
 	provider->xlate_extended = qcom_icc_xlate_extended;
 	provider->data = data;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
-		clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-		return ret;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -524,7 +518,7 @@ regmap_done:
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err;
+			goto err_remove_nodes;
 		}
 
 		node->name = qnodes[i]->name;
@@ -538,20 +532,26 @@ regmap_done:
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	/* Populate child NoC devices if any */
 	if (of_get_child_count(dev->of_node) > 0) {
 		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
 		if (ret)
-			goto err;
+			goto err_deregister_provider;
 	}
 
 	return 0;
-err:
+
+err_deregister_provider:
+	icc_provider_deregister(provider);
+err_remove_nodes:
 	icc_nodes_remove(provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(provider);
 
 	return ret;
 }
@@ -561,9 +561,9 @@ int qnoc_remove(struct platform_device *
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }


