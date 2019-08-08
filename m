Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD6B86929
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390348AbfHHSzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 14:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390201AbfHHSzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 14:55:17 -0400
Received: from quaco.ghostprotocols.net (unknown [177.195.210.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A52AA21882;
        Thu,  8 Aug 2019 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565290516;
        bh=hCGEPreGEztLG4/FZ1cf7YUJEYlwsdXQHRn+GLNH6oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooriS+alDM8vU/wTHP5IJJ5AdJhkkSgJUF+9HNv9KuyE4/5PCkmMunfOL794X89J1
         GgQ0LBz8ZzKa88g4fB+SM0OhfasJ2tT55uznrF9ldgMe9tpxNlOwPFdgE8/I3WEAjm
         SHfvUDi0sq8/CCzcrnM70fB+ZbwXFOqWh12ZTj4A=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Thomas Richter <tmricht@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/10] perf record: Fix module size on s390
Date:   Thu,  8 Aug 2019 15:53:56 -0300
Message-Id: <20190808185358.20125-9-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808185358.20125-1-acme@kernel.org>
References: <20190808185358.20125-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

On s390 the modules loaded in memory have the text segment located after
the GOT and Relocation table. This can be seen with this output:

  [root@m35lp76 perf]# fgrep qeth /proc/modules
  qeth 151552 1 qeth_l2, Live 0x000003ff800b2000
  ...
  [root@m35lp76 perf]# cat /sys/module/qeth/sections/.text
  0x000003ff800b3990
  [root@m35lp76 perf]#

There is an offset of 0x1990 bytes. The size of the qeth module is
151552 bytes (0x25000 in hex).

The location of the GOT/relocation table at the beginning of a module is
unique to s390.

commit 203d8a4aa6ed ("perf s390: Fix 'start' address of module's map")
adjusts the start address of a module in the map structures, but does
not adjust the size of the modules. This leads to overlapping of module
maps as this example shows:

[root@m35lp76 perf] # ./perf report -D
     0 0 0xfb0 [0xa0]: PERF_RECORD_MMAP -1/0: [0x3ff800b3990(0x25000)
          @ 0]:  x /lib/modules/.../qeth.ko.xz
     0 0 0x1050 [0xb0]: PERF_RECORD_MMAP -1/0: [0x3ff800d85a0(0x8000)
          @ 0]:  x /lib/modules/.../ip6_tables.ko.xz

The module qeth.ko has an adjusted start address modified to b3990, but
its size is unchanged and the module ends at 0x3ff800d8990.  This end
address overlaps with the next modules start address of 0x3ff800d85a0.

When the size of the leading GOT/Relocation table stored in the
beginning of the text segment (0x1990 bytes) is subtracted from module
qeth end address, there are no overlaps anymore:

   0x3ff800d8990 - 0x1990 = 0x0x3ff800d7000

which is the same as

   0x3ff800b2000 + 0x25000 = 0x0x3ff800d7000.

To fix this issue, also adjust the modules size in function
arch__fix_module_text_start(). Add another function parameter named size
and reduce the size of the module when the text segment start address is
changed.

Output after:
     0 0 0xfb0 [0xa0]: PERF_RECORD_MMAP -1/0: [0x3ff800b3990(0x23670)
          @ 0]:  x /lib/modules/.../qeth.ko.xz
     0 0 0x1050 [0xb0]: PERF_RECORD_MMAP -1/0: [0x3ff800d85a0(0x7a60)
          @ 0]:  x /lib/modules/.../ip6_tables.ko.xz

Reported-by: Stefan Liebler <stli@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 203d8a4aa6ed ("perf s390: Fix 'start' address of module's map")
Link: http://lkml.kernel.org/r/20190724122703.3996-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/s390/util/machine.c | 14 +++++++++++++-
 tools/perf/util/machine.c           |  3 ++-
 tools/perf/util/machine.h           |  2 +-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/arch/s390/util/machine.c b/tools/perf/arch/s390/util/machine.c
index a19690a17291..de26b1441a48 100644
--- a/tools/perf/arch/s390/util/machine.c
+++ b/tools/perf/arch/s390/util/machine.c
@@ -7,7 +7,7 @@
 #include "api/fs/fs.h"
 #include "debug.h"
 
-int arch__fix_module_text_start(u64 *start, const char *name)
+int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
 {
 	u64 m_start = *start;
 	char path[PATH_MAX];
@@ -17,6 +17,18 @@ int arch__fix_module_text_start(u64 *start, const char *name)
 	if (sysfs__read_ull(path, (unsigned long long *)start) < 0) {
 		pr_debug2("Using module %s start:%#lx\n", path, m_start);
 		*start = m_start;
+	} else {
+		/* Successful read of the modules segment text start address.
+		 * Calculate difference between module start address
+		 * in memory and module text segment start address.
+		 * For example module load address is 0x3ff8011b000
+		 * (from /proc/modules) and module text segment start
+		 * address is 0x3ff8011b870 (from file above).
+		 *
+		 * Adjust the module size and subtract the GOT table
+		 * size located at the beginning of the module.
+		 */
+		*size -= (*start - m_start);
 	}
 
 	return 0;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index cf826eca3aaf..83b2fbbeeb90 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1378,6 +1378,7 @@ static int machine__set_modules_path(struct machine *machine)
 	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path, 0);
 }
 int __weak arch__fix_module_text_start(u64 *start __maybe_unused,
+				u64 *size __maybe_unused,
 				const char *name __maybe_unused)
 {
 	return 0;
@@ -1389,7 +1390,7 @@ static int machine__create_module(void *arg, const char *name, u64 start,
 	struct machine *machine = arg;
 	struct map *map;
 
-	if (arch__fix_module_text_start(&start, name) < 0)
+	if (arch__fix_module_text_start(&start, &size, name) < 0)
 		return -1;
 
 	map = machine__findnew_module_map(machine, start, name);
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index f70ab98a7bde..7aa38da26427 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -222,7 +222,7 @@ struct symbol *machine__find_kernel_symbol_by_name(struct machine *machine,
 
 struct map *machine__findnew_module_map(struct machine *machine, u64 start,
 					const char *filename);
-int arch__fix_module_text_start(u64 *start, const char *name);
+int arch__fix_module_text_start(u64 *start, u64 *size, const char *name);
 
 int machine__load_kallsyms(struct machine *machine, const char *filename);
 
-- 
2.21.0

