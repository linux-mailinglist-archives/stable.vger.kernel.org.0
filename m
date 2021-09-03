Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E632E3FFA6C
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 08:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhICGef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 02:34:35 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:15392
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230128AbhICGef (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 02:34:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTJ8mUp6DShLmuVCKBXYvfTqRUOb1jSdVVKc9fFfl+jOHhvCZpksp8LjcYzBhjbpiDv0LnmrpRiXkLnf2VT/5UJVWM42xzLErq3sOMjboB6bDLdQ6a6epoYNzgyZeTtgDpkEcGU7XC88Um8uEbBbXj8Q9FyZWJGgiDxB80o1aIBIofZPrqOgw2uehvqrkDm4xksa1iGGzcY4lwAejCvzxxnWP2VSaqT0sjQjlO5vCZ5f8Q78ec9CwSmz8ZfcpFA6qPyyAXd1SILVhsC8tR1tICdos0Y9oHUrtQej58DG2rs9x5NCPSBWs8TYkXzIDeozhO1rvnchJZb8R17+GKI3AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=y1cUm9U9TKymOIG3px+NPHFpMhNVugswVzVQ+KaXYXY=;
 b=ZMPbJy42lXy2euxgzeMH1KicGgNB5HJnEJdEaz+scpKUYJoatEBF+UQHxLoVi5AYib1idL0Fqsxaw4t+Cq2fCHV97ZW5tvoJcnVu+Ptiwb/eqqnYuA0yxEgSDeCJuk1KlilfGSk83GZu5CITcLMtkdV6uiclqG9M9aYdz3ukbEIhJ/ZrOmv/XXPumYIcT4EFCj6dl2mEXZ1BsfKTISBrxRBXuX7FhxoMrw3+dZDA/+VRTdISciP180zLUZ9k+WPvKi1+cXYWzjDI5ZvthpJ2wQbIbHWBAQZyIYvkk1Z1PUoVcbrDIu8FwzJUSCvKcPCwCgx4IEaHgM8EpBNN+SjBGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1cUm9U9TKymOIG3px+NPHFpMhNVugswVzVQ+KaXYXY=;
 b=P7Lzmd63YlcPUvFI3we1Mc5T8Gt5c773WjcaRNehUACTgZKmOEZ2jxOCrSsJccvzb06O28epL4wCcY9v5/hh8ZqfMS6AqfmFWKTjZ7ixQlL6Yw7ZB+aQTgc3A47f44rmjsNuK9mKTJcp+TLNPUY/vUZV+tGWspgfG/1iWTsXuhI=
Received: from CO2PR04CA0182.namprd04.prod.outlook.com (2603:10b6:104:5::12)
 by BN7PR12MB2659.namprd12.prod.outlook.com (2603:10b6:408:27::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 06:33:34 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::53) by CO2PR04CA0182.outlook.office365.com
 (2603:10b6:104:5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Fri, 3 Sep 2021 06:33:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 06:33:33 +0000
Received: from equan-buildpc.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Fri, 3 Sep
 2021 01:33:31 -0500
From:   Evan Quan <evan.quan@amd.com>
To:     <linux-pci@vger.kernel.org>
CC:     <bhelgaas@google.com>, <Alexander.Deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] PCI: Create device links for AMD integrated USB xHCI and UCSI controllers
Date:   Fri, 3 Sep 2021 14:33:11 +0800
Message-ID: <20210903063311.3606226-1-evan.quan@amd.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa5e8e05-64bf-4798-e1e4-08d96ea4c0fc
X-MS-TrafficTypeDiagnostic: BN7PR12MB2659:
X-Microsoft-Antispam-PRVS: <BN7PR12MB26590D3311A1F89F11750FE2E4CF9@BN7PR12MB2659.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bypGI8UAlzXd93rA4QnM8xf6JV0a/JoPX2R5LDL7AUuVSj+o4HLqDP7dVQFwZndFNhfdNaZz80CHYPxrwCxa1rT4GeF8J/T8Tifb3chdHIXTEoY8C3M6PZv8qadmoj4jzfURtyHAipNyh7nqd2JXHvs5MrUReAefCKEJqwlnyoQQaIyq/ACH+Qs/pVqFpeM3VrsHu7XRooh2u6z7/FhThNogqdG7mAQ3KVpDXm/bzXw6JKuadRwAgN7awfSw+2HL0f4tFA045n4HRDZwd01SlpiEWEg/saFRp4ComO+3fOj+kMiEof9ss/BaH/R/hfuXwTuEXEioc6WigX/UJNUck9+bd5QYvJ6vToO35JfiemldpArWFOBn2fpOK3/9b0BzuitfucLMreiRFeJ2gM0cWE96/ygl0nfP5kWLtlFenTsVrmlLCri14nXZchflpmWrrvXte3oxbh4uSl+ej/aKr1y1l9HGoCV+/zBaNxJZIio1DHHZ+XFc3p4fV/KmA4Q1Wwr20hqhhqPqqvY891iN8FI2cbvRk4jRXTibB59+u7NnMaPZ/nS6Qo9l52y/zpLspW+0oZwudS/bJczLP3EVPu/xbWRh49XjoUVsA0Ngnj+1kwtGdy6s8z2+J461xTsJM2+JS1LTrFIBX5tPxuWUq9Pd/5TEqAK3pVLxFaViJrJKOJmOpPYrPRa69w3xqmQz1DAYKt+Q14GUt8pNe5GVNMwA25g1W/0w2RaCC0XvFYQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(36840700001)(46966006)(36860700001)(8936002)(1076003)(86362001)(2616005)(4326008)(81166007)(316002)(356005)(54906003)(83380400001)(70206006)(47076005)(70586007)(7696005)(44832011)(82740400003)(426003)(336012)(6666004)(186003)(6916009)(16526019)(82310400003)(36756003)(26005)(478600001)(5660300002)(8676002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 06:33:33.9547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5e8e05-64bf-4798-e1e4-08d96ea4c0fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2659
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Latest AMD GPUs have built-in USB xHCI and UCSI controllers. Add device
link support for them.

Cc: stable@vger.kernel.org
Signed-off-by: Evan Quan <evan.quan@amd.com>
---
 drivers/pci/quirks.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dea10d62d5b9..f0c5dd3406a1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5338,7 +5338,7 @@ DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
 
 /*
- * Create device link for NVIDIA GPU with integrated USB xHCI Host
+ * Create device link for GPUs with integrated USB xHCI Host
  * controller to VGA.
  */
 static void quirk_gpu_usb(struct pci_dev *usb)
@@ -5347,9 +5347,11 @@ static void quirk_gpu_usb(struct pci_dev *usb)
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
 
 /*
- * Create device link for NVIDIA GPU with integrated Type-C UCSI controller
+ * Create device link for GPUs with integrated Type-C UCSI controller
  * to VGA. Currently there is no class code defined for UCSI device over PCI
  * so using UNKNOWN class for now and it will be updated when UCSI
  * over PCI gets a class code.
@@ -5362,6 +5364,9 @@ static void quirk_gpu_usb_typec_ucsi(struct pci_dev *ucsi)
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 			      PCI_CLASS_SERIAL_UNKNOWN, 8,
 			      quirk_gpu_usb_typec_ucsi);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+			      PCI_CLASS_SERIAL_UNKNOWN, 8,
+			      quirk_gpu_usb_typec_ucsi);
 
 /*
  * Enable the NVIDIA GPU integrated HDA controller if the BIOS left it
-- 
2.29.0

