Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E9D6C0D21
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjCTJW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjCTJWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:22:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAED23D80
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B32B5612CB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2670C433EF;
        Mon, 20 Mar 2023 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679304098;
        bh=3FsDVhavfJR3dWvMhZM4RhnbO3qhQhZtikJsF4H/xTM=;
        h=Subject:To:Cc:From:Date:From;
        b=TX+4s8JlxuBTWp011CcrVOeVz8KoEGpIFcg+GLWDKuLVNd0hGbrfvThi6VEZtFGbf
         /e5MuEs5EsOEzmek1j7RjTXNhnxxp87FpxYce3TVkjZW+ChELX+1iZ1fhDrMYyMN7r
         nNUzNL0Ir80OTNS3eZuDVm1rdAPNDRpMMDZ230Ng=
Subject: FAILED: patch "[PATCH] interconnect: qcom: msm8974: fix registration race" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, bmasney@redhat.com, djakov@kernel.org,
        konrad.dybcio@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:21:27 +0100
Message-ID: <167930408724934@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x bfe7bcd2b9f5215de2144f097f39971180e7ea54
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930408724934@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

bfe7bcd2b9f5 ("interconnect: qcom: msm8974: fix registration race")
919d4e1a207e ("interconnect: msm8974: Ignore return value of icc_provider_del() in .remove()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bfe7bcd2b9f5215de2144f097f39971180e7ea54 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:39 +0100
Subject: [PATCH] interconnect: qcom: msm8974: fix registration race

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 4e60a9568dc6 ("interconnect: qcom: add msm8974 driver")
Cc: stable@vger.kernel.org      # 5.5
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-12-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>

diff --git a/drivers/interconnect/qcom/msm8974.c b/drivers/interconnect/qcom/msm8974.c
index 5ea192f1141d..1828deaca443 100644
--- a/drivers/interconnect/qcom/msm8974.c
+++ b/drivers/interconnect/qcom/msm8974.c
@@ -692,7 +692,6 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 		return ret;
 
 	provider = &qp->provider;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->dev = dev;
 	provider->set = msm8974_icc_set;
 	provider->aggregate = icc_std_aggregate;
@@ -700,11 +699,7 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 	provider->data = data;
 	provider->get_bw = msm8974_get_bw;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
-		goto err_disable_clks;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -712,7 +707,7 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err_del_icc;
+			goto err_remove_nodes;
 		}
 
 		node->name = qnodes[i]->name;
@@ -729,15 +724,16 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	return 0;
 
-err_del_icc:
+err_remove_nodes:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
-
-err_disable_clks:
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
 
 	return ret;
@@ -747,9 +743,9 @@ static int msm8974_icc_remove(struct platform_device *pdev)
 {
 	struct msm8974_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }

