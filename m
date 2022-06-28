Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E8655E6C3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348008AbiF1Psv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 11:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348034AbiF1Psm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 11:48:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F091B23165;
        Tue, 28 Jun 2022 08:48:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPvJk3axoscwMMJ6YCf0A+/nuuPXx6P8S+2Lvzufz9DG6mKiRGpxmgnXf+nbgewsSyo+EGpb1Jt9l/ZxymV0WAnTjSjhgJSRfBq8oc3/FT7PCX5vmy2fcYP6nSP2AHWr2wqG9C8UmLIHDOA/EutgmCW1WxIGeBjrY5gHIqHSDWllYac5ScD0IDotNNemCkz0+MTujdSmGQjBxKdVZTMnR93jlAhACW5502VljyJWE8XcnPJddKi6AOYe6lH/CqJf5G47/o88R1djxhKn7nJb8OihhCiZ7jRPLb19B6yZ6B1AKNbjg4c08dMiwBxe7RfJTPLe4yGLsrEWkrn+zPwdsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06A6iGcl/wfm0nT5KwMP1gllxN6RbErAGeuNtlHvzvU=;
 b=O1uaVLRyh+1BF24hFzJpgnAwx0WSEDJWiFrweR4ugOAt8WaZ5ax+RWQVXDZ/cORCZ6jUdmiUebf042vj7jmn5fDCuStCaik6sVKxdju4dSp9wOtwSg/qS3kSnKdESZ3XE0Dg0vEvPnCJE2peDpKEtUliSow0Vfgh/VSHeBJvhd/MGQM1gUhEd0hqjgXZbVxbcotw25dvT/lcar33qex5SWEWcpfoXcyhXKPGJdxLIbvOCJSJdow+3atE+bM4/55fH8JN7adV6wUNy5BJRjkTx0pJ2PRIeHodzLhfhqHcufFrWL6na1dy3CJW6keATSmJNcnODqPIV5SerzYXX3SvWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=bootlin.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06A6iGcl/wfm0nT5KwMP1gllxN6RbErAGeuNtlHvzvU=;
 b=L3IiVgfDo4cCWYQcyfZPiyyxrjSlZX/e35/WVGoNC+h0goEOqXPzwkA5acWu8SjaNuJRD10qmBlDgPui+ihqHMQiLzAuhlzIUAiIynAkXFe9c7CMmY6Iow4CWQ7WmTa6aAx8+8sg5GZfxQF+mzZ/xR5ATGbqQNLTxWmsxzF296A=
