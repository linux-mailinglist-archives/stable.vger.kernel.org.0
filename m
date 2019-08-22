Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FB299B4E
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbfHVRXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391528AbfHVRXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:34 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0482341C;
        Thu, 22 Aug 2019 17:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494612;
        bh=NJlu1tKopqcwTPS9n/1mEJCBiUAn0IsQou0p8j0a4gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4IwGrXQKMuQc4Pg41xHkW+4eKYueF8zQ7thPBv8YuYaWxI7W0AVH7zpyBPDeChmr
         pWUweGYXvwxEOhEEbLY8128eluQPQPBkUOrpOIsVKEQjv4X41eQCtazFVUOMl3IBD7
         G+YXXOfBRIprYfseWOWI5AfCkQaH4sFp5PCo7nVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas-Mich Richter <tmricht@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Zvonko Kosic <zvonko.kosic@de.ibm.com>,
        Daniel Daz <daniel.diaz@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 007/103] perf record: Fix wrong size in perf_record_mmap for last kernel module
Date:   Thu, 22 Aug 2019 10:17:55 -0700
Message-Id: <20190822171729.066633097@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.vnet.ibm.com>

commit 9ad4652b66f19a60f07e63b942b80b5c2d7465bf upstream.

During work on perf report for s390 I ran into the following issue:

0 0x318 [0x78]: PERF_RECORD_MMAP -1/0:
        [0x3ff804d6990(0xfffffc007fb2966f) @ 0]:
        x /lib/modules/4.12.0perf1+/kernel/drivers/s390/net/qeth_l2.ko

This is a PERF_RECORD_MMAP entry of the perf.data file with an invalid
module size for qeth_l2.ko (the s390 ethernet device driver).

Even a mainframe does not have 0xfffffc007fb2966f bytes of main memory.

It turned out that this wrong size is created by the perf record
command.  What happens is this function call sequence from
__cmd_record():

  perf_session__new():
    perf_session__create_kernel_maps():
      machine__create_kernel_maps():
        machine__create_modules():   Creates map for all loaded kernel modules.
          modules__parse():   Reads /proc/modules and extracts module name and
                              load address (1st and last column)
            machine__create_module():   Called for every module found in /proc/modules.
                              Creates a new map for every module found and enters
                              module name and start address into the map. Since the
                              module end address is unknown it is set to zero.

This ends up with a kernel module map list sorted by module start
addresses.  All module end addresses are zero.

Last machine__create_kernel_maps() calls function map_groups__fixup_end().
This function iterates through the maps and assigns each map entry's
end address the successor map entry start address. The last entry of the
map group has no successor, so ~0 is used as end to consume the remaining
memory.

Later __cmd_record calls function record__synthesize() which in turn calls
perf_event__synthesize_kernel_mmap() and perf_event__synthesize_modules()
to create PERF_REPORT_MMAP entries into the perf.data file.

