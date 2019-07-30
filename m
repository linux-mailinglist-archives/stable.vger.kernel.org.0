Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49E97B434
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 22:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfG3UQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 16:16:44 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41385 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfG3UQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 16:16:44 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so30423229pff.8
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 13:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=9hc+sJms2hXMGQNWN7WU1PS1ixx5relE2nk3BJfrfy4=;
        b=oFyOwQYtTR4ybI4vMkuOqL5ixzuVUrMh4y1OvgP/C0QjRpRdQNHKtR1iP0ITwY99HT
         6HKap4jWMO+upU6ossYk8DQwUJc1BhpTpuDr5ym6WYmAFQUtYaCt6kN2eptv+J2dBPiy
         TZj4rggMnSgldDmqz0rzxOi6Nv3EyjfEdnSp0PUwqIqAN2GeAneMIgLkmJjnrSd7vWaP
         Uc874um1a3w87fmAD8lnWiayZ0ue3FIV4P/SdhyddJYv4v5gF7pv289YDK8uXphnG95w
         nnlxNLVfnAqJJdqMX5BispgRlKCtRUV5gmlVP9c6rL8O2NvcyD8nc55QnHCNvOXNnZW1
         Ierw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9hc+sJms2hXMGQNWN7WU1PS1ixx5relE2nk3BJfrfy4=;
        b=dih/FQyIEGifwmXY0WwHwsY1KlaQ8OeszwCWjB38+lWTEi4aqBtygIGoOmvfKaml6R
         WHEn1cgn4T8V3BODdDGjW3l+NedISeUWoJNy/508QoftYTPtU+gxMigDcBmwxGIl3vcp
         AxomVI0daF2yKwD6dIDguhw62jwksEeq0P0jOwp8mBub65jzSS9XxRiu/tv9uE174rfr
         qI3k9d574faLJ3ZCf618GmL2TIiPLQG+mcNZzgNE2wyquS/IBRDZADwAe9k4cAAzTRjN
         ouYHJ3GKot7m6l7qELpft3bkBu1jzus8Aubq5d0lDrndldh1OV6Y2TGlewh0/byL8I35
         fzBA==
X-Gm-Message-State: APjAAAWas50RmLRL3jbkh6eiK8VVKQUfGYQ2h1uw5ycLKkNvaL688RRV
        cewHkHtPC8dx4aDqlajxapdfQQ==
X-Google-Smtp-Source: APXvYqyc19/8PDsnt0sIvQo5hHbp6+iWUk/SkxEdbvRUZLNWtfnUbYh1oaP+HMjtaVKmDJqU1McNrA==
X-Received: by 2002:a62:1750:: with SMTP id 77mr44045939pfx.172.1564517803827;
        Tue, 30 Jul 2019 13:16:43 -0700 (PDT)
Received: from localhost.localdomain ([49.207.49.136])
        by smtp.gmail.com with ESMTPSA id 135sm67603659pfb.137.2019.07.30.13.16.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 13:16:42 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH for-4.19.y 1/3] usb: dwc2: Disable all EP's on disconnect
Date:   Wed, 31 Jul 2019 01:46:37 +0530
Message-Id: <1564517799-16880-1-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit dccf1bad4be7eaa096c1f3697bd37883f9a08ecb upstream.

Disabling all EP's allow to reset EP's to initial state.
On disconnect disable all EP's instead of just killing
all requests. Because of some platform didn't catch
disconnect event, same stuff added to
dwc2_hsotg_core_init_disconnected() function when USB
reset detected on the bus.

Changed from version 1:
Changed lock acquire flow in dwc2_hsotg_ep_disable()
function.

Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Cherry-picked from lede/openwrt tree
https://git.lede-project.org/?p=source.git.
Build tested for ARCH=arm64 + defconfig

 drivers/usb/dwc2/gadget.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 03614ef64ca4..ed79bdf6f56c 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3107,6 +3107,8 @@ static void kill_all_requests(struct dwc2_hsotg *hsotg,
 		dwc2_hsotg_txfifo_flush(hsotg, ep->fifo_index);
 }
 
+static int dwc2_hsotg_ep_disable(struct usb_ep *ep);
+
 /**
  * dwc2_hsotg_disconnect - disconnect service
  * @hsotg: The device state.
@@ -3125,13 +3127,12 @@ void dwc2_hsotg_disconnect(struct dwc2_hsotg *hsotg)
 	hsotg->connected = 0;
 	hsotg->test_mode = 0;
 
+	/* all endpoints should be shutdown */
 	for (ep = 0; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
-			kill_all_requests(hsotg, hsotg->eps_in[ep],
-					  -ESHUTDOWN);
+			dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
 		if (hsotg->eps_out[ep])
-			kill_all_requests(hsotg, hsotg->eps_out[ep],
-					  -ESHUTDOWN);
+			dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
 	}
 
 	call_gadget(hsotg, disconnect);
@@ -3189,13 +3190,23 @@ void dwc2_hsotg_core_init_disconnected(struct dwc2_hsotg *hsotg,
 	u32 val;
 	u32 usbcfg;
 	u32 dcfg = 0;
+	int ep;
 
 	/* Kill any ep0 requests as controller will be reinitialized */
 	kill_all_requests(hsotg, hsotg->eps_out[0], -ECONNRESET);
 
-	if (!is_usb_reset)
+	if (!is_usb_reset) {
 		if (dwc2_core_reset(hsotg, true))
 			return;
+	} else {
+		/* all endpoints should be shutdown */
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
+			if (hsotg->eps_in[ep])
+				dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
+			if (hsotg->eps_out[ep])
+				dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
+		}
+	}
 
 	/*
 	 * we must now enable ep0 ready for host detection and then
@@ -3996,6 +4007,7 @@ static int dwc2_hsotg_ep_disable(struct usb_ep *ep)
 	unsigned long flags;
 	u32 epctrl_reg;
 	u32 ctrl;
+	int locked;
 
 	dev_dbg(hsotg->dev, "%s(ep %p)\n", __func__, ep);
 
@@ -4011,7 +4023,9 @@ static int dwc2_hsotg_ep_disable(struct usb_ep *ep)
 
 	epctrl_reg = dir_in ? DIEPCTL(index) : DOEPCTL(index);
 
-	spin_lock_irqsave(&hsotg->lock, flags);
+	locked = spin_is_locked(&hsotg->lock);
+	if (!locked)
+		spin_lock_irqsave(&hsotg->lock, flags);
 
 	ctrl = dwc2_readl(hsotg, epctrl_reg);
 
@@ -4035,7 +4049,9 @@ static int dwc2_hsotg_ep_disable(struct usb_ep *ep)
 	hs_ep->fifo_index = 0;
 	hs_ep->fifo_size = 0;
 
-	spin_unlock_irqrestore(&hsotg->lock, flags);
+	if (!locked)
+		spin_unlock_irqrestore(&hsotg->lock, flags);
+
 	return 0;
 }
 
-- 
2.7.4

