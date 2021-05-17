Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CB9383B83
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 19:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbhEQRoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 13:44:06 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:38272
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236106AbhEQRoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 13:44:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3cTDw9lLMqSOxaAzNFKQfyA7evimBWLQmYtgoq64ra4lhgwmmndbl9SnLDy1+gZAijUbXHlBuCFCijKhkpBYKsnrd1QApFvX6DdNL7W2QxfBzNsRYxvUCD2UIcM5UCFnfb7zEjBqSue1vZJ+nyTxABiPcqVeEer2hXmByJAyURfdbEXDw2eC7eCg639JM8HM0hzx+KIjs5FikGHt50YRzq4PkMczzy21+W+fidON8OikqaLfHVnw0TQZrsH1GIZlM1MHniuNM8Ekds6wz4mezDvaLvCauH3Fs24O+byit0Sl/MbNOcrF+fXVkmOZVc4mDG8cGsN9WsFDgL0wQAFZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9s4WxioPRvKGYeG2iMJWg29r4cuSRwwPgTXH9/+eKrA=;
 b=SCPPcTJjObWP3FRUdznuybztPwTSVJW8/+93Df66YFL9cP88QKqqnnj+dnVzBTZUDEEXhnSz8InpmqRD4lsT2nTBxDURgs+HBhhsBtZNo8wYda0KelvvUkxJL/m1MslkBz+VBMj0S6g0t9tAwwQXfIq/iqpSSdMUQ2+vSDKnbv1RYIg+QguON/sV7nY7lWq09YusKMYyHqZhGZjZa8Igi9zHmmC0BQcjCF+wFI/ReZ46WCN4i5qPYSEAytQj11Htu+PzSVl0USHJ9hU08lB4OjvE0XHD/oB0npmNan7qtWunQapaF3oDuzBsc+Lm+04vTd6Y8wFgiGu6n+MIVWtSXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9s4WxioPRvKGYeG2iMJWg29r4cuSRwwPgTXH9/+eKrA=;
 b=qdOnIEg93G0ykkIsR7o+gLQ39hul7dUIzE1cDV/r2r0UtFkl1zxjqMbCuvkVmn0QS1/doy/wbItPDM1dIN7q9aFbws75BtZJjseExplDmDRf+9E8nKnPuStFKKLVFfoB0y5QzMyRZGUjl38aRYV7pVdtXLFFh03SL0UCFcB/45M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1835.namprd12.prod.outlook.com (2603:10b6:3:10c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Mon, 17 May 2021 17:42:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.031; Mon, 17 May
 2021 17:42:46 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] x86/sev-es: Move sev_es_put_ghcb() in prep for follow on patch
