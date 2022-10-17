Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92451600FCF
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 15:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiJQNDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 09:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiJQNDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 09:03:32 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD175FAC6;
        Mon, 17 Oct 2022 06:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEr8IB8G9EZOjHdo7epYbU0XfxYA8dE/lWPmSE8xPlFiI9srhOEMthPo+S9NSwvLVCGq2hSSxvRu58tr4g8ZXCc2Pyiy+S2w1zSM2Cwt/92OnV9Rnrautejc4gZSFnnaDfovziSWM4Za9ahy/iLUuUDPohc3/y85iX+2+hg6kH1EABYCOJgM9e8GKK9DfrIJxDYiS7wxuOirvoNsa+70VTnypJGkWbI9VBHSj2t3Fg7HCYF/eSIJS0AwGVUQM8cMbKZMgpD3tayBrmZpjJ6zxyiNCPzNznAKWlU3S7ViyGjozn4+o54uBk5TLpY1Z7UoUOr5d8m+XX3EHpkvb8zO/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tV2/cZ8ENmRlzU0AeVgTrKzp8Y+7xxQF013lwQaAL6o=;
 b=fx9dkwjmlowjHXNOMjRkWp0Ehi9p9Mx0D3F6vGNx5JfF0EGUgIj02DBVBP4nKoefAapnyCtu7g5ums33xowCZRGp0ZDpRfdRokHz0+CdqCYFBb5+eS/O0rr9w8oM2pikWX3evpoUc9XpDzeSoBsS+jBstElsU2AA6YprWTZ600Oq41w+zanUV+QjsFEywtqi0PrDeVX0QmVHH/Ailjt/TxUb8UM5HhPhrwDsV9711CKQe/piKUy1lTRdAnN9x0mRM1s23Dbdt8FrnAw20wub1h9DUuqCDZWOwQILkS7HFB2/u6au4RqQGeX6tFQEV+QI8F+57eNgRYVDOMsddtiLWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linaro.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tV2/cZ8ENmRlzU0AeVgTrKzp8Y+7xxQF013lwQaAL6o=;
 b=kZ9Tid72nIfY4N3XnHE04gstm3N4oGLVq+o2CP2/YnfEZJswWnxkIJYXRs2xM42P73GNx1qgQ+ZNxR/rsuA6E79Dnflr9FbS/z/Q271phBVUwT6TaVMERCvVrgmvBvm3lFjTBDbOxLYTk/r1v0BzINoAixSYpV4zUw0CmqU8gas=
