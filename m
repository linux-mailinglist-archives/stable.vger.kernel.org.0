Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3082955DC
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 02:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894507AbgJVAz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 20:55:59 -0400
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:31714
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2894510AbgJVAz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Oct 2020 20:55:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZingxS/fFxk8Cl9esuCjvKaOQxhmXVsFkEljiaScL8MZmeHtIuPEtcB7Le6X2rlJy+UCMZLTb7eKwGGadcuxZSpgOcbkQevberT6H3S7jD8vvePsk1cMGJl8x0AM6FzB2BEvW71p3MQx3BPWqeK1LFOf1oHIJV6kDE0dKHMeg+2jV35JO/mBY3mHMFwwGit8f2c1kVzdWTLNGmT43MSeTZTHedwUOpRKaKzg8jWW+de9CB8BFcxHmaTV/n8AcJ8oPt1Rr24i58+rHOWCqRQX/hcrPkBCb9UcL/yH6d0hGsxbOlPK5u+0Io61DAhw5hIZj5OQtMjAtCR+4Xf6JOh/nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lX9ZZ4IEdt4fZ9XOACd8KSDjN7SVTNVMi4IXdX/jFaw=;
 b=C/LCprsQjntMxyRIRLrVK+S2401sUaZGRMCH45F5B9Qps1WraOg2O0IOg9Z44nEGLHsiR3Atwa3xL9EpCataPyxWEhEfGw1gtcboMeuvb0GVXlagF7QlDqAnoNMIxUGALQvAazFvQfovKO6pI+svkGna+tNdIC1z4UFIwSVc5ceMKTwwvufhI7/AQslp3TKChWOy3n7CdkAYW0nEmplfG21v7iOfBCKn2leFK8KHZuGcF2RqilHUrpaHzo9oYIC/h/Z4LbzXU6AySv/tlf5vICAN41bn8Qbvr+ozoIGQU3/JjIOp5N18I4jdgPQu4i6mNaQlEdasKhAUx2KcaVwoOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lX9ZZ4IEdt4fZ9XOACd8KSDjN7SVTNVMi4IXdX/jFaw=;
 b=LLU8mmkluuIzg+KHYuSgogAGMGEn82FApzeVpQSgELTQpbpsskSYmVM0DI+/l9ZtwjIKdCIk8of3qX5nDxBUZIDdg6LIXU8l++AIbLzTGlS//whvjbs7Mh4NK1J0xwaK9Zv//eU58CtOXisokqpYGDOZvKOS0L5EFaMI2OpdOwk=
Authentication-Results: cadence.com; dkim=none (message not signed)
 header.d=none;cadence.com; dmarc=none action=none header.from=nxp.com;
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12)
 by AM0PR04MB4355.eurprd04.prod.outlook.com (2603:10a6:208:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 00:55:54 +0000
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::b902:6be0:622b:26c2]) by AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::b902:6be0:622b:26c2%4]) with mapi id 15.20.3477.028; Thu, 22 Oct 2020
 00:55:54 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     pawell@cadence.com, rogerq@ti.com
Cc:     balbi@kernel.org, linux-usb@vger.kernel.org, linux-imx@nxp.com,
        gregkh@linuxfoundation.org, jun.li@nxp.com, stable@vger.kernel.org,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH v2 3/3] usb: cdns3: Fix on-chip memory overflow issue
Date:   Thu, 22 Oct 2020 08:55:05 +0800
Message-Id: <20201022005505.24167-4-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201022005505.24167-1-peter.chen@nxp.com>
References: <20201022005505.24167-1-peter.chen@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.66]
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To AM8PR04MB7300.eurprd04.prod.outlook.com
 (2603:10a6:20b:1c7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.66) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Thu, 22 Oct 2020 00:55:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64dfddb1-0e13-494e-b5cc-08d876253a48
