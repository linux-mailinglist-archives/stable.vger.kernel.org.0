Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7C3B8045
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhF3Jsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:48:53 -0400
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:13824
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233849AbhF3Jsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 05:48:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT0gD3fswjBfBXGCO1Zil93+mY4j5X0w+UZdXt7EhAzAbRCkJKfu0r+74KhSjyjXb2O1k11pIKSJfxKEwSw7YV5g5cKrGMTfV5HKCgazqLMcuZwmedTtyvYiD7hZqS+C3xsY1waeY4nalU2tUBK8KQxLkrg3FWxaJ0iDM+CEwjtg5oOa9lXv0YUzaNWt+E5cFqAD0UxCcUjCUr6X1IXlw1X6b6XGHZclohsYzmdlT9DuFJKQoymyf4QzQZfUiR4ZkLoc+FvqQn4zI2ZYI7C2gx9mgSwYSyF833X12Gg2vZUorN5S8dTA35yThsaeFD1IavqPgz2jQepRes+Zu7g9OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYxRuYI3uNDG1f5jYBr+msiZ8/j+R6rQWJfEwtvmcrY=;
 b=kG0Xzz+A7i+Il8TJ4cHny2yDGTXpP8nvz5YMO+CGIoaJhxmdq9RNRcevzEqIWNg/hz3nh0svXkRNzxVLhSH9GnzBt7KGVfpEgMky9slNwS3YYjUY7tz127uEFoWxuI3gDsXq9MowuD3UtHYON8ya5/dQxWbk9JjudX4ybS1ns7qQ6kmwBeNcFpm8xkhSN9PopYqRPN+o/8CJTujdfmZ075aHV0UNQ07Rzi93O5LIO2yaNjT4tPncJgL0CSvAuwu7hIkhSwM/XFxJ0ZsW7oDwaTgyeXiSA+sgS/aK5Fd22ZWJ7bXbQyWha4WAjARny5PZnGaR1asZ0+3QlMtLzWaYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYxRuYI3uNDG1f5jYBr+msiZ8/j+R6rQWJfEwtvmcrY=;
 b=BjUtF//UV+ZBlVkOF+t7+JD4rKb/jtkg+3Vzk7DGgwV9hOc7FaEZkiwBW5IRI0JsJ7PP8NJi7MQm2YCnruDgI9y9nnA4Gd6R8VKkyfzJ0caojsDmThFZHTCQI4xyZpMtPnq7HUL0BpZ/Od2Zoqlww0DlzxleX/ToHTSdAPnZ9ekb6evkdrlxcdO4c/fBGiSSER9dnJ0TXp2txVRSboJZs1N4mVAgI/ObJ5gy+AcnCXrmPmCUOQ4Vc4GE4d9/zLW5b741mE+wWqbUV6PrZaRHMhyV6UwZzY1wvQeSCTu7HpaTrI0C2ZRVYQn8BQ8b9KXoRZuBveXFQZWXKvOjWdQumw==
Received: from DM5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:3:7b::13) by
 BYAPR12MB2919.namprd12.prod.outlook.com (2603:10b6:a03:12c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Wed, 30 Jun
 2021 09:46:22 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::79) by DM5PR13CA0027.outlook.office365.com
 (2603:10b6:3:7b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend
 Transport; Wed, 30 Jun 2021 09:46:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Wed, 30 Jun 2021 09:46:22 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Jun
 2021 09:46:21 +0000
Received: from moonraker.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 30 Jun 2021 09:46:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        <linux-serial@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH] serial: tegra: Only print FIFO error message when an error occurs
Date:   Wed, 30 Jun 2021 10:46:01 +0100
Message-ID: <20210630094601.136280-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35674360-3272-4e52-2618-08d93babeb42
X-MS-TrafficTypeDiagnostic: BYAPR12MB2919:
X-Microsoft-Antispam-PRVS: <BYAPR12MB291937356A57B4FD8888B715D9019@BYAPR12MB2919.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PaoqJbnJOW7cTQYyUz4ATbeJZQ2W79maV/XfK81Rdnft4owOoPYdB0BAWkXQLrL3y5uYyiIoO7JCkaKXcFE1o4K1ScO/cNGJJamzS/xEpzXPAILAcmSfmMa/T3v0izKLNfP0Bk8IJiT/2zFMeSvh7tZWv8lUkY2gc1y3AK6RYHbLWVoe9d8PdE7hJ3YdgTCGZWCAnVVqIGQmyxksZCF0gO3jEMAltrpaeeRZTOma2Ks8yUwIG0s7ekhau3xkNx3UwOHahUPOgPl73pcm5oTH1yx1auA1jw7czuXoJuwWdcnQWqXCDUIlwAl/OhjXpdUtAA/HCfhuuO14xCFqbTLrJ0OeK2IMNoVq5srfQpjIPayXUGLa2mFAChb9DFUjgiQQin4TgO+Qo/sckwC/yzLm94wtdMK00EkSkE4o9YILtXjZ1wTV3hmaU7wY589lb/tb5DM7EP10QToC0lP1W/Ewb7sNRkBJ7gXyCxKkCxjMdkF62UyIRdrxGmQkX15dk/b00JmGofKSU1/tbibgnojVtOysFj750BMPmzFFaiLSmfh+T7AbXoC0Hl8or4HGNzbg6w/HWXvEoVzzQvfKlupWnfC3CteMenr13Nnv8cxueDx0X0Lc/bOc4KXcNZl6ZY1bupmmmBsHI6PDSIQtsrUEOD2FbW4TpVE/LnRzuWwJvPmtjVmXZ/M4Gkfe0UVXhbZhmVobu5f1HK/1AzxVfEs8eg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(36860700001)(426003)(54906003)(336012)(82740400003)(110136005)(316002)(26005)(82310400003)(186003)(83380400001)(5660300002)(47076005)(70206006)(6666004)(1076003)(36756003)(15650500001)(2906002)(86362001)(2616005)(7636003)(7696005)(356005)(478600001)(8676002)(70586007)(4326008)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 09:46:22.1103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35674360-3272-4e52-2618-08d93babeb42
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2919
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Tegra serial driver always prints an error message when enabling the
FIFO for devices that have support for checking the FIFO enable status.
Fix this by only display the error message, when an error occurs.

Fixes: 222dcdff3405 ("serial: tegra: check for FIFO mode enabled status")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 drivers/tty/serial/serial-tegra.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 222032792d6c..cd481f7ba8eb 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1045,9 +1045,10 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 
 	if (tup->cdata->fifo_mode_enable_status) {
 		ret = tegra_uart_wait_fifo_mode_enabled(tup);
-		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
-		if (ret < 0)
+		if (ret < 0) {
+			dev_err(tup->uport.dev, "FIFO mode not enabled\n");
 			return ret;
+		}
 	} else {
 		/*
 		 * For all tegra devices (up to t210), there is a hardware
-- 
2.25.1