Received: from MW4PR04CA0337.namprd04.prod.outlook.com (2603:10b6:303:8a::12)
 by SN7PR12MB7153.namprd12.prod.outlook.com (2603:10b6:806:2a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 13:03:19 +0000
Received: from CO1NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::7d) by MW4PR04CA0337.outlook.office365.com
 (2603:10b6:303:8a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Mon, 17 Oct 2022 13:03:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT094.mail.protection.outlook.com (10.13.174.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Mon, 17 Oct 2022 13:03:18 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 08:03:15 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 06:03:14 -0700
Received: from xhdlakshmis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Mon, 17 Oct 2022 08:03:11 -0500
From:   Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>
CC:     <devicetree@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <saikrishna12468@gmail.com>, <git@amd.com>,
        Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] Revert "pinctrl: pinctrl-zynqmp: Add support for output-enable and bias-high-impedance"
Date:   Mon, 17 Oct 2022 18:33:02 +0530
Message-ID: <20221017130303.21746-2-sai.krishna.potthuri@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221017130303.21746-1-sai.krishna.potthuri@amd.com>
References: <20221017130303.21746-1-sai.krishna.potthuri@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT094:EE_|SN7PR12MB7153:EE_
X-MS-Office365-Filtering-Correlation-Id: edfa12a1-3a2b-4616-f670-08dab03ff65b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QhqgIIdG0ZIKeqKTUT0YtJ7eEkmoKYjCzO6eQ5KcYqfU9WCAGRqjBjcw6PwwTrKZBEnVfsUlHRZQtGC9g7E1GX/XdcCFKzBhP1PQi8wHdQgATZZ1dSv5bQGw58S/jMPQpkWQv487/CJWwY3cJPdaIAtwM1QAVUWdcgwXt2tJGLgVROZoTnOZH851gnARYa3ZArFwq0YwAVK+F1ECfU011KMQAp5IeoUaNnW3E8BZMEy1ShpccBhN59xTVKRKhsw8MkchcdToUbCIrSYT/lLMmkmgrLaZFhtSbUgw2OkjN8ExK+wlfgQG0BSwLzuwAfaIwURRUfUOmVZnsJ+zKtmKG9H8RDxLN3AySC1kKinnB5sq86Rg3uUzofnwBTW1UWWbqfoOaec9F2j8wzDosKC1Fu4BR5jeB5MxkpRgp5jD/EWZrIV4j1g1uArb1d9zUAD0D+t8UCtNzHrrFVFOVHA4J16YhibYASxoSht5cF2eDr+8yYbjDyntF7exeK0OYlAlKe4irkdsaYYAEm7lyHoJvvNKzOzsOJdzK0WPn7xwNXXgAc6SDRqx87xUn0n16+hS5H/VEzS1U1i6byoNAhtai1FGb3olUKyY04+dfEz1wjQYYyB33wA1rVgtV8oH0QnCmH0wzSSD32CACyJWE7wyBIrgeoWGJ7k+TOOxtBzg6mIBeMT8qwhfzO9SlB55wNlu4oE1hG/4ZH/16P/bZodYc+tcN5Dbh72qLA2oz3VyVe6/Yyn1n8i/O9G29odyLY7eEQCaVGWQUvdV0xciCgTl9ogmQ2YffsPZUjrmygUJo4Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199015)(40470700004)(46966006)(36840700001)(186003)(426003)(47076005)(36860700001)(336012)(1076003)(2616005)(2906002)(82310400005)(54906003)(5660300002)(316002)(86362001)(26005)(41300700001)(82740400003)(6666004)(70206006)(8676002)(70586007)(83380400001)(40460700003)(4326008)(40480700001)(356005)(81166007)(8936002)(110136005)(103116003)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 13:03:18.7278
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edfa12a1-3a2b-4616-f670-08dab03ff65b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7153
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit ad2bea79ef0144043721d4893eef719c907e2e63.

On systems with older PMUFW (Xilinx ZynqMP Platform Management Firmware)
using these pinctrl properties can cause system hang because there is
missing feature autodetection.
When this feature is implemented in the PMUFW, support for these two
properties should bring back.

Cc: stable@vger.kernel.org
Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
---
 drivers/pinctrl/pinctrl-zynqmp.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-zynqmp.c b/drivers/pinctrl/pinctrl-zynqmp.c
index 7d2fbf8a02cd..c98f35ad8921 100644
--- a/drivers/pinctrl/pinctrl-zynqmp.c
+++ b/drivers/pinctrl/pinctrl-zynqmp.c
@@ -412,10 +412,6 @@ static int zynqmp_pinconf_cfg_set(struct pinctrl_dev *pctldev,
 
 			break;
 		case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
-			param = PM_PINCTRL_CONFIG_TRI_STATE;
-			arg = PM_PINCTRL_TRI_STATE_ENABLE;
-			ret = zynqmp_pm_pinctrl_set_config(pin, param, arg);
-			break;
 		case PIN_CONFIG_MODE_LOW_POWER:
 			/*
 			 * These cases are mentioned in dts but configurable
@@ -424,11 +420,6 @@ static int zynqmp_pinconf_cfg_set(struct pinctrl_dev *pctldev,
 			 */
 			ret = 0;
 			break;
-		case PIN_CONFIG_OUTPUT_ENABLE:
-			param = PM_PINCTRL_CONFIG_TRI_STATE;
-			arg = PM_PINCTRL_TRI_STATE_DISABLE;
-			ret = zynqmp_pm_pinctrl_set_config(pin, param, arg);
-			break;
 		default:
 			dev_warn(pctldev->dev,
 				 "unsupported configuration parameter '%u'\n",
-- 
2.17.1

