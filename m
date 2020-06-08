Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68061F2DC9
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgFHXNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729531AbgFHXNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4116B212CC;
        Mon,  8 Jun 2020 23:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658019;
        bh=PAF7TTob2i+fDQUy2vnO8iUW+qZWiXx2tOJs+soBO68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VV3Qyerf7dWJEdNT3HShUwCKFvIbcbP5CiszGVj80m7eXz3NJpsbCfpBgBLqLbPIA
         5bjEYJhypEOGp+OVE7efveAjbPzw++qmhYWg7cGuZw7GtyLnlvRmJ1Y4gNPNrVZGJW
         /VPXtpYqSy/MtUBcyLJhykXRTsepjCUIMKeaCmVY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 073/606] riscv: perf: RISCV_BASE_PMU should be independent
Date:   Mon,  8 Jun 2020 19:03:18 -0400
Message-Id: <20200608231211.3363633-73-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 arch/riscv/include/asm/perf_event.h | 8 ++------
 arch/riscv/kernel/Makefile          | 2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/include/asm/perf_event.h b/arch/riscv/include/asm/perf_event.h
index 0234048b12bc..062efd3a1d5d 100644
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
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f40205cb9a22..1dcc095dc23c 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_MODULE_SECTIONS)	+= module-sections.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= mcount-dyn.o
 
-obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o
+obj-$(CONFIG_RISCV_BASE_PMU)	+= perf_event.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_callchain.o
 obj-$(CONFIG_HAVE_PERF_REGS)	+= perf_regs.o
 obj-$(CONFIG_RISCV_SBI)		+= sbi.o
-- 
2.25.1

