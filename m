Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68D24A8EF8
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354520AbiBCUkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355513AbiBCUh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:37:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EB2C06135F;
        Thu,  3 Feb 2022 12:35:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BFBAB83556;
        Thu,  3 Feb 2022 20:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A062C340EF;
        Thu,  3 Feb 2022 20:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920541;
        bh=uTL2Nay/8GWAMmVvKaKX/FlLlSAitr1eesRfZ0/hxmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiDIRVaG8JoiYLx6CR0ZnXeAV0JNCrWIP3Sx8TYhR7e6MoEpIPqf0kfCJv9Ciq0zC
         wtIMB98RFGNk1A56DyWre915trzbK/RUXlVynUMn3u9hBP1s0Rbf+R/FG/pI572qu6
         il6RRrNhigsHNPDosf6lY9uE5R8E1RtUb+AqHQ3KnphUr+Wu2yLfdfDZ5Y5WbxDE3L
         7CDdRZ8JLCWR7LughFYaQe/purpP9T7LPhGeITyukVbBv+F8tmip88LI4ymLzREgpS
         FyqF3wkhZ65poRM9I5ly5X6hAI0EVg+04xaAuaoDpMTuprnSNHpmIJsY0ryHm7h3yL
         8EyP1qqqI7/Vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Clark <james.clark@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/25] perf: Always wake the parent event
Date:   Thu,  3 Feb 2022 15:34:44 -0500
Message-Id: <20220203203447.3570-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203447.3570-1-sashal@kernel.org>
References: <20220203203447.3570-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <james.clark@arm.com>

[ Upstream commit 961c39121759ad09a89598ec4ccdd34ae0468a19 ]

When using per-process mode and event inheritance is set to true,
forked processes will create a new perf events via inherit_event() ->
perf_event_alloc(). But these events will not have ring buffers
assigned to them. Any call to wakeup will be dropped if it's called on
an event with no ring buffer assigned because that's the object that
holds the wakeup list.

If the child event is disabled due to a call to
perf_aux_output_begin() or perf_aux_output_end(), the wakeup is
dropped leaving userspace hanging forever on the poll.

Normally the event is explicitly re-enabled by userspace after it
wakes up to read the aux data, but in this case it does not get woken
up so the event remains disabled.

This can be reproduced when using Arm SPE and 'stress' which forks once
before running the workload. By looking at the list of aux buffers read,
it's apparent that they stop after the fork:

  perf record -e arm_spe// -vvv -- stress -c 1

With this patch applied they continue to be printed. This behaviour
doesn't happen when using systemwide or per-cpu mode.

Reported-by: Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211206113840.130802-2-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e2d774cc470ee..071a5bfe7c678 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5830,6 +5830,8 @@ static void ring_buffer_attach(struct perf_event *event,
 	struct perf_buffer *old_rb = NULL;
 	unsigned long flags;
 
+	WARN_ON_ONCE(event->parent);
+
 	if (event->rb) {
 		/*
 		 * Should be impossible, we set this when removing
@@ -5887,6 +5889,9 @@ static void ring_buffer_wakeup(struct perf_event *event)
 {
 	struct perf_buffer *rb;
 
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
@@ -5900,6 +5905,9 @@ struct perf_buffer *ring_buffer_get(struct perf_event *event)
 {
 	struct perf_buffer *rb;
 
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
@@ -6572,7 +6580,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 	if (WARN_ON_ONCE(READ_ONCE(sampler->oncpu) != smp_processor_id()))
 		goto out;
 
-	rb = ring_buffer_get(sampler->parent ? sampler->parent : sampler);
+	rb = ring_buffer_get(sampler);
 	if (!rb)
 		goto out;
 
@@ -6638,7 +6646,7 @@ static void perf_aux_sample_output(struct perf_event *event,
 	if (WARN_ON_ONCE(!sampler || !data->aux_size))
 		return;
 
-	rb = ring_buffer_get(sampler->parent ? sampler->parent : sampler);
+	rb = ring_buffer_get(sampler);
 	if (!rb)
 		return;
 
-- 
2.34.1

