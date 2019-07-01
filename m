Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0666411D08
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfEBP2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbfEBP2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:28:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5EF020449;
        Thu,  2 May 2019 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810885;
        bh=tFwOcYdBwnNQrXnokDuMr2z2Fknctptsdej0/v3dbGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvhxoIbm6OM+EuSJCj5WhCCoiDTKkSqvhiH/PaIcrtyM7XXr02ziRdki7L7EhC4BP
         GoT1Txn1CnLHilCHN+Ep1uQa0/Mdj8rcBGyIFzgYBAFW3h1v/A41SAXgjV2XbrSMrH
         7EqQbFLKKzBOoZ9RoM5nzsvm7dsn1wjP+CnHBQ6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Kim Phillips <kim.phillips@arm.com>,
        Li Bin <huawei.libin@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 67/72] perf machine: Update kernel map address and re-order properly
Date:   Thu,  2 May 2019 17:21:29 +0200
Message-Id: <20190502143338.609980215@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 977c7a6d1e263ff1d755f28595b99e4bc0c48a9f ]

Since commit 1fb87b8e9599 ("perf machine: Don't search for active kernel
start in __machine__create_kernel_maps"), the __machine__create_kernel_maps()
just create a map what start and end are both zero. Though the address will be
updated later, the order of map in the rbtree may be incorrect.

The commit ee05d21791db ("perf machine: Set main kernel end address properly")
fixed the logic in machine__create_kernel_maps(), but it's still wrong in
function machine__process_kernel_mmap_event().

To reproduce this issue, we need an environment which the module address
is before the kernel text segment. I tested it on an aarch64 machine with
kernel 4.19.25:

  [root@localhost hulk]# grep _stext /proc/kallsyms
  ffff000008081000 T _stext
  [root@localhost hulk]# grep _etext /proc/kallsyms
  ffff000009780000 R _etext
  [root@localhost hulk]# tail /proc/modules
  hisi_sas_v2_hw 77824 0 - Live 0xffff00000191d000
  nvme_core 126976 7 nvme, Live 0xffff0000018b6000
  mdio 20480 1 ixgbe, Live 0xffff0000018ab000
  hisi_sas_main 106496 1 hisi_sas_v2_hw, Live 0xffff000001861000
  hns_mdio 20480 2 - Live 0xffff000001822000
  hnae 28672 3 hns_dsaf,hns_enet_drv, Live 0xffff000001815000
  dm_mirror 40960 0 - Live 0xffff000001804000
  dm_region_hash 32768 1 dm_mirror, Live 0xffff0000017f5000
  dm_log 32768 2 dm_mirror,dm_region_hash, Live 0xffff0000017e7000
  dm_mod 315392 17 dm_mirror,dm_log, Live 0xffff000001780000
  [root@localhost hulk]#

Before fix:

  [root@localhost bin]# perf record sleep 3
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.011 MB perf.data (9 samples) ]
  [root@localhost bin]# perf buildid-list -i perf.data
  4c4e46c971ca935f781e603a09b52a92e8bdfee8 [vdso]
  [root@localhost bin]# perf buildid-list -i perf.data -H
  0000000000000000000000000000000000000000 /proc/kcore
  [root@localhost bin]#

After fix:

  [root@localhost tools]# ./perf/perf record sleep 3
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.011 MB perf.data (9 samples) ]
  [root@localhost tools]# ./perf/perf buildid-list -i perf.data
  28a6c690262896dbd1b5e1011ed81623e6db0610 [kernel.kallsyms]
  106c14ce6e4acea3453e484dc604d66666f08a2f [vdso]
  [root@localhost tools]# ./perf/perf buildid-list -i perf.data -H
  28a6c690262896dbd1b5e1011ed81623e6db0610 /proc/kcore

Signed-off-by: Wei Li <liwei391@huawei.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Kim Phillips <kim.phillips@arm.com>
Cc: Li Bin <huawei.libin@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20190228092003.34071-1-liwei391@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 tools/perf/util/machine.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b1508ce3e412..076718a7b3ea 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1358,6 +1358,20 @@ static void machine__set_kernel_mmap(struct machine *machine,
 		machine->vmlinux_map->end = ~0ULL;
 }
 
+static void machine__update_kernel_mmap(struct machine *machine,
+				     u64 start, u64 end)
+{
+	struct map *map = machine__kernel_map(machine);
+
+	map__get(map);
+	map_groups__remove(&machine->kmaps, map);
+
+	machine__set_kernel_mmap(machine, start, end);
+
+	map_groups__insert(&machine->kmaps, map);
+	map__put(map);
+}
+
 int machine__create_kernel_maps(struct machine *machine)
 {
 	struct dso *kernel = machine__get_kernel(machine);
@@ -1390,17 +1404,11 @@ int machine__create_kernel_maps(struct machine *machine)
 			goto out_put;
 		}
 
-		/* we have a real start address now, so re-order the kmaps */
-		map = machine__kernel_map(machine);
-
-		map__get(map);
-		map_groups__remove(&machine->kmaps, map);
-
-		/* assume it's the last in the kmaps */
-		machine__set_kernel_mmap(machine, addr, ~0ULL);
-
-		map_groups__insert(&machine->kmaps, map);
-		map__put(map);
+		/*
+		 * we have a real start address now, so re-order the kmaps
+		 * assume it's the last in the kmaps
+		 */
+		machine__update_kernel_mmap(machine, addr, ~0ULL);
 	}
 
 	if (machine__create_extra_kernel_maps(machine, kernel))
@@ -1536,7 +1544,7 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		if (strstr(kernel->long_name, "vmlinux"))
 			dso__set_short_name(kernel, "[kernel.vmlinux]", false);
 
-		machine__set_kernel_mmap(machine, event->mmap.start,
+		machine__update_kernel_mmap(machine, event->mmap.start,
 					 event->mmap.start + event->mmap.len);
 
 		/*
-- 
2.19.1



