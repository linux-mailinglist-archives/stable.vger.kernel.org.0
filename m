Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6948D5E98A3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 07:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiIZFGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 01:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiIZFGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 01:06:00 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2956927DEA
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 22:05:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUZGRZy/DeKWCe0n2oYpshoZusUqDPPPlfXr7+HQT8769GOCRI0vKi/chph2Fq4Ye1Uhyt1Vk3+8Gk/5CjyuZyaezJJNNIYVGMb89gAXd3hq0mmD9uyLAxuJTfj/kZyBFmacZwzK3bhbCSB+fUs834xhIeOmsUISPpwDwhPkmVw7yXg+/eT1zDmG1Vzl3is43YW06hfVwFF0hT1nfHmfVWeLB6cy1pTua0qau8r5TBYTSDXmvvBALxHgwi940gNP8/gFyBYS5oTXZStRSZAFy5DvUKe5RdlgkaGBgbPh2bHyaAltjYFdgGcFvR3J3WBfP8YPH+gOokZnBQ/KLmysxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8nBoJvKXy47/pKuzyVjYLYE90PjJ9C92NE/hiD2iiE=;
 b=LuWmPR08AGgZAoz2nZZsMFRerZLVo7WdquBif7P+cLSyJU8wwLmL3nNsVj7HP2whZOKvcr93D/yqpK57fDq6wsDF3K/VtynNG9QwxNtRQUWtOPzT6liJ52YHx8yZ0ex95JnMyrzoUkr8oqrINQ1hsxT9Lb4Osp6hX5FkLdkqnXJiY/lU+FmznjUCRUiHdP8/CdVZRScEJCdeYLXPVHJUQo8Xgzf/Nj+gdierer+URuZTvl035EfoLtqFcP5HRR1bAJjPzQ3d08sWnYF0TfbfJMFpuMmhb0Xq7tMJjYQ9D+PcehPfrKreds9QzkQ/a1f+gqoVIEBrIWh/NhcKrZPSOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8nBoJvKXy47/pKuzyVjYLYE90PjJ9C92NE/hiD2iiE=;
 b=THZXGHQ9h5Lwy0lyEolv2JsXJTxezb3jOElwBJdboCd+0dSfiYn6lDYFDnGX26DnI/HP8n4MrMBe/1t5Czt3kRowy0MNb5okLrzJ9fome41azHBHRUJXTs+kqpbN7x176Mx6LKFIA70QNLNbm4lYuhRoXOwGiXzX/CTSq/4Y1ENueyrnsS+mFTZbq3XBguf6DoLFzSOPu9dvu/eHzprltvtuoVXgkaG665V9xHmp8dsL9igiwEKTU6U0TT2iht3X52KR+7miHx2RhcbLL8oEeI0yLtKX02/fMFxqCiNPacVXZfytfvltLX26OFnX/hVEOR0HxpsCaCztV8YmDX7iuw==
Received: from DS7PR03CA0024.namprd03.prod.outlook.com (2603:10b6:5:3b8::29)
 by DM4PR12MB5916.namprd12.prod.outlook.com (2603:10b6:8:69::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Mon, 26 Sep
 2022 05:05:57 +0000
Received: from DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::78) by DS7PR03CA0024.outlook.office365.com
 (2603:10b6:5:3b8::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Mon, 26 Sep 2022 05:05:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT112.mail.protection.outlook.com (10.13.173.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Mon, 26 Sep 2022 05:05:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 25 Sep
 2022 22:05:41 -0700
Received: from 74ef364-lcelt.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 25 Sep 2022 22:05:40 -0700
From:   Haotien Hsu <haotienh@nvidia.com>
To:     <haotienh@nvidia.com>
CC:     <stable@vger.kernel.org>
Subject: [PATCH v2] phy: tegra: xusb: Enable usb role switch attribute
Date:   Mon, 26 Sep 2022 13:05:15 +0800
Message-ID: <20220926050515.133658-1-haotienh@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT112:EE_|DM4PR12MB5916:EE_
X-MS-Office365-Filtering-Correlation-Id: 2800191c-f60f-4a53-991a-08da9f7ccc37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xj1RiCvSOu/OE/Zvg5mA/yChTLgKZk/JUgg2ij3SlLDktKwKy/S35k3Ruj0VGKYikaV2uiirBoRzaazkfV3CDJnQyRIU8zSUhpbR3VOxtbGvdGcNfwrOEoO+pJrnceHEGVo+qf2Gun3NT/qIL7d8Mor8twjXnW19JpxJXhUwkJ3b9JxU2ABw329LnlKvdDOevzhNf32G9HmQWPpo8QTXP4bPpMujgUgN55g7U6o0PJ/m6VXafSxgav93abG8ZOLvFHAU36s3vFoXNQN+j+0hVxjgMfWqMvZ6g89SRuqRzEOF9rkOJSGMsHsSPy5jb2Zbip858KZZdL39CWyArwJA7S+Sxo+la2SBGlEoyMMvZbvV8Gt4XJFB/pJkkYkSwMu/SI5cEHy0mpT9K2Qdet+6nN52Ff0looHkORl6bYLAkNaDmTsl+K+pn+X4PeLtXyHkH8FIa5sZ1Mc+5bySn2OiuqvZdqOXhcHsvDtKGFEhZdJ/AilXpDm+udUlzB2LFovfcbQ2BX0gf0aP5rR0RcuZoglXLqNgBkfC4Zj86hFHYVTme+G20k6PHgPM3Qq850IvuVwuU+Nyw9euCU4OaqSPgBzqb5htHWKoqFXQsK7hSMoedImL/LNC+qAcaiaE2XWpGydgYze3L+PITgrdiYm8yZpBt8842YPtcsMKtG1pSmsysNO6OV0VroyjBY7aGV/C3KlkxI+jU+CSti+b6lWdl+M/djnIm6aKFqUa/1jkEe1G5Y6GaaWlMm+8HE9fR3rXRY9mHELFV94NN28LeM7Yjw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(86362001)(316002)(83380400001)(82310400005)(336012)(16526019)(47076005)(4744005)(426003)(2616005)(5660300002)(36756003)(40460700003)(41300700001)(8676002)(4326008)(6200100001)(8936002)(6862004)(7636003)(82740400003)(70586007)(36860700001)(70206006)(7696005)(37006003)(26005)(1076003)(186003)(7049001)(40480700001)(356005)(2906002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 05:05:57.5740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2800191c-f60f-4a53-991a-08da9f7ccc37
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5916
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch enables the usb-role-switch attribute to have the user-space
check current device role of otg capability ports

Cc: stable@vger.kernel.org
Signed-off-by: Haotien Hsu <haotienh@nvidia.com>
---
V1->V2
- Fix typo and changelog limit
---
 drivers/phy/tegra/xusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index aa5237eacd29..220ab7719ade 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -656,6 +656,7 @@ static int tegra_xusb_setup_usb_role_switch(struct tegra_xusb_port *port)
 	struct usb_role_switch_desc role_sx_desc = {
 		.fwnode = dev_fwnode(&port->dev),
 		.set = tegra_xusb_role_sw_set,
+		.allow_userspace_control = true,
 	};
 	int err = 0;
 
-- 
2.25.1

