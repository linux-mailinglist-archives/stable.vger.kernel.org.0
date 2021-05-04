Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DD8372F2F
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 19:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhEDRtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 13:49:45 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:57148
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231610AbhEDRto (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 13:49:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHZWovRWEcodqFxF5CpjejGFp88ZvfI9SuphjE4VhqFhT6GJisAQ7uGhiU31ibh0ORz9+39duw4FQyL/KoeVEdGinEL+hT2BJaaLEqQ7GURb2KeBHjYH84ij94nLl5zCbEecWo6U1PVe2dxm+r+sVUxHT8EelmToYe3rwDn4jRfX6aRspS2o4+loLrbn7j0VOrluCQ4kSSIvh9jZuTj/akSStIHOp7sJLUBYizOAP692F5R137hDbLaGhyIbsI8u46qJEvsU+xxpLeJ+lNMYLTyjPoThJOEX0J4fpum2USXaMDUAOE6pOnMhtIZhdyZyxVF/OC172Lln1StNn/4VqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=map332Wg5jJCMMaFOcrhFNqee0OloY6iwr5EoYa8o5o=;
 b=V5CpCfhfR7q0EL+0PEvtw8vJlRVbQKL7vDrNNwkqETukoftN3sugxA8Yld8W7trxM718X+tRVv1n68QvhsHi4+V5q3NHygX2N5VGShfudq3GYGKfxgMKxCXpUanU5t6xnGPWGpGo9nKKudFRRTCHK5NGIkDuIzL5Ez2mWiagMHLtFDFrOu62v/bfFtoELx+i4iH+uGomMTWx5d/zu00j2jZ3JcZ4qEgfsdXglEP86Z+YO0zCslVzloYlJsjbDReUSBNOn5+SgL6pIOW72sxTo9oJWiXe2TbXRsKLM4i1T4C+D4RZh8XsQf/3Wt+RSIctqcSXUGGqunbOflbuxOZQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=map332Wg5jJCMMaFOcrhFNqee0OloY6iwr5EoYa8o5o=;
 b=5lm5el+mrmt7GOYMkByrJ52mb6cuCUaBwKKoPzEKByNTcRmumUtnDFkI8cR74cEXanMTxcCU52MLTdthfJr6wWhe3zv4erxPb4XEQXFiM3b+FXDmmitxX3/zmYjRkcVNtIKwGRAiK2LG8APfC7R7Kpy/idf0bGrjALJSmbRT4Nk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3108.namprd12.prod.outlook.com (2603:10b6:408:40::20)
 by BN6PR1201MB0212.namprd12.prod.outlook.com (2603:10b6:405:56::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.42; Tue, 4 May
 2021 17:48:47 +0000
Received: from BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::418b:8ea0:dc4b:d211]) by BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::418b:8ea0:dc4b:d211%6]) with mapi id 15.20.4065.039; Tue, 4 May 2021
 17:48:47 +0000
From:   Yazen Ghannam <Yazen.Ghannam@amd.com>
To:     linux-edac@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, tony.luck@intel.com, x86@kernel.org,
        Smita.KoralahalliChannabasappa@amd.com,
        Yazen Ghannam <yazen.ghannam@amd.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] x86/MCE: Always save CS register on AMD Zen IF errors
