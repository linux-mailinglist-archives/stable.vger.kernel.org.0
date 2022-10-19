Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B359603E3F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiJSJLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiJSJH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:07:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCC45053B;
        Wed, 19 Oct 2022 02:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1134B617ED;
        Wed, 19 Oct 2022 08:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2352EC433D6;
        Wed, 19 Oct 2022 08:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169813;
        bh=XQAYMWo06//zIHjMBtnXreMiMDYguIyBbLd57r3zYXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySkbGR6TqpwS+u+qlSBNT2RN4y8U5i8BgsUbLG+QBkZe4wW0p59cX5L2qvPwyxtPP
         J0KqZgZ1yfYoyF+hU4vp71w/VIsglijsGgUsHPPU0GM3Jf8d6MnmDioMFR/X7Qe5L2
         v0CdSBT4tG/NHS3rMfdXYv1kXXM50z7O2isPiqKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 419/862] soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()
Date:   Wed, 19 Oct 2022 10:28:26 +0200
Message-Id: <20221019083308.475167546@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit af8f6f39b8afd772fda4f8e61823ef8c021bf382 ]

There are two refcount leak bugs in qcom_smsm_probe():

(1) The 'local_node' is escaped out from for_each_child_of_node() as
the break of iteration, we should call of_node_put() for it in error
path or when it is not used anymore.
(2) The 'node' is escaped out from for_each_available_child_of_node()
as the 'goto', we should call of_node_put() for it in goto target.

Fixes: c97c4090ff72 ("soc: qcom: smsm: Add driver for Qualcomm SMSM")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220721135217.1301039-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smsm.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/soc/qcom/smsm.c b/drivers/soc/qcom/smsm.c
index 9df9bba242f3..3e8994d6110e 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -526,7 +526,7 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	for (id = 0; id < smsm->num_hosts; id++) {
 		ret = smsm_parse_ipc(smsm, id);
 		if (ret < 0)
-			return ret;
+			goto out_put;
 	}
 
 	/* Acquire the main SMSM state vector */
@@ -534,13 +534,14 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 			      smsm->num_entries * sizeof(u32));
 	if (ret < 0 && ret != -EEXIST) {
 		dev_err(&pdev->dev, "unable to allocate shared state entry\n");
-		return ret;
+		goto out_put;
 	}
 
 	states = qcom_smem_get(QCOM_SMEM_HOST_ANY, SMEM_SMSM_SHARED_STATE, NULL);
 	if (IS_ERR(states)) {
 		dev_err(&pdev->dev, "Unable to acquire shared state entry\n");
-		return PTR_ERR(states);
+		ret = PTR_ERR(states);
+		goto out_put;
 	}
 
 	/* Acquire the list of interrupt mask vectors */
@@ -548,13 +549,14 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	ret = qcom_smem_alloc(QCOM_SMEM_HOST_ANY, SMEM_SMSM_CPU_INTR_MASK, size);
 	if (ret < 0 && ret != -EEXIST) {
 		dev_err(&pdev->dev, "unable to allocate smsm interrupt mask\n");
-		return ret;
+		goto out_put;
 	}
 
 	intr_mask = qcom_smem_get(QCOM_SMEM_HOST_ANY, SMEM_SMSM_CPU_INTR_MASK, NULL);
 	if (IS_ERR(intr_mask)) {
 		dev_err(&pdev->dev, "unable to acquire shared memory interrupt mask\n");
-		return PTR_ERR(intr_mask);
+		ret = PTR_ERR(intr_mask);
+		goto out_put;
 	}
 
 	/* Setup the reference to the local state bits */
@@ -565,7 +567,8 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	smsm->state = qcom_smem_state_register(local_node, &smsm_state_ops, smsm);
 	if (IS_ERR(smsm->state)) {
 		dev_err(smsm->dev, "failed to register qcom_smem_state\n");
-		return PTR_ERR(smsm->state);
+		ret = PTR_ERR(smsm->state);
+		goto out_put;
 	}
 
 	/* Register handlers for remote processor entries of interest. */
@@ -595,16 +598,19 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, smsm);
+	of_node_put(local_node);
 
 	return 0;
 
 unwind_interfaces:
+	of_node_put(node);
 	for (id = 0; id < smsm->num_entries; id++)
 		if (smsm->entries[id].domain)
 			irq_domain_remove(smsm->entries[id].domain);
 
 	qcom_smem_state_unregister(smsm->state);
-
+out_put:
+	of_node_put(local_node);
 	return ret;
 }
 
-- 
2.35.1



