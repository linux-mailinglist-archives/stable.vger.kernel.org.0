Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87A84A8D61
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbiBCUax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354153AbiBCUa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:30:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DBBC061753;
        Thu,  3 Feb 2022 12:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 862D761A6C;
        Thu,  3 Feb 2022 20:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09E7C340E8;
        Thu,  3 Feb 2022 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920211;
        bh=uTVbxloRA/oMSMkup+LNxAM+kjT2Mh6U5zYG9RnWECE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/VH332pN2z3YvoHI29Dio+AbXAikl0/5bRuxptK48GS27tswlUWa3r7hYhhfEpum
         wwBTNF587BtsR9D8d2meb4G8N1BmpjAuXYEbpvlZAqqbl4QF77cyH8NZsMP3wwgv0q
         6ayuOOkp6Xik3a6luztX8iLs2f407ZTuMe2U95ML/Ln0k8V5KpU9FFh74a8++Ldb+u
         WvcybdzzqwBIqdr0GbPPBuuq9ea28mnKxsGdhDP2pDobYEe8lOTKqDMnbKWT/aUeIU
         WGzn9zx/2DXZutFt56h2o57SGEO0g3MKKr3X1H6TBglID0bbUJNvsAUkkkqlFh1qMt
         tamC3G5tlWDtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 15/52] perf/x86/rapl: fix AMD event handling
Date:   Thu,  3 Feb 2022 15:29:09 -0500
Message-Id: <20220203202947.2304-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit 0036fb00a756a2f6e360d44e2e3d2200a8afbc9b ]

The RAPL events exposed under /sys/devices/power/events should only reflect
what the underlying hardware actually support. This is how it works on Intel
RAPL and Intel core/uncore PMUs in general.
But on AMD, this was not the case. All possible RAPL events were advertised.

This is what it showed on an AMD Fam17h:
$ ls /sys/devices/power/events/
energy-cores        energy-gpu          energy-pkg          energy-psys
energy-ram          energy-cores.scale  energy-gpu.scale    energy-pkg.scale
energy-psys.scale   energy-ram.scale    energy-cores.unit   energy-gpu.unit
energy-pkg.unit     energy-psys.unit    energy-ram.unit

Yet, on AMD Fam17h, only energy-pkg is supported.

This patch fixes the problem. Given the way perf_msr_probe() works, the
amd_rapl_msrs[] table has to have all entries filled out and in particular
the group field, otherwise perf_msr_probe() defaults to making the event
visible.

With the patch applied, the kernel now only shows was is actually supported:

$ ls /sys/devices/power/events/
energy-pkg  energy-pkg.scale  energy-pkg.unit

The patch also uses the RAPL_MSR_MASK because only the 32-bits LSB of the
RAPL counters are relevant when reading power consumption.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220105185659.643355-1-eranian@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/rapl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 85feafacc445d..77e3a47af5ad5 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -536,11 +536,14 @@ static struct perf_msr intel_rapl_spr_msrs[] = {
  * - perf_msr_probe(PERF_RAPL_MAX)
  * - want to use same event codes across both architectures
  */
-static struct perf_msr amd_rapl_msrs[PERF_RAPL_MAX] = {
-	[PERF_RAPL_PKG]  = { MSR_AMD_PKG_ENERGY_STATUS,  &rapl_events_pkg_group,   test_msr },
+static struct perf_msr amd_rapl_msrs[] = {
+	[PERF_RAPL_PP0]  = { 0, &rapl_events_cores_group, 0, false, 0 },
+	[PERF_RAPL_PKG]  = { MSR_AMD_PKG_ENERGY_STATUS,  &rapl_events_pkg_group,   test_msr, false, RAPL_MSR_MASK },
+	[PERF_RAPL_RAM]  = { 0, &rapl_events_ram_group,   0, false, 0 },
+	[PERF_RAPL_PP1]  = { 0, &rapl_events_gpu_group,   0, false, 0 },
+	[PERF_RAPL_PSYS] = { 0, &rapl_events_psys_group,  0, false, 0 },
 };
 
-
 static int rapl_cpu_offline(unsigned int cpu)
 {
 	struct rapl_pmu *pmu = cpu_to_rapl_pmu(cpu);
-- 
2.34.1

