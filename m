Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6D32902A4
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 12:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406601AbgJPKRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 06:17:46 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:41057
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394906AbgJPKRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 06:17:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kfu5uB2zv0Rp7s4A8RfjALe5ZEvrZkdMvecbPWcnDlJEJfLlFFQnkCtKODd8a305f6kmSiihLYdMq5UCVZ8VeNzcKn1bd0KlgrurBgmWw0YyIuW7X2icQfyWa9WfhXwoXc2brrzfh5ab6dIm4A8uLfOPhCF3G6NQlpjQXInut3QbQGEJ7iaYBbp7EIkfiFnZEWRIOmeMbIYuofer2GnpHkzCDaRTUVlkhSv8sPLqgDZemNXC4Kkw4SjJiCWuY6vnogCRMOEbybS8HlR9M9sMqxwxVn1L2OIMAif5wESeZa+SNNrPUv2tyX7rxWlGY+LQ8pnwCvCk6ST27s0RJvwLaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+TkqBbpRujf5WL8eVc+MjKLAL5YzKX8FIOoE/FK6/U=;
 b=mnqpn7n/uXYRnwW5lD5nimolHlXshtV6A1v9b4O8+5bY67tphLfPF/ILaKZwfIB+sNi3Wj4/MIz1EApx9v1wWVg0ejXpz3e/oFkbk6iRf54V0aE4lydnPq3CuCS0VTit75/Plte/hqt493c/60HEwlzaeXi2TTLG8eG0h2wtXl4O421MTMMJPxz3BzI2+zV+YQTn39HFu+GdV72ifY+j9EoLBlZW3FaTfJs4nOBZqgOMWc0Dahnas/XiKm1R0n3xL6v+QAxMmmTv9AUApbjTmxHG1tsTCuSyUc6AUw6UT8D79X+mefNC3Fq4P0YS1TYxFt8yGeeQbjPRuGi5V4xQvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+TkqBbpRujf5WL8eVc+MjKLAL5YzKX8FIOoE/FK6/U=;
 b=Nzaj7beP7P/QemQER/TWwPKpf0tdW0TPctKt8HuqEyoYKgJNTLQJJsomQffmJah7U3rz3UJ2WMrgzDCLnYHR9zEppzXtzoZii511/tN0D+Pz27JyR0EMLlLFd1uDWZzd43IznIRtuG6sI52KHNxZsLI8yQTHl0O89MWXSEoJEKA=
Authentication-Results: cadence.com; dkim=none (message not signed)
 header.d=none;cadence.com; dmarc=none action=none header.from=nxp.com;
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12)
 by AM0PR04MB4002.eurprd04.prod.outlook.com (2603:10a6:208:5c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Fri, 16 Oct
 2020 10:17:39 +0000
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::ad01:9b1c:3b4b:3a77]) by AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::ad01:9b1c:3b4b:3a77%7]) with mapi id 15.20.3455.032; Fri, 16 Oct 2020
 10:17:39 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     pawell@cadence.com, rogerq@ti.com
Cc:     balbi@kernel.org, linux-usb@vger.kernel.org, linux-imx@nxp.com,
        gregkh@linuxfoundation.org, jun.li@nxp.com,
        Peter Chen <peter.chen@nxp.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign extension
Date:   Fri, 16 Oct 2020 18:16:57 +0800
Message-Id: <20201016101659.29482-2-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201016101659.29482-1-peter.chen@nxp.com>
References: <20201016101659.29482-1-peter.chen@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.66]
X-ClientProxiedBy: SGAP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::19)
 To AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.66) by SGAP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Fri, 16 Oct 2020 10:17:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f53dfb2c-b801-4da3-107f-08d871bcb5e0
