Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AAC4A8E66
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355128AbiBCUhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355189AbiBCUfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8556C0613EB;
        Thu,  3 Feb 2022 12:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45C5E61B16;
        Thu,  3 Feb 2022 20:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E7FC340F6;
        Thu,  3 Feb 2022 20:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920449;
        bh=B2Ld9P6XUc/9jqCyq3qkXZC9eh0RbzRB5eVXvlWyzvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eze73nqrt2pJwpu0BmlPJF/HqdhwlyT/g9tWNvOn7kr8F4O8xZgaydVflwPIASbF6
         cv/HHivqhs6sDTYf+ItQ9G2BacZaU3Z/U7VkW5lU4S8pgqZjHgjmvKPmfr5XTqcX1K
         yIQXmlQlGiCd/fwtUgZyH4v1H9y8GTJNKGZ3t+5zW6Gb37l/ksrUHQqjwoDEEvTYc5
         lSof1nnPzHqSVD62mxRPAmJhqtlMBjWbqgcmtxW6MXhzJ/wNsLZk2sdmBD11Xygvl9
         QE3pzHZEbj9K1Ze/3cN5vy7HrnZ/mqJpnmF5NaS+43UKULyCBHZaLodsi/p2H+xQo4
         U7mwTwQIIGncg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Clark <james.clark@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 37/41] perf: Always wake the parent event
Date:   Thu,  3 Feb 2022 15:32:41 -0500
Message-Id: <20220203203245.3007-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
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
index 0fe6a65bbd58f..d3eed25daeb4c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5934,6 +5934,8 @@ static void ring_buffer_attach(struct perf_event *event,
 	struct perf_buffer *old_rb = NULL;
 	unsigned long flags;
 
+	WARN_ON_ONCE(event->parent);
+
 	if (event->rb) {
 		/*
 		 * Should be impossible, we set this when removing
@@ -5991,6 +5993,9 @@ static void ring_buffer_wakeup(struct perf_event *event)
 {
 	struct perf_buffer *rb;
 
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
@@ -6004,6 +6009,9 @@ struct perf_buffer *ring_buffer_get(struct perf_event *event)
 {
 	struct perf_buffer *rb;
 
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
@@ -6703,7 +6711,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 	if (WARN_ON_ONCE(READ_ONCE(sampler->oncpu) != smp_processor_id()))
 		goto out;
 
-	rb = ring_buffer_get(sampler->parent ? sampler->parent : sampler);
+	rb = ring_buffer_get(sampler);
 	if (!rb)
 		goto out;
 
@@ -6769,7 +6777,7 @@ static void perf_aux_sample_output(struct perf_event *event,
 	if (WARN_ON_ONCE(!sampler || !data->aux_size))
 		return;
 
-	rb = ring_buffer_get(sampler->parent ? sampler->parent : sampler);
+	rb = ring_buffer_get(sampler);
 	if (!rb)
 		return;
 
-- 
2.34.1

