Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C751038C
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 02:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfEAAyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 20:54:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:6348 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfEAAyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 20:54:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 17:54:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,415,1549958400"; 
   d="scan'208";a="228225462"
Received: from otc-lr-04.jf.intel.com ([10.54.39.157])
  by orsmga001.jf.intel.com with ESMTP; 30 Apr 2019 17:54:52 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     acme@kernel.org, eranian@google.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [RESEND PATCH 1/6] perf/x86/intel/uncore: Handle invalid event coding for free-running counter
Date:   Tue, 30 Apr 2019 17:53:43 -0700
Message-Id: <1556672028-119221-2-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556672028-119221-1-git-send-email-kan.liang@linux.intel.com>
References: <1556672028-119221-1-git-send-email-kan.liang@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

Counting with invalid event coding for free-running counter may cause
OOPs, e.g. uncore_iio_free_running_0/event=1/.

Current code only validate the event with free-running event format,
event=0xff,umask=0xXY. Non-free-running event format never be checked
for the PMU with free-running counters.

Add generic hw_config() to check and reject the invalid event coding
for free-running PMU.

Fixes: 0f519f0352e3 ("perf/x86/intel/uncore: Support IIO free-running counters on SKX")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/uncore.h       | 10 ++++++++++
 arch/x86/events/intel/uncore_snbep.c |  1 +
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index 79eb2e2..28499e3 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -419,6 +419,16 @@ static inline bool is_freerunning_event(struct perf_event *event)
 	       (((cfg >> 8) & 0xff) >= UNCORE_FREERUNNING_UMASK_START);
 }
 
+/* Check and reject invalid config */
+static inline int uncore_freerunning_hw_config(struct intel_uncore_box *box,
+					       struct perf_event *event)
+{
+	if (is_freerunning_event(event))
+		return 0;
+
+	return -EINVAL;
+}
+
 static inline void uncore_disable_box(struct intel_uncore_box *box)
 {
 	if (box->pmu->type->ops->disable_box)
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index b10e043..8e4e8e4 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3585,6 +3585,7 @@ static struct uncore_event_desc skx_uncore_iio_freerunning_events[] = {
 
 static struct intel_uncore_ops skx_uncore_iio_freerunning_ops = {
 	.read_counter		= uncore_msr_read_counter,
+	.hw_config		= uncore_freerunning_hw_config,
 };
 
 static struct attribute *skx_uncore_iio_freerunning_formats_attr[] = {
-- 
2.7.4

