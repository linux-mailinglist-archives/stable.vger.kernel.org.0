Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61E729C347
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821512AbgJ0Rod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902156AbgJ0ObF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:31:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB7C22264;
        Tue, 27 Oct 2020 14:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809064;
        bh=+/KRflT3X+qc6wD5Djjyrc5e/Ch0qiDBeIFzSoJga24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjGa8Yv3yPA449kpfz+wdObJNqiQfk2++V5IGijhaPZp32iV8u2zPgQdewDxAwow0
         NqUC+iHCa7jwmhqk+mFdBm7eZy4w0qjZqInKjADIisNrAk3rmDFxf43Rcz7D+seLDr
         z6LXQ7a6dDvi96XrxIlB141uv6vubwnCpDEBN5VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/408] perf/x86/intel/uncore: Update Ice Lake uncore units
Date:   Tue, 27 Oct 2020 14:50:01 +0100
Message-Id: <20201027135457.983208264@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 8f5d41f3a0f495435c88ebba8fc150c931c10fef ]

There are some updates for the Icelake model specific uncore performance
monitors. (The update can be found at 10th generation intel core
processors families specification update Revision 004, ICL068)

1) Counter 0 of ARB uncore unit is not available for software use
2) The global 'enable bit' (bit 29) and 'freeze bit' (bit 31) of
   MSR_UNC_PERF_GLOBAL_CTRL cannot be used to control counter behavior.
   Needs to use local enable in event select MSR.

Accessing the modified bit/registers will be ignored by HW. Users may
observe inaccurate results with the current code.

The changes of the MSR_UNC_PERF_GLOBAL_CTRL imply that groups cannot be
read atomically anymore. Although the error of the result for a group
becomes a bit bigger, it still far lower than not using a group. The
group support is still kept. Only Remove the *_box() related
implementation.

Since the counter 0 of ARB uncore unit is not available, update the MSR
address for the ARB uncore unit.

There is no change for IMC uncore unit, which only include free-running
counters.

Fixes: 6e394376ee89 ("perf/x86/intel/uncore: Add Intel Icelake uncore support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200925134905.8839-2-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snb.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index c37cb12d0ef68..ad9798bd89cf6 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -110,6 +110,10 @@
 #define ICL_UNC_CBO_0_PER_CTR0			0x702
 #define ICL_UNC_CBO_MSR_OFFSET			0x8
 
+/* ICL ARB register */
+#define ICL_UNC_ARB_PER_CTR			0x3b1
+#define ICL_UNC_ARB_PERFEVTSEL			0x3b3
+
 DEFINE_UNCORE_FORMAT_ATTR(event, event, "config:0-7");
 DEFINE_UNCORE_FORMAT_ATTR(umask, umask, "config:8-15");
 DEFINE_UNCORE_FORMAT_ATTR(edge, edge, "config:18");
@@ -297,6 +301,12 @@ void skl_uncore_cpu_init(void)
 	snb_uncore_arb.ops = &skl_uncore_msr_ops;
 }
 
+static struct intel_uncore_ops icl_uncore_msr_ops = {
+	.disable_event	= snb_uncore_msr_disable_event,
+	.enable_event	= snb_uncore_msr_enable_event,
+	.read_counter	= uncore_msr_read_counter,
+};
+
 static struct intel_uncore_type icl_uncore_cbox = {
 	.name		= "cbox",
 	.num_counters   = 4,
@@ -305,7 +315,7 @@ static struct intel_uncore_type icl_uncore_cbox = {
 	.event_ctl	= SNB_UNC_CBO_0_PERFEVTSEL0,
 	.event_mask	= SNB_UNC_RAW_EVENT_MASK,
 	.msr_offset	= ICL_UNC_CBO_MSR_OFFSET,
-	.ops		= &skl_uncore_msr_ops,
+	.ops		= &icl_uncore_msr_ops,
 	.format_group	= &snb_uncore_format_group,
 };
 
@@ -334,13 +344,25 @@ static struct intel_uncore_type icl_uncore_clockbox = {
 	.single_fixed	= 1,
 	.event_mask	= SNB_UNC_CTL_EV_SEL_MASK,
 	.format_group	= &icl_uncore_clock_format_group,
-	.ops		= &skl_uncore_msr_ops,
+	.ops		= &icl_uncore_msr_ops,
 	.event_descs	= icl_uncore_events,
 };
 
+static struct intel_uncore_type icl_uncore_arb = {
+	.name		= "arb",
+	.num_counters   = 1,
+	.num_boxes	= 1,
+	.perf_ctr_bits	= 44,
+	.perf_ctr	= ICL_UNC_ARB_PER_CTR,
+	.event_ctl	= ICL_UNC_ARB_PERFEVTSEL,
+	.event_mask	= SNB_UNC_RAW_EVENT_MASK,
+	.ops		= &icl_uncore_msr_ops,
+	.format_group	= &snb_uncore_format_group,
+};
+
 static struct intel_uncore_type *icl_msr_uncores[] = {
 	&icl_uncore_cbox,
-	&snb_uncore_arb,
+	&icl_uncore_arb,
 	&icl_uncore_clockbox,
 	NULL,
 };
@@ -358,7 +380,6 @@ void icl_uncore_cpu_init(void)
 {
 	uncore_msr_uncores = icl_msr_uncores;
 	icl_uncore_cbox.num_boxes = icl_get_cbox_num();
-	snb_uncore_arb.ops = &skl_uncore_msr_ops;
 }
 
 enum {
-- 
2.25.1



