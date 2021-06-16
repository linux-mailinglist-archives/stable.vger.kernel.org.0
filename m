Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D393AA298
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 19:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFPRpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 13:45:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:36239 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhFPRpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 13:45:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623865395; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=JxuEFYVJLCvVBCk9gMQ8FzZXCj/3QmLbn9ez+0VSlIU=; b=pIrSwkfpy30SHx7fnVua8YpzkB/b6ccCcGmFLmNG+UvUO2gCRLFkxhSuEkkVAZLVMo/vayGE
 CbP9ENXzwfvSxuFY1ZP6gazD4ivYwRtGtrDv7WcS/+ib6mEChbquOoOb3zAx4VNQcLuC3iQ/
 2Tx+kOEGSyv+rqZ4ayY2RnpDuWM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60ca382fed59bf69ccc5b342 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Jun 2021 17:43:11
 GMT
Sender: sibis=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AFE64C433D3; Wed, 16 Jun 2021 17:43:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from blr-ubuntu-87.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2AC2BC433D3;
        Wed, 16 Jun 2021 17:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2AC2BC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sibis@codeaurora.org
From:   Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org, jassisinghbrar@gmail.com,
        manivannan.sadhasivam@linaro.org
Cc:     agross@kernel.org, rananta@codeaurora.org, vnkgutta@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Sibi Sankar <sibis@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH] mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion
Date:   Wed, 16 Jun 2021 23:12:58 +0530
Message-Id: <1623865378-1943-1-git-send-email-sibis@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix IPCC (Inter-Processor Communication Controller) channel exhaustion by
setting the channel private data to NULL on mbox shutdown.

Err Logs:
remoteproc: MBA booted without debug policy, loading mpss
remoteproc: glink-edge: failed to acquire IPC channel
remoteproc: failed to probe subdevices for remoteproc: -16

Fixes: fa74a0257f45 ("mailbox: Add support for Qualcomm IPCC")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Cc: stable@vger.kernel.org
---
 drivers/mailbox/qcom-ipcc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index 2d13c72944c6..584700cd1585 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -155,6 +155,11 @@ static int qcom_ipcc_mbox_send_data(struct mbox_chan *chan, void *data)
 	return 0;
 }
 
+static void qcom_ipcc_mbox_shutdown(struct mbox_chan *chan)
+{
+	chan->con_priv = NULL;
+}
+
 static struct mbox_chan *qcom_ipcc_mbox_xlate(struct mbox_controller *mbox,
 					const struct of_phandle_args *ph)
 {
@@ -184,6 +189,7 @@ static struct mbox_chan *qcom_ipcc_mbox_xlate(struct mbox_controller *mbox,
 
 static const struct mbox_chan_ops ipcc_mbox_chan_ops = {
 	.send_data = qcom_ipcc_mbox_send_data,
+	.shutdown = qcom_ipcc_mbox_shutdown,
 };
 
 static int qcom_ipcc_setup_mbox(struct qcom_ipcc *ipcc)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

