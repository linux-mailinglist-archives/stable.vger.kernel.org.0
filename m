Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6C96579E2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiL1PFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiL1PFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:05:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5638FDFA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D856161540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCABC433EF;
        Wed, 28 Dec 2022 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239944;
        bh=q/xbrCOGSPYNH9TVapXx+pUJmemXqHT+snAIei8Q1ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKDJWXlBukAxHGAWme/Hl47LJzAhW6tNOOfImeQ6Vdb5m7BKtX1qRmPVmYyEl6hyY
         L5VR8wa41+gbNgf6n8RtXVDVehJXQmwWVpgDkUntKaS+VRGLwVlBgM2KcnFcywEieN
         jDYH1KSGYlR7YRQnaQ7aWZW7wXXRaSXBwKnkrBkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0037/1146] soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index
Date:   Wed, 28 Dec 2022 15:26:16 +0100
Message-Id: <20221228144331.172797964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 6d7860f5750d73da2fa1a1f6c9405058a593fa32 ]

As idr_alloc() and of_property_read_string_index() can return negative
numbers, it should be better to check the return value and deal with
the exception.
Therefore, it should be better to use goto statement to stop and return
error.

Fixes: 6adba21eb434 ("soc: qcom: Add APR bus driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221107014403.3606-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/apr.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index b4046f393575..cd44f17dad3d 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -454,11 +454,19 @@ static int apr_add_device(struct device *dev, struct device_node *np,
 	adev->dev.driver = NULL;
 
 	spin_lock(&apr->svcs_lock);
-	idr_alloc(&apr->svcs_idr, svc, svc_id, svc_id + 1, GFP_ATOMIC);
+	ret = idr_alloc(&apr->svcs_idr, svc, svc_id, svc_id + 1, GFP_ATOMIC);
 	spin_unlock(&apr->svcs_lock);
+	if (ret < 0) {
+		dev_err(dev, "idr_alloc failed: %d\n", ret);
+		goto out;
+	}
 
-	of_property_read_string_index(np, "qcom,protection-domain",
-				      1, &adev->service_path);
+	ret = of_property_read_string_index(np, "qcom,protection-domain",
+					    1, &adev->service_path);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read second value of qcom,protection-domain\n");
+		goto out;
+	}
 
 	dev_info(dev, "Adding APR/GPR dev: %s\n", dev_name(&adev->dev));
 
@@ -468,6 +476,7 @@ static int apr_add_device(struct device *dev, struct device_node *np,
 		put_device(&adev->dev);
 	}
 
+out:
 	return ret;
 }
 
-- 
2.35.1



