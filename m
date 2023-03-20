Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDE76C0D1C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCTJWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjCTJWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:22:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4E519C48
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23F92B80C88
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF82C433D2;
        Mon, 20 Mar 2023 09:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679304078;
        bh=1pCUscXLbPPWCzdjPgBqiOAkYQiIXOxoqyzKGcBC0LM=;
        h=Subject:To:Cc:From:Date:From;
        b=ga4/4IiUP0LRPBww3a6WCALh/aR+ZDmkCpOjTkYyHelBCca16EkdUL5Ydjz339lGN
         62AqO5q/kzDQg/MGDohUBRAJ2d9Sn2HWGfCptbcvMWeOvOQtjBtUhbRAuvi16x/o5d
         m+s/CBXGcPb362wW/cvlN1+hv68JbAtPd5Ry4FGk=
Subject: FAILED: patch "[PATCH] interconnect: qcom: rpmh: fix registration race" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, djakov@kernel.org,
        konrad.dybcio@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:21:08 +0100
Message-ID: <1679304068175236@kroah.com>
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
git cherry-pick -x 74240a5bebd48d8b843c6d0f1acfaa722a5abeb7
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679304068175236@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

74240a5bebd4 ("interconnect: qcom: rpmh: fix registration race")
6570d1d46eea ("interconnect: qcom: rpmh: fix probe child-node error handling")
4681086c9bec ("interconnect: icc-rpmh: Ignore return value of icc_provider_del() in .remove()")
57eb14779dfd ("interconnect: qcom: icc-rpmh: Support child NoC device probe")
789a39ad39bc ("interconnect: qcom: icc-rpmh: Consolidate probe functions")
46bdcac533cc ("interconnect: qcom: Add SC7280 interconnect provider driver")
c1de07884f2b ("Merge branch 'icc-sm8350' into icc-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 74240a5bebd48d8b843c6d0f1acfaa722a5abeb7 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:38 +0100
Subject: [PATCH] interconnect: qcom: rpmh: fix registration race

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
Cc: stable@vger.kernel.org      # 5.7
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-11-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>

diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index 5168bbf3d92f..fdb5e58e408b 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -192,9 +192,10 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	provider->pre_aggregate = qcom_icc_pre_aggregate;
 	provider->aggregate = qcom_icc_aggregate;
 	provider->xlate_extended = qcom_icc_xlate_extended;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->data = data;
 
+	icc_provider_init(provider);
+
 	qp->dev = dev;
 	qp->bcms = desc->bcms;
 	qp->num_bcms = desc->num_bcms;
@@ -203,10 +204,6 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	if (IS_ERR(qp->voter))
 		return PTR_ERR(qp->voter);
 
-	ret = icc_provider_add(provider);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < qp->num_bcms; i++)
 		qcom_icc_bcm_init(qp->bcms[i], dev);
 
@@ -218,7 +215,7 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 		node = icc_node_create(qn->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err;
+			goto err_remove_nodes;
 		}
 
 		node->name = qn->name;
@@ -232,19 +229,27 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	}
 
 	data->num_nodes = num_nodes;
+
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
-	icc_provider_del(provider);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_rpmh_probe);
@@ -253,8 +258,8 @@ int qcom_icc_rpmh_remove(struct platform_device *pdev)
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }

