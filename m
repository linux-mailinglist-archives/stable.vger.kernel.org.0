Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0601442FA37
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhJOR05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 13:26:57 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:4608
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237584AbhJOR0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 13:26:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nT1/ZxghRS4v/dw+ZLA5gxUXPWynitMDd7+JpoXtSvxP2Rhd9ivTe4Ed1RByox2bTMgp7mO4sTZmpp+LpkPJncsfuoW98yQeLiz0Qr8CLElRHndKqRUATk1eNg1Sv9NaEJoYIULZwK3YLaHKzxVmvWGOrfBmAcGEwB+w5YbFEgEVCQZaikr6wRzOnloZfvIOQn+ZErkzVM81ZCavt/leDkKvD2laRehm6uOYQeqDqj7G8X64M4P34z0epdmPyExAXZAOHlfFfUBxGzU2N9TrHGWpxYlYQ1rOCawGR8fIy3kvczn2L+UJ0GnyQLbRR4o5L4yTuU1iXqHpBhQoSP5c0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6R+B+i+sdUGDofKwnROtjeoanx7R9RwSUO5zwOWPITc=;
 b=EgYuj5m4/JeyQgPV+CafEEK8VJKqXIqxHgXlPWA7Z9ill7jt1ianN3nyf0v+9IFNC9OmpNZIy6b6Yr/vzv7B/KPo0EwVNvEuwRWtLiaoQ2nf9tzghlsW+fuVzH5CvIbbikMGEzSebIoHxIQsHvPf9672CGDixw8nK75Nlaq7u+lJ6Hp+m0c1kgUpW8MyHB/IGKm5jWKjfe85JDw0lROM9yesKUsRTnkuvBX4b4XEZ77Ih91fiyt0mJufX6o+fWTMjn9wB2y9mgv0m1Yj9aj+EGvOfOeeeTg0UDW6ikcfNgSyg81ew46tIIxIun+8s6K8ATHdwaldUL7uOqUqHZ3ajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6R+B+i+sdUGDofKwnROtjeoanx7R9RwSUO5zwOWPITc=;
 b=iaR4IDQAqOl29fOsJIlGe8nehil8cRVsmVFraegq/Piw6CHmmpejy6CQkwxfdGxeuxiuE04g1xrFVZLda3gvtIXfWViQTCttmquNZwDEhLSBGr+vwhvF4wz+B4OFPwKaFbPsDOJCBSRij81MH4M4GPc1rnwFJXG8VX6sPybaxGY=
Received: from MWHPR12CA0050.namprd12.prod.outlook.com (2603:10b6:300:103::12)
 by BN8PR12MB3619.namprd12.prod.outlook.com (2603:10b6:408:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 17:24:39 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:103:cafe::2c) by MWHPR12CA0050.outlook.office365.com
 (2603:10b6:300:103::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Fri, 15 Oct 2021 17:24:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 17:24:38 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 15 Oct
 2021 12:24:36 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] x86/sme: Use #define USE_EARLY_PGTABLE_L5 in mem_encrypt_identity.c
Date:   Fri, 15 Oct 2021 12:24:16 -0500
Message-ID: <2cb8329655f5c753905812d951e212022a480475.1634318656.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4d8eac7-e871-46d9-8470-08d99000aa8c
X-MS-TrafficTypeDiagnostic: BN8PR12MB3619:
X-Microsoft-Antispam-PRVS: <BN8PR12MB361927F709805A17C2FCFACBECB99@BN8PR12MB3619.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y7aBl2I6HEq+5Ade163fbcZwdGzP/sv7qRo+qEqIbJ7S4ob7Gkg2T0nohIHjAtJOLHvl6nVsmBo1giKyIMC5Kjgyyhph0dbqO9yLfhMgK4YcRtLgN2wyfj1V+9xw3ycdqKa3Ybp9Snd+/b1IRhOGWTr+rmyorGr1FUqQZzSeqLYcWQHDOayEmPhexMKWu/dBtyCyyj/0ZKA/DXSOZW+s+ql8wRtGW+9syV68jjO0YX48zyxYbriR3Of6pOttuQgW6JGzH/9szRJ6+qZQv+MD/ynGEPMA1XnmnoFArezyqLXQhSdCYd50+vJ/3E0TMqT9NwC4cuIlxb5KT1wx78kWV8BrCGq7jk5OPGM0Cxxx9NnpYYfBJueIkIsIpLoN11D58jktS1X8/VG+jxWWCFLk7L6mnRn4VfCvbdO2cvUEt9eoErZo0ZQYlYH58rItCW0WC1rmLqG4l/lyeK4klhzkrQSfgqC/zK3nnko/BAnQODevxb+437GNTruMt7ldtr2uDlGpjgHN16SVxa8FFX25PZa/fLBi++JCNxTn+hYc29ZlcQWDb1aAiGvhTsq33FiCOgmyL/bhcBUgA5KjJ3W5BvRamQGNAPD3iyZ6tp7f1h14QIShY1fvn4tivQ/9BQnjExHGDJS4hNKml617LrdiGA36LJiwVWNe66oIG9bLo2nQjuSE7VuudGj6lDB63jueCbYFIwAhe2UvRURriQC6Dwn0aXmp+0sZZf4jOWJ8sd0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(316002)(16526019)(86362001)(336012)(26005)(7696005)(36756003)(5660300002)(2906002)(186003)(70586007)(426003)(6666004)(2616005)(70206006)(8676002)(110136005)(83380400001)(4326008)(36860700001)(508600001)(7416002)(47076005)(54906003)(82310400003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 17:24:38.3852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d8eac7-e871-46d9-8470-08d99000aa8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3619
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When runtime support for converting between 4-level and 5-level pagetables
was added to the kernel, the SME code that built pagetables was updated
to use the pagetable functions, e.g. p4d_offset(), etc., in order to
simplify the code. However, the use of the pagetable functions in early
boot code requires the use of the USE_EARLY_PGTABLE_L5 #define in order to
ensure that proper definition of pgtable_l5_enabled() is used.

Without the #define, pgtable_l5_enabled() is #defined as
cpu_feature_enabled(X86_FEATURE_LA57). In early boot, the CPU features
have not yet been discovered and populated, so pgtable_l5_enabled() will
return false even when 5-level paging is enabled. This causes the SME code
to always build 4-level pagetables to perform the in-place encryption.
If 5-level paging is enabled, switching to the SME pagetables results in
a page-fault that kills the boot.

Adding the #define results in pgtable_l5_enabled() using the
__pgtable_l5_enabled variable set in early boot and the SME code building
pagetables for the proper paging level.

Cc: <stable@vger.kernel.org> # 4.18.x
Fixes: aad983913d77 ("x86/mm/encrypt: Simplify sme_populate_pgd() and sme_populate_pgd_large()")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/mem_encrypt_identity.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index f8c612902038..3f0abb403340 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -27,6 +27,15 @@
 #undef CONFIG_PARAVIRT_XXL
 #undef CONFIG_PARAVIRT_SPINLOCKS
 
+/*
+ * This code runs before CPU feature bits are set. By default, the
+ * pgtable_l5_enabled() function uses bit X86_FEATURE_LA57 to determine if
+ * 5-level paging is active, so that won't work here. USE_EARLY_PGTABLE_L5
+ * is provided to handle this situation and, instead, use a variable that
+ * has been set by the early boot code.
+ */
+#define USE_EARLY_PGTABLE_L5
+
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
-- 
2.33.1

