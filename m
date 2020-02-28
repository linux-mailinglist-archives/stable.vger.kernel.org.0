Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC5B17359C
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 11:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgB1Krn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 05:47:43 -0500
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:34425
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726765AbgB1Krn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 05:47:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DC1aTnqQhzrZQRa8FsTLrx0gTqGi4EzGWCmqOCQJPTLrrTAMtl5aUoCFo2YMQbeV9/0ljNmlAOxQ8SWPCyithZnH8tDqM+O4HO6NvFABG5jJPLZLd7oR6EKu+32SKvQqhvipn8lsvTGquun/FA6/s8KlLVCsvHo4acvNHcMTACmJgRosiEARKnZgnxSPXr936RydPIfZN4TaweomfaH73DVHfFUc7xK33cmCxxt8eAIIx09V7hXuXoNCWfhDN6GWT7UcveOprtX7O8B5L/zSY8YUZqmune4gX7WA/RpFNIkEbWwU+6FUwtDijp8o9Hn3MbnhnhptxXs0qzbuGKktXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6vje7PZ2XqQgQ3nZX6HHfMpv7S8S/3Rpl3oZ8TtoNQ=;
 b=Ng1D6q8FkvsTXh/aZ/jEM9Qsu/6AKxPcbObCjn1BgJ4IMSP8QVrsZHEVkkiFzu4xcB1TSSAxJAZBZHUeEkoBxhSguvIE9/3V5o3UeuH26Ufsb449AiOc4prGHco3+UZNKfopZeJr3DtpRe6Q/9mHfb744oQOzjC+ax8DDVF2ckaaUYIagktERfhscXjnqlW73IZ82kddf2SyrCaioIdSbBqxjbvipLu1tDvIEM0b0XU2svsGHbltHk0/B6ckKgMMOJZ2ElhPmzbqTeoe0+jPhMuwX9MudVjjj7lK8CTFRe8lU6QANOf9LuooXJb0NbGVRANE2hAssUBRtcWrCv7s8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6vje7PZ2XqQgQ3nZX6HHfMpv7S8S/3Rpl3oZ8TtoNQ=;
 b=QwkD2Tu0vrJbtRxWKBebvyPCfNosWIAeAcff+qD/KdfWOLVjTHea9bZ0cvrL/4R7+VHyY/b3IJmUxCZQL11JnBx7FPJ48raShb2vVGvzGDibj/qSWWeHEz2vBw/+yf+wliwn/aahy/WiIwTfvupBY8t8AGacue5Jo0qLgqaRCvM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=andrei.botila@oss.nxp.com; 
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com (20.178.92.210) by
 AM6PR04MB6309.eurprd04.prod.outlook.com (20.179.5.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 28 Feb 2020 10:47:38 +0000
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e]) by AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e%3]) with mapi id 15.20.2772.012; Fri, 28 Feb 2020
 10:47:37 +0000
From:   Andrei Botila <andrei.botila@oss.nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Botila <andrei.botila@nxp.com>, stable@vger.kernel.org
Subject: [PATCH] crypto: caam - update xts sector size for large input length
Date:   Fri, 28 Feb 2020 12:46:48 +0200
Message-Id: <20200228104648.18898-1-andrei.botila@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0074.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::15) To AM6PR04MB5430.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15007.swis.ro-buh01.nxp.com (212.146.100.6) by AM0PR06CA0074.eurprd06.prod.outlook.com (2603:10a6:208:fa::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 10:47:37 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 66f1e256-fabb-4522-7467-08d7bc3ba044
X-MS-TrafficTypeDiagnostic: AM6PR04MB6309:|AM6PR04MB6309:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB63090E087CC22387585E46BFB4E80@AM6PR04MB6309.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(189003)(199004)(8676002)(2906002)(6486002)(44832011)(4326008)(8936002)(81166006)(81156014)(6506007)(16526019)(52116002)(316002)(66946007)(2616005)(86362001)(478600001)(6512007)(956004)(6666004)(1076003)(66556008)(5660300002)(66476007)(26005)(110136005)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB6309;H:AM6PR04MB5430.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJkEleYzIh5kvsjZQXzsDfWR/uU9NlabtKsUbyIWQ1dxfyrPPYkpCF5osjcvOG7fEPycz216zZDeBfMBZAnMdA3CxhzAJaUd1LXV81BgtH83gnlLLgkKXNVrIdYJqL4qbTGjOddgz/+PLyefGH2VWsx5Lri+5u89YtQm3m/19AGCMharKBz7JyYUGhYyvkl5wocMa0A0h0UKh24m3tSw07COFNIhlxu3H+xydukv6VaKpb5y4cua2TNOf1/bv/Xg9SrmlY1mCqRe3AghuorgVs4vZ2tNEK0y7+0uGIeo1saIqzT0dGWX6NsK6+hP5uhNFrMWo1mbpJAkJNWFimgHsVBlYmr/OJ/bk7ZZvsUxKKQKBX9w6suoe6CCi+UVx7H+eLH+eSzoD2UqzOQIr73XjOtDQeyWhSjiJncCYCEJClCsV8UTxVLqZzWIrdYshSD4
X-MS-Exchange-AntiSpam-MessageData: m7eOy9LJXoa4wOXWTO2VrH1ZCfhq1KntV69UhQSxIe3nrr5h7bIYIQEe9jmNGHWu58CHLE6HQoF+pI+APWGZJ+yHaGFvK3tXCOI0yx4L0+rsjwkuiAPfJ/kMT1O46LNs9K0DVIBPdXactpD77abodg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f1e256-fabb-4522-7467-08d7bc3ba044
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 10:47:37.5586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qa7XrBdhWYd3tkXL0RWsKPFIaFHSE6huWy8wz6yg5o34xmxq8fGstjYSLTj0DGwaEo8a+bOEGbr9bqnCRSkfew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6309
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
This patch needs to be applied from v4.12+ because dm-crypt has added support
for 4K sector size at that version. The commit was
8f0009a225171 ("dm-crypt: optionally support larger encryption sector size").

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

