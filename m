Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6C58DBA2
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfHNREX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbfHNREW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD0172084D;
        Wed, 14 Aug 2019 17:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802261;
        bh=S8+ami7PZyTwa++XdNV8V2KQnLTzqVa2Tt0O56484VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivEHXGT04fFdtwDzvGGhmuSMqUxCOIXIB9Qq5awPDvkXcFWvUEepmigcoOE8JCWv4
         1WheYXwLMVSSFVeb1yPEP2Pc3TV8XCS4MfOTphKPpUxVO/13AoRQShjNPQiWg13t1i
         hLoQrmJuh3y2jOiqzMi2J1a7LiwYyQAVL3pRLs8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Klaus Theurich <klaus.theurich@de.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.2 031/144] perf annotate: Fix s390 gap between kernel end and module start
Date:   Wed, 14 Aug 2019 18:59:47 +0200
Message-Id: <20190814165801.138549070@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

commit b9c0a64901d5bdec6eafd38d1dc8fa0e2974fccb upstream.

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

In this function the size of symbol __irf_end is calculated. The size of
a symbol is the difference between its start and end address.

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

Function symbols__fixup_end() enlarges the last symbol in the kallsyms
map:

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

On s390 the kernel is located around memory address 0x200, 0x10000 or
0x100000, depending on linux version. Modules however start some- where
around 0x3ff xxxx xxxx.

This is different than x86 and produces a large gap for which histogram
allocation fails.

Fix this by detecting the kernel's last symbol and do no adjustment for
it. Introduce a weak function and handle s390 specifics.

Reported-by: Klaus Theurich <klaus.theurich@de.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20190724122703.3996-2-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/arch/s390/util/machine.c |   17 +++++++++++++++++
 tools/perf/util/symbol.c            |    7 ++++++-
 tools/perf/util/symbol.h            |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/tools/perf/arch/s390/util/machine.c
+++ b/tools/perf/arch/s390/util/machine.c
@@ -6,6 +6,7 @@
 #include "machine.h"
 #include "api/fs/fs.h"
 #include "debug.h"
+#include "symbol.h"
 
 int arch__fix_module_text_start(u64 *start, const char *name)
 {
@@ -21,3 +22,19 @@ int arch__fix_module_text_start(u64 *sta
 
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
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -91,6 +91,11 @@ static int prefix_underscores_count(cons
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
@@ -217,7 +222,7 @@ void symbols__fixup_end(struct rb_root_c
 		curr = rb_entry(nd, struct symbol, rb_node);
 
 		if (prev->end == prev->start && prev->end != curr->start)
-			prev->end = curr->start;
+			arch__symbols__fixup_end(prev, curr);
 	}
 
 	/* Last entry */
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -277,6 +277,7 @@ const char *arch__normalize_symbol_name(
 #define SYMBOL_A 0
 #define SYMBOL_B 1
 
+void arch__symbols__fixup_end(struct symbol *p, struct symbol *c);
 int arch__compare_symbol_names(const char *namea, const char *nameb);
 int arch__compare_symbol_names_n(const char *namea, const char *nameb,
 				 unsigned int n);