X-MS-TrafficTypeDiagnostic: AM0PR04MB4002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB40020CA17B6EED6BE9457F938B030@AM0PR04MB4002.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hKV5anTqzhsSEiUAGuYx6kNLFAll+Vf6Xcv5y/KwaDqxml8dEQV41kdsL4aEK39BVYpuq5WLW7rb7/4utbYjKm6y+6vULpqDSMnrJcb2ErpohOV4WzAdHvvYHLuiVBlCf1nUeqTZX5XudUrCnrUgtWIERbbAcvQJX5Jj8e5cFSp4BvAiUmagm6SLc1oyb5yfup/QPwQM5brBftlghRZ2oQ2/mUmqZH/9MRm76vo5MDoQWT5F50GMmqx6DFWjJ/2sF8qVk6To39lkxlCpJ6nozvLE9LfG9JXeyeiINAGA765ATIwXXagubQNEuylpMh9WAz5KMfsQlblCQKRMVM0KPcxORymf+W+A/ZT+k5V7OM3NXxTRBtpWAK9lbkFCuqES
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7300.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(1076003)(316002)(5660300002)(44832011)(34490700002)(186003)(6486002)(26005)(478600001)(52116002)(36756003)(4326008)(2906002)(6512007)(956004)(2616005)(66946007)(8936002)(66556008)(66476007)(6666004)(16526019)(83380400001)(6506007)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fN5CxBoJWBVfzQfLyrCNURTfjE1czdJdSry6QQcPLItj6EcAPgOsj7ydXqD0c2H7d7J2d8aOZ7wQWlXqglfWuQKYKLDxdvHb0ouf4I3FjUXJgRdPyEdqXWfCvkJ/mIYlTfu3UR7WmT66QN057PMtjIorunhgnqpQSaTUxaLv0eLYV2jnvVU/A/fsbFYHw5PIk+WI5xBWonK8jR7vCB5OICt1nOTh1huKgOEzUJPM1lIq/g9+eqwql2ckq2/fYlL+HW/KsBWjDNcaNJR1TRRwgkBs6Z93T0JjXZzHZfM9ENXXz00feKiKb014SnOVRyM8CsQ3RjDx3aquUYKWoAp+Jz0U3omzdZYsTwHbaUw6hFsBQMVCiyydEWno4cJbnV/wzFUYOfdFivI5e6rGg5JX9331Cm8pKsOE93Y6KVcIfMvkpkecWAT84Ie7gbDT3nOhxOovrzGFFx+ClEayHCWz514XdFCcBFT0/yxqHOj6CaGmAMGCBuyI+Mjy1/ontRju0FEBJOHU+dIlqnOBXUAcEEklMPX4nR4l18Ou+2reXDdnNnTFCqRUzRhqj8W4ToTwGiq0jtwOvCWcsYNX8khVgwsgIWz2NK/wSzUH0HIIpqjVS3xt5h/gNsfdh23wyNGwYjbCwVZHbQr0VqRV0vonNA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53dfb2c-b801-4da3-107f-08d871bcb5e0
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7300.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 10:17:39.3698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tAdTpuCkwbdsCkw4dxOJ4CZ9G3Ppjj/a3gU/bbxmxhd9kPT7NJ82FMRpyNQO8FaqwGu1oLF9YNg8u//xX8hXZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4002
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For code:
trb->length = cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size)
	       	| TRB_LEN(length));

TRB_BURST_LEN(priv_ep->trb_burst_size) may be overflow for int 32 if
priv_ep->trb_burst_size is equal or larger than 0x80;

Below is the Coverity warning:
sign_extension: Suspicious implicit sign extension: priv_ep->trb_burst_size
with type u8 (8 bits, unsigned) is promoted in priv_ep->trb_burst_size << 24
to type int (32 bits, signed), then sign-extended to type unsigned long
(64 bits, unsigned). If priv_ep->trb_burst_size << 24 is greater than 0x7FFFFFFF,
the upper bits of the result will all be 1.

Cc: <stable@vger.kernel.org> #v5.8+
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/gadget.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.h b/drivers/usb/cdns3/gadget.h
index 1ccecd237530..020936cb9897 100644
--- a/drivers/usb/cdns3/gadget.h
+++ b/drivers/usb/cdns3/gadget.h
@@ -1072,7 +1072,7 @@ struct cdns3_trb {
 #define TRB_TDL_SS_SIZE_GET(p)	(((p) & GENMASK(23, 17)) >> 17)
 
 /* transfer_len bitmasks - bits 31:24 */
-#define TRB_BURST_LEN(p)	(((p) << 24) & GENMASK(31, 24))
+#define TRB_BURST_LEN(p)	(unsigned int)(((p) << 24) & GENMASK(31, 24))
 #define TRB_BURST_LEN_GET(p)	(((p) & GENMASK(31, 24)) >> 24)
 
 /* Data buffer pointer bitmasks*/
-- 
2.17.1

