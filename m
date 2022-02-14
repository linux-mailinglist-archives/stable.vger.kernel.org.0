Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF14B4929
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343927AbiBNJ7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:59:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344052AbiBNJ6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:58:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB2D6A3B7;
        Mon, 14 Feb 2022 01:46:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51FDAB80DC7;
        Mon, 14 Feb 2022 09:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E6AC340E9;
        Mon, 14 Feb 2022 09:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831962;
        bh=uTVbxloRA/oMSMkup+LNxAM+kjT2Mh6U5zYG9RnWECE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eejCPZqwJ0lg4Camvy5UgFbPHtw/dPEhZRMjV/JkQrRY2Y59es/Skl7hVJXMMLAn9
         jSDYQn14XLo6j7Vubfo+H6JHH+9BcBPMza/nHYxqYY9RZuTqi8QULSb9kAdd+TGT/Z
         oBr9utt2fA6ZMUIEkvk2pxWRyugyU/kiS6XOYhok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/172] perf/x86/rapl: fix AMD event handling
Date:   Mon, 14 Feb 2022 10:24:54 +0100
Message-Id: <20220214092507.650404408@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



