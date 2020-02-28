Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87468173526
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 11:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgB1KTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 05:19:04 -0500
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:8259
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726063AbgB1KTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 05:19:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqTQa5EyZSOxdSnETnePshv5w8Pk+01S/qPRCc0O1APOsml5YvLO4LhCc3wClpaYr5dO6D5jwuwB/nyZNYWTck+E8fkJ/Ul0nSFiljnFJchHwH+iNuJYNb9FOAAMP6ko03mhx4Coyd0szpnTDJ9XqAwpE8+tPGjX5/upGXkk4lqp5PnTNBSfYClWKa3X+eCdj1clYzwEtkLEuoZqmO3rxZFTDt7O2MFUafjFeAx2uxReg37RlvycOl/QZgTCcoQ3JnYvdDEqdd/okCBJWhTnmsRVCidaQu6DmZzTKrdpSyWZsWvD8QyfDeuSyX2yRduCmafIaYlC7/I4ZKBTS2vFbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Nr+2VCHsEOwlIHi+VzD9JqAt1P+CglbjrOcW8Tl1uI=;
 b=JSfXtT217voBNMQRddAVSHDckRV0/8oqJshi2svPC2Dhinnbj87RkX/IEnoWJXkC+8LPs2tw2LLKHm+Oyd5WmGLfISFbHqeXGYtu/2QjCuyBLu0COyTx/GUe/4FAupWUkwlkK6/C96XyE0YZsWMKiJiaNZuAP65d5PBJvgqMrhqeEXLbRnYhwNxUhbPZbV71A8BvWrdJFClmyQYu1rsZPiE7h1RGmAs1cVuo6A9YU4Gu/Q+SaixWO8qbBCRnxpp8SzjWEhZppL1Lc3rVZBPDlCWXm49i7S1/2liM8Jlnn8jzb1kbE3fUpYmGl+3SRDLXZGCP5c5GXqZ/Bng0hj2bWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Nr+2VCHsEOwlIHi+VzD9JqAt1P+CglbjrOcW8Tl1uI=;
 b=alqIH6+buvtSmauPlj2wHAr781uTfZh/GAaWeFiyhzD9ZaH2l4g2dpCIhNxE3cNokNcHy2GfNYMogf4JHy8xuXYWxc40W+vE6LPUON53jo+EjJPERgSizsUrRUvGUQYd+KXlf+cSXGEUxrPBovPPuqpnDTArXzH6tMM5+3NThmE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=andrei.botila@oss.nxp.com; 
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com (20.178.92.210) by
 AM6PR04MB5094.eurprd04.prod.outlook.com (20.177.32.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Fri, 28 Feb 2020 10:19:00 +0000
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e]) by AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e%3]) with mapi id 15.20.2772.012; Fri, 28 Feb 2020
 10:19:00 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Andrei Botila <andrei.botila@nxp.com>
Cc:     stable@vger.kernel.org
Subject: [PATCH] crypto: caam - update xts sector size for large input length
Date:   Fri, 28 Feb 2020 12:18:38 +0200
Message-Id: <20200228101838.17215-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:208:136::33) To AM6PR04MB5430.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (212.146.100.6) by AM0PR05CA0093.eurprd05.prod.outlook.com (2603:10a6:208:136::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 28 Feb 2020 10:19:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 188b9cee-3a7b-4f38-bfef-08d7bc37a0b5
X-MS-TrafficTypeDiagnostic: AM6PR04MB5094:|AM6PR04MB5094:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB5094DE53652D5F531DD80823B4E80@AM6PR04MB5094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(199004)(189003)(6506007)(186003)(6512007)(6862004)(478600001)(8676002)(2616005)(66556008)(26005)(66476007)(66946007)(6666004)(2906002)(1076003)(956004)(44832011)(81156014)(6486002)(86362001)(8936002)(5660300002)(316002)(52116002)(81166006)(4326008)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB5094;H:AM6PR04MB5430.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9clo0r8Ww1wSbjcyi332rFqAOofvRVfUPrpYgQ4tlCG4pDmLDn79N8gbO8QLTrNsF4nEt4LEWDMzzCIqp3ayccXgmdl7RdpnTth1b9nNpbg9Y8vHQGGzvHKVNmkAg65nbr+M/ZAC3BfcTL9xnQTu7PWVJ9bah5gTcE9LxeXcZ6IuqWFlPg7pozda9DOWPjsqpQi0lMFjhBwe0DAMqUX9sbqLR8B/oO4AcDDSKGtMObxj44yKQxIyv1rHUqZa8oGMSFvri1jJLI0t6I4bxq0Bh+8zWazuOEl87Qbm3o/QLlzw4k79nL0asrN5Ti6sw+AWy4q/q0D6XWspL9+aKDoMn896nbb5uO/0s9WN5i3u5fHkQLZF2GpcklDpYyXmwa8Do87l15wq4+0wxROuDmarQKMYQqiFD8aIZZsU9yLboZURzGz0QrBUMSJOdYmUwp86
X-MS-Exchange-AntiSpam-MessageData: xmeJmCYVIvmro4dZMYBgIyocs2MUVJR5qTQaAldnkJZiB6tAcgBd+XpwbqsZ3W60103XCoquotM/fSfYUOqZqXD7b/WmpPhtr+tQwe0cLQycB08m7e+1is8FiKufnLUE581AjCbx0qGPtIR2atHM7Q==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 188b9cee-3a7b-4f38-bfef-08d7bc37a0b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 10:19:00.4411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6J5zCztc5l/7HGZ2AgnZ+yy9npyQYPXylVnb6OV86AchcZSv+gLDYRDp1nhPMAilu4jKljqBdeb9oen/He6Z0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5094
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Since in the software implementation of XTS-AES there is
no notion of sector every input length is processed the same way.
CAAM implementation has the notion of sector which causes different
results between the software implementation and the one in CAAM
for input lengths bigger than 512 bytes.
Increase sector size to maximum value on 16 bits.

Fixes: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index aa9ccca67045..8ebbbd28b1f7 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1518,7 +1518,13 @@ EXPORT_SYMBOL(cnstr_shdsc_skcipher_decap);
  */
 void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata)
 {
-	__be64 sector_size = cpu_to_be64(512);
+	/*
+	 * Set sector size to a big value, practically disabling
+	 * sector size segmentation in xts implementation. We cannot
+	 * take full advantage of this HW feature with existing
+	 * crypto API / dm-crypt SW architecture.
+	 */
+	__be64 sector_size = cpu_to_be64(BIT(15));
 	u32 *key_jump_cmd;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
@@ -1571,7 +1577,13 @@ EXPORT_SYMBOL(cnstr_shdsc_xts_skcipher_encap);
  */
 void cnstr_shdsc_xts_skcipher_decap(u32 * const desc, struct alginfo *cdata)
 {
-	__be64 sector_size = cpu_to_be64(512);
+	/*
+	 * Set sector size to a big value, practically disabling
+	 * sector size segmentation in xts implementation. We cannot
+	 * take full advantage of this HW feature with existing
+	 * crypto API / dm-crypt SW architecture.
+	 */
+	__be64 sector_size = cpu_to_be64(BIT(15));
 	u32 *key_jump_cmd;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
-- 
2.17.1

