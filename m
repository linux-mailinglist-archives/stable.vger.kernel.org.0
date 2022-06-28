Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8958155E6D8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348019AbiF1Psw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 11:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348028AbiF1Psm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 11:48:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1EA2A273;
        Tue, 28 Jun 2022 08:48:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITeWnqZpiyEOWosi+/ignRBbptHHhAeQWz28B/eS7Gan+v4fh8rxlAFzuyCZzUG6MQ3vnbFe/EdwuKmPkntIe3ZDWv6oP0J90ExaWleWyAmgSQHaDGgpHL117z4mhIN8IiiB6Ev4wi0ypJnAUSMfyFgyJ0JwtkPlJhIzgzlRZ4IHAriNjFI7prV/sG2uqlWSDXY3CBpMIGtQIMON5fTQyVnFf56zlKr7IlZIbp7/EZVViH9Fze380l9PL/+MPtcdVMfhUS/c8ccplvNIls1rrGNvzn2r9fnYEGcwe2n+1yg29Wx/RlUV6e4ch9qYPCs/o80TrYgVPWh+5+aBot5lxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9ySKLjh/+qg2ASdKk08y1u/uD+vsC2NbCyrGRhsq1o=;
 b=eSF7+Z7ubIOmYlDQljJgw9eMRFgTyR9AR6mPbqTjQNov9KFPHzTR3FmqfezV+s3MM22zThc2lmheXe3UQG/9p2vHj+jrRebDX9PKV1GTlVdtpopLk8V1yqlw6MuCv/WPWuaI4lRq3KTqPeZymQ6F0sBBEhLNFZE51ehMr0L2w2MIcbQ4UZJlZNuCbzQvm1RTczMRmFC+Az2QNmvpdjHqmrG0cc58fBy2ECwQGGDEDrmbPOqFspsXRsw/TVJw0FV3fsXcKTI29tVzjAUOi5wRDxV9tePo2NaJw+Uw0KQShRewXzfMRew+yp0B8btY20iM8VEoyL+aXEEFzss2/X7wVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=bootlin.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9ySKLjh/+qg2ASdKk08y1u/uD+vsC2NbCyrGRhsq1o=;
 b=iX4kETWLm/mT6HaeIVj6TIJmWhAUtpcjlCHZ5yqliHxoyZADynIqfP5zuc/dQjV5TrvbpkpLoTgMzntvYsezOUGB3xTj4Pchf3VQj4s2quKdJYmnPr5ZVAZAgPpiPmi6sQRvXiOMAgP9KBoj0nN48SP/cQc3BFXKdyqy1DsoU74=
