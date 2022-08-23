Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DE359EE81
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiHWV4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHWV4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:56:08 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A73B21E0E;
        Tue, 23 Aug 2022 14:56:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAgBssOpd/sZ1R2rXM2cm+uxEbjXk2FmMol4xmjjx46kperFZ9M4iTB3pQ26p/VKVnW+0DIahjNNIZjDJVtUIgeZz0pwKxW0DzXt5bwF/PWEbD51m4XHaDeZ+o5frfGRvYVJ5IVlOdnJ23EFDwZFtMJwFwnNWWtLkJuaZR9jXiDqfEv0PLYGPdxDKu09Wkiqqaks709KxnyZEDTCVYhwjPk9eKhNtXkvzrb84Kz+foTPz4dFRQ50+Msd5mWw6gGjanEKV0EXbT+FzQU62CMwOvw17hRaeDmcjlFut9ZOSV0AqZ/9mrnst+94GHdnx45QQBEledGeJevWIc56RY/bTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0f2XjPrxqoQUgxQjP/tf25RswGarrCT94ARK1Lxw50=;
 b=D4A9sgijjOlN8uvx3wMpFQY9ROmRDdHjmj34zdelrDyveAAmAbMABmtTdWf0unCUqju7wDO/RDTOUromPLR7jEsxFHo0y00jApBaGmiqAwEchebPBhdxf9vbFNQtmi9gxZ5BVCkrAfsjXYWgE4lQczPYfAWus8B5vWLp7kndcEFveU4BUwEt9U6DJu0cekyMYRL2P/ndAkP3UWjY0OjB16l18u9N6pnpaeLDMB+C3SRdSbFXnm09k5TTIh01MooybhJiY3mlkrn6ubSYvmsRsxEkU1qtHKaA1K4Z4WVLijrqitMa3n1aWpl77wBCJQ5aZ+khImBwnkqZ91uFCMIQVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0f2XjPrxqoQUgxQjP/tf25RswGarrCT94ARK1Lxw50=;
 b=s1Yue2Q6wAORAtl314sCvRPLfrk2GufrQIN/NWYTWehNadEQYOUgV6ATGs2RosJyXXgWrSFqvaDk7Uxneti/0lfBn/oCWYDA8/gGTrMOEyfWMK5XUkwpSSYv3vIBY/Nn4FnsqZb7+Lvty603aLlVW+odCnQE9yRUieDfo5wMuvo=
