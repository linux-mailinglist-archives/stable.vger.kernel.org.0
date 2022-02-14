Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05D94B4924
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346499AbiBNKYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:24:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346966AbiBNKXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:23:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F8860ABD;
        Mon, 14 Feb 2022 01:56:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69CE060FA2;
        Mon, 14 Feb 2022 09:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30708C340E9;
        Mon, 14 Feb 2022 09:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832576;
        bh=rLhsafBCTYJ0kb1t3aQgksvKXgmCdBjj0TYBC5ydbvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qr5X/Ib7TtF7pxsQwsLicwDuC4/Pd8XHsynGdYDOi2hWz9T62BbD6rhCXDd7MOCRE
         QC9vHv5zSTKOCuMleeof4JtobGf92jpAs4l3png3rvjozHG07J3fIqPaVXp7HfTfIh
         RvKPAnXU6MmvyLPN1UCgqxh0ZsfFhfu5dMru69Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        James Clark <james.clark@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 058/203] perf: Always wake the parent event
Date:   Mon, 14 Feb 2022 10:25:02 +0100
Message-Id: <20220214092512.228339005@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 04e6e2dae60e4..a0e21d0f36d7a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6004,6 +6004,8 @@ static void ring_buffer_attach(struct perf_event *event,
 	struct perf_buffer *old_rb = NULL;
 	unsigned long flags;
 
+	WARN_ON_ONCE(event->parent);
+
 	if (event->rb) {
 		/*
 		 * Should be impossible, we set this when removing
@@ -6061,6 +6063,9 @@ static void ring_buffer_wakeup(struct perf_event *event)
 {
 	struct perf_buffer *rb;
 
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
@@ -6074,6 +6079,9 @@ struct perf_buffer *ring_buffer_get(struct perf_event *event)
 {
 	struct perf_buffer *rb;
 
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
 	if (rb) {
@@ -6772,7 +6780,7 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 	if (WARN_ON_ONCE(READ_ONCE(sampler->oncpu) != smp_processor_id()))
 		goto out;
 
-	rb = ring_buffer_get(sampler->parent ? sampler->parent : sampler);
+	rb = ring_buffer_get(sampler);
 	if (!rb)
 		goto out;
 
@@ -6838,7 +6846,7 @@ static void perf_aux_sample_output(struct perf_event *event,
 	if (WARN_ON_ONCE(!sampler || !data->aux_size))
 		return;
 
-	rb = ring_buffer_get(sampler->parent ? sampler->parent : sampler);
+	rb = ring_buffer_get(sampler);
 	if (!rb)
 		return;
 
-- 
2.34.1



