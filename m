Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572A058C08
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 22:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfF0Uwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 16:52:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43918 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfF0Uwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 16:52:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id i189so1801102pfg.10
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 13:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9FOb1l6NNujBgS6Pd8VeV0djJsyicx4ys2rNzFqoG7Q=;
        b=jZTy9GN90LSuaoebKhySaUJBbIs/l70thCKH0ogjOOYnf/FImagU1mFVs7SVkvyqv1
         Oj6TfG4WHhDxW0FALTRuCvImxwAMbuCetVw2/Uz+Cmm57Se0OLRiYUOoUo5o3yCfIRZq
         WzyzhtDTiNoptljlGDvrfADw560u434AQtlScKg+2m86W7cuCH1GUaywOowQsJDvvgih
         O1aVgm4kH1rwEmBrhHAAhjowCSNKJeFnVlPD+SuBnzN8DrAY1WWjCHGOCZt8OwhUQIPX
         CV1L8NyANpsdnx+5aKvDhAW3Z7LaFgiAGKVJKBwOhTQjTqLmMmTzFXQ+vfydsbQhNKB+
         YkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9FOb1l6NNujBgS6Pd8VeV0djJsyicx4ys2rNzFqoG7Q=;
        b=g4uBylsJOwW5LvxkJRoEQCWufejwre757Xg0N58JGI96FwzNlb/S63bhIMPiXJVmvw
         3AJoShhrpAImTFuhiR6+UoXnAOhwuT7nfcIvgC8ILPH7ABROPCqO6fH5X0vZfo5WEu/q
         0ozcR1epgrH5L0Wr5oPABQ7q/CXUm4sr1/M6oW4u5qphYg34yO9hUY8L5v436tZqY0Vv
         oOY2/mzmuXOVrRYAjt63AjBDTR2G8rods8swRwrhS8bJeHnO0bWl3IgmClcU0zbgR/Nt
         FVR7rfztkAra7kj1g6n9kqoLrhfS5lc+evvJDAp0odnJuY/kAgRvSeD+lm5o3V+b4MVI
         ZnKg==
X-Gm-Message-State: APjAAAWqlKdBUV/oanyr1jthaIrGHjubafPlsPvJFUoOjnWiquJJ8Hd6
        y6lJD4uZtH2aUsDWOKXiSG4PGiuABvY=
X-Google-Smtp-Source: APXvYqxRCzT9WvpX0UY5boOll5wk4dWaNsxfMfmoyhUn7t+zOVaBDkQ7G/8C8FNy0PH5a0V2038Erw==
X-Received: by 2002:a17:90a:634a:: with SMTP id v10mr8609992pjs.16.1561668769151;
        Thu, 27 Jun 2019 13:52:49 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id 2sm3674083pff.174.2019.06.27.13.52.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 13:52:48 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y 3/9] usb: dwc3: gadget: use num_trbs when skipping TRBs on ->dequeue()
Date:   Thu, 27 Jun 2019 20:52:34 +0000
Message-Id: <20190627205240.38366-4-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627205240.38366-1-john.stultz@linaro.org>
References: <20190627205240.38366-1-john.stultz@linaro.org>
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
index 019643a6ce9d..cb6dfea5d5e7 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1370,6 +1370,8 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 				break;
 		}
 		if (r == req) {
+			int i;
+
 			/* wait until it is processed */
 			dwc3_stop_active_transfer(dep, true);
 
@@ -1407,32 +1409,12 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
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
@@ -1443,8 +1425,6 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 	}
 
 out1:
-	/* giveback the request */
-
 	dwc3_gadget_giveback(dep, req, -ECONNRESET);
 
 out0:
-- 
2.17.1

