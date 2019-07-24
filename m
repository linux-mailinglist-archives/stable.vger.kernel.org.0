Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8850A72ED4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfGXM1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:27:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726723AbfGXM1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 08:27:24 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OCMG1T139702
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 08:27:23 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2txn7xnm5s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 08:27:23 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <tmricht@linux.ibm.com>;
        Wed, 24 Jul 2019 13:27:21 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 24 Jul 2019 13:27:18 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6OCRGfG53215232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 12:27:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74B51A4040;
        Wed, 24 Jul 2019 12:27:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 321EDA405B;
        Wed, 24 Jul 2019 12:27:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Jul 2019 12:27:16 +0000 (GMT)
From:   Thomas Richter <tmricht@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     brueckner@linux.ibm.com, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, Thomas Richter <tmricht@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] perf/top: Fix s390 gap between kernel end and module start
Date:   Wed, 24 Jul 2019 14:27:03 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190724122703.3996-1-tmricht@linux.ibm.com>
References: <20190724122703.3996-1-tmricht@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19072412-4275-0000-0000-000003501D1C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072412-4276-0000-0000-000038604540
Message-Id: <20190724122703.3996-2-tmricht@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240139
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During execution of command 'perf top' the error message:

   Not enough memory for annotating '__irf_end' symbol!)

is emitted from this call sequence:
  __cmd_top
    perf_top__mmap_read
      perf_top__mmap_read_idx
        perf_event__process_sample
          hist_entry_iter__add
            hist_iter__top_callback
              perf_top__record_precise_ip
                hist_entry__inc_addr_samples
                  symbol__inc_addr_samples
                    symbol__get_annotation
                      symbol__alloc_hist

In this function the size of symbol __irf_end is calculated. The size
of a symbol is the difference between its start and end address.
When the symbol was read the first time, its start and end was set to:
   symbol__new: __irf_end 0xe954d0-0xe954d0
which is correct and maps with /proc/kallsyms:

   root@s8360046:~/linux-4.15.0/tools/perf# fgrep _irf_end /proc/kallsyms
   0000000000e954d0 t __irf_end
   root@s8360046:~/linux-4.15.0/tools/perf#

In function symbol__alloc_hist() the end of symbol __irf_end is

  symbol__alloc_hist sym:__irf_end start:0xe954d0 end:0x3ff80045a8

which is identical with the first module entry in /proc/kallsyms

This results in a symbol size of __irf_req for histogram analyses of
70334140059072 bytes and a malloc() for this requested size fails.

The root cause of this is function
  __dso__load_kallsyms()
  +-> symbols__fixup_end()

Function symbols__fixup_end() enlarges the last symbol in the
kallsyms map
   # fgrep __irf_end /proc/kallsyms
   0000000000e954d0 t __irf_end
   #

to the start address of the first module:
   # cat /proc/kallsyms | sort  | egrep ' [tT] '
   ....
   0000000000e952d0 T __security_initcall_end
   0000000000e954d0 T __initramfs_size
   0000000000e954d0 t __irf_end
   000003ff800045a8 T fc_get_event_number       [scsi_transport_fc]
   000003ff800045d0 t store_fc_vport_disable    [scsi_transport_fc]
   000003ff800046a8 T scsi_is_fc_rport  [scsi_transport_fc]
   000003ff800046d0 t fc_target_setup   [scsi_transport_fc]

On s390 the kernel is located around memory address 0x200, 0x10000
or 0x100000, depending on linux version. Modules however start some-
where around 0x3ff xxxx xxxx.

This is different than x86 and produces a large gap for which
histogram allocation fails.

Fix this by detecting the kernel's last symbol and do no
adjustment for it. Introduce a weak function and handle s390 specifics.

Cc: <stable@vger.kernel.org>
Reported-by: Klaus Theurich <klaus.theurich@de.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 tools/perf/arch/s390/util/machine.c | 17 +++++++++++++++++
 tools/perf/util/symbol.c            |  7 ++++++-
 tools/perf/util/symbol.h            |  1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/s390/util/machine.c b/tools/perf/arch/s390/util/machine.c
index de26b1441a48..c8c86a0c9b79 100644
--- a/tools/perf/arch/s390/util/machine.c
+++ b/tools/perf/arch/s390/util/machine.c
@@ -6,6 +6,7 @@
 #include "machine.h"
 #include "api/fs/fs.h"
 #include "debug.h"
+#include "symbol.h"
 
 int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
 {
@@ -33,3 +34,19 @@ int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
 
 	return 0;
 }
+
+/* On s390 kernel text segment start is located at very low memory addresses,
+ * for example 0x10000. Modules are located at very high memory addresses,
+ * for example 0x3ff xxxx xxxx. The gap between end of kernel text segment
+ * and beginning of first module's text segment is very big.
+ * Therefore do not fill this gap and do not assign it to the kernel dso map.
+ */
+void arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
+{
+	if (strchr(p->name, '[') == NULL && strchr(c->name, '['))
+		/* Last kernel symbol mapped to end of page */
+		p->end = roundup(p->end, page_size);
+	else
+		p->end = c->start;
+	pr_debug4("%s sym:%s end:%#lx\n", __func__, p->name, p->end);
+}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 5cbad55cd99d..3b49eb4e3ed9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -91,6 +91,11 @@ static int prefix_underscores_count(const char *str)
 	return tail - str;
 }
 
+void __weak arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
+{
+	p->end = c->start;
+}
+
 const char * __weak arch__normalize_symbol_name(const char *name)
 {
 	return name;
@@ -217,7 +222,7 @@ void symbols__fixup_end(struct rb_root_cached *symbols)
 		curr = rb_entry(nd, struct symbol, rb_node);
 
 		if (prev->end == prev->start && prev->end != curr->start)
-			prev->end = curr->start;
+			arch__symbols__fixup_end(prev, curr);
 	}
 
 	/* Last entry */
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 9a8fe012910a..f30ab608ea54 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -277,6 +277,7 @@ const char *arch__normalize_symbol_name(const char *name);
 #define SYMBOL_A 0
 #define SYMBOL_B 1
 
+void arch__symbols__fixup_end(struct symbol *p, struct symbol *c);
 int arch__compare_symbol_names(const char *namea, const char *nameb);
 int arch__compare_symbol_names_n(const char *namea, const char *nameb,
 				 unsigned int n);
-- 
2.21.0

