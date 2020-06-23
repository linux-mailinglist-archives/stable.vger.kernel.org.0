Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBDC2047CC
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 05:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731905AbgFWDJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 23:09:13 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:38126
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731690AbgFWDJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 23:09:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoQVHOcgY+CjtHt8xNpa04vLLJYZxgjcM0X5sGsAv4ZxifIKjGKvcZZFbTnGgASQmBJVS9mxBB5J9IhY61rkgUf9mXsLw7d8txcDFKhq0etK0ZHb9j9BzzGYdrdSxYQqWTPpFTYRa28a21MexiR0awogcdK4HOdZCbeLBCzd9Gc1GS4lN2T0j9bd5m4JNT/7OLZHXDAus+JeVgk8sVt2Om0wPRn8xjNdyMfk0F9QBGKmexkZy6DHBfJl02VrgRbfb0WMoSLCVEqRt0O8j+QK2fBIlkOeF2rkwZ4jH3w4S5iUV3jK3HyZGDqw81iQhxGihjtd09vblbcNY7GLwxIsNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R60Q3zQXyLF0pY1ylTobYrl09+PDICmnewOEQkS1a7U=;
 b=NJfnbycg71HVv/5X27hlnY6mYIP9wGEL/4HuoVGEWUy4Hei1xnsLOcil8dTdspaiqd1aTzyZfCDaw2eEvEttOIte1LefeSgWuz1ukeFUL7kh51TVWLoN8+PhSuuNax5IOa4y4OOxzF6DUXAkAuI4nE5Yfbkc45IsdnxDIxP1wjzR9PoPr2TPucUVf+3UBxDjIpaWlfnQRSzcDnGxrqdv6k29HXeOwTPaHGo/UpARjuar1cuhy73bX3AoVlxJIrbrQ2XWkbH6KVSQuCqzZRS4CDvII6AQrI/8NeGwEYrijMw+5nASJ5QHI8iPgvT6Ab0OT9Izjm+iDJpntsawSZcuQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R60Q3zQXyLF0pY1ylTobYrl09+PDICmnewOEQkS1a7U=;
 b=TSjw+W8TzRYVm+nGxbV/rj9LxCydK8FXnr4f85EGl0ht3vc9HcGZ/hJsiqLk8HX0iEt5xnDvHLVtb0uDg46j17tQVltqh9wzjvcsqhZm36hoh+8sU45I2PsS7CQXrj1ri4j5cONCaZca+j+TmRQPJNsWD1ZJuxMYNWZSvFHYf/8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB6854.eurprd04.prod.outlook.com (2603:10a6:20b:10c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 03:09:09 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 03:09:09 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, jun.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] usb: cdns3: ep0: fix the test mode set incorrectly
Date:   Tue, 23 Jun 2020 11:09:16 +0800
Message-Id: <20200623030918.8409-2-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623030918.8409-1-peter.chen@nxp.com>
References: <20200623030918.8409-1-peter.chen@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.67) by SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 23 Jun 2020 03:09:06 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 43390d82-8b61-4aeb-90e5-08d81722cc07
X-MS-TrafficTypeDiagnostic: AM7PR04MB6854:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB68540E2ABACD41CA6F07F8B68B940@AM7PR04MB6854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P+dp7F0jVJj2cHjEL99ilC64yWrFW8RwXtTI9q6ZNZAf8gjI4QthWMb1kwqG2cmJiFPI5fRXOwqB45fr9biZ2yQKQtcqSb06cLvLI6qnlJe4HFrNbCC8KsWIDKKqEw26Z8jyMi5KBCyp8NwuPi3bAIA6cpen3N69NzwlZtFpUIDzBEuz0cmaKvnEmrDmbv04EYaoLybIMIN37+GOdjNQ82zyP5xsEmenGTaYYhPyybz2gPIgFNhnHRLyvRgnSB0tr29fDN9UMcqw5/FVHiR6THe8XtCVlzf8LzH+lqp+6Vss6d1Js8BRWIWwGOO82sMEqyWMSfkfdwPRapVClT7ZoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(86362001)(6512007)(1076003)(4744005)(316002)(2906002)(66476007)(66556008)(66946007)(6486002)(44832011)(956004)(5660300002)(2616005)(478600001)(6666004)(26005)(16526019)(186003)(6506007)(8936002)(8676002)(52116002)(4326008)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GK+IOJyPlAnYBGHkjJTEKpfi5diCbSsMp+j7WYRkG5ZjO3+QzTy8svECC+MYDqFkrvzdkt8mneRdZfOjEZ4UOCe1GccqjvHKcsV2f6DggW2D24tf/96nt1cUBMh0P84U0cZx3Xeb5GkXStOnutV0ueZrQr3lUgKmD7iNs25TcFh7KrIeqN7REnEuFKpipK4370EelJhXPluHktBbem3e18ibq37rHg9E5Pax02lkxQy2QWnuzThT7njGxqOcHQ0WLuyW+Wb+DJZkaBMrH21aIp4UFZvvWmlo5NnH1t0WQk2+HzWUvrmaQD3q7vA8yF6cDT2IofKnNMs0u5eru/t01L5vb8FrI8JrJsfKXo/HZWP8N1mizXBz5nm1ZtM7eOi2OfgleiiTSCxBDKgTevrwGg2IKy/Atkq0feltzeeGdQ/u021VCcxvdJWvHWGqJL4PlChfI1qfL3qmB6Ps2sJpUTmBBJ/FPi2/4hzhMHIEtQJZEL58MAYOTEMg1zJMX58A
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43390d82-8b61-4aeb-90e5-08d81722cc07
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 03:09:09.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGihjTupdFqzRierGxhByqF4xCSzAQ+H1vbAy+M1V3101z4Xj+/Uks3bSYrOovN6HP1pDEMBfT0/+DhPhjYqUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6854
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 'tmode' is ctrl->wIndex, changing it as the real test
mode value for register assignment.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/ep0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index 2465a84e8fee..74a1ff5000ba 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -327,7 +327,8 @@ static int cdns3_ep0_feature_handle_device(struct cdns3_device *priv_dev,
 		if (!set || (tmode & 0xff) != 0)
 			return -EINVAL;
 
-		switch (tmode >> 8) {
+		tmode >>= 8;
+		switch (tmode) {
 		case TEST_J:
 		case TEST_K:
 		case TEST_SE0_NAK:
-- 
2.17.1

