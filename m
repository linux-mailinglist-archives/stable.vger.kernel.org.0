Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17F13830DB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbhEQOb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239956AbhEQO3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0ED0613E2;
        Mon, 17 May 2021 14:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260891;
        bh=ecMUojRfCQWZifUEJf19pqCydIxR+b6WWVFbWvPzg0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjMXj0prhYOgipsh9hkLx/OB8gqu4d6TynmB7zBWs6ASd0/J4TE/wapwQ6g1rrsxu
         ngfVufZUmDWGkEeAPjVyfOJzX7kwMrhDzTQmEEt+eJDFe6U/PtCnouD/2VRMTB2Bco
         2hJvZv2qyNr9eFkBv8OBapyn/jyVQEJi5VF3nWH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Huang Rui <ray.huang@amd.com>, Ingo Molnar <mingo@kernel.org>,
        Alexander Monakov <amonakov@ispras.ru>
Subject: [PATCH 5.12 261/363] x86, sched: Fix the AMD CPPC maximum performance value on certain AMD Ryzen generations
Date:   Mon, 17 May 2021 16:02:07 +0200
Message-Id: <20210517140311.434526337@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

commit 3743d55b289c203d8f77b7cd47c24926b9d186ae upstream.

Some AMD Ryzen generations has different calculation method on maximum
performance. 255 is not for all ASICs, some specific generations should use 166
as the maximum performance. Otherwise, it will report incorrect frequency value
like below:

  ~ → lscpu | grep MHz
  CPU MHz:                         3400.000
  CPU max MHz:                     7228.3198
  CPU min MHz:                     2200.0000

[ mingo: Tidied up whitespace use. ]
[ Alexander Monakov <amonakov@ispras.ru>: fix 225 -> 255 typo. ]

Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
Fixed-by: Alexander Monakov <amonakov@ispras.ru>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210425073451.2557394-1-ray.huang@amd.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211791
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/amd.c        |   16 ++++++++++++++++
 arch/x86/kernel/smpboot.c        |    2 +-
 drivers/cpufreq/acpi-cpufreq.c   |    6 +++++-
 4 files changed, 24 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_s
 
 #ifdef CONFIG_CPU_SUP_AMD
 extern u32 amd_get_nodes_per_socket(void);
+extern u32 amd_get_highest_perf(void);
 #else
 static inline u32 amd_get_nodes_per_socket(void)	{ return 0; }
+static inline u32 amd_get_highest_perf(void)		{ return 0; }
 #endif
 
 static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1170,3 +1170,19 @@ void set_dr_addr_mask(unsigned long mask
 		break;
 	}
 }
+
+u32 amd_get_highest_perf(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
+			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
+		return 166;
+
+	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
+			       (c->x86_model >= 0x40 && c->x86_model < 0x70)))
+		return 166;
+
+	return 255;
+}
+EXPORT_SYMBOL_GPL(amd_get_highest_perf);
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -2046,7 +2046,7 @@ static bool amd_set_max_freq_ratio(void)
 		return false;
 	}
 
-	highest_perf = perf_caps.highest_perf;
+	highest_perf = amd_get_highest_perf();
 	nominal_perf = perf_caps.nominal_perf;
 
 	if (!highest_perf || !nominal_perf) {
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -646,7 +646,11 @@ static u64 get_max_boost_ratio(unsigned
 		return 0;
 	}
 
-	highest_perf = perf_caps.highest_perf;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		highest_perf = amd_get_highest_perf();
+	else
+		highest_perf = perf_caps.highest_perf;
+
 	nominal_perf = perf_caps.nominal_perf;
 
 	if (!highest_perf || !nominal_perf) {


