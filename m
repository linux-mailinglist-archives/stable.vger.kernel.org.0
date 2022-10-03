Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BBA5F32F6
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 17:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiJCP43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 11:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJCP42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 11:56:28 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84DB2CCBA;
        Mon,  3 Oct 2022 08:56:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rumh37tClmdqsY3MG0avSjaJ5xbzmaLR6cvjMCN3mg8VTtRbJxyC8b4JMPCvnH7K8sods68hkvswrJYKYpFwekicY0Vxz/+aAYpCny+vejEAwfhpDXJHSajkDuB7i0YTeq2m8DdXFuMZ6otOZflkLsMUvIBG3ju0tjdZf6CieW+1/ShvXg+C7wJPXdX5JtW9vH3FE3za3YwkbyFZM260+BN59T9lq6XM2jzKCqxHhbHFtaKdatGH2oRA9LsHdAGC5QdhzuPdBXSW4CyxnJbO4WZV6rLHJ/1pFMWfcuvfis1ThZIbhsH71lpblShmPqrS0YlQLLyA4I0rBNorKsCUBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSmijHv5o6zTEx3jhQeL3MaXHoinDjET9rFDDbfrO44=;
 b=HQUKRBywQ77OhlJEf8C8ZP9v0Jeh4NZREn56Jw9XlRQkUGs8NLy+/NJqx7LTqU/B1I9drjkfXhPfkA9RvVmR1393U6CLfNrKEfs2T061zcsHrd9HF0cGhsIdCxPQcmkJkqnlYYkqqoHiJ64D2tT+FEDjU9bRpEpEVkhbLoR7kWvx7/36Rjl5LwQm5q5UWeAoQD/i03EBd8h1K58ZUZMrIaT3WgTJatk2RKkOpcnBKSe9+y3Hm7HAGxVfx74KrlF7Mg6HmaIkdKuXZUKiU6oEuRS8rYg1HNitzD7qVg0JuWnDL1z8xaHU8oDpB7dxQUMPmEgbIwnoMsKKHwjFgO0BNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSmijHv5o6zTEx3jhQeL3MaXHoinDjET9rFDDbfrO44=;
 b=AOQIuAs1PDlK8PNbU20Teui7VlntlKgzhZs+PjH6FLudGmFf3WK1j0aMP1TIzDZKmw9a2OwIalhhq2uWO2gfjGAztNP3+mcTUxQwXcAcqnWTkUTSD6/mc8QNEaVpHnbP4T3Jamq0H0rMatyTzij4QXatSOMkSxVIZ7NCEtACH8Y=
Received: from DM6PR21CA0024.namprd21.prod.outlook.com (2603:10b6:5:174::34)
 by BY5PR12MB4164.namprd12.prod.outlook.com (2603:10b6:a03:207::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 15:56:23 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::1f) by DM6PR21CA0024.outlook.office365.com
 (2603:10b6:5:174::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.8 via Frontend
 Transport; Mon, 3 Oct 2022 15:56:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 15:56:21 +0000
Received: from pyuan-Cloudripper.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 3 Oct 2022 10:56:18 -0500
From:   Perry Yuan <Perry.Yuan@amd.com>
To:     <rafael.j.wysocki@intel.com>, <ray.huang@amd.com>,
        <viresh.kumar@linaro.org>
CC:     <Deepak.Sharma@amd.com>, <Mario.Limonciello@amd.com>,
        <Nathan.Fontenot@amd.com>, <Alexander.Deucher@amd.com>,
        <Shimmer.Huang@amd.com>, <Xiaojian.Du@amd.com>, <Li.Meng@amd.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Perry Yuan <Perry.Yuan@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] x86/cpu/amd: remove the CPU model ID to get correct highest perf
Date:   Mon, 3 Oct 2022 23:55:47 +0800
Message-ID: <20221003155547.1325988-1-Perry.Yuan@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT057:EE_|BY5PR12MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c4df5dc-70e2-4d53-11d3-08daa557d181
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qeZDaUjbeRE1HQpRIBGOtiE7NEnDRHYHj6c9ZfMjYS3OyKfiP0/6HMRXlwrOIUeFFLvvT0CBhzAh+RMdMJt6w8+ModTTIp/CGA4RrozaFCiBYmfW2PRcCujJRsoWfC8vUV5lZFRusT0F4MUsw/zvhoRMQaNBj8y506uDGkGSov844eeSEOzFRlsMgK9Qp2gmI9UJKXY9AU11CgHkNYIkZTLEr6nOh960YSkBjw6pwhiJbXMChaMODKyoQczCJjYYt4+wGbkd/r8ue+xLN5H5sAZtdR0ABe27B2MgRFgRy+dIMCwAenv2zUhZkSbH3IMsUMwZBmSUk1Bw/ncVzhuWxfTainEzmt/brgB6R3TxZTjgpq/D7EGhSgQHqibT6E2Qz5HiQbNJcgxTYmcSjzwEiyDcprPSNfC7jqab4dbD0TwpjHj5p/ik6QiIHrxu/Q9Ko0BAeyfIhxPYQRKzxGv/Sd7WTLl115ua7csHSisNJjB922O/ecutSDpw7U2oKHkjQYvJsMmNBSBqwpFbP8nB8lFrVCyoSnbUKsu09f1J9zD4b0Bpcwf89LKzqP3UmckJDyJW4fTbqVp6TPFEKpo85xBKVzxwg4G9hn7fZ2YC6rjxjiW/MU+Pc9BWNCyOoN0L0vIe1UWZKkH7Ngd/XpehxEBBhDj2zsr1xqlhvu7FTTMtjyBvxYGKcKHVNXR+7zQHyPIeZ4QbGtDABqsup24eROBaNytyfjCRG4Dg5jPB6RySqaRw53UnX6ZyXmI0yMdqQgKKTK8bN9FuCSFoN+H3BjaBMMfGVwk3y8R43N2dNWTeVmX+KDrpgL1fHHQwRb+UMLPwTmHsW1qaiHDxGPA8Mw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199015)(36840700001)(46966006)(40470700004)(82310400005)(5660300002)(40460700003)(81166007)(2906002)(356005)(478600001)(8676002)(16526019)(336012)(83380400001)(4326008)(70206006)(86362001)(426003)(47076005)(26005)(6666004)(110136005)(41300700001)(54906003)(7696005)(8936002)(82740400003)(36756003)(316002)(36860700001)(2616005)(186003)(1076003)(40480700001)(70586007)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:56:21.9793
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c4df5dc-70e2-4d53-11d3-08daa557d181
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The AMD Rome CPU model IDs(30h-3Fh) do not need to get the highest
perf value from the amd_get_highest_perf() function, the correct
highest perf will be queried from the cppc_acpi interface.

Fixes: 3743d55b2 (x86, sched: Fix the AMD CPPC maximum performance value on certain AMD Ryzen generations)
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/cpu/amd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 48276c0e479d..1734cc5aa7ff 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1183,8 +1183,7 @@ u32 amd_get_highest_perf(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
-			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
+	if (c->x86 == 0x17 && (c->x86_model >= 0x70 && c->x86_model < 0x80))
 		return 166;
 
 	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
-- 
2.34.1

