Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76201EC015
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 18:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgFBQdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 12:33:35 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:29117 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgFBQdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 12:33:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591115614; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=bML8xYcSHixqGiWlTX8GPg6V0NOqHOANEhjj6IVL0dI=; b=oGjPC2V3K2fSdG4F2v81ME2jz8cJzIBZmo7P0DN53kOmr4QW84Z5VOdSAjonFarcEgQcaa+S
 lvCww4fFpNLlFCVe+rjzT7vfSTq01YrNNNUwmG9s5e7IggMCu7NyjpHYS8GfacaJ+BlajMQ0
 8qYPpuIjicolMdrScCtfXk6iAIk=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5ed67f4b4c2ebead13ebe8b8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 02 Jun 2020 16:33:15
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4A063C433A0; Tue,  2 Jun 2020 16:33:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from blr-ubuntu-253.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sibis)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 493AEC433CA;
        Tue,  2 Jun 2020 16:33:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 493AEC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=sibis@codeaurora.org
From:   Sibi Sankar <sibis@codeaurora.org>
To:     bjorn.andersson@linaro.org
Cc:     agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        evgreen@chromium.org, ohad@wizery.com, rohitkr@codeaurora.org,
        Sibi Sankar <sibis@codeaurora.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] remoteproc: qcom: q6v5: Update running state before requesting stop
Date:   Tue,  2 Jun 2020 22:02:56 +0530
Message-Id: <20200602163257.26978-1-sibis@codeaurora.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sometimes the stop triggers a watchdog rather than a stop-ack. Update
the running state to false on requesting stop to skip the watchdog
instead.

Error Logs:
$ echo stop > /sys/class/remoteproc/remoteproc0/state
ipa 1e40000.ipa: received modem stopping event
remoteproc-modem: watchdog received: sys_m_smsm_mpss.c:291:APPS force stop
qcom-q6v5-mss 4080000.remoteproc-modem: port failed halt
ipa 1e40000.ipa: received modem offline event
remoteproc0: stopped remote processor 4080000.remoteproc-modem

Fixes: 3b415c8fb263 ("remoteproc: q6v5: Extract common resource handling")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
---
 drivers/remoteproc/qcom_q6v5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5.c b/drivers/remoteproc/qcom_q6v5.c
index 111a442c993c4..fd6fd36268d93 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -153,6 +153,8 @@ int qcom_q6v5_request_stop(struct qcom_q6v5 *q6v5)
 {
 	int ret;
 
+	q6v5->running = false;
+
 	qcom_smem_state_update_bits(q6v5->state,
 				    BIT(q6v5->stop_bit), BIT(q6v5->stop_bit));
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

