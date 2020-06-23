Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0F92047CE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 05:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbgFWDJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 23:09:17 -0400
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:13838
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731308AbgFWDJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 23:09:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7r3PV0d6PAWXGPE8SrCwZ88o6r0nu/U5bxwXknQF1Zv+Ufhh0jeSGNOCVbhzSqXQtQqcw1i2SA9cwHwMdhx1btzXSFOTgalmwwZw8p1PA1B7zLgJh46O5lbRNOhUcYMhWvjTIhqG/aCrXe5TIb38cejBGBNNXtQm/Y1yi5o7DcHHwd26vrfQn5XhdZHBIf8MjUwhPPSrFG0GpzL/EhcywZBtPqagP8EcA+S1VF6R7wcOzCUSSnTKDQxS5f8F0exIYawOFRjmAChbOdju4zDKGvR3uqgdUFCAoTH9WmxxhsRegedRHByXwT2r+i1GVF/7tsh2/YjhGiFq8lyr5kU4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM6xaQEgJZ5/HrNNf9mg7phfYmVNBC86IXnEoMgs/qo=;
 b=Z1vC8xiJ7wBlG82zOGpro0SXigsD3deDoquq2Su8R3Iu7gIm/StmIJupsBXvgaY/3N7gULC/rW2Yhm/x8ppKxDnCR6Nr8+YOS+DiTLStInCb6XYHwJl0mc7BR8D+J8Bi9ArpIespM+U38kfSGMSkMk/G0e7fzXcwGb/THPGyKTqyCX8ipDmUhI701d7FkFCDowDlwR/XlJO2jId3QQxNoTFgkOrGhOJkFYoHEEU7LoJ9fltOcqRqlUo4X3e8Qc7chBV9EGxSJyTKjPtQN3McS6wO1OOMoA/CQe+TASJA+6pe9Ky3T0+u5tjYFvynSEIwZ2IzlNk61czB5xcHL4o8Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM6xaQEgJZ5/HrNNf9mg7phfYmVNBC86IXnEoMgs/qo=;
 b=jRePFCKy55mECL2NzvgMoLOtOXKt6l4/0KALFgdOJhxZd5O5UP5EKojFTyjbQSioRqRubQjAzf86Te7VeYr3PNwp2GPQYQhv1MOzE3uzZPLnKpUDEJ6Bgx2O57moa6bK9W7kxegnPFevcy+EU1LLCaGpgAnk5E9lsJcwNTH6xv8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB6854.eurprd04.prod.outlook.com (2603:10a6:20b:10c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 03:09:12 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::1101:adaa:ee89:af2a%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 03:09:12 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     balbi@kernel.org, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com, pawell@cadence.com,
        rogerq@ti.com, jun.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] usb: cdns3: trace: using correct dir value
Date:   Tue, 23 Jun 2020 11:09:17 +0800
Message-Id: <20200623030918.8409-3-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623030918.8409-1-peter.chen@nxp.com>
References: <20200623030918.8409-1-peter.chen@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b29397-desktop.ap.freescale.net (119.31.174.67) by SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 23 Jun 2020 03:09:09 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4640df1b-85b6-4186-6143-08d81722cdf6
X-MS-TrafficTypeDiagnostic: AM7PR04MB6854:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR04MB6854C04B0765E81A2E2BC2D08B940@AM7PR04MB6854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XU8eMy3hwp7Mm6pMg4RQVnaDizYYMgccmr+CkT0o1LEnC9+64uJ/Dbwgi8JuAr1GuHuQqqBI1DH1CVIn45qoMjkHsaItCzMMZlcFE6LSAkEDSQE87wdzHj0jFukRE+b5MI1pl7Rjcy4Pn/zIzU/lv2AapKd7LZl6Ds8Jz77mrgBDr0cxyowsKeNlBun79buInIhufldyVyei8KYqfXS8F+4Iap5cYP/Kvv1ge47fNK2k0j5IJ88jG9tO127UAhfMh5Z7XA72hnGXs/Cx89DoSRrEr5lNY9Ls605kQd5dGCHOhCpktdxYDv85tcsFebu5zwd7jPUBcX/ya4lgFYBeLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(86362001)(6512007)(1076003)(316002)(2906002)(66476007)(66556008)(66946007)(6486002)(44832011)(956004)(5660300002)(2616005)(478600001)(6666004)(26005)(16526019)(186003)(6506007)(8936002)(8676002)(52116002)(4326008)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vQKPXsboykPvvhWQdz4hV+W14M15JmKMS+Lpwy5H7jyFwB8/yb4KY6Cc7tDR+cAGiBJ7aLwW4q6X8mgA75GduRD6RT73swBaXmkl56+B0OvRkgRyN03iAzrscVmMxNdHUjtGvo0AmZGLv17vtzXbbm/fdTvU08MqTTnkSVoRTFa1CzhNL1Zc9jL6EI2xH+RYdstlICZYNwHg7QgnlO+kcdvXIAlCDqNwKrI3KIZpNgBXGZ4JqIqn+wgip/ztjll/nN1dxTuUi727DoC1nfgtxaMHE8uQVKHbeVwywb4lS0kQdbe0Yf+5svegDwaeVb4X21Ie6PMScsboPGm++YrLyn0vvDjmTlpA3FQOaErVxJd1J8h7LHypC1CmCzJkgPVLGu7tA7DkmiLPXRhhix7uhRk3rFHRnlA4r6iJxkeTmJl7DUmCc7dR9GeKh4UFbaRbqW5yDiA0arGMSH4lU1MdL3VIvyXsFHpBEeu27iXBwYuMG7MxgAmIc3FrUFzcyyGZ
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4640df1b-85b6-4186-6143-08d81722cdf6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 03:09:12.7525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9mvC4VdnbMpEllm9v/DRM7B5RAYEMERuACJk5Uao3WrXh3Qq/i7rTSgGqTSmtFMw+7uL4jKAjxsRvVX7xiScA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6854
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It should use the correct direction value from register, not depends
on previous software setting. It fixed the EP number wrong issue at
trace when the TRBERR interrupt occurs for EP0IN.

When the EP0IN IOC has finished, software prepares the setup packet
request, the expected direction is OUT, but at that time, the TRBERR
for EP0IN may occur since it is DMULT mode, the DMA does not stop
until TRBERR has met.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/usb/cdns3/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/trace.h b/drivers/usb/cdns3/trace.h
index de2c34d5bfc5..0a2a3269bfac 100644
--- a/drivers/usb/cdns3/trace.h
+++ b/drivers/usb/cdns3/trace.h
@@ -156,7 +156,7 @@ DECLARE_EVENT_CLASS(cdns3_log_ep0_irq,
 		__dynamic_array(char, str, CDNS3_MSG_MAX)
 	),
 	TP_fast_assign(
-		__entry->ep_dir = priv_dev->ep0_data_dir;
+		__entry->ep_dir = priv_dev->selected_ep;
 		__entry->ep_sts = ep_sts;
 	),
 	TP_printk("%s", cdns3_decode_ep0_irq(__get_str(str),
-- 
2.17.1

