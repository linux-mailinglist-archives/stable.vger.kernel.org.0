Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABAA72ED0
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGXM1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:27:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726555AbfGXM1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 08:27:21 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OCMiih175554
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 08:27:20 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2txmwne5wb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 08:27:20 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <tmricht@linux.ibm.com>;
        Wed, 24 Jul 2019 13:27:18 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 24 Jul 2019 13:27:16 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6OCQxJA26673596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 12:26:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95ADCA4059;
        Wed, 24 Jul 2019 12:27:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5381AA4040;
        Wed, 24 Jul 2019 12:27:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Jul 2019 12:27:14 +0000 (GMT)
From:   Thomas Richter <tmricht@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     brueckner@linux.ibm.com, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, Thomas Richter <tmricht@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] perf/record: Fix module size on s390
Date:   Wed, 24 Jul 2019 14:27:02 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19072412-0012-0000-0000-00000335B941
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072412-0013-0000-0000-0000216F4D07
Message-Id: <20190724122703.3996-1-tmricht@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240139
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On s390 the modules loaded in memory have the text segment
located after the GOT and Relocation table. This can be seen
with this output:
  [root@m35lp76 perf]# fgrep qeth /proc/modules
  qeth 151552 1 qeth_l2, Live 0x000003ff800b2000
  ...
  [root@m35lp76 perf]# cat /sys/module/qeth/sections/.text
  0x000003ff800b3990
  [root@m35lp76 perf]#

There is an offset of 0x1990 bytes. The size of the qeth module
is 151552 bytes (0x25000 in hex).
The location of the GOT/relocation table at the beginning of a
module is unique to s390.

commit 203d8a4aa6ed ("perf s390: Fix 'start' address of module's map")
adjusts the start address of a module in the map structures, but
does not adjust the size of the modules. This leads to overlapping
of module maps as this example shows:

[root@m35lp76 perf] # ./perf report -D
     0 0 0xfb0 [0xa0]: PERF_RECORD_MMAP -1/0: [0x3ff800b3990(0x25000)
          @ 0]:  x /lib/modules/.../qeth.ko.xz
     0 0 0x1050 [0xb0]: PERF_RECORD_MMAP -1/0: [0x3ff800d85a0(0x8000)
          @ 0]:  x /lib/modules/.../ip6_tables.ko.xz

The module qeth.ko has an adjusted start address modified to b3990,
but its size is unchanged and the module ends at 0x3ff800d8990.
This end address overlaps with the next modules start address of
0x3ff800d85a0.

When the size of the leading GOT/Relocation table stored in the
beginning of the text segment (0x1990 bytes) is subtracted from
module qeth end address, there are no overlaps anymore:

   0x3ff800d8990 - 0x1990 = 0x0x3ff800d7000

which is the same as

   0x3ff800b2000 + 0x25000 = 0x0x3ff800d7000.

To fix this issue, also adjust the modules size in function
arch__fix_module_text_start(). Add another function parameter
named size and reduce the size of the module when the text segment
start address is changed.

Output after:
     0 0 0xfb0 [0xa0]: PERF_RECORD_MMAP -1/0: [0x3ff800b3990(0x23670)
          @ 0]:  x /lib/modules/.../qeth.ko.xz
     0 0 0x1050 [0xb0]: PERF_RECORD_MMAP -1/0: [0x3ff800d85a0(0x7a60)
          @ 0]:  x /lib/modules/.../ip6_tables.ko.xz

Fixes: 203d8a4aa6ed ("perf s390: Fix 'start' address of module's map")
Cc: <stable@vger.kernel.org> # v4.9+
Reported-by: Stefan Liebler <stli@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
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
index dc7aafe45a2b..081fe4bdebaa 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1365,6 +1365,7 @@ static int machine__set_modules_path(struct machine *machine)
 	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path, 0);
 }
 int __weak arch__fix_module_text_start(u64 *start __maybe_unused,
+				u64 *size __maybe_unused,
 				const char *name __maybe_unused)
 {
 	return 0;
@@ -1376,7 +1377,7 @@ static int machine__create_module(void *arg, const char *name, u64 start,
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