Received: from SN7PR04CA0228.namprd04.prod.outlook.com (2603:10b6:806:127::23)
 by BN0PR02MB8174.namprd02.prod.outlook.com (2603:10b6:408:149::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 15:48:36 +0000
Received: from SN1NAM02FT0031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:127:cafe::a0) by SN7PR04CA0228.outlook.office365.com
 (2603:10b6:806:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17 via Frontend
 Transport; Tue, 28 Jun 2022 15:48:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0031.mail.protection.outlook.com (10.97.4.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 15:48:35 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Jun 2022 08:48:33 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 28 Jun 2022 08:48:33 -0700
Envelope-to: miquel.raynal@bootlin.com,
 vigneshr@ti.com,
 boris.brezillon@collabora.com,
 linux-mtd@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 git@amd.com,
 richard@nod.at,
 amit.kumar-mahapatra@amd.com,
 stable@vger.kernel.org
Received: from [10.140.6.18] (port=39110 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <amit.kumar-mahapatra@xilinx.com>)
        id 1o6DS4-000ELN-Vl; Tue, 28 Jun 2022 08:48:33 -0700
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
To:     <miquel.raynal@bootlin.com>, <nagasure@xilinx.com>,
        <vigneshr@ti.com>
CC:     <boris.brezillon@collabora.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@amd.com>, <richard@nod.at>,
        <amit.kumar-mahapatra@amd.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3 1/2] mtd: rawnand: arasan: Update NAND bus clock instead of system clock
Date:   Tue, 28 Jun 2022 21:18:23 +0530
Message-ID: <20220628154824.12222-2-amit.kumar-mahapatra@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220628154824.12222-1-amit.kumar-mahapatra@xilinx.com>
References: <20220628154824.12222-1-amit.kumar-mahapatra@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c5dfe78-1db3-4f4a-6118-08da591da953
X-MS-TrafficTypeDiagnostic: BN0PR02MB8174:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7i7IhraaM+tCvcdZ3Jowv9i4YU8+BfZeZParhVn1zLFrFb5mBftBvQ3iu3/MYX1SNHeglDMku4Zr7zTLTwAYPOSG4KDS8UG+q8p7q/pRgHvdj8y+jpDBwuJ7fTUJ/ZP/31hWAPxj2RnL9oKlCrEiWHPuS2C8NJiXko8MQNaYvXn6bDwgidhuabLoZdZOhXpwsmJDvLOsjA1ecovXyepS1tjfnXYzm4NGUaDysOwFx1OfAIc+aPY/ybeI1iYZibTB7fZQx3DjDwA8BxPOMPj8cOJgrw/9aOycyPmYtqshuFQCegEwt/Tum2Q0WEvGb0sGTEHvCERb9zbTjZ28/9NAcmOBBcLit/PsCl02emkUqi9LZ110XhstjndOIjHIVyRMAoDAzwNXcd5Vw7S1sKnPfsoJ7LQGxPCSH5KXdQTqR52f+iB8PD+fmbfDPNl282PRmt7wnmjKAcsR7MGMjMzwpFUuzDEm+9r/13gMtcpOkSwd0R901lqdgFfcMi3qh4N3Iyfg+XVEoOtBrCeOXh3uVHZ2we2uTuHykI7ncIBWKLf5KoZtSfOhCtFnRknyCv/yvRDspInxCVpTfCTNJ+/nZBYIndtXGZfCZP5R7M0b9+jNuLEp7rmTP60j2+tJFr8xB+mslBys6maq+2ZPZnXxi4/egRlPV3BsvVHk0mx9uoJpRFpPG85gOL6BrhyKtf3jmuADUJmzIMAkYRayQG6F1IvSQaARbHTRDN84ZOXOPkKdE5ObKkKESlo69lMXoMqWLwPxLxa3nefo6s9KONPUm9qRMq7dcSLnhL0H3uHkQGT3PFWf+KIFhhabbHmnikpmVRU3cmtzwRXGHS5FUYg+w==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(346002)(136003)(36840700001)(40470700004)(46966006)(316002)(6666004)(70206006)(70586007)(4326008)(8676002)(478600001)(110136005)(54906003)(40460700003)(40480700001)(8936002)(82310400005)(9786002)(5660300002)(15650500001)(2906002)(36860700001)(83380400001)(36756003)(26005)(82740400003)(1076003)(2616005)(41300700001)(356005)(7696005)(7636003)(47076005)(186003)(336012)(426003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 15:48:35.4677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c5dfe78-1db3-4f4a-6118-08da591da953
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0031.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8174
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In current implementation the Arasan NAND driver is updating the
system clock(i.e., anand->clk) in accordance to the timing modes
(i.e., SDR or NVDDR). But as per the Arasan NAND controller spec the
flash clock or the NAND bus clock(i.e., nfc->bus_clk), need to be
updated instead. This patch keeps the system clock unchanged and updates
the NAND bus clock as per the timing modes.

Fixes: 197b88fecc50 ("mtd: rawnand: arasan: Add new Arasan NAND controller")
CC: stable@vger.kernel.org # 5.8+
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/arasan-nand-controller.c b/drivers/mtd/nand/raw/arasan-nand-controller.c
index 53bd10738418..c5264fa223c4 100644
--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -347,17 +347,17 @@ static int anfc_select_target(struct nand_chip *chip, int target)
 
 	/* Update clock frequency */
 	if (nfc->cur_clk != anand->clk) {
-		clk_disable_unprepare(nfc->controller_clk);
-		ret = clk_set_rate(nfc->controller_clk, anand->clk);
+		clk_disable_unprepare(nfc->bus_clk);
+		ret = clk_set_rate(nfc->bus_clk, anand->clk);
 		if (ret) {
 			dev_err(nfc->dev, "Failed to change clock rate\n");
 			return ret;
 		}
 
-		ret = clk_prepare_enable(nfc->controller_clk);
+		ret = clk_prepare_enable(nfc->bus_clk);
 		if (ret) {
 			dev_err(nfc->dev,
-				"Failed to re-enable the controller clock\n");
+				"Failed to re-enable the bus clock\n");
 			return ret;
 		}
 
-- 
2.17.1