X-MS-TrafficTypeDiagnostic: AM0PR04MB4355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB43557A7D27ECE34DC13D71F88B1D0@AM0PR04MB4355.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m/c7AbccxjMCwPPxZEX1VEl5rRuvSmCy+Nxwv4psSL96G1t5hqKVddOH2SLxLFNDl9j1YOiyQaYktLiWteKf9amqJ63eveHbtvGunb/f0n8AzoSofiOq+3w93NLsFr80Cb6ch3Y6AQpMX4wfjP1TZjwRUJXJyK3536ws2+lke/T47XD6xzYD6EC5YNxfDG0arXdzqPI3LUzBICxgKRY2qIN870Y8CpeQHCNKaWr/Xm0FdvNnJN24vxb+zXg/Y+p9GH95XLIIt87ZR5uC+VTlS985TdshbuRD4+8alpf5sPlPBgyMHwP5eb/2UTKtv0XEZlPDO703KBQmklnZxdy1GI6N+/N2RdkVnOZr4zxivs5XkPUTARwIADg9uEYCD/yW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7300.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(86362001)(956004)(8936002)(6486002)(2906002)(30864003)(66946007)(6666004)(66476007)(66556008)(5660300002)(1076003)(36756003)(316002)(6512007)(44832011)(2616005)(16526019)(26005)(478600001)(8676002)(52116002)(83380400001)(186003)(6506007)(4326008)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EhtPfcCScr65Idsq2OT/ZpbpjD1KiZGLFJFb0SGkZQ4txJ2S9vlLXvoKCzLbFde0Pj9k176ndczJOkBC/mx6zC3E4ETt2cb2aewnvbbfNjoT1yHEW+p0jm9gXd+IbrFbNHXJFJnY7JXgobFfbz0aDlzhQiaKjNIkeIaecu6Bgq5cssXsyXy/XAFSYHUhAY0wfKrCY9Lwh41qItxvaDO6g/TpmANb5S7RC3/Jwd5BvxEsW3FoGZk3x8xXBg96wf4zAya9uHrNQKd3foOzrhhIg5HyiLAqm7dRVay+aeOO0iyrsl4ak6A8cqlcGsIgH4yYCuymzL7N1iyeXTSmFD01RAOdjMCTSzG/FDmL/2By8hV7U4XV1VHh21pqJBhugeYJjvMaOxshgBy/2/BqdN+T7MGUQhskuyBS/ZMbQWpACOyGN9ig+Shsoj8x+gu5nghqL/cONz5IR6JN0ARP+a0qVjeDakowQMK0Mz7rdoroz/PJMQPS6UnzKkH4zK5Lw773ABvLlqpa++h7zFOE8HtowM81qPbIhvtxx5wUuTAJleROWCmAgRN6ZKkhKvJ5D+9jiEylwvaVX59qtv7+RlwHStUIoAuyjUXoN9YZAmHFeT3MmmZ9ZGkVNzUV2VlxPzP3gDUeNfJUGd4wcJ0T81/StQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64dfddb1-0e13-494e-b5cc-08d876253a48
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7300.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2020 00:55:53.9254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1t8wnMpJVZkLaK+g1/nJJAw1rLVETT0KRIY5siqSYN1WmrLkCZDN+wPRlq9mkTTs9Bo8dW7SMfSNBB9WXbpdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4355
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

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

