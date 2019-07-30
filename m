Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111C07B435
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 22:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfG3UQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 16:16:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37178 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfG3UQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 16:16:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id i70so19888790pgd.4
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 13:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BeA/svtAIFW8HDV9tUYz5pgLvX8TrGYNMj5kwb+rqcE=;
        b=k/5uDoU+a06aMoVqDSCbVpbcEi6eGjeSTKQ39j7yNqiQXZaBK2cZmzIyhyn4cdQy3O
         sPrc8MIasvPdgbP3sf4gie614PaC8WVhyTBZo0w8ZxXeSZMIl+CKLTiJO6/RBIycRJaC
         tb82SWrI980qCnHmIPpKHKuIhs3M2P2ZpjSDHDtpElOs3twZbVDMzDxn8UMClj1tstD6
         7S1C9ZCRcC9bSLXcmW8oFepKXgJVXgMs2quS4VQ4cBG6XRhW2A2DWKOSdlJ/9ztOJ4KQ
         c5tlrlsGZrSz6l/v+CWX4BEGtiC78kESi+tZ1PBAm2cmBpSWBOf+lZT/GfU8oNBpUfAo
         JHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BeA/svtAIFW8HDV9tUYz5pgLvX8TrGYNMj5kwb+rqcE=;
        b=pzoNdWBOBHNadS3tI9aalOP5Pf8UjnkxVCRzR5M5LX/UTHLakQI3cSqBfOOZPY/oEQ
         c/FXnX+Je4/54ljh6YjYmvXrDKIR7gTCJWCc4Ecbge6MU3Kc6c/ZVPT25UzgQ4t+8n0K
         IzlwKOKHQMqh8T88n9rhqNhrzDgfdDMlxP+vKL9Qrg9MXUFrt2uN8dqtkVgLL1PvAt+7
         b0JF4UZmfO3+VqMfBW468l2axQyKS7oPB6/fG1BORUeuXTI0EplWEOeilG0z2kbsRzV9
         NigT8JW6/t6f+qf/7yUH2sgufpUHtpCn7kdLCNIH6pFj1KXBc1RlXEfkHJf50wGSnkAG
         Cv1Q==
X-Gm-Message-State: APjAAAWV27qN0krvca2EafovicpXJwa+zcg3s3k9YaIl8uUDUru5u/zO
        FTeSnUVH94EDEyhp4gik8QMmuq3y35E=
X-Google-Smtp-Source: APXvYqxQpR6P5VT2YjZrU1dnwrvSMJLWVfNQT/i6a+++9WjV+cMQ0mugAt88Z5nJQR5HQfZpuF9u1Q==
X-Received: by 2002:a63:61c6:: with SMTP id v189mr103070806pgb.36.1564517806498;
        Tue, 30 Jul 2019 13:16:46 -0700 (PDT)
Received: from localhost.localdomain ([49.207.49.136])
        by smtp.gmail.com with ESMTPSA id 135sm67603659pfb.137.2019.07.30.13.16.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 13:16:45 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        Minas Harutyunyan <minas.harutyunyan@synopsys.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH for-4.19.y 2/3] usb: dwc2: Fix disable all EP's on disconnect
Date:   Wed, 31 Jul 2019 01:46:38 +0530
Message-Id: <1564517799-16880-2-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564517799-16880-1-git-send-email-amit.pundir@linaro.org>
References: <1564517799-16880-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <minas.harutyunyan@synopsys.com>

commit 4fe4f9fecc36956fd53c8edf96dd0c691ef98ff9 upstream.

Disabling all EP's allow to reset EP's to initial state.
Introduced new function dwc2_hsotg_ep_disable_lock() which
before calling dwc2_hsotg_ep_disable() function acquire
hsotg->lock and release on exiting.
From dwc2_hsotg_ep_disable() function removed acquiring
hsotg->lock.
In dwc2_hsotg_core_init_disconnected() function when USB
reset interrupt asserted disabling all ep’s by
dwc2_hsotg_ep_disable() function.
This updates eliminating sparse imbalance warnings.

Reverted changes in dwc2_hostg_disconnect() function.
Introduced new function dwc2_hsotg_ep_disable_lock().
Changed dwc2_hsotg_ep_ops. Now disable point to
dwc2_hsotg_ep_disable_lock() function.
In functions dwc2_hsotg_udc_stop() and dwc2_hsotg_suspend()
dwc2_hsotg_ep_disable() function replaced by
dwc2_hsotg_ep_disable_lock() function.
In dwc2_hsotg_ep_disable() function removed acquiring
of hsotg->lock.

