Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7F558C06
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 22:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfF0Uwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 16:52:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46967 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfF0Uwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 16:52:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so1796565pfy.13
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 13:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4Ag3DptOQlKFvwhPzNLWrHIQu/RujtBlVJPxwQgjUZ4=;
        b=xHiJhrSX+JSre8rOd6Cct+h18tuOFNpJtHqH//2drv/WJrQ6DlvS6OjN+XkAzsSJ7p
         5PGrfaHh8wCqeYYjfEkBEyoMNJv9B2jxgxogc8EE5RgIoDIweZHyEUI6gQjx7oNCB33d
         BRxXXO1g6O8f9BZu9HY400wvD7gnICKH88EKc4tLwdhBfBGXqTGbPNjEvl2jzw8fhYZQ
         /OCY8sLnUW6bsKHR/pgTJwJGLXMUu2MkuHeSG0XygFeBU7INB584rv6oPHJH5hsjNu32
         zec75NOMp0HZM9oEmfWX2KCFQAYgAXO5A9eGXCOT2pokFSMya5iYtzOCkmro7ugBtjnU
         5zrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4Ag3DptOQlKFvwhPzNLWrHIQu/RujtBlVJPxwQgjUZ4=;
        b=Ya9ezQ1suARJ5B5+IsLFucEg/HeUdxxedXClB30iL/ELKtv6kMJCZ1lVGM5hTETou6
         SleaybuRyOEDmIhStVCiO3d1IN9HRQwA5eNFfxO46pRD8quDFBN1h8Iyx05l5vRRvsqM
         xg5Q49JeUqJq77BmyKTy8ySZgwAVA+zaQME4AA0CtM5INhy/cNu7UYWSe4q1DaaXZgYO
         HdHqDPfzGg8TJNJmsTuj37N8DFE52nzYlDgl3oURlaHRvoZA6Q5tTV8NZkmN+QENi1tF
         HMpyBGAvGT0nOKvJ2fSk+VFVUK1FlJWnqqPeyNdveMH36PdebenQFB6TYXQgr6lu5UCU
         M0yw==
X-Gm-Message-State: APjAAAUpYIF9r4uqpy/XRkE8n2IAjJhMcsC2Yyf8Sb3s1txh52vSq3Rj
        vimtnxixzWUPEs/2SJbO8+FKfZPdbPI=
X-Google-Smtp-Source: APXvYqwFzFzc5WG5FDPcHRdqb2AaRR84Y9E3us/OjEIh46TdQGH18lAYeE49opbpuX3HCTe4z8EjjA==
X-Received: by 2002:a17:90a:270f:: with SMTP id o15mr8423034pje.56.1561668767538;
        Thu, 27 Jun 2019 13:52:47 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id 2sm3674083pff.174.2019.06.27.13.52.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 13:52:46 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y 2/9] usb: dwc3: gadget: track number of TRBs per request
Date:   Thu, 27 Jun 2019 20:52:33 +0000
Message-Id: <20190627205240.38366-3-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627205240.38366-1-john.stultz@linaro.org>
References: <20190627205240.38366-1-john.stultz@linaro.org>
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
index 4894fed1441c..019643a6ce9d 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1043,6 +1043,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 		req->trb_dma = dwc3_trb_dma_offset(dep, trb);
 	}
 
+	req->num_trbs++;
+
 	__dwc3_prepare_one_trb(dep, trb, dma, length, chain, node,
 			stream_id, short_not_ok, no_interrupt);
 }
@@ -1077,6 +1079,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 
 			/* Now prepare one extra TRB to align transfer size */
 			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
 			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr,
 					maxp - rem, false, 1,
 					req->request.stream_id,
@@ -1121,6 +1124,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 
 		/* Now prepare one extra TRB to align transfer size */
 		trb = &dep->trb_pool[dep->trb_enqueue];
+		req->num_trbs++;
 		__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp - rem,
 				false, 1, req->request.stream_id,
 				req->request.short_not_ok,
@@ -1137,6 +1141,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 
 		/* Now prepare one extra TRB to handle ZLP */
 		trb = &dep->trb_pool[dep->trb_enqueue];
+		req->num_trbs++;
 		__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
 				false, 1, req->request.stream_id,
 				req->request.short_not_ok,
@@ -2233,6 +2238,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	dwc3_ep_inc_deq(dep);
 
 	trace_dwc3_complete_trb(dep, trb);
+	req->num_trbs--;
 
 	/*
 	 * If we're in the middle of series of chained TRBs and we
-- 
2.17.1

