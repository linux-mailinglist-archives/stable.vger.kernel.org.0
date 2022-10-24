Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C5B60A499
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiJXMN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiJXMMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:12:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC21BC8D;
        Mon, 24 Oct 2022 04:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44ED6612B2;
        Mon, 24 Oct 2022 11:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54708C433D6;
        Mon, 24 Oct 2022 11:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612281;
        bh=qKvP4bmsphMKHgqIDzfbkKxyiFWTwXsEYkyhH5HCDMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqqWLrMxIXsNYEZ8bTFfvDy+3uz8uLfR039xXRiF55o3YugPi555Q+NrZLbk2GLDS
         f8ycMJW9LV3cwoyQqVI+eydgKVPbbV/aWAaQXfr7cnPXFlMfGtjkG4Q4h4T0feG3Wq
         EXPuqMe9kX7nNnFosQlpJRbdZ7UBhGIk9WzU+VfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 107/210] soc: qcom: smsm: Fix refcount leak bugs in qcom_smsm_probe()
Date:   Mon, 24 Oct 2022 13:30:24 +0200
Message-Id: <20221024113000.486304399@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5304529b41c9..a8a1dc49519e 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -519,7 +519,7 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	for (id = 0; id < smsm->num_hosts; id++) {
 		ret = smsm_parse_ipc(smsm, id);
 		if (ret < 0)
-			return ret;
+			goto out_put;
 	}
 
 	/* Acquire the main SMSM state vector */
@@ -527,13 +527,14 @@ static int qcom_smsm_probe(struct platform_device *pdev)
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
@@ -541,13 +542,14 @@ static int qcom_smsm_probe(struct platform_device *pdev)
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
@@ -558,7 +560,8 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	smsm->state = qcom_smem_state_register(local_node, &smsm_state_ops, smsm);
 	if (IS_ERR(smsm->state)) {
 		dev_err(smsm->dev, "failed to register qcom_smem_state\n");
-		return PTR_ERR(smsm->state);
+		ret = PTR_ERR(smsm->state);
+		goto out_put;
 	}
 
 	/* Register handlers for remote processor entries of interest. */
@@ -588,16 +591,19 @@ static int qcom_smsm_probe(struct platform_device *pdev)
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



