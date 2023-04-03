Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826AF6D4F2E
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 19:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjDCRj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 13:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjDCRj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 13:39:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B831FF6;
        Mon,  3 Apr 2023 10:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVN3MjuR1cFIvVkWC3S4atjHks3ikxWA6uhNWAJ12S2hlD1z6r1XewVpqquwIb7gSv4BV8Y2OmT82vJpM892ghK74JMGEyOgwRYpX5XPQjz8T7IO0itF/4KARRuZnNlQFyzmH2ClW+VE/zvaavHK4ajryT22mxtdl9ZATh8owbKhD+Ze8hpNNGhIXeH46CAW5VwdaMR5WKJSk3PPE12obbTUw6mD56Clj05O2CZoyoC8VHnt/TTllEPyIw80a2LWsMY6avdddqQEkxonho/j7Mnj3O6o8WdzlukijFw8T/BDdGyQgHb0OAiMLsHSHdeT4DcYq0Y8HH9mezhzFmxIlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WLfqtdhKVlDbza9ugDR5vvk3ha/7LN2PAG5oSykpns=;
 b=B/huIFIQ1livJR5ONttQTiyKHla+OVuZa/l0NMWMYjljI0C6pNJk7lQWmxz7QbaCqDez4H2sT/pNtD2IAKXnFi2D0/6nM7iPM9pbbXaRz9EgRuqgJIhIw2BpB5wzNGJ2vrMPTwX9B9njMcUWfn4U9iuHx2p0DyOoVQ1t0PMca8fAzs3fvpGFJn2L3zb/gMufc7Nc4CyK1jGfTgXKruBGvlHcpnHwRl8PcjRQx/6z5g6QdWGOUl7A6TTFH0uHiDLRTVaRUsmLf6vMZ24lc/Phfqrt/C6Y2pE7IyG4Rynr6kY+9b3Py6K5bT7t4F0j+6Iiikb3Oh+JkD6fGDfniN4Ggw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WLfqtdhKVlDbza9ugDR5vvk3ha/7LN2PAG5oSykpns=;
 b=v1FVhXBEvYw9fQ7AnP4X10RxtLFL5tuTglVMNkTDmig9A4Dot9HWgzVDa9s+h2snvTPr0LIPynZz3N2KAPGwPlcRg+RJgLvTpAIs7EF1YINIni4wPrQScPLGVsSQ7o7ZlA1PFVq2wfCvHxJH5PaEXujoiG3U3BAKNCFqrdmdKAk=
Received: from DM6PR07CA0082.namprd07.prod.outlook.com (2603:10b6:5:337::15)
 by CO6PR12MB5395.namprd12.prod.outlook.com (2603:10b6:303:13a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 17:38:24 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::d6) by DM6PR07CA0082.outlook.office365.com
 (2603:10b6:5:337::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Mon, 3 Apr 2023 17:38:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.28 via Frontend Transport; Mon, 3 Apr 2023 17:38:24 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 12:38:23 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: ccp: Don't initialize CCP for PSP 0x1649
Date:   Mon, 3 Apr 2023 12:38:01 -0500
Message-ID: <20230403173801.2593-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT029:EE_|CO6PR12MB5395:EE_
X-MS-Office365-Filtering-Correlation-Id: 9142c4b0-013b-4341-1dce-08db346a3a02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bG09NDtU6pcBWB84tGmnyw8uFA3Q2bUOzk1wDwHVMjF7Wc1Y2pfd1eX94NQ3r8obgYdGpljgOAd0gNiBzROnwQedCgO7QzHCpiLjU44yXGDL41yndrb7zHfLaJ/9qtb/epLZFWJKiovrAzAVle2FqhbdOqyVw6WzSOp9qr5SBLcx3vKUpaYVquWAYDi7tTgQ2xBPKpb4D4i+bhtFenUvIgK7HTcxLCZyJ63xkO/0u7BiF6Fnq1RvMVB1RvTdwtQEhfdDHD0IOA329FgD31If490gBmv7ukKk41KWFnjpwAkGrnuo4QF32+4NCOsDckuL7mZpCIcObRM41MBix62ctFCHsZmq6EQ+yYXX4oAAE6MBpQd/jqJIZf0wGpX1IgYn2yvAiYlY/MmjYFp/1u7o662c58z8QsagR7uqd+521/GGqIvCCnT0485f1vYFuPWIc7scdm2Rqn9lGtgXPa2818YKihqgY1fWqvPjJONef8n8gEAecoufYbncEH63sTJtQYPZnXULzIk149IyFMtV4WFEKd1fVlaWsBDfwjxOFqAaswdcDoJjPhgMnJdCY+72rEZW9zbSp+JMbMFWzinM5hoOCckV0iOg6VH07A/BVc9jnlmIi/U4/2emRbgEEATmsLYfMlU+WCQ5t8IaD8wlGMIS7wsjzHnYIm1dEjxCubykn9GpHX/3G1smka321g+jfpm1TNvFfyNuLKIdik94RtujnbZQIpDy8P4nJPD9M5U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(44832011)(81166007)(356005)(5660300002)(82740400003)(70206006)(8936002)(70586007)(41300700001)(36860700001)(4326008)(8676002)(36756003)(1076003)(40460700003)(110136005)(54906003)(316002)(47076005)(2616005)(6636002)(83380400001)(82310400005)(336012)(426003)(86362001)(16526019)(478600001)(186003)(26005)(6666004)(40480700001)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 17:38:24.6670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9142c4b0-013b-4341-1dce-08db346a3a02
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5395
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A number of platforms are emitting the error:
```ccp: unable to access the device: you might be running a broken BIOS.```

This is expected behavior as CCP is no longer accessible from the PSP's
PCIe BAR so stop trying to probe CCP for 0x1649.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 084d052fddcc..55411b494d69 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -451,9 +451,9 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
 	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
 	{ PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
-	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[4] },
 	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
 	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
 	/* Last entry must be zero */
 	{ 0, }
 };
-- 
2.34.1

