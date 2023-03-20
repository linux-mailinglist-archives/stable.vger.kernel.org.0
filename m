Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CD96C0D06
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjCTJUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjCTJUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14C461AE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05C3B612CB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179DFC433EF;
        Mon, 20 Mar 2023 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679304012;
        bh=UtB3l7NmRdbR2yDWv0SwcBekOhxInA/mQpOWUWNvo5M=;
        h=Subject:To:Cc:From:Date:From;
        b=Qh3KErAad5FAc5pHe9QcoBoio6mgwW1+1FZUKq+9sYxoG7jIvJ6XiQkGoC471p4f8
         MOsHmAxWcc3yYqEXyVAxQVVVcO2GDuPmjsujvJvfd/rF3dtnf6wMylcZkkin0bDlEr
         BgJN0B6fUGdyxSKdZBELdToLFaot27tIMN74nrgU=
Subject: FAILED: patch "[PATCH] interconnect: qcom: osm-l3: fix registration race" failed to apply to 5.15-stable tree
To:     johan+linaro@kernel.org, djakov@kernel.org,
        konrad.dybcio@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:20:09 +0100
Message-ID: <167930400918528@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 174941ed28a3573db075da46d95b4dcf9d4c49c2
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930400918528@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

174941ed28a3 ("interconnect: qcom: osm-l3: fix registration race")
f221bd781f25 ("interconnect: osm-l3: Ignore return value of icc_provider_del() in .remove()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 174941ed28a3573db075da46d95b4dcf9d4c49c2 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:33 +0100
Subject: [PATCH] interconnect: qcom: osm-l3: fix registration race

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail:

	of_icc_xlate_onecell: invalid index 0
	cpu cpu0: error -EINVAL: error finding src node
	cpu cpu0: dev_pm_opp_of_find_icc_paths: Unable to get path0: -22
	qcom-cpufreq-hw: probe of 18591000.cpufreq failed with error -22

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 5bc9900addaf ("interconnect: qcom: Add OSM L3 interconnect provider support")
Cc: stable@vger.kernel.org      # 5.7
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-6-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>

diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
index 1bc01ff6e02a..1bafb54f1432 100644
--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -158,8 +158,8 @@ static int qcom_osm_l3_remove(struct platform_device *pdev)
 {
 	struct qcom_osm_l3_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
@@ -245,14 +245,9 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	provider->set = qcom_osm_l3_set;
 	provider->aggregate = icc_std_aggregate;
 	provider->xlate = of_icc_xlate_onecell;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->data = data;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(&pdev->dev, "error adding interconnect provider\n");
-		return ret;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -275,12 +270,15 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err;
+
 	platform_set_drvdata(pdev, qp);
 
 	return 0;
 err:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
 
 	return ret;
 }

