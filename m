Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326635A374
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfF1SYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:24:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34252 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfF1SYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:24:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so2961451pgn.1
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IT1pd6Y/Qs6l6wqmDTMXa67ucrhPLOrxpJINsob31Ek=;
        b=JDN8QZz7n8TFHv42pQ/ba4vuwtpFNDbmqW5mj5+fH8kag6pOfRfLtILhFQm8UvflA+
         ijuYHFrvdKOYi/J9cU+GDlPTfCweQOfAGu4SrdcBc5n+dZDf+46EfqBAcEcxrZYtebOr
         ZSULmjefsey6rzKLDhrEltCdQRXDvp0k+eBClIS2TmSwCqFfCZeaILMaW7+P0dQyaMHG
         Iaff/YJBxaVjGtacLoyimeulIWl074RkPcdAEUkowwN95AD1c3XTNo+X/R/L/n8FjabZ
         FKGqbyu3mgi2fwlKFHSl9VCRFwIWqDUTueSUaW4fDiGUlqk/Yywo78rkA10UJd2sVnIY
         1qWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IT1pd6Y/Qs6l6wqmDTMXa67ucrhPLOrxpJINsob31Ek=;
        b=RSM/GGSNnnguiafPjg/xd5khkAnncxUKzcpwYdCbGCXedUSMXXSybgAqxbtYbc9xXO
         wmS0t2j0YkFOXb9etDBqRncjk1lDXg4fLRyeO4ZCReQywOyHAvKTPvIEVPgToAdbg5iC
         NrWIXRlsRL4Pj6fTrFT2hZsGhGwQmnj/+RjCUO4vNynoMv8rkW2dYYsuLRI7wjtWD2HQ
         /pvjgq2P6A5jaSG08nyerroqap2cGqS1IbgylrZLikrSvVNyQx6A8drGqvq8jdhKbgEy
         aHc8P6l+KLQQbQCNrj3EP1GVS0DwPqoCCbcx2nBBCNJ+83XgvopRYTpKQZnP5biLo4lr
         0Apg==
X-Gm-Message-State: APjAAAUsw2UnQGMxS/yIno04UL0yIAE/1Qc4nbTVCTNS6cpEHQIB23lr
        jsuQp2RuewxQvE7htx5sz/FDecU5UKM=
X-Google-Smtp-Source: APXvYqzeLd2WfKVOEvFZElOrK1KYgAkV0GbyMlNufBzlTwl/hEkuywHYikMsTe1rxYvjEBuYisYOJA==
X-Received: by 2002:a17:90a:9503:: with SMTP id t3mr5159952pjo.47.1561746264299;
        Fri, 28 Jun 2019 11:24:24 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id s15sm2916223pfd.183.2019.06.28.11.24.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:24:23 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y v2 4/9] usb: dwc3: gadget: use num_trbs when skipping TRBs on ->dequeue()
Date:   Fri, 28 Jun 2019 18:24:08 +0000
Message-Id: <20190628182413.33225-5-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628182413.33225-1-john.stultz@linaro.org>
References: <20190628182413.33225-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

commit c3acd59014148470dc58519870fbc779785b4bf7 upstream

Now that we track how many TRBs a request uses, it's easier to skip
over them in case of a call to usb_ep_dequeue(). Let's do so and
simplify the code a bit.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit c3acd59014148470dc58519870fbc779785b4bf7)
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index fd91c494307c..4e08904890ed 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1368,6 +1368,8 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 				break;
 		}
 		if (r == req) {
+			int i;
+
 			/* wait until it is processed */
 			dwc3_stop_active_transfer(dep, true);
 
@@ -1405,32 +1407,12 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 			if (!r->trb)
 				goto out0;
 
-			if (r->num_pending_sgs) {
+			for (i = 0; i < r->num_trbs; i++) {
 				struct dwc3_trb *trb;
-				int i = 0;
-
-				for (i = 0; i < r->num_pending_sgs; i++) {
-					trb = r->trb + i;
-					trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
-					dwc3_ep_inc_deq(dep);
-				}
-
-				if (r->needs_extra_trb) {
-					trb = r->trb + r->num_pending_sgs + 1;
-					trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
-					dwc3_ep_inc_deq(dep);
-				}
-			} else {
-				struct dwc3_trb *trb = r->trb;
 
+				trb = r->trb + i;
 				trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 				dwc3_ep_inc_deq(dep);
-
-				if (r->needs_extra_trb) {
-					trb = r->trb + 1;
-					trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
-					dwc3_ep_inc_deq(dep);
-				}
 			}
 			goto out1;
 		}
@@ -1441,8 +1423,6 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 	}
 
 out1:
-	/* giveback the request */
-
 	dwc3_gadget_giveback(dep, req, -ECONNRESET);
 
 out0:
-- 
2.17.1

