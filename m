Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC42047D0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 05:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgFWDJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 23:09:20 -0400
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:13838
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731364AbgFWDJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 23:09:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tc5FRY/rbDLWDQ/VQIyDERkniR/krDN7Bq9K8BuEkooPysAl3SUx5HZtOSSDAV1ZOXzhkI5t0FPT4fj18AAqWxqXIwMTlOWqOHyWO2OoKleF+ypz9kAJvRX+inXf8+9984DZ2pipZgJDK1rUoWL9La6mMlXsX/v+BYy1tR3TGdG1T7OBb5+3XtGDDPPhUGvBVrtF4OgnJCX1hL3tmrMtILu01tieLnC5VlYF3H6nZqBd9ch0nohg+4E+mI+ZFP6AogMX4K6D7g0ZfYMpfJf+DhdKX3D7ltCwXH9NhqtujfaUR6NSTd41Edp/TIHzwpv31Eqlswg5G5DnNQ/7kpWpEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1olVLb9tc/M/8WugwDTzKk2Qh7q5Vzt7ZA7YAyCoJ80=;
 b=Bh50D2ulxLRGjBiAr/C9teRkv8cCb7p4lcbeHADHPFYR7QvZKAlDnLwOayEhAO04BZgks9mP3j8/ak6CGgiL90I9/2oZlM2kzZSaSd3c6oDxYw1R7d8V66FGzhgfs1feQXAhzSXk/QTfUyD8mQ75/C1nNiWqXFr+FUORxfJv1DTdk3HvBSPaOB1lIxUwhfqPob3YOZ3iHWq/6n4dAzGjxbAHkcRhTIciDQjJgGc39ApJ2yH3l5SbO88m8Upcf0Fo9noc3pJXJVFm/YWXgpkJdejZSkq9sTqh0lCNOrBLKXLXXblChqhIYodjmN9h85EE0rDZnl0yKrz3ZQnV3llRwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1olVLb9tc/M/8WugwDTzKk2Qh7q5Vzt7ZA7YAyCoJ80=;
 b=mOUHEqNImdpkGXAMEBqGqT2v1l1fp/PoKc8Gx9JhCq9JRNK4hgG1+vDUQC8ZjJ3ROYV40fhV0vQTG0xiQATtNJtEeOFroFtfLBalqJKue6Nu2UWVUBY50n5ttu0gS4eNZiQBQbNFg7rz3lzKAlE4CAUEA7PsNL6nmKQsRNpgWbE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB6854.eurprd04.prod.outlook.com (2603:10a6:20b:10c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 03:09:16 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 03:09:16 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, jun.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] usb: cdns3: ep0: add spinlock for cdns3_check_new_setup
Date:   Tue, 23 Jun 2020 11:09:18 +0800
Message-Id: <20200623030918.8409-4-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623030918.8409-1-peter.chen@nxp.com>
References: <20200623030918.8409-1-peter.chen@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.67) by SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 23 Jun 2020 03:09:13 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cdd5e6a4-42ce-42cc-1b66-08d81722cff2
X-MS-TrafficTypeDiagnostic: AM7PR04MB6854:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB685403A1BB05419BDA51F8288B940@AM7PR04MB6854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jXdq1QcjLr/bZ2Z3NAwyBoQIec+DqAx6jmc8ZRjVRgsRlE1UiTT/YmubpOgU/2AeNaTOtGxlJHXM/oQ1w30ZkVZepgrtOUWdyovuB+qXnnHuaNJ/ugTOVUU6pbXoGRYshRbgvKx12mp2GqgO3/oj0qUt8BOVvVmeBNTzB9dzotZoGvAy2hMdlfPZXRDJo6WjZonURoMN8k3V+/t+ifFFU+PCUhf3mHaKiUBrFz9Uva8LhJFdaQ+EtzUnp2lMN5H9B6IzbUHBQ2wkP0tqLM/iRkuBQ/PlG6jNScg2iP14y4sToUvRwwBXMZSmMCBNLJT57QKWvqXfo9I0Aow24NsWDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(86362001)(6512007)(1076003)(316002)(2906002)(66476007)(66556008)(66946007)(6486002)(44832011)(956004)(5660300002)(2616005)(478600001)(26005)(16526019)(186003)(6506007)(8936002)(8676002)(52116002)(4326008)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fu0WE8gV9ZQ5rLk0B7iQrLrZ3kBFAukHb5fpc4PdBa60gthgNxzvUFF4fYU8GLeMAhwIsXyGOta1CGc0dPQT6CHyyj6e5vDFpAZ1PlfxlWVAtkpmCewCTNtFYIJdF9WkZYZ7lg2KGYp87k++3mOziWGgTeP00EGJ43QmotUlFJZyQFy4OTyhy7S+2czGw05CCCdp0HiZu0CQacFqo4MmYMyLAIFgwWJCzs3OLgX/lJ7oEd8or9PFuulGJ3ZteuVDPmgP7m63Mj3l2LwnebEBtfarbl0gMOFm6TrMm+uEaYOkJoSVZIzekECrf8jw2HOXXaOFotJxjnX40qeVB5XrU8pbjSRSIUlKx11TgAuwzvt7Ojl3XXz2g39DxChzCA63DztLQdNLXC1HJ7vjtMoSBvCiB9Hnjq1P21PeF3nRnTm9XLL20DCj6vf1kGnEIF2w4IndGtpFk57vRf9oLS5bDKRRaJxIFqno3YlKKaCJGP69dUXTdxO4Yw0adpNn1b7L
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd5e6a4-42ce-42cc-1b66-08d81722cff2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 03:09:16.0362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJ4T0O1VUVYWlZ0pj9bk87DTxTsCWl6w6Pw76Iufk3rMSp/wWrNnD28IT8+2SrUtdgAZ7q6Fgt3m1wsqMdrCHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6854
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The other thread may access other endpoints when the cdns3_check_new_setup
is handling, add spinlock to protect it.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/ep0.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index 74a1ff5000ba..5aa69980e7ff 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -705,15 +705,17 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 	int ret = 0;
 	u8 zlp = 0;
 
+	spin_lock_irqsave(&priv_dev->lock, flags);
 	trace_cdns3_ep0_queue(priv_dev, request);
 
 	/* cancel the request if controller receive new SETUP packet. */
-	if (cdns3_check_new_setup(priv_dev))
+	if (cdns3_check_new_setup(priv_dev)) {
+		spin_unlock_irqrestore(&priv_dev->lock, flags);
 		return -ECONNRESET;
+	}
 
 	/* send STATUS stage. Should be called only for SET_CONFIGURATION */
 	if (priv_dev->ep0_stage == CDNS3_STATUS_STAGE) {
-		spin_lock_irqsave(&priv_dev->lock, flags);
 		cdns3_select_ep(priv_dev, 0x00);
 
 		erdy_sent = !priv_dev->hw_configured_flag;
@@ -738,7 +740,6 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 		return 0;
 	}
 
-	spin_lock_irqsave(&priv_dev->lock, flags);
 	if (!list_empty(&priv_ep->pending_req_list)) {
 		dev_err(priv_dev->dev,
 			"can't handle multiple requests for ep0\n");
-- 
2.17.1

