Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DAD3B9DCD
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 10:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGBI6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 04:58:05 -0400
Received: from mail-eopbgr00084.outbound.protection.outlook.com ([40.107.0.84]:18311
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231158AbhGBI6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 04:58:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMupEbwMmXaw3UUfWgbhWvww/1GkTy0mymaYjLfUScQDL4uor7VNhz/m8jOmVYOiu2BwXjRs2NmQxZWF9LjSTgoOXcVOMjL34+wazHD0DTh9IyFzXzoS5I1bGiKXnPHavFqWnNX+QF4PWK2Rv+ej+PwvDfqY7yj5VWaBiflKoxeC6PkRu3hIUpXgFBf79vbbRqVo6EFLmUNzOKw8i0apAAOUf+Y7NDzU8R5Xdpmnx+SpHGUUXDHx7nFjgUwZ1nqeMIKnH33Zi5Yq09zYVDNGGwfyQZ1S1FJm/eh5AtTU0Pb+IFGHrJwxmHL7dlZv/dGVrlScyC49uuNRZfHNDNHiyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnzN4vCbErc2XiRUzXFYu9XUUtfOTLLqJiZrvFHn+ak=;
 b=bt+GWmCDpuRLZ6W5BjyVmoNNNSpyy07c9cF4jLQmaxc/S7ekbngguOSpqlmNqXhUvfy/TzG0yO+BV1wsbz7l8R5bWH/Qk7pXZNiRChpWeMmJyK7vOrQCUQ5LYn3FIkkpDtQN6zlLVdfdjS13XZ9u/IrZBoHZXXtTKxkyj/IS/FvUkTWccVtxkYj3gaGoGqFNnIeiSsYVQEWb9Sr0bJqH+94/PLJ3fZRLPhxoZLqBv5fZi7OXzN8JiMcMWON39cI1/S+ixXsNK1OiMYyLW4nrJu+Fe8GdhvNsLFY9CpcwscBWpOPT8sWjhSuCztZs4Zipw2GDIGBKTIYmlCVZThKttw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnzN4vCbErc2XiRUzXFYu9XUUtfOTLLqJiZrvFHn+ak=;
 b=FfLLi7wojwWVCVE0zHSMiNjBR974a8A0DdaktgESh0FsL5OG8WRZdAnh8MJNdcTmdxHVUu6FtThUn12kGV/oZky9caRZFCyKheYmqcmKG6Ys8TQp/XMh7CAz0z+hnotXQraeVzTRoyjHWtVwrQcLPILBjxc4jl3bPkD0NaFT4Q4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by DU2PR04MB8680.eurprd04.prod.outlook.com (2603:10a6:10:2df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Fri, 2 Jul
 2021 08:55:31 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::9daa:ab21:f749:36d2]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::9daa:ab21:f749:36d2%9]) with mapi id 15.20.4287.027; Fri, 2 Jul 2021
 08:55:31 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     linux-clk@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, sboyd@kernel.org,
        dongas86@gmail.com, shawnguo@kernel.org, kernel@pengutronix.de,
        abel.vesa@nxp.com, aford173@gmail.com,
        Dong Aisheng <aisheng.dong@nxp.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] clk: imx6q: fix uart earlycon unwork
