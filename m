Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AD52A54F4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388882AbgKCVPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388787AbgKCVPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:15:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E344D206B5;
        Tue,  3 Nov 2020 21:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604438132;
        bh=TqAsOiVQocTwySenwbDM1KmIu7/NjE4J/xrYO55ny2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEsatWijPpin/iphQ0uXmQbxwRTPcSdIwzbCPIkjRpYkqAHtnfuJ/aoAO19kwjW6y
         a6cte5AKAN4WCrnfpZL0k0tKVhGTn6mqTWMjLmn84UT9oTpcbQ2wZRcEuX7ZXH9iNs
         c2iIyOiHjXYrjE1ieMtbg/aG3XciGC6Ht9UxTLO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.9 247/391] usb: cdns3: Fix on-chip memory overflow issue
Date:   Tue,  3 Nov 2020 21:34:58 +0100
Message-Id: <20201103203403.677287857@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 52d3967704aea6cb316d419a33a5e1d56d33a3c1 upstream.

Patch fixes issue caused setting On-chip memory overflow bit in usb_sts
register. The issue occurred because EP_CFG register was set twice
before USB_STS.CFGSTS was set. Every write operation on EP_CFG.BUFFERING
causes that controller increases internal counter holding the number
of reserved on-chip buffers. First time this register was updated in
function cdns3_ep_config before delegating SET_CONFIGURATION request
to class driver and again it was updated when class wanted to enable
endpoint.  This patch fixes this issue by configuring endpoints
enabled by class driver in cdns3_gadget_ep_enable and others just
before status stage.

Cc: stable@vger.kernel.org#v5.8+
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reported-and-tested-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/cdns3/ep0.c    |   65 +++++++++++++++-------------
 drivers/usb/cdns3/gadget.c |  102 +++++++++++++++++++++++++--------------------
 drivers/usb/cdns3/gadget.h |    3 -
 3 files changed, 94 insertions(+), 76 deletions(-)

--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -137,48 +137,36 @@ static int cdns3_req_ep0_set_configurati
 					   struct usb_ctrlrequest *ctrl_req)
 {
 	enum usb_device_state device_state = priv_dev->gadget.state;
-	struct cdns3_endpoint *priv_ep;
 	u32 config = le16_to_cpu(ctrl_req->wValue);
 	int result = 0;
-	int i;
 
 	switch (device_state) {
 	case USB_STATE_ADDRESS:
-		/* Configure non-control EPs */
-		for (i = 0; i < CDNS3_ENDPOINTS_MAX_COUNT; i++) {
-			priv_ep = priv_dev->eps[i];
-			if (!priv_ep)
-				continue;
-
-			if (priv_ep->flags & EP_CLAIMED)
-				cdns3_ep_config(priv_ep);
-		}
-
 		result = cdns3_ep0_delegate_req(priv_dev, ctrl_req);
 
-		if (result)
-			return result;
-
-		if (!config) {
-			cdns3_hw_reset_eps_config(priv_dev);
-			usb_gadget_set_state(&priv_dev->gadget,
-					     USB_STATE_ADDRESS);
-		}
+		if (result || !config)
+			goto reset_config;
 
 		break;
 	case USB_STATE_CONFIGURED:
 		result = cdns3_ep0_delegate_req(priv_dev, ctrl_req);
+		if (!config && !result)
+			goto reset_config;
 
-		if (!config && !result) {
-			cdns3_hw_reset_eps_config(priv_dev);
-			usb_gadget_set_state(&priv_dev->gadget,
-					     USB_STATE_ADDRESS);
-		}
 		break;
 	default:
-		result = -EINVAL;
+		return -EINVAL;
 	}
 
+	return 0;
+
+reset_config:
+	if (result != USB_GADGET_DELAYED_STATUS)
+		cdns3_hw_reset_eps_config(priv_dev);
+
+	usb_gadget_set_state(&priv_dev->gadget,
+			     USB_STATE_ADDRESS);
+
 	return result;
 }
 
