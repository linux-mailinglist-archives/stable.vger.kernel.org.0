Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A8C3B8294
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhF3M7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:59:53 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:6625
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234606AbhF3M7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:59:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6HpxpEABPHe+v/hxt6Z2casdOkScJFMXz4No02k6WzUoaMcmsry2J3W24HUujWNX/x2YiJ09d19T9mGjEW2yBDv89k1qjq/MqF9Gjz9I0fVuYbnpoZ9tQiNe6kQvXePVVl94oDKOiI8Xxl4PK23+VHRm9h5VkD7pC1hMe5kVN/kIDvx49hVEMjCy6KVKlCPuVK8tLEiHEFjuyah7SpZp5AJ6RGsMvBGhaf6Ra6tBLAt63peOK359pW/QLGOAlI1jKrsmfocHdvbM38e1A/oXz6Co1wrehAvkBnNAGZH7tz17mbilt6GbiUIpCRU1Z4Ep4v3r3zX6crOX6/Xwi1XKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSPbnZiRSfg/7Ef8gCrQ9mwViog8bAmh5GHnm4vhM8k=;
 b=fWyeaT3SfHTYYzQOWqjnadpzlhwVzczLG0PtUbNxLqWtCA6l/hTuPdl/kpL8FMuBsbEsjdW684Whr3hWcJmsN3TTQUD7sTEEiAm/wJsugUMqd+fyWqDTgpaDFicQYKvafkXpVgzznVYcXMHz0Mm5/oaAmipoQRv9f7Kocda9tkx7Uee16Wt2v1zlvxoyTMam8y5c8kLFecqmjplwop57fyhm6N8nm2TV0TG96mKyCSjNk2ubhCnPOos8vEAG3VHkHw1RFZLAYJzVQVV//enzethi9ohvS63Jmu8UgV+O3RMCBvR6dTQsSxHCR3OxRxQdQXXzwey/rGqXlHuQfsJPwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSPbnZiRSfg/7Ef8gCrQ9mwViog8bAmh5GHnm4vhM8k=;
 b=q0ysyFzHRq2B90rY9lJItpmm6lJLa3UVMBPVGtzQjvTadVbAgargPFryJ7woF5bOBiy98/jLCL96rqYeGudY3na2ka7qvw9FulaVBhk4VFm70xn/zQg8pDNPotEdUW7rvukD9bNTjNUUhDgf0RyGTHQnegqRo8YGQG3hCCfjTC1EtXt7R+zpyVnSZ4DMjB8HY1+1NQFS6uEBnd+btoVBrzkK9EF8ixmJ6zBq4mbx5MEsdSvEPAIX5F4GpQAbCcbPWQaje1FDgHQTeJeKQ3KKiebuAbXG7w9zs4uJYllLvAY/YUPkMAm0UFiY6Rc2q8GGNla8eFIFu0tgmiZrH6gjiw==
Received: from BN0PR04CA0001.namprd04.prod.outlook.com (2603:10b6:408:ee::6)
 by DM6PR12MB2683.namprd12.prod.outlook.com (2603:10b6:5:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 30 Jun
 2021 12:57:23 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::cf) by BN0PR04CA0001.outlook.office365.com
 (2603:10b6:408:ee::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Wed, 30 Jun 2021 12:57:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Wed, 30 Jun 2021 12:57:22 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Jun
 2021 12:57:21 +0000
Received: from moonraker.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Jun 2021 12:57:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        <linux-serial@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH V2] serial: tegra: Only print FIFO error message when an error occurs
Date:   Wed, 30 Jun 2021 13:56:43 +0100
Message-ID: <20210630125643.264264-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2c04f71-a9fd-407b-ccbe-08d93bc69a69
X-MS-TrafficTypeDiagnostic: DM6PR12MB2683:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2683813732B8CA0A5B09E6F2D9019@DM6PR12MB2683.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hfkNhXA2xv2LjWYYXbf6wtvI/EHswdJSUvJMCXUSXwW/tbyY87hRRRvTKliQYnC3j0gRynTVcPv4xdfvs7Zo1Zg/p2UGDRUF3eA6FNG6pPbm1yAPZ6x+5eIpHp4vR1CHzNtvje4OU3NfOzpxeDzS76oBvVXtzjgABGwB1bsc+XCtsXta1CVkVtrUSOPD8UdCsffFZQyAEeX+SjRl+5mHhd2J+UWS9IZv2rCLtK3lKkBvKioiSPTAFbH6MgfOvc7zXLtdngDV5QMCbCUiTdTkfkJZsyhMSJ/P+iVUrM84ZcfV7ofQ3oXGXRJoS8a8ZGksTKbXw105b0/xYdG9x/kseS4xCp3wwDDz8qsIjUX9QMV4K1xZWRK+7UBcx8nOxemtJM6315jBxRe/O7bKjwBp/huc0FJIk9eE3lZCs2aqVkjElfXw9K9lGn1dt7MIynvOrgivT4hsXRZAGCZMAsHOUPVY1D8QiPXS39iBGAcu+Z0t3MpNhbwYzf872o8Tytmjl9qbtFJI/kASnTax6v+sBIAC6fWrqh2Cf/8WsrSJU373FDPrwQKwu41x9Z6jTFwz1hNxMXi6tmGOP7gvsubcyGP/Y3HgwhvlxYES2imdIcg3xtOnzqv0Fw87Sh9p42aSbZF0so6YwNr0V2YgOhUcmTk4hRpHzh5BxAoLBX1MQ10Ige8RYGIattDS2PT0/SROCt7CvRQB9JQ39qZ56SCTMA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(36840700001)(46966006)(82310400003)(8676002)(1076003)(5660300002)(6666004)(70206006)(15650500001)(70586007)(8936002)(336012)(4326008)(478600001)(7636003)(82740400003)(356005)(2616005)(316002)(426003)(86362001)(47076005)(36860700001)(186003)(7696005)(26005)(36756003)(110136005)(54906003)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 12:57:22.7715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c04f71-a9fd-407b-ccbe-08d93bc69a69
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2683
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Tegra serial driver always prints an error message when enabling the
FIFO for devices that have support for checking the FIFO enable status.
Fix this by displaying the error message, only when an error occurs.

Finally, update the error message to make it clear that enabling the
FIFO failed and display the error code.

Fixes: 222dcdff3405 ("serial: tegra: check for FIFO mode enabled status")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
Changes since V1:
- Updated the error message to make it more meaningful.

drivers/tty/serial/serial-tegra.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 222032792d6c..eba5b9ecba34 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1045,9 +1045,11 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 
 	if (tup->cdata->fifo_mode_enable_status) {
 		ret = tegra_uart_wait_fifo_mode_enabled(tup);
-		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
-		if (ret < 0)
+		if (ret < 0) {
+			dev_err(tup->uport.dev,
+				"Failed to enable FIFO mode: %d\n", ret);
 			return ret;
+		}
 	} else {
 		/*
 		 * For all tegra devices (up to t210), there is a hardware
-- 
2.25.1

