Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486DF145E99
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 23:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAVW0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 17:26:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38881 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgAVW0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 17:26:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id a33so273595pgm.5
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 14:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JESjh6inBv92WxZqfb4czYKZ8FKdIT47e0CUpHsL9zw=;
        b=RsGmOvIt+Bzr6i4aIVzintUFXr+6XX+aQJNI6juKMss4wBAunzxItSZlGbXw7ha+3c
         V5pNjplf1oyvhJV3/UY1eBclT7Bav7RGheW0wzEZ34ThAk5YhiMCUCN0jmmS1fz8i5Rq
         3WBNsJe0+drVR3Fi8glb78/uzKQBNkHkind1gitZeqjlkXBg0eabjb5ILlDjiP473ux2
         LZ5J1BPDiBf1L0IJfDdw5BDmpkkp2vVEuWl426uWWk4c+8E+pLHAJj5YK1M0M+OeLBsV
         MxdvsQOkXmBtkojh4QldDc4RcnkQiSuotRNJcvmGpFH5ESJmrVx/O4yKvoYr4dhdqkxW
         1p0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JESjh6inBv92WxZqfb4czYKZ8FKdIT47e0CUpHsL9zw=;
        b=NhqFjjs1qSWUQy7ucaXPnyNEm2GMdg8pAmU9dm+4aEI9pP+GKDBhLIauGktCSNrUGp
         p5GPnVLdqI8nZ/KpVduOCQYoeOQv3ee+PPePU3ejk1kQAkUOFERuhePHMa2j8U34MEEi
         pixwfEgSksq925c0uLtKdCgpnBuWDshtf+A4JsBFSv6IeI3yifLKC8f13P1kNfKQDjvi
         hfik4qlqNKSMMBp/2gz3scOQGUi5GW5F8Z/TqBQ4LiUwXo3UY4uLVjcAypCIB1e0eS86
         RSApGoAjzUiXGAG0CP2So/fwwdD/+WILAVDOJivisJUz/YaDz6rpP7frGZJdLnaAyJ+D
         lLdA==
X-Gm-Message-State: APjAAAVCPJD5OJD6PoYkwS79+xQsEAAK7OaimUHl5/YWzX7Qb6wbE9tf
        JAPgrG8FsG0enYNfLpbmGCbblw==
X-Google-Smtp-Source: APXvYqyHFnzdcPwFmtLdIrSYOuAiwsCTGRIQwQ9Jlfx8tJ4RGPs5SBRmOuXWib6jnxyijCN3yYVuiA==
X-Received: by 2002:a63:111e:: with SMTP id g30mr541062pgl.251.1579732011742;
        Wed, 22 Jan 2020 14:26:51 -0800 (PST)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id a28sm47793509pfh.119.2020.01.22.14.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 14:26:51 -0800 (PST)
From:   John Stultz <john.stultz@linaro.org>
To:     lkml <linux-kernel@vger.kernel.org>
Cc:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [RFC][PATCH 1/2] usb: dwc3: gadget: Check for IOC/LST bit in both event->status and TRB->ctrl fields
Date:   Wed, 22 Jan 2020 22:26:44 +0000
Message-Id: <20200122222645.38805-2-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122222645.38805-1-john.stultz@linaro.org>
References: <20200122222645.38805-1-john.stultz@linaro.org>
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
with adb on dwc3 based HiKey960 after functionfs gadget added
scatter-gather support around v4.20.

Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Yang Fei <fei.yang@intel.com>
Cc: Thinh Nguyen <thinhn@synopsys.com>
Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: Jack Pham <jackp@codeaurora.org>
Cc: Todd Kjos <tkjos@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux USB List <linux-usb@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Tested-by: Tejas Joglekar <tejas.joglekar@synopsys.com>
Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
[jstultz: forward ported to mainline, added note to commit log]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 154f3f3e8cff..1edce3bbb55c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2420,7 +2420,12 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
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

