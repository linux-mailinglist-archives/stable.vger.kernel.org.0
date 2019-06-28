Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A535A372
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfF1SYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:24:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35187 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfF1SYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:24:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so3399580pfd.2
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ih7U4hpwGmfoDyYEDt6ssld4EzhtjygGMzYklaGP3Wc=;
        b=mk8J9R2LyueC0i6f8ZRSA4DJA28jyZ55n95SHVFP+uj39/BO2/IP0UxjTWqCeq+eym
         C9Cw336mhXrmmHCrfxSmauKAhudkV8ioUSHg4cI7lRcrIbrEvlov9A8WtIgE1hoMLyse
         1wJpZ57harz3Dfq81xg6bEm2chVzpT3sTF+rfxzjdoSOEZYIjxESghqgqV9Qvh2p9ZGg
         NN+KFLHYLoz9RCCQAayXKK5w6VZvIaRekatiZLtaetKv+W68+BQbUd+ugJqQewUhcykj
         3at2yTQZPpWIatsQRPnl1GYEBbQH5ijtulJnlZqqxO/Yx0QsW6657rOMwAsQRVRHNIgb
         fMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ih7U4hpwGmfoDyYEDt6ssld4EzhtjygGMzYklaGP3Wc=;
        b=peE1gscpyNTdZ6ONxVfilvPqNRMunrOLrkaosGROti+V+mPUMHQjeyHK1BNhGjORiK
         JQjAv9aR8Phb8FwLfR/3aKW/weX0IaeCnkYgO82ClX3ZxTcVc67+loKPdkwPWrlPhes1
         +o3rqGFdcnIYaJwmVLNVgKyLZpy2qZZ7ceC1WkbwMA4mIp105i1jeSOC1MuZg+ZRodLY
         S53V0RfPVXyTc0sXkSB+RtprEunJSOCRnZ4iJHxKMdPtK3oy3j2n/kW7HuMuyHu9psvs
         mDWmhsqlyJwh/QoDIYnfqXE9o7dt+gBD5y5LKLqEDYMpcxsgM0INi0pjCR9azq5hCGwr
         LQHA==
X-Gm-Message-State: APjAAAUKdyFIHZQX6VmAH2LZ0xBkNCB32G5xafo6LPd3e2ZENV4QuIe0
        r2a0qzA3gQp9XJDm/AYAVjwJakcufJo=
X-Google-Smtp-Source: APXvYqwNCvTT67rkuVqcy61BjZbsAe5ofBN1aWGbeqvKWE2t4Pbv7bPlmW0h2lAhCJbdl9UBETECtA==
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mr14679396pjp.47.1561746262349;
        Fri, 28 Jun 2019 11:24:22 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id s15sm2916223pfd.183.2019.06.28.11.24.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:24:21 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y v2 3/9] usb: dwc3: gadget: track number of TRBs per request
Date:   Fri, 28 Jun 2019 18:24:07 +0000
Message-Id: <20190628182413.33225-4-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628182413.33225-1-john.stultz@linaro.org>
References: <20190628182413.33225-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

commit 09fe1f8d7e2f461275b1cdd832f2cfa5e9be346d upstream

This will help us remove the wait_event() from our ->dequeue().

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit 09fe1f8d7e2f461275b1cdd832f2cfa5e9be346d)
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/core.h   | 3 +++
 drivers/usb/dwc3/gadget.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 4872cba8699b..0de78cb29f2c 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -847,6 +847,7 @@ struct dwc3_hwparams {
  * @epnum: endpoint number to which this request refers
  * @trb: pointer to struct dwc3_trb
  * @trb_dma: DMA address of @trb
+ * @num_trbs: number of TRBs used by this request
  * @needs_extra_trb: true when request needs one extra TRB (either due to ZLP
  *	or unaligned OUT)
  * @direction: IN or OUT direction flag
@@ -867,6 +868,8 @@ struct dwc3_request {
 	struct dwc3_trb		*trb;
 	dma_addr_t		trb_dma;
 
+	unsigned		num_trbs;
+
 	unsigned		needs_extra_trb:1;
 	unsigned		direction:1;
 	unsigned		mapped:1;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8db7466e4f76..fd91c494307c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1041,6 +1041,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 		req->trb_dma = dwc3_trb_dma_offset(dep, trb);
 	}
 
+	req->num_trbs++;
+
 	__dwc3_prepare_one_trb(dep, trb, dma, length, chain, node,
 			stream_id, short_not_ok, no_interrupt);
 }
@@ -1075,6 +1077,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 
 			/* Now prepare one extra TRB to align transfer size */
 			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
 			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr,
 					maxp - rem, false, 1,
 					req->request.stream_id,
@@ -1119,6 +1122,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 
 		/* Now prepare one extra TRB to align transfer size */
 		trb = &dep->trb_pool[dep->trb_enqueue];
+		req->num_trbs++;
 		__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp - rem,
 				false, 1, req->request.stream_id,
 				req->request.short_not_ok,
@@ -1135,6 +1139,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 
 		/* Now prepare one extra TRB to handle ZLP */
 		trb = &dep->trb_pool[dep->trb_enqueue];
+		req->num_trbs++;
 		__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
 				false, 1, req->request.stream_id,
 				req->request.short_not_ok,
@@ -2231,6 +2236,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	dwc3_ep_inc_deq(dep);
 
 	trace_dwc3_complete_trb(dep, trb);
+	req->num_trbs--;
 
 	/*
 	 * If we're in the middle of series of chained TRBs and we
-- 
2.17.1

