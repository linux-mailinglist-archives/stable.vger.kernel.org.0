Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B072183C5
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 11:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgGHJbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 05:31:18 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:1152
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728339AbgGHJaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 05:30:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IH4DVohHOMxDPOiGxP4mi43aQ6CrAuE0wLWQjSCm3rjk9px3BEUSipYPNc2Gp+9gtLu8lmBvK1Qjtm8gFkWUXApGH+Z9pNTiWpnS3u35mfrKivifkth20ajn7Tog4JqAF0hTT3k0J3wnUP6E8qkjhuK7bQk/3BPhNfTSX/QqcIrC+GPgKkNYSHnKKB2QK86yrJKMQ4NOGNHbdPhpZG/fYevQ6Nfr5ukkPwSJo4FH00TN1QwmJmnE7R+HsYl1gcyBb9Yt3pIrMJH8RW9W/mJMaI2q5Vda1Hp5OX0NX7LCwASnhQdMW1M+d9cr2+1fOu0mXgKJr2bF0Gq6rGS497BNvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJi9its5ZdzQmv+CJ0aLD37lq5eyalSOlgkHj7Ckkb8=;
 b=QnmoE7yrd2v4mlbNnbCV2QhYHsmcqaIORJ76BqcEtgIZJTTEJC2ixEQeNbNSKxipiu/R/U22Dx9Yq3OXQNj771YMrVRMTnuJ9rQb4G9RVezR+NwefF5xjhNwdXoD3Is+wuUVOa51epy/xYCqvacyEuNgcfbiESh7pDV18kjwgVOG7bvB3bPs1h82KwjwB3QNX6DMxrsLWycgTXQsKQjKuLJkJJf8oVentqRtci42jT/GtJs7oVmAqswVkPsmzaCkzbWUYGvnZ5XZCmWwkhjqnJWhqofpBAgz/xeaOiVG1XQI2T7l48CsiEsxf+YbuvVb5JEM7ftXHtMekRBjRHgJbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJi9its5ZdzQmv+CJ0aLD37lq5eyalSOlgkHj7Ckkb8=;
 b=M45bDR6hvO6m0//UNYGuw2VVgSisWEvDSz+P33uftwhtIfIrQd9DbpEwfvdAl4ZZv6ipX5DVkuFSQNw39MHifwpC9zZsWi+Z9ovwPCbO4F8ZnnA6FqoObnOlzSYCeGtHBQlGiDIoyHmPHWGWf1dwoN7fET21CUIsyEWYa59eQmg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM6PR04MB4422.eurprd04.prod.outlook.com (2603:10a6:20b:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Wed, 8 Jul
 2020 09:30:49 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 09:30:49 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, jun.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/1] usb: cdns3: gadget: own the lock wrongly at the suspend routine
Date:   Wed,  8 Jul 2020 17:30:43 +0800
Message-Id: <20200708093043.25756-1-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0118.apcprd02.prod.outlook.com
 (2603:1096:4:92::34) To AM7PR04MB7157.eurprd04.prod.outlook.com
 (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.67) by SG2PR02CA0118.apcprd02.prod.outlook.com (2603:1096:4:92::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 09:30:45 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c375608-cf9f-433a-234b-08d82321996e
X-MS-TrafficTypeDiagnostic: AM6PR04MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB44225B03F7CC7496BFAC91108B670@AM6PR04MB4422.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P40qX5BOe6vxlc3StRbnhNlO1JJDisMgZx1wYl4O9aIqwftBe7LStGFI+3Cl+xCia1JmQovMoxAxaXR29IW/d2RFMC74kd09F5lGeMaHXX3gJbB+21CNLpntwxbn2+LuDrRFQzz4T+Sd/+M2f5qY8Q4zFfjxq2F1HQ3MHanc5+lzqoT5g23GKbC16bwMwaXL4dVi+xfY0QSY1yvAPEaloFDlbTwjWuZjpWvNMWoAjFAo/bj6WA/cGwW3Njzrl8mEcvMb0xbUkWZsz/c6p5ihK3arj2QeWHyRo68cggz8712M+RisA9faLkqsWq+Y+kKqHxViX7UejC4RUwBLC9PrPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(54906003)(6512007)(44832011)(6486002)(83380400001)(2906002)(8676002)(4326008)(52116002)(6506007)(26005)(36756003)(2616005)(316002)(956004)(1076003)(8936002)(16526019)(186003)(5660300002)(478600001)(66476007)(86362001)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lET5akunGJc5REWWnfJJnhp360mL1ZzUaCxxuJ/GCk576MCKVFoCIhUqxJ+qHwmVjjiOjRD2OKt8IDrr7aviRQDYx630IyH0zbuZWsLAIeWLcliMaWCrWyFRLd+9EFoIHFA+LpHAhKZO5dIW8BvB07bxQBknAI/v0G/vzyVMN5Cx1br3cqIfjJS36ISo8JaQGtWvGduWZI3KFCOf2zzQ9lXuDDXZSwx9gMbC9imN5QXoLZWiRsleGdVSjB8UR+O4Erx2r9/VN65oEZm5wzEVdEU3oi+iWIyInt3TFhlNOa4GMmHM6Ag/NA8mTy0mA0xxioV/7GSFaryHAp7bzCJTNzB7BLc8wMRTrkb+d6wTFGz9E0QAX03BGRQHCYuDyIwESbL1ZOGjosfuYFoD3Npufb8jBgB/w40P+nKW5hm3CF4Gc2GqgpAt6OneaBsZCOf6rVKgAOwDRqOWvsNBz7uLYJNHAgIGxikekr7hvMH/gn8=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c375608-cf9f-433a-234b-08d82321996e
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7157.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 09:30:48.9941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2iw5I6ZrFoLOm3ikiFrV5cLk/53XInOxBN0a0v7wxRimBNYbKvDC10uEfE/UwFToWI38E3Sgt7gRkjNOR3KPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4422
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When it is device mode with cable connected to host, the call
stack is: cdns3_suspend->cdns3_gadget_suspend->cdns3_disconnect_gadget,
the cdns3_disconnect_gadget owns lock wrongly at this situation,
it causes the system being deadlock after resume due to at
cdns3_device_thread_irq_handler, it tries to get the lock, but will
never get it.

To fix it, we delete the lock operations, and add them at the caller
when necessary.

Cc: stable <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/gadget.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 13027ce6bed8..f6c51cc924a8 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1674,11 +1674,8 @@ static int cdns3_check_ep_interrupt_proceed(struct cdns3_endpoint *priv_ep)
 
 static void cdns3_disconnect_gadget(struct cdns3_device *priv_dev)
 {
-	if (priv_dev->gadget_driver && priv_dev->gadget_driver->disconnect) {
-		spin_unlock(&priv_dev->lock);
+	if (priv_dev->gadget_driver && priv_dev->gadget_driver->disconnect)
 		priv_dev->gadget_driver->disconnect(&priv_dev->gadget);
-		spin_lock(&priv_dev->lock);
-	}
 }
 
 /**
@@ -1713,8 +1710,10 @@ static void cdns3_check_usb_interrupt_proceed(struct cdns3_device *priv_dev,
 
 	/* Disconnection detected */
 	if (usb_ists & (USB_ISTS_DIS2I | USB_ISTS_DISI)) {
+		spin_unlock(&priv_dev->lock);
 		cdns3_disconnect_gadget(priv_dev);
 		priv_dev->gadget.speed = USB_SPEED_UNKNOWN;
+		spin_lock(&priv_dev->lock);
 		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_NOTATTACHED);
 		cdns3_hw_reset_eps_config(priv_dev);
 	}
-- 
2.17.1

