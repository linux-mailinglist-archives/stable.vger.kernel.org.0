Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AF3211808
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgGBBYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgGBBYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:24:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C1522145D;
        Thu,  2 Jul 2020 01:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653045;
        bh=NbpJd0Lm+GZx1BSXzmwTJkP2fHhPnzL6+/cCHrlwfkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFxvVZeAH1CdArsqnAYwzzIMEk2WTY3ZJXw9ejD67T4650qHhetg7T9maocYsa6po
         W1WI8tHfxLpqc1ftIk5ni8KdWMfGdHzc0AZAz6jOKxcIjWNSla2vG0vCTcxy4Hc1Yz
         acVceO7ry0pWfbR8RUsgZlHTfcf9XXbNRt8+lcsY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 02/40] perf/x86/rapl: Move RAPL support to common x86 code
Date:   Wed,  1 Jul 2020 21:23:23 -0400
Message-Id: <20200702012402.2701121-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012402.2701121-1-sashal@kernel.org>
References: <20200702012402.2701121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit fd3ae1e1587d64ef8cc8e361903d33625458073e ]

To prepare for support of both Intel and AMD RAPL.

As per the AMD PPR, Fam17h support Package RAPL counters to monitor power usage.
The RAPL counter operates as with Intel RAPL, and as such it is beneficial
to share the code.

No change in functionality.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200527224659.206129-2-eranian@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/Kconfig            | 6 +++---
 arch/x86/events/Makefile           | 1 +
 arch/x86/events/intel/Makefile     | 2 --
 arch/x86/events/{intel => }/rapl.c | 9 ++++++---
 4 files changed, 10 insertions(+), 8 deletions(-)
 rename arch/x86/events/{intel => }/rapl.c (98%)

diff --git a/arch/x86/events/Kconfig b/arch/x86/events/Kconfig
index 9a7a1446cb3a0..4a809c6cbd2f5 100644
--- a/arch/x86/events/Kconfig
+++ b/arch/x86/events/Kconfig
@@ -10,11 +10,11 @@ config PERF_EVENTS_INTEL_UNCORE
 	available on NehalemEX and more modern processors.
 
 config PERF_EVENTS_INTEL_RAPL
-	tristate "Intel rapl performance events"
-	depends on PERF_EVENTS && CPU_SUP_INTEL && PCI
+	tristate "Intel/AMD rapl performance events"
+	depends on PERF_EVENTS && (CPU_SUP_INTEL || CPU_SUP_AMD) && PCI
 	default y
 	---help---
-	Include support for Intel rapl performance events for power
+	Include support for Intel and AMD rapl performance events for power
 	monitoring on modern processors.
 
 config PERF_EVENTS_INTEL_CSTATE
diff --git a/arch/x86/events/Makefile b/arch/x86/events/Makefile
index 9e07f554333fb..b418ef6878796 100644
--- a/arch/x86/events/Makefile
+++ b/arch/x86/events/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y					+= core.o probe.o
+obj-$(PERF_EVENTS_INTEL_RAPL)		+= rapl.o
 obj-y					+= amd/
 obj-$(CONFIG_X86_LOCAL_APIC)            += msr.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel/
diff --git a/arch/x86/events/intel/Makefile b/arch/x86/events/intel/Makefile
index 3468b0c1dc7c9..e67a5886336c1 100644
--- a/arch/x86/events/intel/Makefile
+++ b/arch/x86/events/intel/Makefile
@@ -2,8 +2,6 @@
 obj-$(CONFIG_CPU_SUP_INTEL)		+= core.o bts.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= ds.o knc.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= lbr.o p4.o p6.o pt.o
-obj-$(CONFIG_PERF_EVENTS_INTEL_RAPL)	+= intel-rapl-perf.o
-intel-rapl-perf-objs			:= rapl.o
 obj-$(CONFIG_PERF_EVENTS_INTEL_UNCORE)	+= intel-uncore.o
 intel-uncore-objs			:= uncore.o uncore_nhmex.o uncore_snb.o uncore_snbep.o
 obj-$(CONFIG_PERF_EVENTS_INTEL_CSTATE)	+= intel-cstate.o
diff --git a/arch/x86/events/intel/rapl.c b/arch/x86/events/rapl.c
similarity index 98%
rename from arch/x86/events/intel/rapl.c
rename to arch/x86/events/rapl.c
index 5053a403e4ae0..3c222d6fdee3b 100644
--- a/arch/x86/events/intel/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -1,11 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Support Intel RAPL energy consumption counters
+ * Support Intel/AMD RAPL energy consumption counters
  * Copyright (C) 2013 Google, Inc., Stephane Eranian
  *
  * Intel RAPL interface is specified in the IA-32 Manual Vol3b
  * section 14.7.1 (September 2013)
  *
+ * AMD RAPL interface for Fam17h is described in the public PPR:
+ * https://bugzilla.kernel.org/show_bug.cgi?id=206537
+ *
  * RAPL provides more controls than just reporting energy consumption
  * however here we only expose the 3 energy consumption free running
  * counters (pp0, pkg, dram).
@@ -58,8 +61,8 @@
 #include <linux/nospec.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
-#include "../perf_event.h"
-#include "../probe.h"
+#include "perf_event.h"
+#include "probe.h"
 
 MODULE_LICENSE("GPL");
 
-- 
2.25.1