Cc: <stable@vger.kernel.org> #v5.8+
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reported-and-tested-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/ep0.c    |  65 ++++++++++++-----------
 drivers/usb/cdns3/gadget.c | 102 +++++++++++++++++++++----------------
 drivers/usb/cdns3/gadget.h |   3 +-
 3 files changed, 94 insertions(+), 76 deletions(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index 4761c852d9c4..d3121a32cc68 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -137,48 +137,36 @@ static int cdns3_req_ep0_set_configuration(struct cdns3_device *priv_dev,
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
 
@@ -705,6 +693,7 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 	unsigned long flags;
 	int ret = 0;
 	u8 zlp = 0;
+	int i;
 
 	spin_lock_irqsave(&priv_dev->lock, flags);
 	trace_cdns3_ep0_queue(priv_dev, request);
@@ -720,6 +709,17 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 		u32 val;
 
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
 		/* wait until configuration set */
@@ -811,6 +811,7 @@ void cdns3_ep0_config(struct cdns3_device *priv_dev)
 	struct cdns3_usb_regs __iomem *regs;
 	struct cdns3_endpoint *priv_ep;
 	u32 max_packet_size = 64;
+	u32 ep_cfg;
 
 	regs = priv_dev->regs;
 
@@ -842,8 +843,10 @@ void cdns3_ep0_config(struct cdns3_device *priv_dev)
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
@@ -851,8 +854,10 @@ void cdns3_ep0_config(struct cdns3_device *priv_dev)
 	/* init ep in */
 	cdns3_select_ep(priv_dev, USB_DIR_IN);
 
-	writel(EP_CFG_ENABLE | EP_CFG_MAXPKTSIZE(max_packet_size),
-	       &regs->ep_cfg);
+	if (!(priv_ep->flags & EP_CONFIGURED))
+		writel(ep_cfg, &regs->ep_cfg);
+
+	priv_ep->flags |= EP_CONFIGURED;
 
 	writel(EP_STS_EN_SETUPEN | EP_STS_EN_TRBERREN, &regs->ep_sts_en);
 
diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index c127af6c0fe8..5fa89baa53da 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -296,6 +296,8 @@ static void cdns3_ep_stall_flush(struct cdns3_endpoint *priv_ep)
  */
 void cdns3_hw_reset_eps_config(struct cdns3_device *priv_dev)
 {
+	int i;
+
 	writel(USB_CONF_CFGRST, &priv_dev->regs->usb_conf);
 
 	cdns3_allow_enable_l1(priv_dev, 0);
@@ -304,6 +306,10 @@ void cdns3_hw_reset_eps_config(struct cdns3_device *priv_dev)
 	priv_dev->out_mem_is_allocated = 0;
 	priv_dev->wait_for_setup = 0;
 	priv_dev->using_streams = 0;
+
+	for (i = 0; i < CDNS3_ENDPOINTS_MAX_COUNT; i++)
+		if (priv_dev->eps[i])
+			priv_dev->eps[i]->flags &= ~EP_CONFIGURED;
 }
 
 /**
@@ -1976,27 +1982,6 @@ static int cdns3_ep_onchip_buffer_reserve(struct cdns3_device *priv_dev,
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
@@ -2034,8 +2019,9 @@ static void cdns3_configure_dmult(struct cdns3_device *priv_dev,
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
@@ -2096,7 +2082,7 @@ void cdns3_ep_config(struct cdns3_endpoint *priv_ep)
 		break;
 	default:
 		/* all other speed are not supported */
-		return;
+		return -EINVAL;
 	}
 
 	if (max_packet_size == 1024)
@@ -2106,11 +2092,33 @@ void cdns3_ep_config(struct cdns3_endpoint *priv_ep)
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
@@ -2120,9 +2128,12 @@ void cdns3_ep_config(struct cdns3_endpoint *priv_ep)
 
 	cdns3_select_ep(priv_dev, bEndpointAddress);
 	writel(ep_cfg, &priv_dev->regs->ep_cfg);
+	priv_ep->flags |= EP_CONFIGURED;
 
 	dev_dbg(priv_dev->dev, "Configure %s: with val %08x\n",
 		priv_ep->name, ep_cfg);
+
+	return 0;
 }
 
 /* Find correct direction for HW endpoint according to description */
@@ -2263,7 +2274,7 @@ static int cdns3_gadget_ep_enable(struct usb_ep *ep,
 	u32 bEndpointAddress;
 	unsigned long flags;
 	int enable = 1;
-	int ret;
+	int ret = 0;
 	int val;
 
 	priv_ep = ep_to_cdns3_ep(ep);
@@ -2302,6 +2313,17 @@ static int cdns3_gadget_ep_enable(struct usb_ep *ep,
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
@@ -2312,13 +2334,17 @@ static int cdns3_gadget_ep_enable(struct usb_ep *ep,
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
 
@@ -2348,20 +2374,6 @@ static int cdns3_gadget_ep_enable(struct usb_ep *ep,
 
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
diff --git a/drivers/usb/cdns3/gadget.h b/drivers/usb/cdns3/gadget.h
index 737377913788..21fa461c518e 100644
--- a/drivers/usb/cdns3/gadget.h
+++ b/drivers/usb/cdns3/gadget.h
@@ -1159,6 +1159,7 @@ struct cdns3_endpoint {
 #define EP_QUIRK_EXTRA_BUF_DET	BIT(12)
 #define EP_QUIRK_EXTRA_BUF_EN	BIT(13)
 #define EP_TDLCHK_EN		BIT(15)
+#define EP_CONFIGURED		BIT(16)
 	u32			flags;
 
 	struct cdns3_request	*descmis_req;
@@ -1360,7 +1361,7 @@ void cdns3_gadget_giveback(struct cdns3_endpoint *priv_ep,
 int cdns3_init_ep0(struct cdns3_device *priv_dev,
 		   struct cdns3_endpoint *priv_ep);
 void cdns3_ep0_config(struct cdns3_device *priv_dev);
-void cdns3_ep_config(struct cdns3_endpoint *priv_ep);
+int cdns3_ep_config(struct cdns3_endpoint *priv_ep, bool enable);
 void cdns3_check_ep0_interrupt_proceed(struct cdns3_device *priv_dev, int dir);
 int __cdns3_gadget_wakeup(struct cdns3_device *priv_dev);
 
-- 
2.17.1

