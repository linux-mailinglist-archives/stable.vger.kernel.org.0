Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69824605E9
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 12:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhK1LpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 06:45:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33918 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbhK1LnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 06:43:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1491960F1F
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14BBC004E1;
        Sun, 28 Nov 2021 11:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638099583;
        bh=+5Exwmi7jaN7SiJnAkiJvg8hy5KkIcwnejPezG22Fs0=;
        h=Subject:To:Cc:From:Date:From;
        b=sDmWjgG09rFIlaZ7qpWy4GK94v552EYQBOwxN4igsnF9Uqh5B2OuEEyS4aUmiQqN4
         s65tjwjQUIV9NlW8wtWsiJCGLJVB3g1aa0j9dqbF/QqKRJfOXeJzz0eABqsegi6b3v
         ZThKjb5Lc5EsqGDew7hBELF0NiAK/NtYaOCAUeqk=
Subject: FAILED: patch "[PATCH] cpufreq: intel_pstate: Fix active mode offline/online EPP" failed to apply to 5.10-stable tree
To:     rafael.j.wysocki@intel.com, srinivas.pandruvada@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Nov 2021 12:39:40 +0100
Message-ID: <163809958089253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ed38eb49d101e829ae0f8c0a0d3bf5cb6bcbc6b2 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Wed, 17 Nov 2021 14:57:31 +0100
Subject: [PATCH] cpufreq: intel_pstate: Fix active mode offline/online EPP
 handling

After commit 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and
->online callbacks") the EPP value set by the "performance" scaling
algorithm in the active mode is not restored after an offline/online
cycle which replaces it with the saved EPP value coming from user
space.

Address this issue by forcing intel_pstate_hwp_set() to set a new
EPP value when it runs first time after online.

Fixes: 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and ->online callbacks")
Link: https://lore.kernel.org/linux-pm/adc7132c8655bd4d1c8b6129578e931a14fe1db2.camel@linux.intel.com/
Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 1088ff350159..1bc00645b656 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1006,6 +1006,12 @@ static void intel_pstate_hwp_offline(struct cpudata *cpu)
 		 */
 		value &= ~GENMASK_ULL(31, 24);
 		value |= HWP_ENERGY_PERF_PREFERENCE(cpu->epp_cached);
+		/*
+		 * However, make sure that EPP will be set to "performance" when
+		 * the CPU is brought back online again and the "performance"
+		 * scaling algorithm is still in effect.
+		 */
+		cpu->epp_policy = CPUFREQ_POLICY_UNKNOWN;
 	}
 
 	/*

