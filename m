Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D545368B31
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 04:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhDWCkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 22:40:52 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:34934
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230367AbhDWCkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 22:40:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFAH3KmUhFgSZIHnuRqinXIVNwtWfKyJYXm3zu2bX8KTdqjRxg1m8grX3n0xI5R5beQCN/YuKCo+1m87clbusc6UpZGiMGPLlP46DHkypg+dPHZGLEOBmDFqJ2KEyCMhRr/Uw8/yih1qbm+POrMcavQMXULgMA664/CIB0W7wSmbksqH70h8ierQfhy55zXgAvfG69rAjWbaumLmdjnFGvMWyMQokeVX+tgctTx3t3Nv/HIKI0NOI/ZxdiI3k4PvdWZa7sP7EMTIo6ZbLij01LN/h1Kyc6/owOi2N79HLIllQIo+UEel+sKVHA0r7xjQPzYKJ44zi/TowmhZ+5hWLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bDe4EWpjRPgcUvUFk2zVq/g+RfZOd//qUpRjkEylAQ=;
 b=Jq8wT0ZiFSV7Ej6E743vIYAYDOClCvPtXXcwaMzLqV1vn8BwHj2jQFMU73c/HK8O6xWciy9YoZaOr4eEZCkh5w07CTMiKsNau3RyYBz33KLPRLEOVcmpZNRfYzM8d4rmyiCtrNPnBJW0ktEmgJ+/JVtp3Ia28uhU4wLnrOJq9LBLKelkZ6qpf7w7l2aAc5Thl0KVyGV8YOaS4zNw4wbqDZgFtR6d1IyMsNsoiPDqbgqan1UUnIHVKxpUm/m3cd7GS5K7GMDiwlsodWls6Hk3rZdaMtjmfVww09DoW7YBDS26EGZnFwNNrTpAY9FsQCrCVgN1yGIq9CrIXIl9p1J18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bDe4EWpjRPgcUvUFk2zVq/g+RfZOd//qUpRjkEylAQ=;
 b=2Ug3aA1zlL1/73mnCIu7bRVhTNLaUxNWoxNG+/kWoxvLDMoLWstzoifwpXFKS/0jbmkKqQPCieIJSwiOWJmbXONty2k04SFSp7Su6bsPEwL+aKCUUe7Un9L7ZY7dy6xTbVyLcGmElIZoMdfg5meTkonkgarL18WCsSr1IExycGc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR12MB1951.namprd12.prod.outlook.com (2603:10b6:300:113::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 02:40:12 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4065.020; Fri, 23 Apr 2021
 02:40:12 +0000
From:   Huang Rui <ray.huang@amd.com>
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Huang Rui <ray.huang@amd.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3] x86, sched: Fix the AMD CPPC maximum perf on some specific generations
Date:   Fri, 23 Apr 2021 10:39:28 +0800
Message-Id: <20210423023928.688767-1-ray.huang@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [58.247.170.245]
X-ClientProxiedBy: HK2P15301CA0006.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::16) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd.amd.com (58.247.170.245) by HK2P15301CA0006.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.3 via Frontend Transport; Fri, 23 Apr 2021 02:40:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4af5c342-b41b-45f4-a824-08d906011df8
X-MS-TrafficTypeDiagnostic: MWHPR12MB1951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB1951DCA270996988A11F7ABFEC459@MWHPR12MB1951.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 448WJ6Eh7Vr4DsPiIbBuY4RtAgreNol4C/VjqER/Q+aqWp90hFsqVD1bu3Zc/3DBqEbi761E36otHCmhLmTUDc3ztzImjEZpt0uXCY8dgSE8333qfVUjCOdQWEWoBA8FW5T17m9Hcj3YwKM+0O1v399RF6vegZXPYfnmRf9k8w2Uq63odgbmOLvfqmubOn+bE1cHMDnqHl2Amdc+alVmvJuvlndedh07UY4uy+zSHnhOkrMSfnBYN4mAO8fpt9+JK0YW8F8IRPTZq+jO/qDasnPouCV07DkRl3o4qBI+rxX/sYrbF/QuQBpHdHow9roSmPm+2xmz4P5M5FkW/BOI81I4WJefnzI7oQmaKQdVfxDYWMjwmorSXKTXLNXPnCZQUcf5OOCSJC/VCqqrNL89gDmTAF/bR9k0hE6ZKCT9B20wenAc5SaorqyMrAVyQT7CRiQX0uWFtPphEDw1zg+WWbztYDbUzKoDEcDtDiy8dYO/5d5PeYPXhwtR9rGw6PfnW07rEyPdTY6I7MXOIYbDqmcl5eZW/MpQRTAUWXXh7wUa04fymFM1FzFn5cPppNxX3BasCR8xe5vGZy9SuEgTPbeBZd3H9QnoFi5tul8X+k6swQrK7qnzp/EBy4pa/avdgJ/uGbIrHw4CHoUvUw+t0sPuTSkeAT1JIDX15k7TJZ9+X0ymP3VOMMzYSfw9YElWwoXKmfff7GbwIzone6qm/O9TwvwwvzahYpU47hOc09Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(966005)(478600001)(66556008)(38350700002)(66476007)(66946007)(38100700002)(83380400001)(6666004)(5660300002)(7696005)(4326008)(52116002)(86362001)(2906002)(36756003)(16526019)(54906003)(316002)(8936002)(186003)(6486002)(2616005)(26005)(8676002)(956004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UjZDc2RtVEtiZWpMTXJ5NUZNMUsza2VyblBZTnpnSjlqeUd3K1ZabHVjTC83?=
 =?utf-8?B?STRweC92MHB0ZlE2bmpvaXRwbm51ckl5aENRYjBibXJ0ZjA1ZnVPYUt3cnJi?=
 =?utf-8?B?YS81WllZV29WU1I4QkNqTXdtUUNERTJuMk9seitUZThBN1ZKc1g3VmFWQkEz?=
 =?utf-8?B?U0pIbm5DQ2c1ZkcxcGN2L1VKQTR3UkJtQmJ3S2ZsUjZGMjhQYm54bTcrcGI5?=
 =?utf-8?B?Qy9EcFhIMHJYSTNnVS9IWmRKQkViRmV4WWxZU3Z6aEt4WjVYNHFybWFMTklR?=
 =?utf-8?B?Y3pLcG5Pd21EaVh5b0tuRHFTSEwrc0VGWFozZEJkMWFIc3BJR3pGOEJ3MHFJ?=
 =?utf-8?B?TlY1Z1IzQmh6MjVtaEtIL3NXK0lsdkhjQndPOVpmUnhNSTU2L05CNTljNEN4?=
 =?utf-8?B?MS9BN0R0WEhwaVBHemdybC91UmlVeU9VWWd1Sko4VmhOUis0NzdPUzNuWCtP?=
 =?utf-8?B?QXk2NXMxMDBrL0FYTDlkdEZMdWtQU3dmMFdFczFTeWNFTlF1MzRGUHBHVy8w?=
 =?utf-8?B?RVM1WjNxNEtsU0ppVHZIdTlNMjl4ZlhmaXFmSGY2OWhhcWIrellKSS8xNUhj?=
 =?utf-8?B?ZU5nb1o3TDR5anh3OU50Q3pkMTZuVWNYRy9JM2RlZ3FxcnVxNno4MnVzSy90?=
 =?utf-8?B?eEYvZ1JHRmErZnFPOEJjRTJUUzdoT2FkYlQ5a09idVBXVllaRlBucS9PaVFJ?=
 =?utf-8?B?S1htY29KdDEvRzhzc1ErbXlMT0RXZ3JpZ3FaRThWSjM4c05xRUdzVXNMUG5u?=
 =?utf-8?B?TWtwVXBZVkxzWWNXTmRuZXZ6bCtRQ2ZrWFM1ZVJFNmJ6V2F0YTJaOElRb1RH?=
 =?utf-8?B?bHRXb01FOXNYdWxDQ3pWUXhjM2VmNUVNK0t2Wk5PbFpXNkxDa1BXZUtXS0lx?=
 =?utf-8?B?eUkzSWp1eUZSbUQydkhvcVBpZG4vYmkvOXRJR3RKdTRSOEFjcmg3Wk9XWFE1?=
 =?utf-8?B?TFBwSzNLNTNuZ0RXclNMR1NTekVqK3FoOUFZMklzMURKNVBreFdxYnltUmtU?=
 =?utf-8?B?L2w0QzBYblV3MXRqOGY3RHFpYmZJKzBiczE1c0Z6Z2p1UXRHNTBXazlXWlJx?=
 =?utf-8?B?N1lKbmRScklLU09XOUlMZmdTTy9xWkdERU9aWDd4UmsxUnhiSzQ0L1J3bzlZ?=
 =?utf-8?B?b1o4NXJqUUJEbHhFOVkrMlhrckZ3cnRDdmlqTWdTcXVHMUNKS016V1dmNWM4?=
 =?utf-8?B?Y1c4MXdIUGh2TXlZSGN5Vk43czZKVzdPdUx3MGZ2ak5vNmxtSFkxenBWamNJ?=
 =?utf-8?B?MERGQkppSllBdTZtN2Q2amk4WWpkdVMxSldTTE94MUhHWERGYUR4REZkUXdt?=
 =?utf-8?B?THNaN090K0hZNDRyNnc2dnljSTMwRUlLTEJpRkNyemo5S1g4RmFkbmJkMXdN?=
 =?utf-8?B?YXczb2VQaXhPQ1ZnanlkRDlpUjQvSlM3TkdwcDFseWs2eUprajltd2NoenZZ?=
 =?utf-8?B?MjZmQUZweGhwbGVZVkpPOEVMYzl0TmIrK0x0LzZNM0E4aDlvZS9PZHdTNllJ?=
 =?utf-8?B?MVlReStDbTQ5TGtid0h0RGEwakdiNisvOXRBY0hMajQ2d0tIVFE3b2JGN0dB?=
 =?utf-8?B?Sm5yL2ZncitFMCs0eFh1UmZPTGtqUmt1elZNK3Z5WjBxaGtlekJqWnRxVVJU?=
 =?utf-8?B?Q2N3SkRUdmdRMWhwSzBwUE9jbEF5MTRaWUVzMFR5dC9JWFVzaWNwWTcwcDFs?=
 =?utf-8?B?RWdKTnh2MmNJYVN2Vi9Oc1lScVZOUURDeFBNNnJUL0I5YlhzQmpCWkhiWEJv?=
 =?utf-8?Q?2wshsdhahpuWeD6j4lqWGoXADCIJwmwvB7Zqldb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af5c342-b41b-45f4-a824-08d906011df8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 02:40:12.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 890h9V/jzaH61olgaEVevtsaDmTPhgAWgN6LUpYuaZuMfkmiBenc+9EylOZs1Y7q34Rtrqguuba3G14Tj/am+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1951
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some AMD Ryzen generations has different calculation method on maximum
perf. 255 is not for all asics, some specific generations should use 166
as the maximum perf. Otherwise, it will report incorrect frequency value
like below:

~ → lscpu | grep MHz
CPU MHz:                         3400.000
CPU max MHz:                     7228.3198
CPU min MHz:                     2200.0000

Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")

Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211791
Signed-off-by: Huang Rui <ray.huang@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Nathan Fontenot <nathan.fontenot@amd.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
---

Changes from V1 -> V2:
- Enhance the commit message.
- Move amd_get_highest_perf() into amd.c.
- Refine the implementation of switch-case.
- Cc stable mail list.

Changes from V2 -> V3:
- Move the update into cppc_get_perf_caps() to correct the highest perf value in
  the API.

---
 arch/x86/include/asm/processor.h |  2 ++
 arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
 drivers/acpi/cppc_acpi.c         |  8 ++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f1b9ed5efaa9..908bcaea1361 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
 
 #ifdef CONFIG_CPU_SUP_AMD
 extern u32 amd_get_nodes_per_socket(void);
+extern u32 amd_get_highest_perf(void);
 #else
 static inline u32 amd_get_nodes_per_socket(void)	{ return 0; }
+static inline u32 amd_get_highest_perf(void)		{ return 0; }
 #endif
 
 static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 347a956f71ca..aadb691d9357 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
 		break;
 	}
 }
+
+u32 amd_get_highest_perf(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u32 cppc_max_perf = 225;
+
+	switch (c->x86) {
+	case 0x17:
+		if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
+		    (c->x86_model >= 0x70 && c->x86_model < 0x80))
+			cppc_max_perf = 166;
+		break;
+	case 0x19:
+		if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
+		    (c->x86_model >= 0x40 && c->x86_model < 0x70))
+			cppc_max_perf = 166;
+		break;
+	}
+
+	return cppc_max_perf;
+}
+EXPORT_SYMBOL_GPL(amd_get_highest_perf);
diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 69057fcd2c04..58e72b6e222f 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1107,8 +1107,12 @@ int cppc_get_perf_caps(int cpunum, struct cppc_perf_caps *perf_caps)
 		}
 	}
 
-	cpc_read(cpunum, highest_reg, &high);
-	perf_caps->highest_perf = high;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
+		perf_caps->highest_perf = amd_get_highest_perf();
+	} else {
+		cpc_read(cpunum, highest_reg, &high);
+		perf_caps->highest_perf = high;
+	}
 
 	cpc_read(cpunum, lowest_reg, &low);
 	perf_caps->lowest_perf = low;
-- 
2.25.1

