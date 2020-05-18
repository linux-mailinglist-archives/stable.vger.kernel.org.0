Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7651D83C6
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732759AbgERSHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387409AbgERSHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D76220715;
        Mon, 18 May 2020 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825250;
        bh=pIBnweJDLILGqQ1G6rH5bi6niKVnTxExVR+TsRgjWt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otJbsOCMbiMgPTLPWShJ+2sBCRKqY7WiC1jN7jqUrq57MaqkLI36JFtRfllgLyk8r
         9cqCxLEM8lVsUYaYXsK7jXNHUR8HW23OLVp//kqVcTj9HTa24tn9Mb4lBS8m0vNAUU
         PiyOmzjUnCmXpjuOM9+fRy+THZ1fJ3CjGgmxhduw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.6 189/194] riscv: perf: RISCV_BASE_PMU should be independent
Date:   Mon, 18 May 2020 19:37:59 +0200
Message-Id: <20200518173547.167753429@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 48084c3595cb7429f6ba734cfea1313573b9a7fa upstream.

Selecting PERF_EVENTS without selecting RISCV_BASE_PMU results in a build
error.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
[Palmer: commit text]
Fixes: 178e9fc47aae("perf: riscv: preliminary RISC-V support")
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/include/asm/perf_event.h |    8 ++------
 arch/riscv/kernel/Makefile          |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

--- a/arch/riscv/include/asm/perf_event.h
+++ b/arch/riscv/include/asm/perf_event.h
@@ -12,19 +12,14 @@
 #include <linux/ptrace.h>
 #include <linux/interrupt.h>
 
+#ifdef CONFIG_RISCV_BASE_PMU
 #define RISCV_BASE_COUNTERS	2
 
 /*
  * The RISCV_MAX_COUNTERS parameter should be specified.
  */
 
-#ifdef CONFIG_RISCV_BASE_PMU
 #define RISCV_MAX_COUNTERS	2
-#endif
-
-#ifndef RISCV_MAX_COUNTERS
-#error "Please provide a valid RISCV_MAX_COUNTERS for the PMU."
-#endif
 
 /*
  * These are the indexes of bits in counteren register *minus* 1,
@@ -82,6 +77,7 @@ struct riscv_pmu {
 	int		irq;
 };
 
+#endif
 #ifdef CONFIG_PERF_EVENTS
 #define perf_arch_bpf_user_pt_regs(regs) (struct user_regs_struct *)regs
 #endif
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_MODULE_SECTIONS)	+= module-
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= mcount-dyn.o
 
-obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o
+obj-$(CONFIG_RISCV_BASE_PMU)	+= perf_event.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_callchain.o
 obj-$(CONFIG_HAVE_PERF_REGS)	+= perf_regs.o
 obj-$(CONFIG_RISCV_SBI)		+= sbi.o


