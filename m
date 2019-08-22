Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0301399B4F
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391566AbfHVRXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391563AbfHVRXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:34 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F36DD23426;
        Thu, 22 Aug 2019 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494614;
        bh=irG79BRN+ND2MxZ1FUv7m4nPGmkpbWu7XaNgMHd+65E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfq5xbWLFZx3A29cVZUqmXgnFqTo+7nlOwau1UgH0t6CPA3i9ptLMGiCovnEXNb1Y
         y7Q2JtSKlE++lbc4lMqiFnQiFLHor4rlOHTUVl662bTpP0eje2G+l54x0UUr2r8R0p
         TZOreetXnGMh6a15zNRvV4tEgWKLpVB0YwuIXfVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Liebler <stli@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 009/103] perf record: Fix module size on s390
Date:   Thu, 22 Aug 2019 10:17:57 -0700
Message-Id: <20190822171729.229084973@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
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
@@ -6,7 +6,7 @@
 #include "api/fs/fs.h"
 #include "debug.h"
 
-int arch__fix_module_text_start(u64 *start, const char *name)
+int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
 {
 	u64 m_start = *start;
 	char path[PATH_MAX];
@@ -16,6 +16,18 @@ int arch__fix_module_text_start(u64 *sta
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
@@ -1074,6 +1074,7 @@ static int machine__set_modules_path(str
 	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path, 0);
 }
 int __weak arch__fix_module_text_start(u64 *start __maybe_unused,
+				u64 *size __maybe_unused,
 				const char *name __maybe_unused)
 {
 	return 0;
@@ -1085,7 +1086,7 @@ static int machine__create_module(void *
 	struct machine *machine = arg;
 	struct map *map;
 
-	if (arch__fix_module_text_start(&start, name) < 0)
+	if (arch__fix_module_text_start(&start, &size, name) < 0)
 		return -1;
 
 	map = machine__findnew_module_map(machine, start, name);
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -205,7 +205,7 @@ struct symbol *machine__find_kernel_func
 
 struct map *machine__findnew_module_map(struct machine *machine, u64 start,
 					const char *filename);
-int arch__fix_module_text_start(u64 *start, const char *name);
+int arch__fix_module_text_start(u64 *start, u64 *size, const char *name);
 
 int __machine__load_kallsyms(struct machine *machine, const char *filename,
 			     enum map_type type, bool no_kcore);