On s390 this results in the last module qeth_l2.ko
(which has highest start address, see module table:
        [root@s8360047 perf]# cat /proc/modules
        qeth_l2 86016 1 - Live 0x000003ff804d6000
        qeth 266240 1 qeth_l2, Live 0x000003ff80296000
        ccwgroup 24576 1 qeth, Live 0x000003ff80218000
        vmur 36864 0 - Live 0x000003ff80182000
        qdio 143360 2 qeth_l2,qeth, Live 0x000003ff80002000
        [root@s8360047 perf]# )
to be the last entry and its map has an end address of ~0.

When the PERF_RECORD_MMAP entry is created for kernel module qeth_l2.ko
its start address and length is written. The length is calculated in line:
    event->mmap.len   = pos->end - pos->start;
and results in 0xffffffffffffffff - 0x3ff804d6990(*) = 0xfffffc007fb2966f

(*) On s390 the module start address is actually determined by a __weak function
named arch__fix_module_text_start() in machine__create_module().

I think this improvable. We can use the module size (2nd column of /proc/modules)
to get each loaded kernel module size and calculate its end address.
Only for map entries which do not have a valid end address (end is still zero)
we can use the heuristic we have now, that is use successor start address or ~0.

Signed-off-by: Thomas-Mich Richter <tmricht@linux.vnet.ibm.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Thomas-Mich Richter <tmricht@linux.vnet.ibm.com>
Cc: Zvonko Kosic <zvonko.kosic@de.ibm.com>
LPU-Reference: 20170803134902.47207-2-tmricht@linux.vnet.ibm.com
Link: http://lkml.kernel.org/n/tip-nmoqij5b5vxx7rq2ckwu8iaj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Daniel Daz <daniel.diaz@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/machine.c    |    4 +++-
 tools/perf/util/symbol-elf.c |    2 +-
 tools/perf/util/symbol.c     |   21 ++++++++++++++-------
 tools/perf/util/symbol.h     |    2 +-
 4 files changed, 19 insertions(+), 10 deletions(-)

--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1079,7 +1079,8 @@ int __weak arch__fix_module_text_start(u
 	return 0;
 }
 
-static int machine__create_module(void *arg, const char *name, u64 start)
+static int machine__create_module(void *arg, const char *name, u64 start,
+				  u64 size)
 {
 	struct machine *machine = arg;
 	struct map *map;
@@ -1090,6 +1091,7 @@ static int machine__create_module(void *
 	map = machine__findnew_module_map(machine, start, name);
 	if (map == NULL)
 		return -1;
+	map->end = start + size;
 
 	dso__kernel_module_get_build_id(map->dso, machine->root_dir);
 
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1478,7 +1478,7 @@ static int kcore_copy__parse_kallsyms(st
 
 static int kcore_copy__process_modules(void *arg,
 				       const char *name __maybe_unused,
-				       u64 start)
+				       u64 start, u64 size __maybe_unused)
 {
 	struct kcore_copy_info *kci = arg;
 
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -217,7 +217,8 @@ void __map_groups__fixup_end(struct map_
 		goto out_unlock;
 
 	for (next = map__next(curr); next; next = map__next(curr)) {
-		curr->end = next->start;
+		if (!curr->end)
+			curr->end = next->start;
 		curr = next;
 	}
 
@@ -225,7 +226,8 @@ void __map_groups__fixup_end(struct map_
 	 * We still haven't the actual symbols, so guess the
 	 * last map final address.
 	 */
-	curr->end = ~0ULL;
+	if (!curr->end)
+		curr->end = ~0ULL;
 
 out_unlock:
 	pthread_rwlock_unlock(&maps->lock);
@@ -512,7 +514,7 @@ void dso__sort_by_name(struct dso *dso,
 
 int modules__parse(const char *filename, void *arg,
 		   int (*process_module)(void *arg, const char *name,
-					 u64 start))
+					 u64 start, u64 size))
 {
 	char *line = NULL;
 	size_t n;
@@ -525,8 +527,8 @@ int modules__parse(const char *filename,
 
 	while (1) {
 		char name[PATH_MAX];
-		u64 start;
-		char *sep;
+		u64 start, size;
+		char *sep, *endptr;
 		ssize_t line_len;
 
 		line_len = getline(&line, &n, file);
@@ -558,7 +560,11 @@ int modules__parse(const char *filename,
 
 		scnprintf(name, sizeof(name), "[%s]", line);
 
-		err = process_module(arg, name, start);
+		size = strtoul(sep + 1, &endptr, 0);
+		if (*endptr != ' ' && *endptr != '\t')
+			continue;
+
+		err = process_module(arg, name, start, size);
 		if (err)
 			break;
 	}
@@ -905,7 +911,8 @@ static struct module_info *find_module(c
 	return NULL;
 }
 
-static int __read_proc_modules(void *arg, const char *name, u64 start)
+static int __read_proc_modules(void *arg, const char *name, u64 start,
+			       u64 size __maybe_unused)
 {
 	struct rb_root *modules = arg;
 	struct module_info *mi;
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -268,7 +268,7 @@ int filename__read_build_id(const char *
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 int modules__parse(const char *filename, void *arg,
 		   int (*process_module)(void *arg, const char *name,
-					 u64 start));
+					 u64 start, u64 size));
 int filename__read_debuglink(const char *filename, char *debuglink,
 			     size_t size);
 