Received: from SA1PR02CA0023.namprd02.prod.outlook.com (2603:10b6:806:2cf::25)
 by SA2PR02MB7835.namprd02.prod.outlook.com (2603:10b6:806:142::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 15:48:38 +0000
Received: from SN1NAM02FT0053.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:2cf:cafe::5c) by SA1PR02CA0023.outlook.office365.com
 (2603:10b6:806:2cf::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 28 Jun 2022 15:48:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0053.mail.protection.outlook.com (10.97.4.115) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 15:48:37 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Jun 2022 08:48:36 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 28 Jun 2022 08:48:36 -0700
Envelope-to: miquel.raynal@bootlin.com,
 vigneshr@ti.com,
 boris.brezillon@collabora.com,
 linux-mtd@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 git@amd.com,
 richard@nod.at,
 amit.kumar-mahapatra@amd.com,
 okitain@gmail.com,
 stable@vger.kernel.org
Received: from [10.140.6.18] (port=39110 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <amit.kumar-mahapatra@xilinx.com>)
        id 1o6DS8-000ELN-Ds; Tue, 28 Jun 2022 08:48:36 -0700
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
To:     <miquel.raynal@bootlin.com>, <nagasure@xilinx.com>,
        <vigneshr@ti.com>
CC:     <boris.brezillon@collabora.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@amd.com>, <richard@nod.at>,
        <amit.kumar-mahapatra@amd.com>, Olga Kitaina <okitain@gmail.com>,
        <stable@vger.kernel.org>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Subject: [PATCH v3 2/2] mtd: rawnand: arasan: Fix clock rate in NV-DDR
Date:   Tue, 28 Jun 2022 21:18:24 +0530
Message-ID: <20220628154824.12222-3-amit.kumar-mahapatra@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220628154824.12222-1-amit.kumar-mahapatra@xilinx.com>
References: <20220628154824.12222-1-amit.kumar-mahapatra@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c9cd016-968a-4c04-2099-08da591daa80
X-MS-TrafficTypeDiagnostic: SA2PR02MB7835:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nE1qpFuko43JNFn5P//HC6+OCXRoLunTNQwNLm1aFen8BtqVef8O7iIpsQcx/utRrpHmEcTh+t3Dq/HTknvNQ4Dpq5X9zhY3jpJQiRBmC+rr/3jnE2bftzphvhU6Dq9DUMJR2WBIRoHxu8Gq8XQHJipFQc4E0bxq+K9UnjIje+iufkbgHsTKWVqc+chdF9vO3zN9Pq2YO3t7hhYROVCY3MLkbAm0FqEI/LSW59p147z5UFqLlDoMoQGeUeZ8PD2CJvlf0yPfSXF3EUnPv7X0n4vOxCKrDu8vv2hJNWUz4XXxeTaPRZrnLOT1e6g1+jX39jYnF7C54kHuCHUHDEY5yIiuhGbiZybInmXi8Tzw8C1QkmTaabH41E1phPxd+YNGwqdpJXsZfbxg5FfdCeXX4oJISr/wgYs229zsawNRL85a5+6bEOllom3eu8mZNRyDR+qfOenC2t15/b0sup8YP3IU1zM9pRlUxeB3VuMjW62vFzeBWL41m1aRNwfat+Z8dN05b8Ey4eK1ZPtK7D4L85Brh6uEFZustCkrA7ySGSmcO1cDx3SQRJsZ5olz00FXYzrTNC80qt3e7DantAkXJqSdqIDEQpTzkngoZybMK4hsqMrjCJvhicJpihOElHhCQs/8aDMmvPtr4wlLu2aBQYPxQwe1AUbmrhCAoizya0KeQ1c+VAkQrkA9ZW4BcmNYNETHpqC5yoLaDpNhg+/0eq80KpOVtlk/hTx1O17ndaZtwgyEXNoDsctPsws66aGHRMuh4TITfyqj35PUECP4e0niZb421aPzKaJLoAzKZrnVz/hX96w2S7OR2dQZr98kJaJPtxNbgcUlMxGTM6nS9w==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(36840700001)(40470700004)(46966006)(8676002)(70586007)(36860700001)(4326008)(70206006)(40480700001)(7416002)(41300700001)(40460700003)(9786002)(26005)(6666004)(478600001)(7636003)(7696005)(82740400003)(186003)(2906002)(36756003)(356005)(8936002)(82310400005)(47076005)(107886003)(2616005)(110136005)(54906003)(336012)(1076003)(5660300002)(316002)(426003)(83380400001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 15:48:37.4856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9cd016-968a-4c04-2099-08da591daa80
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0053.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7835
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kitaina <okitain@gmail.com>

According to the Arasan NAND controller spec, the flash clock rate for SDR
must be <= 100 MHz, while for NV-DDR it must be the same as the rate of the
CLK line for the mode. The driver previously always set 100 MHz for NV-DDR,
which would result in incorrect behavior for NV-DDR modes 0-4.

The appropriate clock rate can be calculated from the NV-DDR timing
parameters as 1/tCK, or for rates measured in picoseconds,
10^12 / nand_nvddr_timings->tCK_min.

Fixes: 197b88fecc50 ("mtd: rawnand: arasan: Add new Arasan NAND controller")
CC: stable@vger.kernel.org # 5.8+
Signed-off-by: Olga Kitaina <okitain@gmail.com>
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/arasan-nand-controller.c b/drivers/mtd/nand/raw/arasan-nand-controller.c
index c5264fa223c4..d4121d1243bf 100644
--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -1043,7 +1043,13 @@ static int anfc_setup_interface(struct nand_chip *chip, int target,
 				 DQS_BUFF_SEL_OUT(dqs_mode);
 	}
 
-	anand->clk = ANFC_XLNX_SDR_DFLT_CORE_CLK;
+	if (nand_interface_is_sdr(conf)) {
+		anand->clk = ANFC_XLNX_SDR_DFLT_CORE_CLK;
+	} else {
+		/* ONFI timings are defined in picoseconds */
+		anand->clk =  div_u64((u64)NSEC_PER_SEC * 1000,
+				      conf->timings.nvddr.tCK_min);
+	}
 
 	/*
 	 * Due to a hardware bug in the ZynqMP SoC, SDR timing modes 0-1 work
-- 
2.17.1

