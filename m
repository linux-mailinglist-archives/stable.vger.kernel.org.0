Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA12137938
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgAJWF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgAJWF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3548620678;
        Fri, 10 Jan 2020 22:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693958;
        bh=hNUI5rCXY/JGwB+H+BOV4HGykXp69tf62roWzp9ofdo=;
        h=From:To:Cc:Subject:Date:From;
        b=BDR1/nKXPYPRJtI1tdfJgdh86fVC1BXVdn2707GXsp3DdfwMlOuScxtDEtaxntoPL
         +3gcvDGLoib3qVROGEaiuzkC4559hc4/C2+D+Ai3tdeaW1ghQo0HYDxhdje8XpNxJx
         Z5CQsP8HWs5FCN5AWzgrrBqioHnFtc6gm1NYnXpI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Kondratiev <vladimir.kondratiev@intel.com>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 01/11] mips: cacheinfo: report shared CPU map
Date:   Fri, 10 Jan 2020 17:05:46 -0500
Message-Id: <20200110220556.28505-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Kondratiev <vladimir.kondratiev@intel.com>

[ Upstream commit 3b1313eb32c499d46dc4c3e896d19d9564c879c4 ]

Report L1 caches as shared per core; L2 - per cluster.

This fixes "perf" that went crazy if shared_cpu_map attribute not
reported on sysfs, in form of

/sys/devices/system/cpu/cpu*/cache/index*/shared_cpu_list
/sys/devices/system/cpu/cpu*/cache/index*/shared_cpu_map

Signed-off-by: Vladimir Kondratiev <vladimir.kondratiev@intel.com>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cacheinfo.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/cacheinfo.c b/arch/mips/kernel/cacheinfo.c
index 428ef2189203..3ea95568ece4 100644
--- a/arch/mips/kernel/cacheinfo.c
+++ b/arch/mips/kernel/cacheinfo.c
@@ -61,6 +61,25 @@ static int __init_cache_level(unsigned int cpu)
 	return 0;
 }
 
+static void fill_cpumask_siblings(int cpu, cpumask_t *cpu_map)
+{
+	int cpu1;
+
+	for_each_possible_cpu(cpu1)
+		if (cpus_are_siblings(cpu, cpu1))
+			cpumask_set_cpu(cpu1, cpu_map);
+}
+
+static void fill_cpumask_cluster(int cpu, cpumask_t *cpu_map)
+{
+	int cpu1;
+	int cluster = cpu_cluster(&cpu_data[cpu]);
+
+	for_each_possible_cpu(cpu1)
+		if (cpu_cluster(&cpu_data[cpu1]) == cluster)
+			cpumask_set_cpu(cpu1, cpu_map);
+}
+
 static int __populate_cache_leaves(unsigned int cpu)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
@@ -68,14 +87,20 @@ static int __populate_cache_leaves(unsigned int cpu)
 	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
 
 	if (c->icache.waysize) {
+		/* L1 caches are per core */
+		fill_cpumask_siblings(cpu, &this_leaf->shared_cpu_map);
 		populate_cache(dcache, this_leaf, 1, CACHE_TYPE_DATA);
+		fill_cpumask_siblings(cpu, &this_leaf->shared_cpu_map);
 		populate_cache(icache, this_leaf, 1, CACHE_TYPE_INST);
 	} else {
 		populate_cache(dcache, this_leaf, 1, CACHE_TYPE_UNIFIED);
 	}
 
-	if (c->scache.waysize)
+	if (c->scache.waysize) {
+		/* L2 cache is per cluster */
+		fill_cpumask_cluster(cpu, &this_leaf->shared_cpu_map);
 		populate_cache(scache, this_leaf, 2, CACHE_TYPE_UNIFIED);
+	}
 
 	if (c->tcache.waysize)
 		populate_cache(tcache, this_leaf, 3, CACHE_TYPE_UNIFIED);
-- 
2.20.1

