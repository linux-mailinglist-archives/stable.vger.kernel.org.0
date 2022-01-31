Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8CD4A442F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359308AbiAaL1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:27:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57728 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359403AbiAaLZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84BBD612A4;
        Mon, 31 Jan 2022 11:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496EBC340EE;
        Mon, 31 Jan 2022 11:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628310;
        bh=jxJjGJQnN9EiZZsKB1Qdr7b4KXmNmYe3+R3/dfYuTxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqiCBUiZaJIJYS+ewQdRAQWqxWTMcOSV9eEsChgvHzWGN5xQcZSYHmZuGhR/m9nDv
         gVyu0q/Qwv6GHwMp2+YfFq+0nuGXAOW9MHPs0SmagdOJsQvqcDERvODucp7SRQD8fx
         5v7AlsIb6NbfNXCRtjPgCfS8hlqg6CzFRwXi9jUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 191/200] perf/core: Fix cgroup event list management
Date:   Mon, 31 Jan 2022 11:57:34 +0100
Message-Id: <20220131105239.967010693@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2458,7 +2458,11 @@ static void perf_remove_from_context(str
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
@@ -2891,11 +2895,14 @@ perf_install_in_context(struct perf_even
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


