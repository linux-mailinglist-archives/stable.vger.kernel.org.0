Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5393674682
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404296AbfGYFkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404269AbfGYFkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:40:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0482F22C97;
        Thu, 25 Jul 2019 05:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033204;
        bh=djMy0ZkF1cNdzzJkInuRNcFK9iveLhe5RDIiDs8gmkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o56kGNCiHeAUCGrnkqOKdKyOhgHRiGhoK8e9h5/OEaWVT70ELg0kuQXhBDfAmUVo0
         J5SghAuk3rHB7k+xgM8PjS11wmLeAA19h7iBMZdXiAayoxTDMWRTW2GIlMpiHxPlU3
         9L96mfaP3DBWZdXMWg+NzRTN3YdtO7lV3YA1Tusg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, acme@kernel.org,
        eranian@google.com, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/271] perf/x86/intel/uncore: Handle invalid event coding for free-running counter
Date:   Wed, 24 Jul 2019 21:19:07 +0200
Message-Id: <20190724191701.880558315@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 543ac280b3576c0009e8c0fcd4d6bfc9978d7bd0 ]

Counting with invalid event coding for free-running counter may cause
OOPs, e.g. uncore_iio_free_running_0/event=1/.

Current code only validate the event with free-running event format,
event=0xff,umask=0xXY. Non-free-running event format never be checked
for the PMU with free-running counters.

Add generic hw_config() to check and reject the invalid event coding
for free-running PMU.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: acme@kernel.org
Cc: eranian@google.com
Fixes: 0f519f0352e3 ("perf/x86/intel/uncore: Support IIO free-running counters on SKX")
Link: https://lkml.kernel.org/r/1556672028-119221-2-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.h       | 10 ++++++++++
 arch/x86/events/intel/uncore_snbep.c |  1 +
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index cc6dd4f78158..42fa3974c421 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -402,6 +402,16 @@ static inline bool is_freerunning_event(struct perf_event *event)
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
index b10e04387f38..8e4e8e423839 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3585,6 +3585,7 @@ static struct uncore_event_desc skx_uncore_iio_freerunning_events[] = {
 
 static struct intel_uncore_ops skx_uncore_iio_freerunning_ops = {
 	.read_counter		= uncore_msr_read_counter,
+	.hw_config		= uncore_freerunning_hw_config,
 };
 
 static struct attribute *skx_uncore_iio_freerunning_formats_attr[] = {
-- 
2.20.1



