Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D766729E6
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 22:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjARVFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 16:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjARVFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 16:05:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA3B568B2
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 13:05:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8PAQiScpcYRy8mSVCatZBgQWbTfQNm+9JRCSXdY70mk47eYnkkzXnHht/7p61xNVqSmZMhB+U7/oKD0HBkfePpfQu2Wn/q4RF6QJN/uh+6ZQjtH33siA5krIFyOMr6KXHVLtEniuWpx3VXJddfabOnMb9iZCzurFms9qvcBotuQqNU/ihVN+q7kF0S6duyaJSRSYKTWVpgwZnzwsno4Dgeehmun9x6eJTodUeiuxBmoLrkvV6itoSfaDu5yy43SBWDr+A9JQa57+uFA4/VseKfcG6msoLmAHcfxY9mnBNB8siqybQAwagdHquMgaRNzyocmclp+OmmUGMYLo5l9/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO5WHbTInyq+L238Qv8EPZhovff2gn/yKZMQosWC0o4=;
 b=V/ztBCeiIVq0THhjUPE0y7rs0InT+7DkEZXA8+vLmOj6ppqqLWGDkeXCvrJUr9YfksyMOV3S6sgfoXKQB/lXOrqiaFdKcv9Pd6Bvvb+LgmrcoACU+tszpFzK1opax3Ai20Forl8NGfQ9cMgA82J0H4zNdR4sOlDSgE09YCOsSJDHDwRjAUWkYEYRchu6Dn8+G//NWNFNnMz2rCkkyhxCyRwH1VkCHOKt2ZxyQh8JtROu+uA6Zi0IZEH87nd3555gGC4xE47lD4I572jgphD4EoPbwRfHmCgsB0a2SdzcASJDKvnbRB8Xd+IxoIcE+uZoHm+mFYSHvdffpojOjUNCaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO5WHbTInyq+L238Qv8EPZhovff2gn/yKZMQosWC0o4=;
 b=mwezYvdKPqoC5NImnR7SQAIkHYYXrhUzmbRySU4O0NPLagNmPRDkCZU51qOMnUycnoOowWmN8ILNfFIzBo7sOevmDYea0wOvhbn64IH4kKAuTJctgAFowpL4Aq1cI5XqM104PWZwo9gHNB2VLzRg9j/ANJrfWLtHhVGn4TXXWQI=
Received: from CY8PR10CA0006.namprd10.prod.outlook.com (2603:10b6:930:4f::29)
 by DS0PR12MB8044.namprd12.prod.outlook.com (2603:10b6:8:148::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 21:05:14 +0000
Received: from CY4PEPF0000C965.namprd02.prod.outlook.com
 (2603:10b6:930:4f:cafe::c1) by CY8PR10CA0006.outlook.office365.com
 (2603:10b6:930:4f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Wed, 18 Jan 2023 21:05:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C965.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Wed, 18 Jan 2023 21:05:14 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 18 Jan
 2023 15:05:10 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH] drm/amdgpu: drop experimental flag on aldebaran
Date:   Wed, 18 Jan 2023 16:04:46 -0500
Message-ID: <20230118210446.2661629-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C965:EE_|DS0PR12MB8044:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c67b550-8653-47fd-9af5-08daf997b1a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R073/4jBBqQDUJcPLv283lt4GQvKj3QzE2KekxeYlW9irZbZCKEveVAXmTkxJQcFKj2g5PY55SnR5vjeYtL1voteeyKEzpv8eIasO6H+gJrUUcsD8BUheo3wBqdUPL31q1IoDryAXfJKsK4yf/DjbSU6Mouyu1sVODMYxgMBhNJdcio4NxZ+knpGVOPedX3F+5k6ZNTlMv9nYr8deZnqYB/56vhUM6DSfTLQNswqA+g0GxCFqcL0F6UpOBnNzchNymp4Rs9xweqzs/W6XMHRx+dXzFaKNasSVAXpfA1p7MOQWSGbbHT39ANQ6d649Wm5wTr+k8851+3RwZmGkhKZqEqKYB0oCc0kN4wUgfsEd0ONIqiP5SOQrD15GANvXkxD2xXi1N9Cs/OLH22DUvJ/3z9YE7afnEm7m19KvqLvG0a0rM3I0dy8WrKaKAAOtAbxjz8ijw/HwHbjsUsUJ63dYedFvWZzsgaMJYFsmySXriZiGlIS4oz1nl8kV8+XDkys6MkSL+8f2Zx55KozZUkjs3nINszY7Z0uRon3XtE9lA8jD6EfOavGkOA41Hn4NOlXi3oasQMTQTZtzmzSEzpmoSYNDKNqYT6lqckBcWpd/HvZCwQzmaGmMk48JeVX4BjUk2lk90K/fXwO3htf2h/9xDWtzO1xyjd63eCLHKCAfkDp/j6A81N8bCqEwciQG0YM0QiqZ0lbb2lLOj21V79FrZjHfkbpOZs44OsEABOWJes=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199015)(46966006)(36840700001)(40470700004)(83380400001)(8936002)(5660300002)(41300700001)(4326008)(8676002)(356005)(70586007)(47076005)(426003)(82310400005)(86362001)(40460700003)(2906002)(70206006)(36756003)(36860700001)(82740400003)(40480700001)(81166007)(110136005)(2616005)(7696005)(6666004)(478600001)(26005)(16526019)(186003)(316002)(1076003)(54906003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:05:14.0985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c67b550-8653-47fd-9af5-08daf997b1a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C965.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These have been at production level for a while. Drop
the flag.

This should have gone back to 5.15 at the time, but got
missed, so let's change it now so users don't have to
specify the module parameter.

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3786a9bc0455ca58d953319f62daf96b6eb95490)
Cc: stable@vger.kernel.org # 5.15.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index cabbf02eb054..c946590ce635 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1936,10 +1936,10 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x73FF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_DIMGREY_CAVEFISH},
 
 	/* Aldebaran */
-	{0x1002, 0x7408, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
-	{0x1002, 0x740C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
-	{0x1002, 0x740F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
-	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN|AMD_EXP_HW_SUPPORT},
+	{0x1002, 0x7408, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
+	{0x1002, 0x740C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
+	{0x1002, 0x740F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
+	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
 
 	/* CYAN_SKILLFISH */
 	{0x1002, 0x13FE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
-- 
2.39.0

