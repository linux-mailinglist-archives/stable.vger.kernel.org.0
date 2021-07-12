Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4010B3C4809
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhGLGfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236804AbhGLGeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2BB361151;
        Mon, 12 Jul 2021 06:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071413;
        bh=UtCAsljQ+Djj+UjaXl/mUqLAIRtUYcla61Rch2fxNTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9UlE2t0OV/soZ5OU3XQupDxH6BQLUq1U67UWRDvYSj33pTQ33fAA84542Hq+mN15
         qdODOU4B0DUpGjEMJPgHXE3wPjFZ3H7Ra81yrnOkbu82fpYNukhgZodvtLZa+pdmsM
         wr+DaQs0LFReWu35TSL/DQGMfxfgQu8eWAUKkh+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baochen Qiang <bqiang@codeaurora.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.10 058/593] bus: mhi: Wait for M2 state during system resume
Date:   Mon, 12 Jul 2021 08:03:38 +0200
Message-Id: <20210712060849.494682847@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baochen Qiang <bqiang@codeaurora.org>

commit 02b49cd1174527e611768fc2ce0f75a74dfec7ae upstream.

During system resume, MHI host triggers M3->M0 transition and then waits
for target device to enter M0 state. Once done, the device queues a state
change event into ctrl event ring and notifies MHI host by raising an
interrupt, where a tasklet is scheduled to process this event. In most
cases, the tasklet is served timely and wait operation succeeds.

However, there are cases where CPU is busy and cannot serve this tasklet
for some time. Once delay goes long enough, the device moves itself to M1
state and also interrupts MHI host after inserting a new state change
event to ctrl ring. Later when CPU finally has time to process the ring,
there will be two events:

1. For M3->M0 event, which is the first event to be processed queued first.
   The tasklet handler serves the event, updates device state to M0 and
   wakes up the task.

2. For M0->M1 event, which is processed later, the tasklet handler
   triggers M1->M2 transition and updates device state to M2 directly,
   then wakes up the MHI host (if it is still sleeping on this wait queue).

Note that although MHI host has been woken up while processing the first
event, it may still has no chance to run before the second event is
processed. In other words, MHI host has to keep waiting till timeout
causing the M0 state to be missed.

kernel log here:
...
Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.911251] mhi 0000:06:00.0: Entered with PM state: M3, MHI state: M3
Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.917762] mhi 0000:06:00.0: State change event to state: M0
Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4247.917767] mhi 0000:06:00.0: State change event to state: M1
Apr 15 01:45:14 test-NUC8i7HVK kernel: [ 4338.788231] mhi 0000:06:00.0: Did not enter M0 state, MHI state: M2, PM state: M2
...

Fix this issue by simply adding M2 as a valid state for resume.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Cc: stable@vger.kernel.org
Fixes: 0c6b20a1d720 ("bus: mhi: core: Add support for MHI suspend and resume")
Signed-off-by: Baochen Qiang <bqiang@codeaurora.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210524040312.14409-1-bqiang@codeaurora.org
[mani: slightly massaged the commit message]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210621161616.77524-4-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/mhi/core/pm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -809,6 +809,7 @@ int mhi_pm_resume(struct mhi_controller
 
 	ret = wait_event_timeout(mhi_cntrl->state_event,
 				 mhi_cntrl->dev_state == MHI_STATE_M0 ||
+				 mhi_cntrl->dev_state == MHI_STATE_M2 ||
 				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
 				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
 


