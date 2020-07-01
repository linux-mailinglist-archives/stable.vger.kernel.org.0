Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF71E2113FD
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 22:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgGAUAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 16:00:24 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:30497 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726444AbgGAUAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 16:00:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593633623; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=+Pn1474j/5xsTytr2L5ZmcpTGg1W/hqe1WIx/N9tLNU=; b=o4Bzc4FhAaSn3N+tKEB4icSaK+wJ76YB8Plv+Jc0U5XGigbdE2Jgn3soJ2Hy7e6nZChpLeou
 V91CUoNUgcolks+zZhB0c+ns0sg8TqrXxNPnTtdwIMQxBKPpplrHJxMyCzT3Y58MAxZ4bUE7
 55xYxyozbWGARGxe3HUDFMQRfR8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n15.prod.us-west-2.postgun.com with SMTP id
 5efceb496f2ee827da04f36a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 01 Jul 2020 20:00:09
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 497D5C433CB; Wed,  1 Jul 2020 20:00:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from blr-ubuntu-253.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1CF91C433CA;
        Wed,  1 Jul 2020 20:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1CF91C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=sibis@codeaurora.org
From:   Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org, rishabhb@codeaurora.org
Cc:     agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tsoni@codeaurora.org,
        sidgup@codeaurora.org, stable@vger.kernel.org,
        Sibi Sankar <sibis@codeaurora.org>
Subject: [RESEND v1] soc: qcom: pdr: Reorder the PD state indication ack
Date:   Thu,  2 Jul 2020 01:29:54 +0530
Message-Id: <20200701195954.9007-1-sibis@codeaurora.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Protection Domains (PD) have a mechanism to keep its resources
enabled until the PD down indication is acked. Reorder the PD state
indication ack so that clients get to release the relevant resources
before the PD goes down.

Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
Reported-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
---

I couldn't find the previous patch on patchworks. Resending the patch
since it would need to land on stable trees as well

 drivers/soc/qcom/pdr_interface.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pdr_interface.c b/drivers/soc/qcom/pdr_interface.c
index a90d707da6894..088dc99f77f3f 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -279,13 +279,15 @@ static void pdr_indack_work(struct work_struct *work)
 
 	list_for_each_entry_safe(ind, tmp, &pdr->indack_list, node) {
 		pds = ind->pds;
-		pdr_send_indack_msg(pdr, pds, ind->transaction_id);
 
 		mutex_lock(&pdr->status_lock);
 		pds->state = ind->curr_state;
 		pdr->status(pds->state, pds->service_path, pdr->priv);
 		mutex_unlock(&pdr->status_lock);
 
+		/* Ack the indication after clients release the PD resources */
+		pdr_send_indack_msg(pdr, pds, ind->transaction_id);
+
 		mutex_lock(&pdr->list_lock);
 		list_del(&ind->node);
 		mutex_unlock(&pdr->list_lock);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

