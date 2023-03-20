Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825456C0D1B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjCTJWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjCTJV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:21:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FE724114
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1214F612D6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F961C4339C;
        Mon, 20 Mar 2023 09:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679304057;
        bh=1uaPdS2Qy8i1BIp7t+/k63spdKDiZesXhV3YhbdxMic=;
        h=Subject:To:Cc:From:Date:From;
        b=0yLzFp2mTkHs6FBuUm4ENEMJCVAKkCyiTMCMIUpHg/SCJj0Azyqd6Oc/j0OplneQ4
         zmhEAInqsC2rPkZWcb47tlCYcT07PyQmmczt/lKymnYzfBXyjpnUbFwXtBJoI+Mk55
         2+lBmHG8y3bafaYaEh68SvZ6FsX2ifbwLbDOJ1fY=
Subject: FAILED: patch "[PATCH] interconnect: qcom: rpm: fix registration race" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, djakov@kernel.org, jun.nie@linaro.org,
        konrad.dybcio@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:20:46 +0100
Message-ID: <167930404610348@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 90ae93d8affc1061cd87ca8ddd9a838c7d31a158
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930404610348@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

90ae93d8affc ("interconnect: qcom: rpm: fix registration race")
bc463201f608 ("interconnect: qcom: rpm: fix probe child-node error handling")
8ef2ca20754d ("interconnect: icc-rpm: Ignore return value of icc_provider_del() in .remove()")
e39bf2972c6e ("interconnect: icc-rpm: Support child NoC device probe")
2b6c7d645118 ("interconnect: sdm660: merge common code into icc-rpm")
656ba110e164 ("interconnect: sdm660: drop default/unused values")
7ae77e60abef ("interconnect: sdm660: expand DEFINE_QNODE macros")
63e8ab610d8a ("interconnect: icc-rpm: move bus clocks handling into qnoc_probe")
13404ac8882f ("interconnect: qcom: sdm660: Add missing a2noc qos clocks")
5833c9b87662 ("interconnect: qcom: sdm660: Correct NOC_QOS_PRIORITY shift and mask")
a06c2e5c048e ("interconnect: qcom: sdm660: Fix id of slv_cnoc_mnoc_cfg")
9e856a74bd02 ("Merge branch 'icc-sdm660' into icc-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90ae93d8affc1061cd87ca8ddd9a838c7d31a158 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:36 +0100
Subject: [PATCH] interconnect: qcom: rpm: fix registration race

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

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index 91778cfcbc65..4180a06681b2 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -503,7 +503,6 @@ int qnoc_probe(struct platform_device *pdev)
 	}
 
 	provider = &qp->provider;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->dev = dev;
 	provider->set = qcom_icc_set;
 	provider->pre_aggregate = qcom_icc_pre_bw_aggregate;
@@ -511,12 +510,7 @@ int qnoc_probe(struct platform_device *pdev)
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
@@ -524,7 +518,7 @@ int qnoc_probe(struct platform_device *pdev)
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err;
+			goto err_remove_nodes;
 		}
 
 		node->name = qnodes[i]->name;
@@ -538,20 +532,26 @@ int qnoc_probe(struct platform_device *pdev)
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
@@ -561,9 +561,9 @@ int qnoc_remove(struct platform_device *pdev)
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }

