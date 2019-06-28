Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CE75A376
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfF1SY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:24:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40341 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfF1SY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:24:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so3393553pfp.7
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lT3fxv5LATFR+LwgNYhFFmzfdH8/UFjXtWib2WTIrbM=;
        b=NSJevXZYgKbgf3gTOSY6ABPd6HIDrATAwaVAkJtHmyEV+e1XC44yrZTYnWrwylUFk6
         vjzp/7EFBH8eQF7ClX1CCZG5sZq3ssBVu2XmAqafeeVifGN7hJ105CaRnuTf2P2tvw8H
         xeBaE0EnK0n1OZYWH6JB3NNg0V5tw2/cNNt3ry5kEo80Gdh7xA7bKCQn52WITt0KIN7J
         J6qXD1je1YFbfeATZU5suXDkrPwsOud2ZQFmluHjfzS3PjT36LETox1fcI2adhcUg6S7
         2iFyUdgUwEKMoM4+lypKEa/fynWRv3vRD2Cqk8leOXknbx92ap/uFbIHwtNe/STBBBDi
         yRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lT3fxv5LATFR+LwgNYhFFmzfdH8/UFjXtWib2WTIrbM=;
        b=NYVrMk6GDN2MnFfzGULPYHZJr2lwGn3WBBqOTbG7fuJgm00HMkXl5VhlOR6Z26Z9Wj
         wfL3dZ2FZjLJ+xBJdlH1U+MpD1qornpq65x7ZhKkGx8h9Zwq2d7LJK9bbeq63cf/pXVO
         0Hdw00sE0ugxMTtcO+MuXIziHvvEdhrZktr9teA/+LwBX6ceH2woXV/nULcTNLuQwr3y
         OLuCg0LLu9Dlcs3dsUuHYg1ltXCMkEEJmz9N3gYDbneNQLYqtvevdinx+zRpf5dGiXJC
         Wk+Fab3kx5SC83lR4mr0ggB0b4dXKPv00nmRHnU4rBAnC8zhjRcTx4YwGyctHaeTT+c4
         G86A==
X-Gm-Message-State: APjAAAUhmPc+wIQsGKcSpCDiq2tF6UUJYuKCMcY4VCvOfUA2ksuhir9p
        DjfljBf+Bg/LuWLhDVzycXOO7ji4zyk=
X-Google-Smtp-Source: APXvYqxFBgbJKazoH14+J2IhpQeuPNTxNOQwuSXCkvYIBIZNSudfMZQPcQIomrsNlyGq7MiTx2OEYQ==
X-Received: by 2002:a17:90a:ad86:: with SMTP id s6mr14952881pjq.42.1561746265909;
        Fri, 28 Jun 2019 11:24:25 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id s15sm2916223pfd.183.2019.06.28.11.24.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:24:25 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y v2 5/9] usb: dwc3: gadget: extract dwc3_gadget_ep_skip_trbs()
Date:   Fri, 28 Jun 2019 18:24:09 +0000
Message-Id: <20190628182413.33225-6-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628182413.33225-1-john.stultz@linaro.org>
References: <20190628182413.33225-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

commit 7746a8dfb3f9c91b3a0b63a1d5c2664410e6498d upstream

Extract the logic for skipping over TRBs to its own function. This
makes the code slightly more readable and makes it easier to move this
call to its final resting place as a following patch.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit 7746a8dfb3f9c91b3a0b63a1d5c2664410e6498d)
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 61 +++++++++++++++------------------------
 1 file changed, 24 insertions(+), 37 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4e08904890ed..46aa20b376cd 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1341,6 +1341,29 @@ static int dwc3_gadget_ep_queue(struct usb_ep *ep, struct usb_request *request,
 	return ret;
 }
 
+static void dwc3_gadget_ep_skip_trbs(struct dwc3_ep *dep, struct dwc3_request *req)
+{
+	int i;
+
+	/*
+	 * If request was already started, this means we had to
+	 * stop the transfer. With that we also need to ignore
+	 * all TRBs used by the request, however TRBs can only
+	 * be modified after completion of END_TRANSFER
+	 * command. So what we do here is that we wait for
+	 * END_TRANSFER completion and only after that, we jump
+	 * over TRBs by clearing HWO and incrementing dequeue
+	 * pointer.
+	 */
+	for (i = 0; i < req->num_trbs; i++) {
+		struct dwc3_trb *trb;
+
+		trb = req->trb + i;
+		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
+		dwc3_ep_inc_deq(dep);
+	}
+}
+
 static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		struct usb_request *request)
 {
@@ -1368,38 +1391,8 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 				break;
 		}
 		if (r == req) {
-			int i;
-
 			/* wait until it is processed */
 			dwc3_stop_active_transfer(dep, true);
-
-			/*
-			 * If request was already started, this means we had to
-			 * stop the transfer. With that we also need to ignore
-			 * all TRBs used by the request, however TRBs can only
-			 * be modified after completion of END_TRANSFER
-			 * command. So what we do here is that we wait for
-			 * END_TRANSFER completion and only after that, we jump
-			 * over TRBs by clearing HWO and incrementing dequeue
-			 * pointer.
-			 *
-			 * Note that we have 2 possible types of transfers here:
-			 *
-			 * i) Linear buffer request
-			 * ii) SG-list based request
-			 *
-			 * SG-list based requests will have r->num_pending_sgs
-			 * set to a valid number (> 0). Linear requests,
-			 * normally use a single TRB.
-			 *
-			 * For each of these two cases, if r->unaligned flag is
-			 * set, one extra TRB has been used to align transfer
-			 * size to wMaxPacketSize.
-			 *
-			 * All of these cases need to be taken into
-			 * consideration so we don't mess up our TRB ring
-			 * pointers.
-			 */
 			wait_event_lock_irq(dep->wait_end_transfer,
 					!(dep->flags & DWC3_EP_END_TRANSFER_PENDING),
 					dwc->lock);
@@ -1407,13 +1400,7 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 			if (!r->trb)
 				goto out0;
 
-			for (i = 0; i < r->num_trbs; i++) {
-				struct dwc3_trb *trb;
-
-				trb = r->trb + i;
-				trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
-				dwc3_ep_inc_deq(dep);
-			}
+			dwc3_gadget_ep_skip_trbs(dep, r);
 			goto out1;
 		}
 		dev_err(dwc->dev, "request %pK was not queued to %s\n",
-- 
2.17.1

