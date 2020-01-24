Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C689014845A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgAXLBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387461AbgAXLBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:01 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96FFF2075D;
        Fri, 24 Jan 2020 11:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863660;
        bh=96UEnDxM92NBHI4XdABdLtJAps/MsfmjxmY7SZNS2d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SriN6iUPMyY5bbqiFXTUkZpHWGawvZwGDquhZExXo65Y2gm/dsyWacFAI6ZbBXCFl
         24Yf1oysOvHFOqOfMOUyULx55EPzP0Z6h+nW7WHv2ysbW++AzWjdsX1YIYUYW9PXUK
         xyEemnZdD11ojZpsqMb0F8Vv/041SQkl6Wsgz2Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/639] usb: gadget: fsl_udc_core: check allocation return value and cleanup on failure
Date:   Fri, 24 Jan 2020 10:23:30 +0100
Message-Id: <20200124093052.465389456@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

[ Upstream commit 4ab2b48c98f2ec9712452d520a381917f91ac3d2 ]

The allocation with fsl_alloc_request() and kmalloc() were unchecked
fixed this up with a NULL check and appropriate cleanup.

Additionally udc->ep_qh_size was reset to 0 on failure of allocation.
Similar udc->phy_mode is initially 0 (as udc_controller was
allocated with kzalloc in fsl_udc_probe()) so reset it to 0 as well
so that this function is side-effect free on failure. Not clear if
this is necessary or sensible as fsl_udc_release() probably can not
be called if fsl_udc_probe() failed - but it should not hurt.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: b504882da5 ("USB: add Freescale high-speed USB SOC device controller driver")
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fsl_udc_core.c | 30 +++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index d44b26d5b2a2c..367697144cda2 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2247,8 +2247,10 @@ static int struct_udc_setup(struct fsl_udc *udc,
 	udc->phy_mode = pdata->phy_mode;
 
 	udc->eps = kcalloc(udc->max_ep, sizeof(struct fsl_ep), GFP_KERNEL);
-	if (!udc->eps)
-		return -1;
+	if (!udc->eps) {
+		ERR("kmalloc udc endpoint status failed\n");
+		goto eps_alloc_failed;
+	}
 
 	/* initialized QHs, take care of alignment */
 	size = udc->max_ep * sizeof(struct ep_queue_head);
@@ -2262,8 +2264,7 @@ static int struct_udc_setup(struct fsl_udc *udc,
 					&udc->ep_qh_dma, GFP_KERNEL);
 	if (!udc->ep_qh) {
 		ERR("malloc QHs for udc failed\n");
-		kfree(udc->eps);
-		return -1;
+		goto ep_queue_alloc_failed;
 	}
 
 	udc->ep_qh_size = size;
@@ -2272,8 +2273,17 @@ static int struct_udc_setup(struct fsl_udc *udc,
 	/* FIXME: fsl_alloc_request() ignores ep argument */
 	udc->status_req = container_of(fsl_alloc_request(NULL, GFP_KERNEL),
 			struct fsl_req, req);
+	if (!udc->status_req) {
+		ERR("kzalloc for udc status request failed\n");
+		goto udc_status_alloc_failed;
+	}
+
 	/* allocate a small amount of memory to get valid address */
 	udc->status_req->req.buf = kmalloc(8, GFP_KERNEL);
+	if (!udc->status_req->req.buf) {
+		ERR("kzalloc for udc request buffer failed\n");
+		goto udc_req_buf_alloc_failed;
+	}
 
 	udc->resume_state = USB_STATE_NOTATTACHED;
 	udc->usb_state = USB_STATE_POWERED;
@@ -2281,6 +2291,18 @@ static int struct_udc_setup(struct fsl_udc *udc,
 	udc->remote_wakeup = 0;	/* default to 0 on reset */
 
 	return 0;
+
+udc_req_buf_alloc_failed:
+	kfree(udc->status_req);
+udc_status_alloc_failed:
+	kfree(udc->ep_qh);
+	udc->ep_qh_size = 0;
+ep_queue_alloc_failed:
+	kfree(udc->eps);
+eps_alloc_failed:
+	udc->phy_mode = 0;
+	return -1;
+
 }
 
 /*----------------------------------------------------------------
-- 
2.20.1



