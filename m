Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E7738E005
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 06:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhEXEFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 00:05:10 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21149 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhEXEFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 00:05:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621829022; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=qJyT7ZMqzWN/xyhBNw4dAHIGfNS/+50PSHAczgqPi3c=; b=MU72zxFMwCMHlqvVdxKONW2IjEdZ2FzfK4ZEgHGD7o3hsDJ9pXW73TOCDf+pLSYXfAmm9Z3F
 kpW8RBy3uF5TyWS/XCvuDMA+svp3/VSnIBeRhIgNHxi8Y8AbYGLXqMfFEBvMPYJOJbJ6A/YL
 N6cZvh0TMj5W9xKvu7agtDEVxTo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60ab258814eae4d7417ceac8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 24 May 2021 04:03:20
 GMT
Sender: bqiang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81A24C43217; Mon, 24 May 2021 04:03:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from bqiang-Celadon-RN.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bqiang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4486CC433D3;
        Mon, 24 May 2021 04:03:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4486CC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=bqiang@codeaurora.org
From:   Baochen Qiang <bqiang@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org
Cc:     hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        stable@vger.kernel.org
Subject: [PATCH v2] bus: mhi: Wait for M2 state during system resume
Date:   Mon, 24 May 2021 12:03:12 +0800
Message-Id: <20210524040312.14409-1-bqiang@codeaurora.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During system resume, MHI host triggers M3->M0 transition and then waits
for target device to enter M0 state. Once done, the device queues a state
change event into ctrl event ring and notifies MHI host by raising an
interrupt, where a tasklet is scheduled to process this event. In most cases,
the tasklet is served timely and wait operation succeeds.

However, there are cases where CPU is busy and cannot serve this tasklet
for some time. Once delay goes long enough, the device moves itself to M1
state and also interrupts MHI host after inserting a new state change
event to ctrl ring. Later CPU finally has time to process the ring, however
there are two events in it now:
	1. for M3->M0 event, which is processed first as queued first,
	   tasklet handler updates device state to M0 and wakes up the task,
	   i.e., the MHI host.
	2. for M0->M1 event, which is processed later, tasklet handler
	   triggers M1->M2 transition and updates device state to M2 directly,
	   then wakes up the MHI host(if still sleeping on this wait queue).
Note that although MHI host has been woken up while processing the first
event, it may still has no chance to run before the second event is processed.
In other words, MHI host has to keep waiting till timeout cause the M0 state
has been missed.

kernel log here:
...
Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.911251] mhi 0000:06:00.0: Entered with PM state: M3, MHI state: M3
Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.917762] mhi 0000:06:00.0: State change event to state: M0
Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.917767] mhi 0000:06:00.0: State change event to state: M1
Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4338.788231] mhi 0000:06:00.0: Did not enter M0 state, MHI state: M2, PM state: M2
...

Fix this issue by simply adding M2 as a valid state for resume.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Fixes: 0c6b20a1d720 ("bus: mhi: core: Add support for MHI suspend and resume")
Signed-off-by: Baochen Qiang <bqiang@codeaurora.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
---
 drivers/bus/mhi/core/pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index e2e59a341fef..59b009a3ee9b 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -934,6 +934,7 @@ int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
 
 	ret = wait_event_timeout(mhi_cntrl->state_event,
 				 mhi_cntrl->dev_state == MHI_STATE_M0 ||
+				 mhi_cntrl->dev_state == MHI_STATE_M2 ||
 				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
 				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
 
-- 
2.25.1

