Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B9458CA8D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 16:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbiHHOcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 10:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiHHOcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 10:32:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1EA65C2;
        Mon,  8 Aug 2022 07:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkOBCMd+kMVOPP/gA1nLRW7nc0tY/lpuQWh5viD09jfCB9cwybukACbCXdnI7Wgr1rxkeXxWqwmBMw9pg61bCpxqkiwk8azukwWnevwiUxSv6ovWydYNIPBQaz4o4oCl2FfR0SHxc9huDkU/8RMamkqDzoUw9Ibj9gnGhI0Nw9Gg7Sc6ZERzbGcQ+9VKEEqeLToR8CWMBuZ57Am9AVeupZfmkXgWO8exJYSTcLoSkbaL/TaeEW1rTvUl08hnn+mkOFpcccUf4W4hNH7ZK5ys2y+hGlb8u0a/Ot/2OUyOJZYUkVt6FWjr8Fj9J7QKsujNUkt6Ce2EYiiZku+aIvRonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrbpcEboXfNYdOm4QrGdRpnrUza2rkhM1uramB0oLzU=;
 b=BhYgmLfBbyvLrNETQL0Wo+bsOE0xwYRawpiAwhv+rTtU/OR6+eEbdXrQA3QocN6/aA9tOjZd6tI0vdRL1J4gsD/9JQVFxkfazImPsVHrjAIcbl9B/cThVKscICs54MUsJDZkrU5A3e/locymT21uG0U8qZ3XBU/TKM+I7o1s/gBU6ILBl3NwfDr0eBmqFAVYUdoJ1qOrrizPdrDdJ4GAoX0eukgCFfBQDxj/xxYsgSG8K1zakjhMAH88YAUaNo9ufXhUQYLpkjojhCXm3UenqjGKPOUKRJrka5eQmOSdPXVtahyENwhTW5cO6uk5NOZqZ+WFJZ60fq/rmtCvHo+B+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrbpcEboXfNYdOm4QrGdRpnrUza2rkhM1uramB0oLzU=;
 b=1Sp7sSt0RnfIlNQK5gTSOju+NjVGCSJLMMV7cOxhMShdRZ4ReIwpfARkU+EboJoo30CsYGYInMY1Mvn8m3+/JO0CJ9DpQ3UurOZn/fWizzBdfx/If0PkNtXHUp039jGrVeV3QBY3gZhUjb3NgiEghba3tcE/UZewoinZtz7M9M4=
Received: from BN0PR04CA0062.namprd04.prod.outlook.com (2603:10b6:408:ea::7)
 by BYAPR12MB3399.namprd12.prod.outlook.com (2603:10b6:a03:ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Mon, 8 Aug
 2022 14:32:51 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::56) by BN0PR04CA0062.outlook.office365.com
 (2603:10b6:408:ea::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Mon, 8 Aug 2022 14:32:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5504.14 via Frontend Transport; Mon, 8 Aug 2022 14:32:50 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 8 Aug
 2022 09:32:48 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     <gregkh@linuxfoundation.org>
CC:     <andrew.cooper3@citrix.com>, <bp@alien8.de>, <bp@suse.de>,
        <bpf@vger.kernel.org>, <jpoimboe@redhat.com>,
        <kim.phillips@amd.com>, <linux-kernel@vger.kernel.org>,
        <mingo@kernel.org>, <peterz@infradead.org>,
        <thomas.lendacky@amd.com>, <x86@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v4] x86/bugs: Enable STIBP for IBPB mitigated RetBleed
