Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859043AED44
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhFUQTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhFUQS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 12:18:56 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC43C061767
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 09:16:42 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f10so6717661plg.0
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 09:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VPrk83BZDsAH7WUMF1d2R72wMyUpeMl+U7nePSbVVRA=;
        b=huDSOvIlbSyFl9E2MCyw66RCSWecg0r7QPcTGiCt0NK4S7jvku4/XR+MTXiBUCzC5D
         XGj4uCnF5BujyrWbUXka34ykWiTdvqr9WO/vJBeUwh75OJ+aS1ROoNYCDs4a+U2YfPZz
         2UqLN2zEd3Kozrmu/p0Lv0stjUyEGF77QmierNm8sgt3GAr6bCLnV9NODBT62uwVnU4w
         J4I/ibufHSE8yw90Eri1Rpz7iXTXnBIvoXpWR+Kh107IAHREzrxjzPxvjtIXPsMoXtCW
         KTpWsvnxx9+AXULJBY8gPv2ElINNGF1V/Oevr7pu2gA4A17hGafpqUwhtCTYnm5OtH+g
         e+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VPrk83BZDsAH7WUMF1d2R72wMyUpeMl+U7nePSbVVRA=;
        b=FkwJfbIeymBftGcRvPX4K2mrL6Bea1Hz+DJXatVyrOmEAWifFW8GXbDkGq6fHzxA4C
         +B7q5xNrzjhJ08mdKsiXr4BehLo6b5+FNxG3thzipfTV3GLItQ1/xui7P67LdGYlRd7V
         qnOg4a44M2dkj7bgr/dmkzmiUc4QF6lLRG45fV77AV+VfnKWzVxIL2WGhH6a5sMcdmnw
         o4jta2oTyXgySmzBoJYKWm79OlEeWmuAxL/2O7oegzNeXzc/7on0+Dim0rkUBpia1845
         jH+6bjC19zRF143xtE9InKKETgGLe7vofowXYf0E30KSuNJ6l/LE66iHMbECLkHJ4Wim
         vAyQ==
X-Gm-Message-State: AOAM533uF0zzd1GZ2XUHEq9Iuj0KpAfvJapAB5M23cQekaIMV5wx8ZBN
        P8QJl5sQxr4LgcJTSj7++gAV
X-Google-Smtp-Source: ABdhPJwGz3BRSZL+r+HThpxcq72wbUjc7FO3g6EMwm0YD9d2NABfB6OWr5M5R9yMSW/nwTuZydG6rQ==
X-Received: by 2002:a17:90a:8c4:: with SMTP id 4mr38123055pjn.82.1624292202003;
        Mon, 21 Jun 2021 09:16:42 -0700 (PDT)
Received: from localhost.localdomain ([120.138.13.116])
        by smtp.gmail.com with ESMTPSA id k88sm10734730pjk.15.2021.06.21.09.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:16:41 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org, Baochen Qiang <bqiang@codeaurora.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 3/8] bus: mhi: Wait for M2 state during system resume
Date:   Mon, 21 Jun 2021 21:46:11 +0530
Message-Id: <20210621161616.77524-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621161616.77524-1-manivannan.sadhasivam@linaro.org>
References: <20210621161616.77524-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baochen Qiang <bqiang@codeaurora.org>

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
---
 drivers/bus/mhi/core/pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 704a5e225097..bbf6cd04861e 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -926,6 +926,7 @@ int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
 
 	ret = wait_event_timeout(mhi_cntrl->state_event,
 				 mhi_cntrl->dev_state == MHI_STATE_M0 ||
+				 mhi_cntrl->dev_state == MHI_STATE_M2 ||
 				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
 				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
 
-- 
2.25.1

