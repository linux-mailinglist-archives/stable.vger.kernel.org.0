Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1A713FF47
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391855AbgAPXlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388327AbgAPX1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:27:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C32B2072E;
        Thu, 16 Jan 2020 23:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217240;
        bh=Jas9M4NC9WttapCSqzQTQUihydt2rWA4eNC4cFlbr/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6dG6kMPEferV7By1oYWzHYBKqkqpknzGd0KlmkVzqgK0Ir0BcaGS6lh1BNngwYdI
         cSUFFW+J4XkgHCjmAb8wdq5UpmVBPKdNMdwCq59yTOE2+xztyZi2H3wq+6fkH+s/IY
         IKCfk0Hb9cE9O7zo0eW5VMC+ZprYbqcSo8zpnHgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Kondratiev <vladimir.kondratiev@intel.com>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/203] mips: cacheinfo: report shared CPU map
Date:   Fri, 17 Jan 2020 00:18:24 +0100
Message-Id: <20200116231800.650807790@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f777e44653d5..47312c529410 100644
--- a/arch/mips/kernel/cacheinfo.c
+++ b/arch/mips/kernel/cacheinfo.c
@@ -50,6 +50,25 @@ static int __init_cache_level(unsigned int cpu)
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
@@ -57,14 +76,20 @@ static int __populate_cache_leaves(unsigned int cpu)
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



