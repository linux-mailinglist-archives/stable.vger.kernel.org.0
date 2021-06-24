Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A483B35D3
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 20:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhFXSg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 14:36:26 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:45824 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232533AbhFXSg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 14:36:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624559647; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=GxBqhq5qZ6sCOlmDi4RHXLn9UxYWl42lZR0vN6cONic=; b=DRkD2efLg4iS0dXTSxz23iScRsRpcqkPiz6xDr7QKTM1T6pk9fgLoGvcKNdKtYidUT+RNj1/
 KN3QDcRLEyHK1atojlEEq2n9ZDmamScwovYTahnteg35kGw0IsHDtLOB45heo7XuEopjB42t
 hxOlwaE+opKEn7xIPl3A+IYSJ8E=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60d4d00806ea41c941da5370 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 18:33:44
 GMT
Sender: sibis=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8B71BC43217; Thu, 24 Jun 2021 18:33:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from blr-ubuntu-87.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F12E4C433D3;
        Thu, 24 Jun 2021 18:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F12E4C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sibis@codeaurora.org
From:   Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org, vkoul@kernel.org
Cc:     agross@kernel.org, ohad@wizery.com, mathieu.poirier@linaro.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] remoteproc: qcom: pas: Add missing power-domain "mxc" for CDSP
Date:   Fri, 25 Jun 2021 00:03:25 +0530
Message-Id: <1624559605-29847-1-git-send-email-sibis@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add missing power-domain "mxc" required by CDSP PAS remoteproc on SM8350
SoC.

Fixes: e8b4e9a21af7 ("remoteproc: qcom: pas: Add SM8350 PAS remoteprocs")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Cc: stable@vger.kernel.org
---

The device tree and pas documentation lists mcx as a required pd for cdsp.
Looks like it was missed while adding the proxy pds in the pas driver.
Bjorn/Vinod you'll need to test this patch before picking it up.

 drivers/remoteproc/qcom_q6v5_pas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index b921fc26cd04..ad20065dbdea 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -661,6 +661,7 @@ static const struct adsp_data sm8350_cdsp_resource = {
 	},
 	.proxy_pd_names = (char*[]){
 		"cx",
+		"mxc",
 		NULL
 	},
 	.ssr_name = "cdsp",
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

