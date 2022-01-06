Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DDB486114
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 08:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbiAFHno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 02:43:44 -0500
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:41953
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234484AbiAFHnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jan 2022 02:43:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InRfE+yg2ivPqqUsrFhxPwdN67aQ/yXRwIuYWS/hi7KGXHHXQjiKAu9vPgXNoqgnvgAUXXV4ucAvbAX7NWANu8ainwYwrWOtQGk6yWqASSb9A1UXuYZDRy6+DDZyDYg8aiCV4GowiSCIW6/b1awLY3mlpDhx00F51ZhaoFr2mO+LqI6lyA+B9jkxuTsYZUWo07tAgv1qACbMHfoqG0yKgkSk3mjni1lTF3UvKwOZYUJ6J7gTgz0+w/flCXASm7W4oNkQyAsN3So5YHqwjTKC8hLmMLcNwSFdmMQAcUk8+whiBtEqdazrEN543djUf/rOH7gCV0h2HD/PCESWStHcPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPR0atBDHY80BPB4rfw9xxOAR0z+Hek8HoPovBWKUh4=;
 b=XEAzHr8v76MESKO00UFlXwn2dmJnlp/tl1VxfBDq1AOyNIlo0oxBAA0iYwEceemTyIF1/URb9VJlrsLt7SARk5mTPI23I4C7bVzMWK9bSNnysz0QG1k4xhig2RPQtHYRlnwYapMPuVf0WTbI7il0w/x4kIkL/OG3pWBvmrBkCGOYgzeP77AVrawFFc3368Q6gzVnNA3MKCNo3X2Vg2ZijMNgsM+WDfd3kUlzpqfCavHTHMgS/VfRH2ZzoGtEUsBmpxdyhHk4GqPGu1I36NiKL00Ep++VdmFYEWJ+W0DN79wp/VjOF6lTPGnu/Os0uRpuX7heHvmE0UXU9jadz4bnow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPR0atBDHY80BPB4rfw9xxOAR0z+Hek8HoPovBWKUh4=;
 b=bYenOkd25WoGbKkVzte++c5KtVv4VwexYH+3xH3AaECrmUHaU1XAz4A0aps5Pq8l1usRn1C4m4MUVpIq80X4yWbFNau2v8z3VBf4iH2WH3njuVIXeUyMwLOx3gEi1RvylkEgkpCLEcnptg8S5AIXbSuLppmcDrU3x1f47CQh9qk=
Received: from BN9PR03CA0191.namprd03.prod.outlook.com (2603:10b6:408:f9::16)
 by BN9PR12MB5130.namprd12.prod.outlook.com (2603:10b6:408:137::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 07:43:34 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::a7) by BN9PR03CA0191.outlook.office365.com
 (2603:10b6:408:f9::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Thu, 6 Jan 2022 07:43:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.7 via Frontend Transport; Thu, 6 Jan 2022 07:43:34 +0000
Received: from hr-amd.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 01:43:29 -0600
From:   Huang Rui <ray.huang@amd.com>
To:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Perry Yuan <Perry.Yuan@amd.com>, Jinzhou Su <Jinzhou.Su@amd.com>,
        "Xiaojian Du" <Xiaojian.Du@amd.com>, Huang Rui <ray.huang@amd.com>,
        kernel test robot <lkp@intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, <x86@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] x86, sched: Fix the undefined reference building error of init_freq_invariance_cppc
Date:   Thu, 6 Jan 2022 15:43:06 +0800
Message-ID: <20220106074306.2712090-2-ray.huang@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106074306.2712090-1-ray.huang@amd.com>
References: <20220106074306.2712090-1-ray.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17b74f13-a550-4263-8a48-08d9d0e83e6f
X-MS-TrafficTypeDiagnostic: BN9PR12MB5130:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5130B52FB7D374EBA53CD4A5EC4C9@BN9PR12MB5130.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qW4kIlqpXYju5u0vziJWVPad5dfDSRCXJmvJlWfFGGdwzo/3fJXIlfV0V4mnm6lYjooUg1MmBFV8+ddQiktrWFIl7btuc+RA4fqk5WBkFzj42uVB0qIaUkI3O6YDf1HJ/PNiQzaB1Rx1C9DkL2n7P47jFm9dRxoBqeyjRBvXiB2fvq2CBco0yyIgP+NYiATgqa39oWBtRAsPy/X0DvNSdpdi3wM8T61iOTTMclg20ZcwuQQPi/XnVg+C00DfNQ/yXITt4w2ilY44S9uH0kwTdD8sqWVCMtl/RjNMg5bIfOBPZmlcz35iz8k7R++8GNvQZQaOuXPH9sCVkbwhdKsz4vE1kXZavFHcR10XFaCnHaoZaoSZCXKr4m9XIkcHbdNVz5pP9ilLVXXWrjRxiIxYkPAytogsLHORNYfE64SnRcVXWMz0rBiQ6wmo88dRwZI4bWsu5Ow7OzF2EvkOeiP+rljoDIJ2Vt+pHuSl/ZDGgFFs0gepHGUjZO7LPVkpZy2p6FbmhWkdMLG8QOS2FdnfKQz7cP5aKTBd70AwQPLGNVJswQo1j5fD/Njwdv/5Obu8oTzUiSv0CsGKSlfL46w5mncteEF4FUsFD2THqLF9dOc5O0cGOouCJNkUR4ShVM8dDCI3DVgGiyyp3ReSAZl3INPE9TB8zqTLkF6R6mQ1KNanbzdVcMqvQK53qIHDku4I7oVbjcVrIWDlcB/FODLKqWgUL+vpfYGcZqzHVKF+o+B7H8/mqwa/mfOs5I4xorr0UftXwkGzl5HUhu+eWruiWhgP2CtPDQajY2zPuY6uPoiveQhJvgLY9VobU3ngYA2eC2xzmz8cYwplJcMvP12VpUehfIk2txa9lhjhiQlrx79M1NvOnkRZGf9zBwEx/bTH
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(316002)(2906002)(336012)(966005)(36860700001)(82310400004)(5660300002)(8676002)(6666004)(508600001)(4326008)(110136005)(2616005)(86362001)(70586007)(40460700001)(47076005)(83380400001)(70206006)(81166007)(26005)(16526019)(356005)(1076003)(36756003)(8936002)(54906003)(426003)(7696005)(186003)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 07:43:34.7654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b74f13-a550-4263-8a48-08d9d0e83e6f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The init_freq_invariance_cppc function is implemented in smpboot and depends on
CONFIG_SMP.

  MODPOST vmlinux.symvers
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
  LD      .tmp_vmlinux.kallsyms1
ld: drivers/acpi/cppc_acpi.o: in function `acpi_cppc_processor_probe':
/home/ray/brahma3/linux/drivers/acpi/cppc_acpi.c:819: undefined reference to `init_freq_invariance_cppc'
make: *** [Makefile:1161: vmlinux] Error 1

See https://lore.kernel.org/lkml/484af487-7511-647e-5c5b-33d4429acdec@infradead.org/.

Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
---
 arch/x86/include/asm/topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index cc164777e661..2f0b6be8eaab 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -221,7 +221,7 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled)
 }
 #endif
 
-#ifdef CONFIG_ACPI_CPPC_LIB
+#if defined(CONFIG_ACPI_CPPC_LIB) && defined(CONFIG_SMP)
 void init_freq_invariance_cppc(void);
 #define init_freq_invariance_cppc init_freq_invariance_cppc
 #endif
-- 
2.25.1