Date:   Mon, 17 May 2021 12:42:32 -0500
Message-Id: <8c07662ec17d3d82e5c53841a1d9e766d3bdbab6.1621273353.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0036.namprd04.prod.outlook.com
 (2603:10b6:803:2a::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0401CA0036.namprd04.prod.outlook.com (2603:10b6:803:2a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 17 May 2021 17:42:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ad091b2-1256-4058-bff0-08d9195b2e1e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1835:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1835AFDBB0138E0EAD2AF41CEC2D9@DM5PR12MB1835.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFmLWSJv0/eKWUtHX2om40egqGke7c6GTW2e2OKyS4eRI50afPLP67vbm2Gp77NWH4Td6AEPhkUb14nDUo5VhveU81Qk01BaBZSAuAJ9c7sLpTbft5x68a7i2JAzYvCoqOK/CxGuN+HFkQFE98pVKU/E4mJjiaZRuuDNWQ5cz8Z76+7Z1feKib0TxBb3WOir94V2qBigExhSJzoCbW9dWwNCCNhAOz5J/9YI4D79yTeDMupY3WDe3rxJ8Iy8oXPgDOwFOrVhE/lQOeLOIiBdg3Hbaex1CDExMzdRRVYDp7Gl+M1+wv0ddr6mZ68w0AA9lFIWDwdrMpepVaCQqGANWWuaki64F+3idwgqz5O8KegaGQ0qwoPC+fUFBtv0Mh/OVG8F/a5nT7TZTlr8LxFfed6Di7ok5B6blS1pfsATCVJT8lSLxXFKJh+WlUCvBxMR0JAp5MsUltyVGGycUIifH28MVYrCcvca+tLZ3Gcr6PyB8JVgwmQ0HkTOuYiITli4x9ji3+SLexGhlKuano20EnamdpoS3IyTRvup98xArGQSsyEZwwUV/8GO2WwjpeR2ufBHMkV1qqcznBe6Aip9LoYYal5kYhs8dWr/1qsKFKU+7kOlHiTHGVlQ+jLSU2tXPAKnT60tvQgmc9ktjABT6F+/WqCGe5uxJW6073f3FLI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(186003)(2616005)(956004)(6666004)(498600001)(16526019)(54906003)(86362001)(4326008)(7696005)(38100700002)(7416002)(38350700002)(8676002)(83380400001)(8936002)(6486002)(26005)(36756003)(2906002)(66556008)(52116002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0fLJUq9bVpH9+Qva6xDJvyS8VRm8GM1nA23fn5yRVHOnJdQRL1Af2O8g7lfD?=
 =?us-ascii?Q?LMEiukplBbQApOvTC4qxU2LGk8LaRU9v18g1UzhHVi7zyE67molmf2zvKlcr?=
 =?us-ascii?Q?XLPLz+1+kYmO/Ub2j2OBUUi4x3thbGw4n84EToUC9Z/3+KalAiltkwNAY7yt?=
 =?us-ascii?Q?O1Jrqbk9IBhk9umXC1Mxa5Kqnx0ak2XqaTlHDEFuLEql1O/QYEPoZyFkKYkm?=
 =?us-ascii?Q?441Mpb/t+VGpCz/o7RJWxjejPRMnKQoWj9msewI73VwIo+hWW7hlAlf4laja?=
 =?us-ascii?Q?mGTEHf+rhI9PGJK8QhuRyEpdwRAyn0VkmmLjaHyXPAXdBF+Bl/V6WArZhpuJ?=
 =?us-ascii?Q?U68SitR0hoSNq/WrV1mrSr+AhrJZqA9htpDmPQNuPmzURl6VKf8inq2XeDxq?=
 =?us-ascii?Q?52CQcSpD7dm8eYQ5XLCq3ke74ahuG9En0wcio2+ivYlJwgZM9xgWyvVqWuuf?=
 =?us-ascii?Q?3zOfSgkG7M0EqArVw48oH3su0sl+Gft63/lJfLkvVapZQ+hj8P+hJI7UzRMK?=
 =?us-ascii?Q?+c3jyTC7dvsVuInFXj0whVni407Td5qyOVjV3UxNypdcTabW2ZiS7JxuOMsQ?=
 =?us-ascii?Q?X0BiUJDTLKmXBOtfYych8SBaeylK+g4fdLNH9iTYHQtxX2uCrCl2A1JX+0jd?=
 =?us-ascii?Q?AkL4Ucj6QwRXdlkfqp2Atl4lM2iEXjdP7+G7EkMkmLUtcG8V4/I8rCnwOTdf?=
 =?us-ascii?Q?9uXYvIUSff/6+KS5ESQH5xkUBvKtK11w6+OD9grRuNH1tyURfS3PQY3b7y27?=
 =?us-ascii?Q?Rh056VGbFZ7ch27chBGlSV2wNb73crpLmATtH5rQJ3VJ05mjb6IlNkWudrDP?=
 =?us-ascii?Q?dmLCLfFWlKI+KofoXTFinmVXkzzZd31TatBofg4cJfj3G2UlTqMvjHM4ZmCz?=
 =?us-ascii?Q?whJvodLLpcZlNusa68hIaEhGLwWJfAjhRTLbTiBImNe2XEyWHHtxFIe8t41r?=
 =?us-ascii?Q?99HG8qGDhWAvQowZjxicE8iV7YbFOr4NfilzrpQ0CQaVHOF/RFbuCIQhibke?=
 =?us-ascii?Q?NiklZ6GZ5nBPTg5UJVRbdDCp//B40oTVod424W+fuZFBTsSplAcr/Ew2Ms/o?=
 =?us-ascii?Q?1DvHX8v/wjQWm4pWovm7DKAblFaZRfr0bydZPRoi71oOmg4bGRtVTyl2pHnk?=
 =?us-ascii?Q?BbX7f0gEDt6TVTVMzQJoFQ8mPc8xoTKI1mxvR89ZD06sg5ZyDUSjCEORL5rF?=
 =?us-ascii?Q?JvrAfLfXBd2yvUqGyJqqcKksamGKv48BSAKTsqQjxHE0P6XFmCrbCaxbZA1l?=
 =?us-ascii?Q?Ta23rYEMdZFbVNQnX6Kj2aAdCIsUW1UKjfam2077A/lqiOUYPcl2JLjQgG/3?=
 =?us-ascii?Q?p6QoygEc1OEtjn1xYEyABHuM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad091b2-1256-4058-bff0-08d9195b2e1e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:42:45.8120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SASuwSEN31ce9L324pbj+/kjm2r3Y+1cXQ7HygNSHUdH3gRE/TV4lb6R6yw15lDAzz4/x49zORr2QqOeEl0mGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1835
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Move the location of sev_es_put_ghcb() in preparation for an update to it
in a follow-on patch. This will better highlight the changes being made
to the function.

No functional change.

Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/sev.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 9578c82832aa..45e212675811 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -221,24 +221,6 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 	return ghcb;
 }
 
-static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
-{
-	struct sev_es_runtime_data *data;
-	struct ghcb *ghcb;
-
-	data = this_cpu_read(runtime_data);
-	ghcb = &data->ghcb_page;
-
-	if (state->ghcb) {
-		/* Restore GHCB from Backup */
-		*ghcb = *state->ghcb;
-		data->backup_ghcb_active = false;
-		state->ghcb = NULL;
-	} else {
-		data->ghcb_active = false;
-	}
-}
-
 /* Needed in vc_early_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
@@ -461,6 +443,24 @@ static enum es_result vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt
 /* Include code shared with pre-decompression boot stage */
 #include "sev-shared.c"
 
+static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
+{
+	struct sev_es_runtime_data *data;
+	struct ghcb *ghcb;
+
+	data = this_cpu_read(runtime_data);
+	ghcb = &data->ghcb_page;
+
+	if (state->ghcb) {
+		/* Restore GHCB from Backup */
+		*ghcb = *state->ghcb;
+		data->backup_ghcb_active = false;
+		state->ghcb = NULL;
+	} else {
+		data->ghcb_active = false;
+	}
+}
+
 void noinstr __sev_es_nmi_complete(void)
 {
 	struct ghcb_state state;
-- 
2.31.0

