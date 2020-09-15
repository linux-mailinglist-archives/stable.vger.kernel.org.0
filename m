Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE8826B2A1
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 00:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgIOWuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 18:50:52 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:46401 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727445AbgIOPmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 11:42:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600184571; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=Zz4BNUqKbCHLO8ckozEFnp9zSsg8XUlX5psi9jFrCPQ=; b=qNg1t0QhFZhB8psMM6c3yPceQypwmKnaa1ORj5xgq2kGfEO4scxHctKifd/VmgHpoxXZ9vgr
 crtVzxrl98HFfkajBAUKPK4dBs+XEQJFvYZl8FGmj14lKViHngsO/O9sPxjnnUVY6A5ZESzY
 EOBNHWgJ4nu4DovomnEeW/AAhGE=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f60e0fb73afa3417eb9a216 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Sep 2020 15:42:51
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1EC05C433F1; Tue, 15 Sep 2020 15:42:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from blr-ubuntu-253.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69077C433F0;
        Tue, 15 Sep 2020 15:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 69077C433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sibis@codeaurora.org
From:   Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org
Cc:     agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@linaro.org,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>
Subject: [PATCH] soc: qcom: apr: Fixup the error displayed on lookup failure
Date:   Tue, 15 Sep 2020 21:12:32 +0530
Message-Id: <20200915154232.27523-1-sibis@codeaurora.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

APR client incorrectly prints out "ret" variable on pdr_add_lookup failure,
it should be printing the error value returned by the lookup instead.

Fixes: 8347356626028 ("soc: qcom: apr: Add avs/audio tracking functionality")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
---
 drivers/soc/qcom/apr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 1f35b097c6356..7abfc8c4fdc72 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -328,7 +328,7 @@ static int of_apr_add_pd_lookups(struct device *dev)
 
 		pds = pdr_add_lookup(apr->pdr, service_name, service_path);
 		if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
-			dev_err(dev, "pdr add lookup failed: %d\n", ret);
+			dev_err(dev, "pdr add lookup failed: %ld\n", PTR_ERR(pds));
 			return PTR_ERR(pds);
 		}
 	}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