Received: from MW4PR03CA0327.namprd03.prod.outlook.com (2603:10b6:303:dd::32)
 by BYAPR12MB3030.namprd12.prod.outlook.com (2603:10b6:a03:ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Tue, 23 Aug
 2022 21:56:04 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::66) by MW4PR03CA0327.outlook.office365.com
 (2603:10b6:303:dd::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20 via Frontend
 Transport; Tue, 23 Aug 2022 21:56:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5566.15 via Frontend Transport; Tue, 23 Aug 2022 21:56:03 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 23 Aug
 2022 16:56:02 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Asish Kalra <ashish.kalra@amd.com>,
        "Michael Roth" <michael.roth@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        <stable@vger.kernel.org>, "Sean Christopherson" <seanjc@google.com>
Subject: [PATCH] x86/sev: Don't use cc_platform_has() for early SEV-SNP calls
Date:   Tue, 23 Aug 2022 16:55:51 -0500
Message-ID: <0c9b9a6c33ff4b8ce17a87a6c09db44d3b52bad3.1661291751.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c018d9d-390e-4336-51d8-08da8552466a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3030:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3214nZxwjv41t0S7pOmOoCfYRo36Uz0XCcz/nx78/e8LShzMnnFta1qGlqy5/UcOHVGqbezS/N3/q+Yv181HKwkk/J+sOnGzWAozHNPX6LAR3JEKLmeBtG6iUo4q8TpZW1Fep/SoIZlJ8VV3Y3seF4ZzsT0hjT6/iulqtrBeoZX9W86d0yocjKiDhTMDk67prRQ3bEK2uw51kzJGKAFkrHykRo9sfGxho+IqWniqUmpVEBC45TxwNh4ZdEDw27ZjdZktk7NhjVCqIl6huLufiyPE3h8r5LBjrvtUsxw5qvzlNn5ylf9/E50PoXy1XOmsYQx9cDnOK86SwvPQZL75kf8b3oGtuvzSFVKMeZHHru/Rh3iQYpPnvbNBGDDmY9u2KbxzKypL0A5zv/nAwVTq+Hztv3oesCiTM42ky6C8CSR1Cj+d58gAQv29oC8GQXtbejlugWJVS39ZG8ISU5jFSVXehPG/rSkHdGdZKGhcD9A8c84v+s1ysf1wvjwlNUaYJOuLGEWGuKj4WJvFYJC9Gz/HyIS98Btuomf+28jc0fkXgPUKkVJ9RHcc2gwj6xUTAitJ01RH8mogeXwdcWchp4Le5kfGYBi/2A5KGVmXdXt5ZYyMDUUSNcjqZrLlc8g7qKEL5UNOzQGLVROig8QH6EaOyCKgFt1TEKc6SrD1vb0OordyNBpN6I78QSsJaDX+TYUeDyngoaQvD0n5Sk8five8kSP1iDvc1IcGAt6gA8rdLSdmvSaXjWuehI6dyIJalLZFQu2X7Ztcrtiy3cInhCpeokmBqFIKgZM6AxT9P4ikDAT1fj0V0QqwaYIHQ0qsWkXwghlz0HX18cBhV5YHxoUOrD1cTvIdo61Np2SYLDkGVf4fMn7BYS5VfppvTdQ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(40470700004)(46966006)(36840700001)(7416002)(82740400003)(356005)(86362001)(8676002)(70586007)(40460700003)(70206006)(4326008)(316002)(81166007)(36860700001)(8936002)(40480700001)(110136005)(83380400001)(5660300002)(2906002)(82310400005)(336012)(7696005)(6666004)(16526019)(47076005)(426003)(41300700001)(478600001)(186003)(54906003)(26005)(2616005)(966005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 21:56:03.9657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c018d9d-390e-4336-51d8-08da8552466a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3030
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running identity mapped and depending on the kernel configuration,
it is possible that cc_platform_has() can have compiler generated code
that uses jump tables. This causes a boot failure because the jump table
uses un-mapped kernel virtual addresses, not identity mapped addresses.
This has been seen with CONFIG_RETPOLINE=n.

Similar to sme_encrypt_kernel(), use an open-coded direct check for the
status of SNP rather than trying to eliminate the jump table. This
preserves any code optimization in cc_platform_has() that can be useful
post boot. It also limits the changes to SEV-specific files so that
future compiler features won't necessarily require possible build changes
just because they are not compatible with running identity mapped.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216385
Link: https://lore.kernel.org/all/YqfabnTRxFSM+LoX@google.com/
Cc: <stable@vger.kernel.org> # 5.19.x
Reported-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/sev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 63dc626627a0..4f84c3f11af5 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -701,7 +701,13 @@ static void __init early_set_pages_state(unsigned long paddr, unsigned int npage
 void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
 					 unsigned int npages)
 {
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+	/*
+	 * This can be invoked in early boot while running identity mapped, so
+	 * use an open coded check for SNP instead of using cc_platform_has().
+	 * This eliminates worries about jump tables or checking boot_cpu_data
+	 * in the cc_platform_has() function.
+	 */
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
 		return;
 
 	 /*
@@ -717,7 +723,13 @@ void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long padd
 void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
 					unsigned int npages)
 {
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+	/*
+	 * This can be invoked in early boot while running identity mapped, so
+	 * use an open coded check for SNP instead of using cc_platform_has().
+	 * This eliminates worries about jump tables or checking boot_cpu_data
+	 * in the cc_platform_has() function.
+	 */
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
 		return;
 
 	/* Invalidate the memory pages before they are marked shared in the RMP table. */
-- 
2.37.2

