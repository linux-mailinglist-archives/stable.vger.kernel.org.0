Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41508DA47
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbfHNROC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730718AbfHNROC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED872063F;
        Wed, 14 Aug 2019 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802840;
        bh=XvpTegBVJi8SPTBuyUa6LSeJKocGxJQMUDQvCQCJqSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmPbUkpPg208IfHJOf+0sqwqbEwI+/GtG0ctFmM51Xfcktxrwa6tjJxawLYEbj3Oq
         Hfyq+wZoXWzT1Tfu7SsMv19i678rFA4C1OjYg0kdd4sjFuEL0LsVGw8ttR1RT6yj/B
         bsLGjtIrHQ9UUH2+DIljEdOks9bckyrez7BlByOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Liebler <stli@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 20/69] perf record: Fix module size on s390
Date:   Wed, 14 Aug 2019 19:01:18 +0200
Message-Id: <20190814165746.927471670@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

commit 12a6d2940b5f02b4b9f71ce098e3bb02bc24a9ea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/arch/s390/util/machine.c |   14 +++++++++++++-
 tools/perf/util/machine.c           |    3 ++-
 tools/perf/util/machine.h           |    2 +-
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/tools/perf/arch/s390/util/machine.c
+++ b/tools/perf/arch/s390/util/machine.c
@@ -8,7 +8,7 @@
 #include "debug.h"
 #include "symbol.h"
 
-int arch__fix_module_text_start(u64 *start, const char *name)
+int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
 {
 	u64 m_start = *start;
 	char path[PATH_MAX];
@@ -18,6 +18,18 @@ int arch__fix_module_text_start(u64 *sta
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
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1233,6 +1233,7 @@ static int machine__set_modules_path(str
 	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path, 0);
 }
 int __weak arch__fix_module_text_start(u64 *start __maybe_unused,
+				u64 *size __maybe_unused,
 				const char *name __maybe_unused)
 {
 	return 0;
@@ -1244,7 +1245,7 @@ static int machine__create_module(void *
 	struct machine *machine = arg;
 	struct map *map;
 
-	if (arch__fix_module_text_start(&start, name) < 0)
+	if (arch__fix_module_text_start(&start, &size, name) < 0)
 		return -1;
 
 	map = machine__findnew_module_map(machine, start, name);
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -213,7 +213,7 @@ struct symbol *machine__find_kernel_func
 
 struct map *machine__findnew_module_map(struct machine *machine, u64 start,
 					const char *filename);
-int arch__fix_module_text_start(u64 *start, const char *name);
+int arch__fix_module_text_start(u64 *start, u64 *size, const char *name);
 
 int __machine__load_kallsyms(struct machine *machine, const char *filename,
 			     enum map_type type, bool no_kcore);


