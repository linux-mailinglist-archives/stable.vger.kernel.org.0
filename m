Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA5A6CC26D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjC1OpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbjC1OpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:45:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED57D514
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:44:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87CC9B81D6D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2545C433D2;
        Tue, 28 Mar 2023 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014697;
        bh=UNy7alHGGbVyn/tPZNs5FvFam3JZZAFua2nS+eSlX8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KStCZXWpXfldzaoroj2MTilEriPp1/BwmV+FbCvEXerSOAaNfq4xXOEzY8LF+YOSU
         0mrnXqpKIkmcEmpVTdUeZDYAc3Vli3C0UeQn3l44M2jqWL1YgYwgvDT4cvZNPodkUx
         prHAdu0wqcYVBis0kQvWhS4L+VjWiso2lBa92d8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 002/240] interconnect: qcom: sm8450: switch to qcom_icc_rpmh_* function
Date:   Tue, 28 Mar 2023 16:39:25 +0200
Message-Id: <20230328142619.751814230@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 87e8fab1917a2b3f6e3dedfd1cdf22a1416e6676 ]

Change sm8450 interconnect driver to use generic qcom_icc_rpmh_*
functions rather than embedding a copy of thema. This also fixes an
overallocation of memory for icc_onecell_data structure.

Fixes: fafc114a468e ("interconnect: qcom: Add SM8450 interconnect provider driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230105002221.1416479-3-dmitry.baryshkov@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8450.c | 98 +-----------------------------
 1 file changed, 2 insertions(+), 96 deletions(-)

diff --git a/drivers/interconnect/qcom/sm8450.c b/drivers/interconnect/qcom/sm8450.c
index e3a12e3d6e061..2d7a8e7b85ec2 100644
--- a/drivers/interconnect/qcom/sm8450.c
+++ b/drivers/interconnect/qcom/sm8450.c
@@ -1844,100 +1844,6 @@ static const struct qcom_icc_desc sm8450_system_noc = {
 	.num_bcms = ARRAY_SIZE(system_noc_bcms),
 };
 
-static int qnoc_probe(struct platform_device *pdev)
-{
-	const struct qcom_icc_desc *desc;
-	struct icc_onecell_data *data;
-	struct icc_provider *provider;
-	struct qcom_icc_node * const *qnodes;
-	struct qcom_icc_provider *qp;
-	struct icc_node *node;
-	size_t num_nodes, i;
-	int ret;
-
-	desc = device_get_match_data(&pdev->dev);
-	if (!desc)
-		return -EINVAL;
-
-	qnodes = desc->nodes;
-	num_nodes = desc->num_nodes;
-
-	qp = devm_kzalloc(&pdev->dev, sizeof(*qp), GFP_KERNEL);
-	if (!qp)
-		return -ENOMEM;
-
-	data = devm_kcalloc(&pdev->dev, num_nodes, sizeof(*node), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	provider = &qp->provider;
-	provider->dev = &pdev->dev;
-	provider->set = qcom_icc_set;
-	provider->pre_aggregate = qcom_icc_pre_aggregate;
-	provider->aggregate = qcom_icc_aggregate;
-	provider->xlate_extended = qcom_icc_xlate_extended;
-	INIT_LIST_HEAD(&provider->nodes);
-	provider->data = data;
-
-	qp->dev = &pdev->dev;
-	qp->bcms = desc->bcms;
-	qp->num_bcms = desc->num_bcms;
-
-	qp->voter = of_bcm_voter_get(qp->dev, NULL);
-	if (IS_ERR(qp->voter))
-		return PTR_ERR(qp->voter);
-
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(&pdev->dev, "error adding interconnect provider\n");
-		return ret;
-	}
-
-	for (i = 0; i < qp->num_bcms; i++)
-		qcom_icc_bcm_init(qp->bcms[i], &pdev->dev);
-
-	for (i = 0; i < num_nodes; i++) {
-		size_t j;
-
-		if (!qnodes[i])
-			continue;
-
-		node = icc_node_create(qnodes[i]->id);
-		if (IS_ERR(node)) {
-			ret = PTR_ERR(node);
-			goto err;
-		}
-
-		node->name = qnodes[i]->name;
-		node->data = qnodes[i];
-		icc_node_add(node, provider);
-
-		for (j = 0; j < qnodes[i]->num_links; j++)
-			icc_link_create(node, qnodes[i]->links[j]);
-
-		data->nodes[i] = node;
-	}
-	data->num_nodes = num_nodes;
-
-	platform_set_drvdata(pdev, qp);
-
-	return 0;
-err:
-	icc_nodes_remove(provider);
-	icc_provider_del(provider);
-	return ret;
-}
-
-static int qnoc_remove(struct platform_device *pdev)
-{
-	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
-
-	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
-
-	return 0;
-}
-
 static const struct of_device_id qnoc_of_match[] = {
 	{ .compatible = "qcom,sm8450-aggre1-noc",
 	  .data = &sm8450_aggre1_noc},
@@ -1966,8 +1872,8 @@ static const struct of_device_id qnoc_of_match[] = {
 MODULE_DEVICE_TABLE(of, qnoc_of_match);
 
 static struct platform_driver qnoc_driver = {
-	.probe = qnoc_probe,
-	.remove = qnoc_remove,
+	.probe = qcom_icc_rpmh_probe,
+	.remove = qcom_icc_rpmh_remove,
 	.driver = {
 		.name = "qnoc-sm8450",
 		.of_match_table = qnoc_of_match,
-- 
2.39.2



