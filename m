Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E2A58C0A
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 22:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfF0Uww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 16:52:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44463 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfF0Uwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 16:52:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so1538293pgp.11
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 13:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x0T4yaPnaskEaM5/BDitZIdztqXyQmXKds/Qu7Ooum4=;
        b=UXhD5+/rbf+0Ef2XiMOaD9wCyvl3rZCSpx1VoptGkl6ryBZo1q+GfzSeOEJULx0nCa
         +gR/ZcO6K7lQG9MjfnnYIcMdVoWYO/uL2ogdcCAmQyVXTdP2wcgmd2GE6v4JOr9BlkAp
         E+GRzA7URfEX8++kQS4hD0hJ2X181NlZE57h6nkmuSaJ3iJAxWcojAALoA1MVNxAw3eL
         kd94qFDKj7mm9/zOo8RCY50KU56Ts3sf2Kim/dvI91i6RPwHPhyQTjwX27i77boJGSmR
         8EcsZ6avuizzAIh3YT07I7f2YEDDn3/AfMgTE/x3MTcpXo3H32iQbhpp989SPBBqfX4u
         1WNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x0T4yaPnaskEaM5/BDitZIdztqXyQmXKds/Qu7Ooum4=;
        b=f3J5vwcOANByLP6HfFrs/M/k/rBbdAxanGpBTs1vUO/3c2P3yeSymtPwKGhVS6tUMy
         SsQ97DxmHFp/436TOHPXMgVodcUCcHy7gx8R1lpZNHeE7TY2RblYurygWiPHa+dXm4DO
         OI+Av5Ty16lukgMAIXlRRU+sl5MqSJKpiq2xmWd8z4t3nQ3iYopnSw/M1TRSyztgXSkO
         SiYLENrVApBRwXwuFU32w41G5UUqY8a/23qYMWTJjPSfWFFzrYTfgVVOqCM1fmuKwpLT
         LvMRR61Ypgx0vB2aScEAVTdJD39tYWennX0CFwmWq2QM6h9c0AZUQUnj7aJW1eaZHAYS
         I6yg==
X-Gm-Message-State: APjAAAWjVqYEWH9JYYwoojOBlwjzTtlvshCelS0XKsyeTI7z0rANrIsn
        1Ow8JJ2eN/FrHA4o5Vo0/Oyd2MmdlaE=
X-Google-Smtp-Source: APXvYqxR2nDJk9Mq/lm/Mf73r1h7BoL1EPPnnmuw7r56047wKZ4k09pvq6vWz7DfOEPZWZpv6nCChQ==
X-Received: by 2002:a17:90a:1c17:: with SMTP id s23mr8537488pjs.108.1561668770524;
        Thu, 27 Jun 2019 13:52:50 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id 2sm3674083pff.174.2019.06.27.13.52.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 13:52:49 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y 4/9] usb: dwc3: gadget: extract dwc3_gadget_ep_skip_trbs()
Date:   Thu, 27 Jun 2019 20:52:35 +0000
Message-Id: <20190627205240.38366-5-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627205240.38366-1-john.stultz@linaro.org>
References: <20190627205240.38366-1-john.stultz@linaro.org>
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
index cb6dfea5d5e7..f0c3b08ff7c6 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1343,6 +1343,29 @@ static int dwc3_gadget_ep_queue(struct usb_ep *ep, struct usb_request *request,
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
@@ -1370,38 +1393,8 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
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
@@ -1409,13 +1402,7 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
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