Date:   Fri,  2 Jul 2021 16:54:38 +0800
Message-Id: <20210702085438.1988087-1-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [119.31.174.66]
X-ClientProxiedBy: SG2PR02CA0087.apcprd02.prod.outlook.com
 (2603:1096:4:90::27) To DB9PR04MB8477.eurprd04.prod.outlook.com
 (2603:10a6:10:2c3::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SG2PR02CA0087.apcprd02.prod.outlook.com (2603:1096:4:90::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 08:55:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f45c68e2-4e70-4deb-af22-08d93d372576
X-MS-TrafficTypeDiagnostic: DU2PR04MB8680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB86807323A23459B6D860942F801F9@DU2PR04MB8680.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vVSenLjwqoSnDbdj1bLCRvQp7iDHfbrp4YNUok9sMIeZ8PScL/iCPmLRulkPQ5ySSGP7XL9K+yI6sZWd595Fs01iNepq0Pz2L0prmShJCJwyD+iK/K8ApzE9FBfIUEE23HoWZaDPam7O+ZRrpZov8tsAagfDnw1JN/HIcIY1eC7kyxyU9b5ybo6c5uiggy3eDaq4zPyiX5ikN02zCoeE4mXhuuvoxTv6JtEsxvw+HmzO9iQ/Qmom/sc0TCn33kIBNyMx7dZ1oyWUueZyHhxVB67CmOm0+ykx0wEv4gUNmQqbP9B5h8QIvOlGCDkHtHjZ65lUXu2IIfS8C/4ZFgZ3rM9vRiVoU+dnblSoymvv6aVsbFbIXjR7WKscFJQAg5ibnSXq8uM12mut0ZQb21t8rBdZUVv+QPMFwgIQddjDu86hvN1SUM2KBWsWlZzSUnMxShQXK5or/79m9sPv8YqQMo96lsBN4SWuvtA6AbOqnMPhTEwNg98HGY4VQhgupLPBnhnKDGMymtc75hJXu0nmBzFUD8zEc+Y6hX+8qjJXNNNT+N2l6/oVf8b0LP5ZYQXG3g1hL8AO4dtBjXxOKxG1Tewims0qaeJ8Ek533asH/VwfXrQ06uHiD6VIxgCDgaCp5TVFZhYm59h4Vu5NC75dpeOQGmhQCB0E8c55u6cUPzGaaY+bYf63vu4han0zXHeAnxjBZ75I28PyV+37GfhGFEmuNskjlzWcOANcu5SCQET5IzpY8XAlFULC7LjTohi5uNpZogvhgb5045CPnncJig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(2616005)(6506007)(316002)(8936002)(38350700002)(36756003)(956004)(4744005)(6512007)(5660300002)(52116002)(83380400001)(16526019)(186003)(38100700002)(4326008)(66476007)(6666004)(6486002)(66946007)(8676002)(2906002)(26005)(1076003)(86362001)(6916009)(478600001)(66556008)(69590400013)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UK6AY7VHiVVmm4sV9FAVZm9XY7nWygaCYL9V+yXG/WS73ZHL0wqoeUUe8dXO?=
 =?us-ascii?Q?jZlSOZjcorZ7KiSF9ZSnt+UI/asKPoBrD8UyOLv/ouMAOdOHseafqXTJ4MsA?=
 =?us-ascii?Q?ckpyvz31f8jTwFZKQU+YtHpJVTMXBU3bMvUw0XVxzKd/uSDA2pSHwCTVqdP6?=
 =?us-ascii?Q?O6r/uT0lqVIA4cGqpISo5dkE8NdsdLaVHhyfNVn2upm0Jw1a6evJEZMblpI5?=
 =?us-ascii?Q?X/X9HP1cui06Jh4JULmlzMveXl52YBIoL7TUjlkAw+Rf+Hd+2dD+bjz/8Xaf?=
 =?us-ascii?Q?CT5XCZ/oz0JtM99eofzdd9CkLInsu1Ge5CuiALXFOu9qJC2D25Cswmi7YU+b?=
 =?us-ascii?Q?PAAqjcHNCPjmTWPOgkLG/DE7+2ZnlgDzSlz5pRwo3cl/NejVwGbyEay3fATz?=
 =?us-ascii?Q?TJYYbfIBS4WmDyR99i8opTtbl+3JODm2u2ZXdc9xspyBHx5tu5Jsb9X8v6Vg?=
 =?us-ascii?Q?cLFYwS2W1M+CXskFO5io8gS8tApPGiNQDCVqjeTjNjfklvcMLSCbYHlcuCdm?=
 =?us-ascii?Q?XonrcSPxVNvfWt+p10/S5eN8ZT/VekIILXoN/bchm6OxlrmkHuxboffecTua?=
 =?us-ascii?Q?bOxzuidfCNuSBQelLit8e2DEl27/z1QA8+MnUe88pPso0DpSovtf+6oXS/d9?=
 =?us-ascii?Q?nQkIFHAc7QDU1+yk2+H/1qlghFcHN0who/6y34aaeq8BXUnZ8hO6Go6vupAh?=
 =?us-ascii?Q?zsyB36GFIO/pfp1vXE9+zU2wQVRq/uz8ILPSxjodKVV8V2ZbFTprXwi2bK6G?=
 =?us-ascii?Q?W8mK1k1JGcDp+IzGmM9Oz6GZl5whu4iXJ0XSJouthbvLccmoHuGI2LQt0A46?=
 =?us-ascii?Q?dS+qpi/CibHVRvvQjdO3fXJ1fvX9bD0DJ6Un2rOdZuT8lo02jvxOc6onozlN?=
 =?us-ascii?Q?JBiNJrc0N5SydGKcFdBcXtecOllJOr0gVFvoN3D55UBu8M5EETg/1sjAOLPM?=
 =?us-ascii?Q?uH+ZiJ+sUiEC+suV6pZB1Q12Coc2Hpvhe78TNQkBSCovpIeo4SQTBM4HZ8TX?=
 =?us-ascii?Q?vChpWy9l8yebkxCvvqENsBecxXMTkw1t8Fbp80OBxO7eAWcCl8oWFF8eeFMV?=
 =?us-ascii?Q?Pg6jyClbVWRWri+s1GtMGehCyxPrfwuCxjy3AtBgxfo8Kpw8dXKGW9NywC49?=
 =?us-ascii?Q?MR4ljnVdq/883xekJJscwCJGG9ALzTuhgjCkxx38X8ykwmiWNJwvgfT+HlIO?=
 =?us-ascii?Q?Qk3Q8X4wAgzpxc1OYDAQLmgWkv1e2Y5rJQDBwkgSQc7fPQeAy5PUI5dMFzr3?=
 =?us-ascii?Q?LavBt/YFYBD9TQjF0mqvH7fA7mixu9euG1I9O8l/dJ0SjSe+WpUCOJ8cUFIV?=
 =?us-ascii?Q?2unYWwj2I/autQs3RqZ6fzMm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45c68e2-4e70-4deb-af22-08d93d372576
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 08:55:31.4529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 84uLicy7/te0UztF3V4Hsr0/Q6cFd4Jy14o7HZb8BuUfzIYQUtBATWFCF5rZ47dLvvOqD+k8+lL14h4f/gZchA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8680
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The earlycon depends on the bootloader setup UART clocks being retained.
There're actually two uart clocks (ipg, per) on MX6QDL,
but the 'Fixes' commit change to register only one which means
another clock may be disabled during booting phase
and result in the earlycon unwork.

Cc: stable@vger.kernel.org # v5.10+
Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated with stdout")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
---
 drivers/clk/imx/clk-imx6q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index 496900de0b0b..de36f58d551c 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -974,6 +974,6 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 			       hws[IMX6QDL_CLK_PLL3_USB_OTG]->clk);
 	}
 
-	imx_register_uart_clocks(1);
+	imx_register_uart_clocks(2);
 }
 CLK_OF_DECLARE(imx6q, "fsl,imx6q-ccm", imx6q_clocks_init);
-- 
2.25.1