Date:   Mon, 8 Aug 2022 09:32:33 -0500
Message-ID: <20220808143233.14211-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <YvEcSGxAh9qbOxPH@kroah.com>
References: <YvEcSGxAh9qbOxPH@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 044f994f-4f58-41bc-c950-08da794adf4f
X-MS-TrafficTypeDiagnostic: BYAPR12MB3399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYePLO0XS3lUvfmzkDqiRT86hFbF8d1kqmHQZWO8ndfVKna9PVvCfxZax6ucD3VFh/vHjhGSc+RSgFdR5jw14SGGVt3JmCxeZZTvRI/ZaAwOserQgNTDVxHBU/GU0LptlRgSDZF2oVO4KJk/F8Ce1y8LXt59yO/ZgJlL+czbsPAULajSgciPpCfgN4uXYH7GfkLlFqBLw+h5pWj291UhRFDw7FIZ+JaYUK8x83V56/hTl5aTgJfLZAoeRIVN9Az06VfQA6PxtXZ9ye12TbO0jO3jp7KPGeM1to3pn1rN6VJQ+iB2CNCwfKtU0YOpK+Cr8iwrQhm2ApAxGgOdGXJYPYhI7Dchwnu5l8ah6ht0KjedsLPipvyCcpIE8qfjeqoZKHmd5gf9us1DxjWOkZPXR3LcrWv3dH54/dqNJvvxN0GbJvJe+lUdO8ygTSIQsS7ulOJWARogUQOcPtomXJZmXwuyolT+i4McmVafPf3uigbKq0wTwyslSoOF4lbXruJXjiFfp4D1eXx1eV9sUDenKJvGiC54eCociITrWVI5OdXn75VYnWCiKo73+xCywoyLuxMNS47dlANHwFONWHTNVqasvW3dQeJQ3Ksk4/yLNvcwTjRipvbT10iPgU18aXlyCE7/6s1DZKkOO1hHzMeblYFsqqUVgce2tXwjPvwh3ti9mXBxF28vn8xOlL1IEr2j3MDMF0xPrLqfapGzUjahmopksCnUnD55Wlmd4Exp795MBp5tV41gXhFpuJzc3oBG200BHdf9l2Vc5Rt0ars9xhhacsaa133ngAzT+MJLv/q1rVuAkwf7Du77oO0B/rntYCDD8t7tZrMfn95iG1MBjaoCF5Tyf+B88ROt44CzU9S9LF64kONc1C8GeIKR4D3N
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(40470700004)(46966006)(356005)(82740400003)(26005)(40480700001)(478600001)(1076003)(5660300002)(6666004)(2906002)(7696005)(36756003)(81166007)(41300700001)(82310400005)(86362001)(4326008)(44832011)(70206006)(966005)(70586007)(83380400001)(2616005)(8936002)(8676002)(7416002)(36860700001)(6916009)(54906003)(16526019)(40460700003)(336012)(316002)(426003)(47076005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 14:32:50.6810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 044f994f-4f58-41bc-c950-08da794adf4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AMD's "Technical Guidance for Mitigating Branch Type Confusion,
Rev. 1.0 2022-07-12" whitepaper, under section 6.1.2 "IBPB On
Privileged Mode Entry / SMT Safety" says:

"Similar to the Jmp2Ret mitigation, if the code on the sibling thread
cannot be trusted, software should set STIBP to 1 or disable SMT to
ensure SMT safety when using this mitigation."

So, like already being done for retbleed=unret, the also for
retbleed=ibpb, force STIBP on machines that have it, and report
its SMT vulnerability status accordingly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Fixes: 3ebc17006888 ("x86/bugs: Add retbleed=ibpb")
Cc: stable@vger.kernel.org # 5.10, 5.15, 5.19
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
v4:  Cc: stable (Greg K-H)
v3:  "unret and ibpb mitigations" -> "UNRET and IBPB mitigations" (Mingo)
v2:  Justify and explain STIBP's role with IBPB (Boris)

 .../admin-guide/kernel-parameters.txt         | 20 ++++++++++++++-----
 arch/x86/kernel/cpu/bugs.c                    | 10 ++++++----
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bab2b0bf5988..ed6a19ae0dd6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5260,20 +5260,30 @@
 			Speculative Code Execution with Return Instructions)
 			vulnerability.
 
+			AMD-based UNRET and IBPB mitigations alone do not stop
+			sibling threads influencing the predictions of other sibling
+			threads.  For that reason, we use STIBP on processors
+			that support it, and mitigate SMT on processors that don't.
+
 			off          - no mitigation
 			auto         - automatically select a migitation
 			auto,nosmt   - automatically select a mitigation,
 				       disabling SMT if necessary for
 				       the full mitigation (only on Zen1
 				       and older without STIBP).
-			ibpb	     - mitigate short speculation windows on
+			ibpb         - [AMD] Mitigate short speculation windows on
 				       basic block boundaries too. Safe, highest
-				       perf impact.
-			unret        - force enable untrained return thunks,
+				       perf impact. It also enables STIBP if
+				       present.
+			ibpb,nosmt   - [AMD] Like ibpb, but will disable SMT when STIBP
+				       is not available. This is the alternative for
+				       systems which do not have STIBP.
+			unret        - [AMD] Force enable untrained return thunks,
 				       only effective on AMD f15h-f17h
 				       based systems.
-			unret,nosmt  - like unret, will disable SMT when STIBP
-			               is not available.
+			unret,nosmt  - [AMD] Like unret, but will disable SMT when STIBP
+				       is not available. This is the alternative for
+				       systems which do not have STIBP.
 
 			Selecting 'auto' will choose a mitigation method at run
 			time according to the CPU.
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6761668100b9..d50686ca5870 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -152,7 +152,7 @@ void __init check_bugs(void)
 	/*
 	 * spectre_v2_user_select_mitigation() relies on the state set by
 	 * retbleed_select_mitigation(); specifically the STIBP selection is
-	 * forced for UNRET.
+	 * forced for UNRET or IBPB.
 	 */
 	spectre_v2_user_select_mitigation();
 	ssb_select_mitigation();
@@ -1179,7 +1179,8 @@ spectre_v2_user_select_mitigation(void)
 	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 
-	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET ||
+	    retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
 		if (mode != SPECTRE_V2_USER_STRICT &&
 		    mode != SPECTRE_V2_USER_STRICT_PREFERRED)
 			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation\n");
@@ -2320,10 +2321,11 @@ static ssize_t srbds_show_state(char *buf)
 
 static ssize_t retbleed_show_state(char *buf)
 {
-	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET ||
+	    retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
 	    if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 		boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
-		    return sprintf(buf, "Vulnerable: untrained return thunk on non-Zen uarch\n");
+		    return sprintf(buf, "Vulnerable: untrained return thunk / IBPB on non-AMD based uarch\n");
 
 	    return sprintf(buf, "%s; SMT %s\n",
 			   retbleed_strings[retbleed_mitigation],
-- 
2.34.1

