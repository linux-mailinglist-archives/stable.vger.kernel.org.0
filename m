Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825184A9627
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357654AbiBDJXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357404AbiBDJW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:22:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75997C06177B;
        Fri,  4 Feb 2022 01:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE1F9615F2;
        Fri,  4 Feb 2022 09:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FFFC004E1;
        Fri,  4 Feb 2022 09:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966546;
        bh=6hLwUiBraFezqxX9zXLap+AGvcq0AkpuGNlQVDPofPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItO7gmOSB2qWWW5hq1Fudc4BEtVpjotCCayCwAZDgGbSPuSTZO0KtdwZGMNbjOBbR
         TBR3nL3ob9yxqe6GfYvDb+uaxOWCksbjg4TBpNfBvVtRNM2HbTmj4Jkic3Ns5C2Vr9
         eIEd/CJaa039LKDoNkQcuIt65lNLTamMTQOaxS+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 09/25] perf/core: Fix cgroup event list management
Date:   Fri,  4 Feb 2022 10:20:16 +0100
Message-Id: <20220204091914.594276962@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

commit c5de60cd622a2607c043ba65e25a6e9998a369f9 upstream.

The active cgroup events are managed in the per-cpu cgrp_cpuctx_list.
This list is only accessed from current cpu and not protected by any
locks.  But from the commit ef54c1a476ae ("perf: Rework
perf_event_exit_event()"), it's possible to access (actually modify)
the list from another cpu.

In the perf_remove_from_context(), it can remove an event from the
context without an IPI when the context is not active.  This is not
safe with cgroup events which can have some active events in the
context even if ctx->is_active is 0 at the moment.  The target cpu
might be in the middle of list iteration at the same time.

If the event is enabled when it's about to be closed, it might call
perf_cgroup_event_disable() and list_del() with the cgrp_cpuctx_list
on a different cpu.

This resulted in a crash due to an invalid list pointer access during
the cgroup list traversal on the cpu which the event belongs to.

Let's fallback to IPI to access the cgrp_cpuctx_list from that cpu.
Similarly, perf_install_in_context() should use IPI for the cgroup
events too.

Fixes: ef54c1a476ae ("perf: Rework perf_event_exit_event()")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220124195808.2252071-1-namhyung@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2466,7 +2466,11 @@ static void perf_remove_from_context(str
 	 * event_function_call() user.
 	 */
 	raw_spin_lock_irq(&ctx->lock);
-	if (!ctx->is_active) {
+	/*
+	 * Cgroup events are per-cpu events, and must IPI because of
+	 * cgrp_cpuctx_list.
+	 */
+	if (!ctx->is_active && !is_cgroup_event(event)) {
 		__perf_remove_from_context(event, __get_cpu_context(ctx),
 					   ctx, (void *)flags);
 		raw_spin_unlock_irq(&ctx->lock);
@@ -2899,11 +2903,14 @@ perf_install_in_context(struct perf_even
 	 * perf_event_attr::disabled events will not run and can be initialized
 	 * without IPI. Except when this is the first event for the context, in
 	 * that case we need the magic of the IPI to set ctx->is_active.
+	 * Similarly, cgroup events for the context also needs the IPI to
+	 * manipulate the cgrp_cpuctx_list.
 	 *
 	 * The IOC_ENABLE that is sure to follow the creation of a disabled
 	 * event will issue the IPI and reprogram the hardware.
 	 */
-	if (__perf_effective_state(event) == PERF_EVENT_STATE_OFF && ctx->nr_events) {
+	if (__perf_effective_state(event) == PERF_EVENT_STATE_OFF &&
+	    ctx->nr_events && !is_cgroup_event(event)) {
 		raw_spin_lock_irq(&ctx->lock);
 		if (ctx->task == TASK_TOMBSTONE) {
 			raw_spin_unlock_irq(&ctx->lock);