Date:   Tue,  4 May 2021 17:47:11 +0000
Message-Id: <20210504174712.27675-2-Yazen.Ghannam@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210504174712.27675-1-Yazen.Ghannam@amd.com>
References: <20210504174712.27675-1-Yazen.Ghannam@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.184.1]
X-ClientProxiedBy: BN6PR18CA0013.namprd18.prod.outlook.com
 (2603:10b6:404:121::23) To BN8PR12MB3108.namprd12.prod.outlook.com
 (2603:10b6:408:40::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ethanolx80b6host.amd.com (165.204.184.1) by BN6PR18CA0013.namprd18.prod.outlook.com (2603:10b6:404:121::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 17:48:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bc65849-0fd5-43fa-9365-08d90f24de53
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0212:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR1201MB021273A93B267AB84D125F24F85A9@BN6PR1201MB0212.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k6ACh7HPl5npTkEeAA48jmGOy99y1PbnCagOPlTD4IISOrPlER1b8ajaa3t2aULNliq58uH+1Q9tgiLTg36dhxxCaEQWc1GNcqI/5UqHNtWHfzqtEjvvjS12NYBUlyn7grQMS16VbHoSgL7RAKa76Bn6OS+r9pTNGi4QoFYUt44Fpz2AdE7+st/TXH0VpCmR+zFHnYCEvhjWjb09eDg8IYcvEUGsSzUffgCSPqhrSwHG9p4w+j7Y+QA6OPArcSNj2j26notTCJ+kDnGaQ04kK/SIsC5hD2le/Yb7PpXfGMfKgwBDgUPVr9qptSbSEID1My1K/QSLWb/ebH6rgZXVKla9kKvvZOmL+SwwKOtBXBSrcJNSF70pS1EdrwexgRW68lBdkHoBegDn33QV1RSdld7rlJNt1W7pr0TDeJ9mgRfVeElkjeLOQil/sYz2bBdKoCYJi51HgwqCW7lXErGl4jpuBuAv0yZ0Y+ievgYM6caZHrjg4QMj0F9cc8yk4mlEhRRCesCX39LhwB9OJ/S0Feo3rboxn3I7ZlrUTKr7Vq9D/nhIKQp1fZBzMTUSaUY0JljnewIFucAVE3+gZuFNLg5TOGsDPqsmN/hNV7r4TWDgBSWEseFWW1ScG2xE9xC4yL+YaI7SwUo+lveDnExe85NW/Q7dzNYXtJRgDoYL0Ck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3108.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(366004)(66476007)(66946007)(8676002)(5660300002)(26005)(2906002)(38100700002)(38350700002)(6916009)(6486002)(478600001)(66556008)(86362001)(1076003)(4326008)(186003)(36756003)(8936002)(316002)(956004)(6666004)(16526019)(7696005)(83380400001)(52116002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6PtglVkSYS5M87hflk0Q54y+melWrVZ/hEsrqrpHGfwYs4c/03GDE3swcygx?=
 =?us-ascii?Q?QoH9vX0nFw18CPwdVI4ePuFbFBXQmxeVqBtzc2TjrERVrvmiG9rQSSp7ha3l?=
 =?us-ascii?Q?u4+bBHZqi5moLXacmS603l7Bc6GgGI1wxDbJfQrzwqk1bUZvDnzsJziba3M5?=
 =?us-ascii?Q?l/2YBS9udq3LOseYQowmvcJD2RPLEVYZw0LvLhbpnZAneEg/6vtmmxTpW6Jw?=
 =?us-ascii?Q?vQrv0xWPFq/wX+c/z/+EkKea7ra9MEWFESm1C6PhcajrsbAvlwR3zHrlbZK3?=
 =?us-ascii?Q?aFBy96GGlsg0DoLqCQqy6h5HSVXf5Oej5jzO3GkQ7/8sumcTcZCt1vY1Jwzd?=
 =?us-ascii?Q?JQuM8RgPkQCveQyhST3R9BzzwNIq9OdrcCaKEdjlam5Y73uEzrwkKD1tLcN7?=
 =?us-ascii?Q?fX1B9rPfnvZ5ONSIYU82BjwEjIdFqwcY9r52QhBQvUAj5J7UiudoGRpF/sfr?=
 =?us-ascii?Q?l5/1HBjR9MXJWBSVnPgABxkbrI78dg6LvgfVPJpeO+EtJo1NGCHYo3SffOoQ?=
 =?us-ascii?Q?T6TPc3zKKoe0eSE4NxnyVSsoWw3zO1ApFRrQPsy1vHZsnH7rtJk08k73c8bt?=
 =?us-ascii?Q?08bAog5aaoB1Cf0xQD/uV72k8uzYWXEAfbAxys8H/toqOupxkV7Dnuh1IkgP?=
 =?us-ascii?Q?Qn1nlmU/VcBTYBJP2e28zejdoafc+7R25PzTyvIWrfPKZv9TJZ5kobSlnB7R?=
 =?us-ascii?Q?Sy7oAnKrhyF+cbvKrpJOE0itN03dbMTf2DWYo+BCwNqsreuVUZphM+eOyetY?=
 =?us-ascii?Q?A9100lFccC8unfLv0e2fdw7enOc4GfFnKk8ZD6J/xhgCQLDSatukLPzA6QTI?=
 =?us-ascii?Q?5ggKKDOgCobyrLFNryYBN8T+8efLnZfJLn72x4Qk0L2yi1J436409dqAouqm?=
 =?us-ascii?Q?V/sKSEamTgP+lu4qUvsONY4lG4FGnx8uu0to3sS0j/6s9L+6ltuyfsQ93CTc?=
 =?us-ascii?Q?phJ2gPOhEDnYt/vvXO7ie2AAHy9fFa8nyw5MN99nraMnxZrNX6s5aSZLHzO8?=
 =?us-ascii?Q?YhnK9IBB6KBBMLWoutrEZhk9If6cAeawgLlJZ4idtMEZqC6mCQ9T0IZpNxeF?=
 =?us-ascii?Q?JJFryo6BWnXxI0OgEXQAO7d68zjRc9NheGcV95dCWZqLeeIMS3iaeTq2tB1q?=
 =?us-ascii?Q?pAUXNZtE6rxeHAfbKreLUw9KCLcdFaXAKz5r1A352MpQmShPsP6HGGfqCwQg?=
 =?us-ascii?Q?XfdibBQuj5kH2M+FwoK3FozvtPdiKH/AqDHf+R+WVZ+2DpwgGX9FYlzzkKsL?=
 =?us-ascii?Q?dgcgv7ESvBuUHIZ7Uf1+13OlKdn5pDNbI/yYcNgvx7CyN7Ma7s0gq/1lKMaL?=
 =?us-ascii?Q?UZ3THrV06H8l+1vYcWvtqNH0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc65849-0fd5-43fa-9365-08d90f24de53
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3108.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 17:48:47.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05hKP3Nd4YcHYpfSHIEqenKY2aBcXsxIiPqOUCYrp5mlWrLXg3NboWBwbVVX/sMBnAxgpxt02vf6RLpuRSbuFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0212
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

The Instruction Fetch (IF) units on AMD Zen-based systems do not
guarantee a synchronous #MC is delivered. Therefore, MCG_STATUS[EIPV|RIPV]
will not be set. However, the microarchitecture does guarantee that the
exception is delivered within the same context. In other words, the
exact rIP is not known, but the context is known to not have changed.

There is no architecturally-defined method to determine this behavior.

The Code Segment (CS) register is always valid on AMD Zen-based IF units
regardless of the value of MCG_STATUS[EIPV|RIPV].

Add a quirk for all current Zen-based systems to save the CS register
for the IF banks.

This is needed to properly determine the context of the error.
Otherwise, the severity grading function will assume the context is
IN_KERNEL due to the m->cs value being 0 (the initialized value). This
leads to unnecessary kernel panics on data poison errors due to the
kernel believing the poison consumption occurred in kernel context.

Cc: <stable@vger.kernel.org>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
---
 arch/x86/kernel/cpu/mce/amd.c      | 17 +++++++++++++++++
 arch/x86/kernel/cpu/mce/core.c     |  7 +++++++
 arch/x86/kernel/cpu/mce/internal.h |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index e486f96b3cb3..141dcdd857b5 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -180,6 +180,23 @@ static struct smca_hwid smca_hwid_mcatypes[] = {
 struct smca_bank smca_banks[MAX_NR_BANKS];
 EXPORT_SYMBOL_GPL(smca_banks);
 
+/*
+ * Zen-based Instruction Fetch Units set EIPV=RIPV=0 on poison consumption
+ * errors (XEC = 12). However, the context is still valid, so save the CS
+ * register for later use.
+ */
+void quirk_zen_ifu(int bank, struct mce *m, struct pt_regs *regs)
+{
+	if (smca_get_bank_type(bank) != SMCA_IF)
+		return;
+	if ((m->mcgstatus & (MCG_STATUS_EIPV|MCG_STATUS_RIPV)) != 0)
+		return;
+	if (((m->status >> 16) & 0x1F) != 12)
+		return;
+
+	m->cs = regs->cs;
+}
+
 /*
  * In SMCA enabled processors, we can have multiple banks for a given IP type.
  * So to define a unique name for each bank, we use a temp c-string to append
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index bf7fe87a7e88..308fb644b94a 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1754,6 +1754,13 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		if (c->x86 == 0x15 && c->x86_model <= 0xf)
 			mce_flags.overflow_recov = 1;
 
+		if (c->x86 == 0x17 || c->x86 == 0x19)
+			quirk_no_way_out = quirk_zen_ifu;
+	}
+
+	if (c->x86_vendor == X86_VENDOR_HYGON) {
+		if (c->x86 == 0x18)
+			quirk_no_way_out = quirk_zen_ifu;
 	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index 88dcc79cfb07..656d5d6c9783 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -181,8 +181,10 @@ extern struct mca_msr_regs msr_ops;
 extern bool filter_mce(struct mce *m);
 
 #ifdef CONFIG_X86_MCE_AMD
+extern void quirk_zen_ifu(int bank, struct mce *m, struct pt_regs *regs);
 extern bool amd_filter_mce(struct mce *m);
 #else
+#define quirk_zen_ifu							NULL
 static inline bool amd_filter_mce(struct mce *m)			{ return false; };
 #endif
 
-- 
2.25.1

