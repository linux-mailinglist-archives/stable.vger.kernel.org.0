Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73A3686A6
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 20:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbhDVShb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 14:37:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:28196 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238676AbhDVSha (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 14:37:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619116615; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=6LTzUA0Exb1djiRGl3kKEyAGDVCGf8HVPiB/ZS+x41M=; b=xHwobMYuSr3gqfQ4LZ2B4cUG9abZcrSW47xfcereEeaVKqLYWWJEoH6Ot3xvIP3+/GpgGblO
 Gj6exUk2Mj85w6gnxLwiov6z4v9Y0rsVf2RL8/7g6AZ/znXoymz6CQKwe4clXyqPJS3QGSQo
 ygZziuuHzmNWOi4O71I/lnuQ2zQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6081c234f34440a9d495f9f2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 18:36:36
 GMT
Sender: subbaram=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B33EDC433D3; Thu, 22 Apr 2021 18:36:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from subbaram-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subbaram)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4332C433D3;
        Thu, 22 Apr 2021 18:36:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A4332C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subbaram@codeaurora.org
From:   Subbaraman Narayanamurthy <subbaram@codeaurora.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Mike Tipton <mdtipton@codeaurora.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] interconnect: qcom: bcm-voter: add a missing of_node_put()
Date:   Thu, 22 Apr 2021 11:36:10 -0700
Message-Id: <1619116570-13308-1-git-send-email-subbaram@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a missing of_node_put() in of_bcm_voter_get() to avoid the
reference leak.

Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
Cc: stable@vger.kernel.org
---
 drivers/interconnect/qcom/bcm-voter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/bcm-voter.c b/drivers/interconnect/qcom/bcm-voter.c
index 1cc565b..dd18cd8 100644
--- a/drivers/interconnect/qcom/bcm-voter.c
+++ b/drivers/interconnect/qcom/bcm-voter.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2020, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2020-2021, The Linux Foundation. All rights reserved.
  */
 
 #include <asm/div64.h>
@@ -205,6 +205,7 @@ struct bcm_voter *of_bcm_voter_get(struct device *dev, const char *name)
 	}
 	mutex_unlock(&bcm_voter_lock);
 
+	of_node_put(node);
 	return voter;
 }
 EXPORT_SYMBOL_GPL(of_bcm_voter_get);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

