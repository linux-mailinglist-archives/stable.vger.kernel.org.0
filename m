Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4A737ED9D
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387836AbhELUkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53452 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244950AbhELTVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:21:19 -0400
Date:   Wed, 12 May 2021 19:20:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620847209;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9CqgNt7a1291GXPjc3CSNz5tckZZ3tHmPuyScdCQVA=;
        b=IsROUS4APyxfYGG36ohjTCkBKPAA183IAUN/J/cqgAGeoEqrUTRFXXMi7eKjbKGpnql6lw
        qZ60CkzNab9ewMamLVcO+YAJJR3Yl1IgFki9C/g2odJjpal6can8bv0QkH8iuT1MoJP2UH
        EvpUiFSPgY2GhygJiI9W6Elo+L8/t37Rtj1pE9pC2EZSAxFWxG/oRYT3kNTqA5SSKOWZkj
        lHas+hIelFUMb0S20o5A+ErHusQcwTDLA2/TaavSeBXSqN0scSoYvU3nceYlJhjGIsk3lK
        HFwUyTzLFxsaff2B1Ujze14RDXinxuzhEASIOWCf90bxYwGxChCmxsADbfDCvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620847209;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9CqgNt7a1291GXPjc3CSNz5tckZZ3tHmPuyScdCQVA=;
        b=pcvKKGaGHByclnWR7utJ6ofzRBTl971ZR+JNGialqF9K6Y4d7xSxUwdOGu8UeUzLw4bW1+
        8cdHDtNQhAlIysAA==
From:   "tip-bot2 for Huang Rui" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] x86, sched: Fix the AMD CPPC maximum performance
 value on certain AMD Ryzen generations
Cc:     Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Huang Rui <ray.huang@amd.com>, Ingo Molnar <mingo@kernel.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210425073451.2557394-1-ray.huang@amd.com>
References: <20210425073451.2557394-1-ray.huang@amd.com>
MIME-Version: 1.0
Message-ID: <162084720697.29796.16642711613957963140.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     337fb3130c29ef5ea3bbcd45e6589b7be6deeb4d
Gitweb:        https://git.kernel.org/tip/337fb3130c29ef5ea3bbcd45e6589b7be6d=
eeb4d
Author:        Huang Rui <ray.huang@amd.com>
AuthorDate:    Sun, 25 Apr 2021 15:34:51 +08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 12 May 2021 21:14:08 +02:00

x86, sched: Fix the AMD CPPC maximum performance value on certain AMD Ryzen g=
enerations

Some AMD Ryzen generations has different calculation method on maximum
performance. 255 is not for all ASICs, some specific generations should use 1=
66
as the maximum performance. Otherwise, it will report incorrect frequency val=
ue
like below:

  ~ =E2=86=92 lscpu | grep MHz
  CPU MHz:                         3400.000
  CPU max MHz:                     7228.3198
  CPU min MHz:                     2200.0000

[ mingo: Tidied up whitespace use. ]

Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD syst=
ems")
Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost f=
requencies")
Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210425073451.2557394-1-ray.huang@amd.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D211791
---
 arch/x86/include/asm/processor.h |  2 ++
 arch/x86/kernel/cpu/amd.c        | 16 ++++++++++++++++
 arch/x86/kernel/smpboot.c        |  2 +-
 drivers/cpufreq/acpi-cpufreq.c   |  6 +++++-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processo=
r.h
index 154321d..556b2b1 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -787,8 +787,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
=20
 #ifdef CONFIG_CPU_SUP_AMD
 extern u32 amd_get_nodes_per_socket(void);
+extern u32 amd_get_highest_perf(void);
 #else
 static inline u32 amd_get_nodes_per_socket(void)	{ return 0; }
+static inline u32 amd_get_highest_perf(void)		{ return 0; }
 #endif
=20
 static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leave=
s)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2d11384..109d2c7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1165,3 +1165,19 @@ void set_dr_addr_mask(unsigned long mask, int dr)
 		break;
 	}
 }
+
+u32 amd_get_highest_perf(void)
+{
+	struct cpuinfo_x86 *c =3D &boot_cpu_data;
+
+	if (c->x86 =3D=3D 0x17 && ((c->x86_model >=3D 0x30 && c->x86_model < 0x40) =
||
+			       (c->x86_model >=3D 0x70 && c->x86_model < 0x80)))
+		return 166;
+
+	if (c->x86 =3D=3D 0x19 && ((c->x86_model >=3D 0x20 && c->x86_model < 0x30) =
||
+			       (c->x86_model >=3D 0x40 && c->x86_model < 0x70)))
+		return 166;
+
+	return 225;
+}
+EXPORT_SYMBOL_GPL(amd_get_highest_perf);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0ad5214..7770245 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -2043,7 +2043,7 @@ static bool amd_set_max_freq_ratio(void)
 		return false;
 	}
=20
-	highest_perf =3D perf_caps.highest_perf;
+	highest_perf =3D amd_get_highest_perf();
 	nominal_perf =3D perf_caps.nominal_perf;
=20
 	if (!highest_perf || !nominal_perf) {
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index d1bbc16..7e74504 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -646,7 +646,11 @@ static u64 get_max_boost_ratio(unsigned int cpu)
 		return 0;
 	}
=20
-	highest_perf =3D perf_caps.highest_perf;
+	if (boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_AMD)
+		highest_perf =3D amd_get_highest_perf();
+	else
+		highest_perf =3D perf_caps.highest_perf;
+
 	nominal_perf =3D perf_caps.nominal_perf;
=20
 	if (!highest_perf || !nominal_perf) {
