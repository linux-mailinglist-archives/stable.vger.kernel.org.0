Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA7E2902A7
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 12:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406590AbgJPKRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 06:17:54 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:41057
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406611AbgJPKRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 06:17:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0yOf7rT32vseJxMSm4OyoHXaiMeJ/cyma67x/Lf7rGh23cpSC5H0nyqHUpBtb07yDPg4CkMDSLKhLZaW+bN19fPcVQDwy0sFi1ZWNMkMtLeOgWz9kyXWQ11IXGTuvVvewVjOp2dv3EBVaMuQXHUR6katC7LU9a9LaH1Zr7kkG6CH9RS+/s7RFhIdgTef1t54LPOaE0+dJmgBTPwp3H+UP0OCjkgkb9dWaA6zWpFJRUJU7IVTZMkNzgfqY3uBK+5sA1+gPQFQRY67hSrYahfrOuArKYPlScTuAEYK2stGeDBqFLmjenDsIhmKCMBmLZG449jTD6UR0M4SLmui+1bXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7jw1WtSqSMTgy2HuuCOupLyr3VSewHShIyu+3hs1qI=;
 b=dc0cdDQz6FC4H+jltzjM4v0WsLonrTIGHyApn0ZeCRQR1W3jH1SS8sJuvOigNoPB10tEy7bov3ut7blF7awgEpHVbc1GvdgOKKR4QGmZxZC08zHINKrhopTRQLAzBTJDvwaPpCCiQC5MKwbuVS09m2eJMfGJ0Nyh5Yvxpc42F4k5jSNu4gLyNqqEYPx34TCZzRlPolcvrIEqYtb93RChRLDLPIVKGAcEyw86eZmmfAOPbmQLfx+KfPZvm54HaaUnxoqYL9frrKvqDexpHLB8hJmDQL26cWKrGOsFdl+6OTGEBTjS2L0GpdYOvU73Pu2UONih7yZevoPhNzQWm8nhmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7jw1WtSqSMTgy2HuuCOupLyr3VSewHShIyu+3hs1qI=;
 b=ohHxpW+oO5CubMGDI1i20MjG2f2B6TRth3A6zB7Q7RMkgh1E6Nv5yw2HdLvzi9oaGiPYT9v0PEMdRWJjd5ENLpwlxq8mkjtTTLi/pgi1UVEz0savQrMJxqJ30r9E9OWKREAVVS+4jfH0EB/0G3hJr2/dFjXBdjh3siLW22LovBM=
Authentication-Results: cadence.com; dkim=none (message not signed)
 header.d=none;cadence.com; dmarc=none action=none header.from=nxp.com;
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12)
 by AM0PR04MB4002.eurprd04.prod.outlook.com (2603:10a6:208:5c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Fri, 16 Oct
 2020 10:17:45 +0000
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::ad01:9b1c:3b4b:3a77]) by AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::ad01:9b1c:3b4b:3a77%7]) with mapi id 15.20.3455.032; Fri, 16 Oct 2020
 10:17:45 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     pawell@cadence.com, rogerq@ti.com
Cc:     balbi@kernel.org, linux-usb@vger.kernel.org, linux-imx@nxp.com,
        gregkh@linuxfoundation.org, jun.li@nxp.com, stable@vger.kernel.org,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 3/3] usb: cdns3: Fix on-chip memory overflow issue
Date:   Fri, 16 Oct 2020 18:16:59 +0800
Message-Id: <20201016101659.29482-4-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201016101659.29482-1-peter.chen@nxp.com>
References: <20201016101659.29482-1-peter.chen@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.66]
X-ClientProxiedBy: SGAP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::19)
 To AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.66) by SGAP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Fri, 16 Oct 2020 10:17:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aeca6c44-f55e-4ae4-947a-08d871bcb952
X-MS-TrafficTypeDiagnostic: AM0PR04MB4002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB400247B5D45AEF2FBA1D0B458B030@AM0PR04MB4002.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsaK1Vt8kLBfiRPaGKUVZJ8PpaRD7LTX/GUJZa44PlnDiheStkIO9rT+xeMbALDnhBS3zsJNgR2lFMa4xF+EBD9DolqU3Pe1ktlc6dEtXu8yApBaIPI4fBHrLvzN3DvRPxmZCSPivReUI0ua4Nt48ExJ/FNuTyZFg95rl0wttfnlyV2WP3m/VEocv7w3aWBzHAXWQuYOexnCgzCxhXMc8STpGY5lYTnSFbr4o4b8+V/OTRUMRPl232ijbUM23MEfjr2RHHV36Vv6i+S2PY4Tk7H3kn3t2HDaajCIMPigp+cuaZbNJHuduDQNFbQ9Utb0+916tNghR39Vj3kWOWkSuZkXO8ih2LllXCmWg1yyOOprr4Y9K15OhrYNQgkjivB4flVciVfEsrI3AhU0ts+RN5IsrUQQSUTKIXhCtLey/yo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7300.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(1076003)(316002)(5660300002)(44832011)(34490700002)(186003)(6486002)(30864003)(26005)(478600001)(52116002)(36756003)(4326008)(2906002)(6512007)(956004)(2616005)(66946007)(8936002)(66556008)(66476007)(6666004)(16526019)(83380400001)(6506007)(86362001)(8676002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RFqDAtfDA3UR4+F1v3e/Zxa5trCiHrkCw7XRcHHFs2sIPKTjIiuBBXJaHauSzEajBQUr+dGm2bARZKqeW+8jOPTyClnrdGwDsNt+F1bB0N2YG1yPDTbq5EChOsmBAd+xyw6wXbcl5AXY7bRLMXEwpdoLGOBOg6gIp2xAYIcJldspD18LlbZPiRS+yUSl0lQQkZsxdVZ0FKkFw5eyphy2xCzYHnADQX4ag0xxPHRMF2PkYiCB7eXBZ5l9bUZFlHXEf7ohu15gwC+QAzXuwaFGyy9Uux7ROlJIFa67mQQZgwLhjqP/6ZAnwV0W+N11SO2Pj7owQ68y4JBOGHI0uJk2PMk/ZfVT+NoziaEn/W96aD3XaLbSuWTaa8AQH4hbb46Qx092kHWhTIRnfd19mwxsNMZc4UqwZuxT3ZD08PWaA4k9t5ScE0m2EJVUF9BstIr44f49/A0Q3k3vIrJulOh5Xnx9C+Us3r0AocayTU/eNjEzImLtW/R6iK+KpwwlN5g+hA6lpSUkGs7bpaML6L75QFZto9FybSzuEyx/4z8BiETuf6SXf1mAYyQD2IKxm7VyGN55Ayv5uPLlmkRlslEWnvp0/dKIydmUepNB4z6iHhmDcN5e415qKWUXx+IK3vvB+5aTZ9PTQ4em7akufGmD8w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeca6c44-f55e-4ae4-947a-08d871bcb952
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7300.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 10:17:45.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shqy9uM0Du24WFDk6LDx3vslBvDzz1HkR99ePZW078UeiIKD+BF4n3/GOsQN7HUa/lhBa7SWnM0Q1ljXRintXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4002
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
index 020936cb9897..5df153ca4389 100644
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

