Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64EF2A5647
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387507AbgKCVBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387501AbgKCVBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:01:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8135421534;
        Tue,  3 Nov 2020 21:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437301;
        bh=CecjKyAvlWAKQTtQf0iP9h9WYD6bopjVvK0S3YdEjJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jutue4gx/fBGKIqr3k0X11cY+FXENHymWzZ+DPFmvwRRJtQecTLfse1XbHTZF86X5
         9KZAWV1aM/nxV69jEYDT7QcIr6KDEJ/uU/IRXAo6S8MP0Irnckn6bEuLSdKsVZQ26H
         RyTQtYgX4hcORdAcRrfZ97SMtxSvtFxQQTK3xSwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Eranian <stephane.eranian@google.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.19 018/191] arch/x86/amd/ibs: Fix re-arming IBS Fetch
Date:   Tue,  3 Nov 2020 21:35:10 +0100
Message-Id: <20201103203235.041843307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 221bfce5ebbdf72ff08b3bf2510ae81058ee568b upstream.

Stephane Eranian found a bug in that IBS' current Fetch counter was not
being reset when the driver would write the new value to clear it along
with the enable bit set, and found that adding an MSR write that would
first disable IBS Fetch would make IBS Fetch reset its current count.

Indeed, the PPR for AMD Family 17h Model 31h B0 55803 Rev 0.54 - Sep 12,
2019 states "The periodic fetch counter is set to IbsFetchCnt [...] when
IbsFetchEn is changed from 0 to 1."

Explicitly set IbsFetchEn to 0 and then to 1 when re-enabling IBS Fetch,
so the driver properly resets the internal counter to 0 and IBS
Fetch starts counting again.

A family 15h machine tested does not have this problem, and the extra
wrmsr is also not needed on Family 19h, so only do the extra wrmsr on
families 16h through 18h.

Reported-by: Stephane Eranian <stephane.eranian@google.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
[peterz: optimized]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/amd/ibs.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -89,6 +89,7 @@ struct perf_ibs {
 	u64				max_period;
 	unsigned long			offset_mask[1];
 	int				offset_max;
+	unsigned int			fetch_count_reset_broken : 1;
 	struct cpu_perf_ibs __percpu	*pcpu;
 
 	struct attribute		**format_attrs;
@@ -375,7 +376,12 @@ perf_ibs_event_update(struct perf_ibs *p
 static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
 					 struct hw_perf_event *hwc, u64 config)
 {
-	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
+	u64 tmp = hwc->config | config;
+
+	if (perf_ibs->fetch_count_reset_broken)
+		wrmsrl(hwc->config_base, tmp & ~perf_ibs->enable_mask);
+
+	wrmsrl(hwc->config_base, tmp | perf_ibs->enable_mask);
 }
 
 /*
@@ -744,6 +750,13 @@ static __init void perf_event_ibs_init(v
 {
 	struct attribute **attr = ibs_op_format_attrs;
 
+	/*
+	 * Some chips fail to reset the fetch count when it is written; instead
+	 * they need a 0-1 transition of IbsFetchEn.
+	 */
+	if (boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
+		perf_ibs_fetch.fetch_count_reset_broken = 1;
+
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {


