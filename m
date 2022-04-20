Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D20508DDE
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380820AbiDTRDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 13:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380816AbiDTRDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 13:03:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DF520BC9
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 10:00:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DE164CE1F39
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 17:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99F1C385A1;
        Wed, 20 Apr 2022 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650474047;
        bh=IQXVmyq50eTLFr9R0yU4kcv2+J+AGruml4vdMvbhcJI=;
        h=Subject:To:From:Date:From;
        b=OWOQ1kicQahH9xnq0762DTIBiXGsbfyenIY3/eTdl28xXvEXMZ71FR0RqBd4Q9/Wr
         RYMk+VgcXdbfXCPaM1DkW5uyYMZAm/oO8hMB7IfI0v+MOhptNtpbRjtQv4I1t98et9
         caEsXbMp9QeOpfoW2vtsGoc8BbGG08ApRVKhdwUY=
Subject: patch "topology: make core_mask include at least cluster_siblings" added to driver-core-linus
To:     darren@os.amperecomputing.com, catalin.marinas@arm.com,
        dietmar.eggemann@arm.com, gregkh@linuxfoundation.org,
        ilkka@os.amperecomputing.com, peterz@infradead.org,
        rafael@kernel.org, scott@os.amperecomputing.com,
        song.bao.hua@hisilicon.com, stable@vger.kernel.org,
        sudeep.holla@arm.com, vincent.guittot@linaro.org, will@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 20 Apr 2022 19:00:36 +0200
Message-ID: <1650474036203198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    topology: make core_mask include at least cluster_siblings

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From db1e59483dfd8d4e956575302520bb8f7e20c79b Mon Sep 17 00:00:00 2001
From: Darren Hart <darren@os.amperecomputing.com>
Date: Mon, 11 Apr 2022 13:53:34 -0700
Subject: topology: make core_mask include at least cluster_siblings

Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
Control Unit, but have no shared CPU-side last level cache.

cpu_coregroup_mask() will return a cpumask with weight 1, while
cpu_clustergroup_mask() will return a cpumask with weight 2.

As a result, build_sched_domain() will BUG() once per CPU with:

BUG: arch topology borken
the CLS domain not a subset of the MC domain

The MC level cpumask is then extended to that of the CLS child, and is
later removed entirely as redundant. This sched domain topology is an
improvement over previous topologies, or those built without
SCHED_CLUSTER, particularly for certain latency sensitive workloads.
With the current scheduler model and heuristics, this is a desirable
default topology for Ampere Altra and Altra Max system.

Rather than create a custom sched domains topology structure and
introduce new logic in arch/arm64 to detect these systems, update the
core_mask so coregroup is never a subset of clustergroup, extending it
to cluster_siblings if necessary. Only do this if CONFIG_SCHED_CLUSTER
is enabled to avoid also changing the topology (MC) when
CONFIG_SCHED_CLUSTER is disabled.

This has the added benefit over a custom topology of working for both
symmetric and asymmetric topologies. It does not address systems where
the CLUSTER topology is above a populated MC topology, but these are not
considered today and can be addressed separately if and when they
appear.

The final sched domain topology for a 2 socket Ampere Altra system is
unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:

For CPU0:

CONFIG_SCHED_CLUSTER=y
CLS  [0-1]
DIE  [0-79]
NUMA [0-159]

CONFIG_SCHED_CLUSTER is not set
DIE  [0-79]
NUMA [0-159]

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: D. Scott Phillips <scott@os.amperecomputing.com>
Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
Link: https://lore.kernel.org/r/c8fe9fce7c86ed56b4c455b8c902982dc2303868.1649696956.git.darren@os.amperecomputing.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/arch_topology.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 1d6636ebaac5..5497c5ab7318 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 			core_mask = &cpu_topology[cpu].llc_sibling;
 	}
 
+	/*
+	 * For systems with no shared cpu-side LLC but with clusters defined,
+	 * extend core_mask to cluster_siblings. The sched domain builder will
+	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
+	 */
+	if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
+	    cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
+		core_mask = &cpu_topology[cpu].cluster_sibling;
+
 	return core_mask;
 }
 
-- 
2.35.3


