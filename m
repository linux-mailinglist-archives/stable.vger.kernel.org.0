Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B556E51A8C6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355759AbiEDRMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356869AbiEDRJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D12743AF0;
        Wed,  4 May 2022 09:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AFE2617DE;
        Wed,  4 May 2022 16:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7FEC385B0;
        Wed,  4 May 2022 16:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683369;
        bh=6KisIebj9lDcZTp40DXBowgWsCa5Vj0P7bVBz0IGuAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elDDmn+sQLcqtvqofd8iMPnjDvp6qB9EkHxkaR0/9xyQMExayXcQ3iEP+PbmL7OFA
         VEuAjwvXGCoSoGNOb6tMAkv+y7PJTohNVWqN0KZPxl53zFd4mOr4RDpL6XzU74ZnpS
         lg/8CrGXAh4w/4lGn+HVEqBuOuHusqRatP9wOkLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "D. Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>
Subject: [PATCH 5.17 040/225] topology: make core_mask include at least cluster_siblings
Date:   Wed,  4 May 2022 18:44:38 +0200
Message-Id: <20220504153113.747830165@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darren Hart <darren@os.amperecomputing.com>

commit db1e59483dfd8d4e956575302520bb8f7e20c79b upstream.

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
 drivers/base/arch_topology.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -628,6 +628,15 @@ const struct cpumask *cpu_coregroup_mask
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
 