Fixes: dccf1bad4be7 ("usb: dwc2: Disable all EP's on disconnect")
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Cherry-picked from lede/openwrt tree
https://git.lede-project.org/?p=source.git.
Build tested for ARCH=arm64 + defconfig

 drivers/usb/dwc2/gadget.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index ed79bdf6f56c..3f68edde0f03 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3107,8 +3107,6 @@ static void kill_all_requests(struct dwc2_hsotg *hsotg,
 		dwc2_hsotg_txfifo_flush(hsotg, ep->fifo_index);
 }
 
-static int dwc2_hsotg_ep_disable(struct usb_ep *ep);
-
 /**
  * dwc2_hsotg_disconnect - disconnect service
  * @hsotg: The device state.
@@ -3130,9 +3128,11 @@ void dwc2_hsotg_disconnect(struct dwc2_hsotg *hsotg)
 	/* all endpoints should be shutdown */
 	for (ep = 0; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
-			dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
+			kill_all_requests(hsotg, hsotg->eps_in[ep],
+					  -ESHUTDOWN);
 		if (hsotg->eps_out[ep])
-			dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
+			kill_all_requests(hsotg, hsotg->eps_out[ep],
+					  -ESHUTDOWN);
 	}
 
 	call_gadget(hsotg, disconnect);
@@ -3176,6 +3176,7 @@ static void dwc2_hsotg_irq_fifoempty(struct dwc2_hsotg *hsotg, bool periodic)
 			GINTSTS_PTXFEMP |  \
 			GINTSTS_RXFLVL)
 
+static int dwc2_hsotg_ep_disable(struct usb_ep *ep);
 /**
  * dwc2_hsotg_core_init - issue softreset to the core
  * @hsotg: The device state
@@ -4004,10 +4005,8 @@ static int dwc2_hsotg_ep_disable(struct usb_ep *ep)
 	struct dwc2_hsotg *hsotg = hs_ep->parent;
 	int dir_in = hs_ep->dir_in;
 	int index = hs_ep->index;
-	unsigned long flags;
 	u32 epctrl_reg;
 	u32 ctrl;
-	int locked;
 
 	dev_dbg(hsotg->dev, "%s(ep %p)\n", __func__, ep);
 
@@ -4023,10 +4022,6 @@ static int dwc2_hsotg_ep_disable(struct usb_ep *ep)
 
 	epctrl_reg = dir_in ? DIEPCTL(index) : DOEPCTL(index);
 
-	locked = spin_is_locked(&hsotg->lock);
-	if (!locked)
-		spin_lock_irqsave(&hsotg->lock, flags);
-
 	ctrl = dwc2_readl(hsotg, epctrl_reg);
 
 	if (ctrl & DXEPCTL_EPENA)
@@ -4049,12 +4044,22 @@ static int dwc2_hsotg_ep_disable(struct usb_ep *ep)
 	hs_ep->fifo_index = 0;
 	hs_ep->fifo_size = 0;
 
-	if (!locked)
-		spin_unlock_irqrestore(&hsotg->lock, flags);
-
 	return 0;
 }
 
+static int dwc2_hsotg_ep_disable_lock(struct usb_ep *ep)
+{
+	struct dwc2_hsotg_ep *hs_ep = our_ep(ep);
+	struct dwc2_hsotg *hsotg = hs_ep->parent;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&hsotg->lock, flags);
+	ret = dwc2_hsotg_ep_disable(ep);
+	spin_unlock_irqrestore(&hsotg->lock, flags);
+	return ret;
+}
+
 /**
  * on_list - check request is on the given endpoint
  * @ep: The endpoint to check.
@@ -4202,7 +4207,7 @@ static int dwc2_hsotg_ep_sethalt_lock(struct usb_ep *ep, int value)
 
 static const struct usb_ep_ops dwc2_hsotg_ep_ops = {
 	.enable		= dwc2_hsotg_ep_enable,
-	.disable	= dwc2_hsotg_ep_disable,
+	.disable	= dwc2_hsotg_ep_disable_lock,
 	.alloc_request	= dwc2_hsotg_ep_alloc_request,
 	.free_request	= dwc2_hsotg_ep_free_request,
 	.queue		= dwc2_hsotg_ep_queue_lock,
@@ -4342,9 +4347,9 @@ static int dwc2_hsotg_udc_stop(struct usb_gadget *gadget)
 	/* all endpoints should be shutdown */
 	for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 		if (hsotg->eps_in[ep])
-			dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
+			dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
 		if (hsotg->eps_out[ep])
-			dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
+			dwc2_hsotg_ep_disable_lock(&hsotg->eps_out[ep]->ep);
 	}
 
 	spin_lock_irqsave(&hsotg->lock, flags);
@@ -4792,9 +4797,9 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg *hsotg)
 
 		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
-				dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
+				dwc2_hsotg_ep_disable_lock(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
-				dwc2_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
+				dwc2_hsotg_ep_disable_lock(&hsotg->eps_out[ep]->ep);
 		}
 	}
 
-- 
2.7.4

