Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E2720C1
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 22:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfGWU1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 16:27:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35516 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfGWU1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 16:27:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id u14so19718923pfn.2
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 13:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WOfhFeRwrk1NDQAubrKcIwqzw+J4sPXSqFL3j8L4jQk=;
        b=JezetA0Nxiw1OmCAW2DXcbq3AmvNuAKkd8EZaqtaZE02yn5PvkQjeWHGm89Hdz/5x0
         ZL73gKx15WWh+UArNMwog4UBdRwhmA8Aays93Bv5o44Kj6UuElrGHFE0oqlQ6L7Lu2kJ
         0jDtfZU+Wr3MXAV4msLIdr/sT1MbA82oTkWRSPhySp0tLXs+dR9/YHF/3UQOUU/Y3OJp
         FrOqsBBL9FByy1fTW5o4xilcETT+or2inIAtjcbVo+EjXq7WpE9JQMUUBkFJ9aiw4fyv
         DgxZdF2eLiLg8U5C9f4yWFJ8D1QS4s4Nb9UfauWvP+esjMgTbNPzSAx6zFw3Fr8GkPco
         fmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WOfhFeRwrk1NDQAubrKcIwqzw+J4sPXSqFL3j8L4jQk=;
        b=TxDXbAU3zB9IwsMfywKgOGS6/lwmrfO3oN14DagrWElFY94jUxd1WFQA/wBP8zXCRz
         72G7G7BK28ImtYhNDTlRqy2ujpRlqTmDHgJXW/GWVEf3cH3WtdwQSYr+v1wV31IBFHCi
         fwa4lX3mah2/1RdWTTk2gCta3RQfY8dLVQ3zUcLSsQcWblDoCOzskENvWRtY7qaMOmhZ
         fgIKfU+0PqGVURE+NtWWILP1zytJgvYIg66XHI61+OOc/jk0qt7OGOHMZLIrw1YaePRy
         S9gaVwXaAtEVtcSd5YkQNQ1A1VrfbFGC8jnLK/Ew/P1sooHkBdMiwuP+aL3w3fnSPAnK
         MNqg==
X-Gm-Message-State: APjAAAVNf+L9ZKlXFhedgpH/0phGzmhICXobe8DNrpKRCLWqcx18T+7v
        bKZRxcoTssxeDOaw6g0p0tuHng==
X-Google-Smtp-Source: APXvYqwRAuZr7uU9qydDUT8b6JlLLZPXYg4os9EGyOFJ139Z/P8r3tDqZio8CygZ1zwDz3EFcrGD9Q==
X-Received: by 2002:a17:90a:109:: with SMTP id b9mr79845273pjb.112.1563913663333;
        Tue, 23 Jul 2019 13:27:43 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id r2sm59205538pfl.67.2019.07.23.13.27.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 13:27:42 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     linux-kernel@vger.kernel.org
Cc:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] usb: dwc3: Check for IOC/LST bit in both event->status and TRB->ctrl fields
Date:   Tue, 23 Jul 2019 20:27:35 +0000
Message-Id: <20190723202735.113381-1-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CY4PR1201MB003708ADAD79BF4FD24D3445AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com>
References: <CY4PR1201MB003708ADAD79BF4FD24D3445AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>

The present code in dwc3_gadget_ep_reclaim_completed_trb() will check
for IOC/LST bit in the event->status and returns if IOC/LST bit is
set. This logic doesn't work if multiple TRBs are queued per
request and the IOC/LST bit is set on the last TRB of that request.
Consider an example where a queued request has multiple queued TRBs
and IOC/LST bit is set only for the last TRB. In this case, the Core
generates XferComplete/XferInProgress events only for the last TRB
(since IOC/LST are set only for the last TRB). As per the logic in
dwc3_gadget_ep_reclaim_completed_trb() event->status is checked for
IOC/LST bit and returns on the first TRB. This makes the remaining
TRBs left unhandled.
To aviod this, changed the code to check for IOC/LST bits in both
event->status & TRB->ctrl. This patch does the same.

At a practical level, this patch resolves USB transfer stalls seen
with adb on dwc3 based Android devices after functionfs gadget
added scatter-gather support around v4.20.

Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Thinh Nguyen <thinhn@synopsys.com>
Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux USB List <linux-usb@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Tested-By: Tejas Joglekar <tejas.joglekar@synopsys.com>
Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
[jstultz: forward ported to mainline, added note to commit log]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
Just wanted to send this out so we're all looking at the same thing.
Not sure if its correct, but it seems to solve the adb stalls I've
been seeing for awhile.

 thanks
 -john

 drivers/usb/dwc3/gadget.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index c9cecb3a9670..1d9701dde69b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2394,7 +2394,12 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
-	if (event->status & DEPEVT_STATUS_IOC)
+	if ((event->status & DEPEVT_STATUS_IOC) &&
+	    (trb->ctrl & DWC3_TRB_CTRL_IOC))
+		return 1;
+
+	if ((event->status & DEPEVT_STATUS_LST) &&
+	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;
 
 	return 0;
-- 
2.17.1