@@ -705,6 +693,7 @@ static int cdns3_gadget_ep0_queue(struct
 	unsigned long flags;
 	int ret = 0;
 	u8 zlp = 0;
+	int i;
 
 	spin_lock_irqsave(&priv_dev->lock, flags);
 	trace_cdns3_ep0_queue(priv_dev, request);
@@ -718,6 +707,17 @@ static int cdns3_gadget_ep0_queue(struct
 	/* send STATUS stage. Should be called only for SET_CONFIGURATION */
 	if (priv_dev->ep0_stage == CDNS3_STATUS_STAGE) {
 		cdns3_select_ep(priv_dev, 0x00);
+
+		/*
+		 * Configure all non-control EPs which are not enabled by class driver
+		 */
+		for (i = 0; i < CDNS3_ENDPOINTS_MAX_COUNT; i++) {
+			priv_ep = priv_dev->eps[i];
+			if (priv_ep && priv_ep->flags & EP_CLAIMED &&
+			    !(priv_ep->flags & EP_ENABLED))
+				cdns3_ep_config(priv_ep, 0);
+		}
+
 		cdns3_set_hw_configuration(priv_dev);
 		cdns3_ep0_complete_setup(priv_dev, 0, 1);
 		request->actual = 0;
@@ -803,6 +803,7 @@ void cdns3_ep0_config(struct cdns3_devic
 	struct cdns3_usb_regs __iomem *regs;
 	struct cdns3_endpoint *priv_ep;
 	u32 max_packet_size = 64;
+	u32 ep_cfg;
 
 	regs = priv_dev->regs;
 
@@ -834,8 +835,10 @@ void cdns3_ep0_config(struct cdns3_devic
 				       BIT(0) | BIT(16));
 	}
 
-	writel(EP_CFG_ENABLE | EP_CFG_MAXPKTSIZE(max_packet_size),
-	       &regs->ep_cfg);
+	ep_cfg = EP_CFG_ENABLE | EP_CFG_MAXPKTSIZE(max_packet_size);
+
+	if (!(priv_ep->flags & EP_CONFIGURED))
+		writel(ep_cfg, &regs->ep_cfg);
 
 	writel(EP_STS_EN_SETUPEN | EP_STS_EN_DESCMISEN | EP_STS_EN_TRBERREN,
 	       &regs->ep_sts_en);
@@ -843,8 +846,10 @@ void cdns3_ep0_config(struct cdns3_devic
 	/* init ep in */
 	cdns3_select_ep(priv_dev, USB_DIR_IN);
 
-	writel(EP_CFG_ENABLE | EP_CFG_MAXPKTSIZE(max_packet_size),
-	       &regs->ep_cfg);
+	if (!(priv_ep->flags & EP_CONFIGURED))
+		writel(ep_cfg, &regs->ep_cfg);
+
+	priv_ep->flags |= EP_CONFIGURED;
 
 	writel(EP_STS_EN_SETUPEN | EP_STS_EN_TRBERREN, &regs->ep_sts_en);
 
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -296,6 +296,8 @@ static void cdns3_ep_stall_flush(struct
  */
 void cdns3_hw_reset_eps_config(struct cdns3_device *priv_dev)
 {
+	int i;
+
 	writel(USB_CONF_CFGRST, &priv_dev->regs->usb_conf);
 
 	cdns3_allow_enable_l1(priv_dev, 0);
@@ -304,6 +306,10 @@ void cdns3_hw_reset_eps_config(struct cd
 	priv_dev->out_mem_is_allocated = 0;
 	priv_dev->wait_for_setup = 0;
 	priv_dev->using_streams = 0;
+
+	for (i = 0; i < CDNS3_ENDPOINTS_MAX_COUNT; i++)
+		if (priv_dev->eps[i])
+			priv_dev->eps[i]->flags &= ~EP_CONFIGURED;
 }
 
 /**
@@ -1907,27 +1913,6 @@ static int cdns3_ep_onchip_buffer_reserv
 	return 0;
 }
 
-static void cdns3_stream_ep_reconfig(struct cdns3_device *priv_dev,
-				     struct cdns3_endpoint *priv_ep)
-{
-	if (!priv_ep->use_streams || priv_dev->gadget.speed < USB_SPEED_SUPER)
-		return;
-
-	if (priv_dev->dev_ver >= DEV_VER_V3) {
-		u32 mask = BIT(priv_ep->num + (priv_ep->dir ? 16 : 0));
-
-		/*
-		 * Stream capable endpoints are handled by using ep_tdl
-		 * register. Other endpoints use TDL from TRB feature.
-		 */
-		cdns3_clear_register_bit(&priv_dev->regs->tdl_from_trb, mask);
-	}
-
-	/*  Enable Stream Bit TDL chk and SID chk */
-	cdns3_set_register_bit(&priv_dev->regs->ep_cfg, EP_CFG_STREAM_EN |
-			       EP_CFG_TDL_CHK | EP_CFG_SID_CHK);
-}
-
 static void cdns3_configure_dmult(struct cdns3_device *priv_dev,
 				  struct cdns3_endpoint *priv_ep)
 {
@@ -1965,8 +1950,9 @@ static void cdns3_configure_dmult(struct
 /**
  * cdns3_ep_config Configure hardware endpoint
  * @priv_ep: extended endpoint object
+ * @enable: set EP_CFG_ENABLE bit in ep_cfg register.
  */
-void cdns3_ep_config(struct cdns3_endpoint *priv_ep)
+int cdns3_ep_config(struct cdns3_endpoint *priv_ep, bool enable)
 {
 	bool is_iso_ep = (priv_ep->type == USB_ENDPOINT_XFER_ISOC);
 	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
@@ -2027,7 +2013,7 @@ void cdns3_ep_config(struct cdns3_endpoi
 		break;
 	default:
 		/* all other speed are not supported */
-		return;
+		return -EINVAL;
 	}
 
 	if (max_packet_size == 1024)
@@ -2037,11 +2023,33 @@ void cdns3_ep_config(struct cdns3_endpoi
 	else
 		priv_ep->trb_burst_size = 16;
 
-	ret = cdns3_ep_onchip_buffer_reserve(priv_dev, buffering + 1,
-					     !!priv_ep->dir);
-	if (ret) {
-		dev_err(priv_dev->dev, "onchip mem is full, ep is invalid\n");
-		return;
+	/* onchip buffer is only allocated before configuration */
+	if (!priv_dev->hw_configured_flag) {
+		ret = cdns3_ep_onchip_buffer_reserve(priv_dev, buffering + 1,
+						     !!priv_ep->dir);
+		if (ret) {
+			dev_err(priv_dev->dev, "onchip mem is full, ep is invalid\n");
+			return ret;
+		}
+	}
+
+	if (enable)
+		ep_cfg |= EP_CFG_ENABLE;
+
+	if (priv_ep->use_streams && priv_dev->gadget.speed >= USB_SPEED_SUPER) {
+		if (priv_dev->dev_ver >= DEV_VER_V3) {
+			u32 mask = BIT(priv_ep->num + (priv_ep->dir ? 16 : 0));
+
+			/*
+			 * Stream capable endpoints are handled by using ep_tdl
+			 * register. Other endpoints use TDL from TRB feature.
+			 */
+			cdns3_clear_register_bit(&priv_dev->regs->tdl_from_trb,
+						 mask);
+		}
+
+		/*  Enable Stream Bit TDL chk and SID chk */
+		ep_cfg |=  EP_CFG_STREAM_EN | EP_CFG_TDL_CHK | EP_CFG_SID_CHK;
 	}
 
 	ep_cfg |= EP_CFG_MAXPKTSIZE(max_packet_size) |
@@ -2051,9 +2059,12 @@ void cdns3_ep_config(struct cdns3_endpoi
 
 	cdns3_select_ep(priv_dev, bEndpointAddress);
 	writel(ep_cfg, &priv_dev->regs->ep_cfg);
+	priv_ep->flags |= EP_CONFIGURED;
 
 	dev_dbg(priv_dev->dev, "Configure %s: with val %08x\n",
 		priv_ep->name, ep_cfg);
+
+	return 0;
 }
 
 /* Find correct direction for HW endpoint according to description */
@@ -2194,7 +2205,7 @@ static int cdns3_gadget_ep_enable(struct
 	u32 bEndpointAddress;
 	unsigned long flags;
 	int enable = 1;
-	int ret;
+	int ret = 0;
 	int val;
 
 	priv_ep = ep_to_cdns3_ep(ep);
@@ -2233,6 +2244,17 @@ static int cdns3_gadget_ep_enable(struct
 	bEndpointAddress = priv_ep->num | priv_ep->dir;
 	cdns3_select_ep(priv_dev, bEndpointAddress);
 
+	/*
+	 * For some versions of controller at some point during ISO OUT traffic
+	 * DMA reads Transfer Ring for the EP which has never got doorbell.
+	 * This issue was detected only on simulation, but to avoid this issue
+	 * driver add protection against it. To fix it driver enable ISO OUT
+	 * endpoint before setting DRBL. This special treatment of ISO OUT
+	 * endpoints are recommended by controller specification.
+	 */
+	if (priv_ep->type == USB_ENDPOINT_XFER_ISOC  && !priv_ep->dir)
+		enable = 0;
+
 	if (usb_ss_max_streams(comp_desc) && usb_endpoint_xfer_bulk(desc)) {
 		/*
 		 * Enable stream support (SS mode) related interrupts
@@ -2243,13 +2265,17 @@ static int cdns3_gadget_ep_enable(struct
 				EP_STS_EN_SIDERREN | EP_STS_EN_MD_EXITEN |
 				EP_STS_EN_STREAMREN;
 			priv_ep->use_streams = true;
-			cdns3_stream_ep_reconfig(priv_dev, priv_ep);
+			ret = cdns3_ep_config(priv_ep, enable);
 			priv_dev->using_streams |= true;
 		}
+	} else {
+		ret = cdns3_ep_config(priv_ep, enable);
 	}
 
-	ret = cdns3_allocate_trb_pool(priv_ep);
+	if (ret)
+		goto exit;
 
+	ret = cdns3_allocate_trb_pool(priv_ep);
 	if (ret)
 		goto exit;
 
@@ -2279,20 +2305,6 @@ static int cdns3_gadget_ep_enable(struct
 
 	writel(reg, &priv_dev->regs->ep_sts_en);
 
-	/*
-	 * For some versions of controller at some point during ISO OUT traffic
-	 * DMA reads Transfer Ring for the EP which has never got doorbell.
-	 * This issue was detected only on simulation, but to avoid this issue
-	 * driver add protection against it. To fix it driver enable ISO OUT
-	 * endpoint before setting DRBL. This special treatment of ISO OUT
-	 * endpoints are recommended by controller specification.
-	 */
-	if (priv_ep->type == USB_ENDPOINT_XFER_ISOC  && !priv_ep->dir)
-		enable = 0;
-
-	if (enable)
-		cdns3_set_register_bit(&priv_dev->regs->ep_cfg, EP_CFG_ENABLE);
-
 	ep->desc = desc;
 	priv_ep->flags &= ~(EP_PENDING_REQUEST | EP_STALLED | EP_STALL_PENDING |
 			    EP_QUIRK_ISO_OUT_EN | EP_QUIRK_EXTRA_BUF_EN);
--- a/drivers/usb/cdns3/gadget.h
+++ b/drivers/usb/cdns3/gadget.h
@@ -1154,6 +1154,7 @@ struct cdns3_endpoint {
 #define EP_QUIRK_EXTRA_BUF_DET	BIT(12)
 #define EP_QUIRK_EXTRA_BUF_EN	BIT(13)
 #define EP_TDLCHK_EN		BIT(15)
+#define EP_CONFIGURED		BIT(16)
 	u32			flags;
 
 	struct cdns3_request	*descmis_req;
@@ -1351,7 +1352,7 @@ void cdns3_gadget_giveback(struct cdns3_
 int cdns3_init_ep0(struct cdns3_device *priv_dev,
 		   struct cdns3_endpoint *priv_ep);
 void cdns3_ep0_config(struct cdns3_device *priv_dev);
-void cdns3_ep_config(struct cdns3_endpoint *priv_ep);
+int cdns3_ep_config(struct cdns3_endpoint *priv_ep, bool enable);
 void cdns3_check_ep0_interrupt_proceed(struct cdns3_device *priv_dev, int dir);
 int __cdns3_gadget_wakeup(struct cdns3_device *priv_dev);
 


