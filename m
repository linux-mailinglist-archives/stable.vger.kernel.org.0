Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3B44B47AD
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244372AbiBNJhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245579AbiBNJgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:36:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EFAA1A4;
        Mon, 14 Feb 2022 01:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1122C6102D;
        Mon, 14 Feb 2022 09:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D70C340E9;
        Mon, 14 Feb 2022 09:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831267;
        bh=I8Ph0gGStHft4R/DZ1s2Vo5pyXczRsabuPR6VqIhCoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rR9AFhcDbsQDfxoHayAukw8dAp3wHaIRwmWmW/nmik6dJbySt1XLAIFMz0DKPs+We
         TenSWcW/w0nVDEvjx7y5jdD5SOoU5Ejyvz/aLERKTjXYkLRDY6Nzh82K2y2Fm5/93j
         jygGh1vwY20q1qPqHOidUxdUTWL9l4vUPXxTsCEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <song@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.19 49/49] perf: Fix list corruption in perf_cgroup_switch()
Date:   Mon, 14 Feb 2022 10:26:15 +0100
Message-Id: <20220214092449.933317340@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

commit 5f4e5ce638e6a490b976ade4a40017b40abb2da0 upstream.

There's list corruption on cgrp_cpuctx_list. This happens on the
following path:

  perf_cgroup_switch: list_for_each_entry(cgrp_cpuctx_list)
      cpu_ctx_sched_in
         ctx_sched_in
            ctx_pinned_sched_in
              merge_sched_in
                  perf_cgroup_event_disable: remove the event from the list

Use list_for_each_entry_safe() to allow removing an entry during
iteration.

Fixes: 058fe1c0440e ("perf/core: Make cgroup switch visit only cpuctxs with cgroup events")
Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220204004057.2961252-1-song@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -798,7 +798,7 @@ static DEFINE_PER_CPU(struct list_head,
  */
 static void perf_cgroup_switch(struct task_struct *task, int mode)
 {
-	struct perf_cpu_context *cpuctx;
+	struct perf_cpu_context *cpuctx, *tmp;
 	struct list_head *list;
 	unsigned long flags;
 
@@ -809,7 +809,7 @@ static void perf_cgroup_switch(struct ta
 	local_irq_save(flags);
 
 	list = this_cpu_ptr(&cgrp_cpuctx_list);
-	list_for_each_entry(cpuctx, list, cgrp_cpuctx_entry) {
+	list_for_each_entry_safe(cpuctx, tmp, list, cgrp_cpuctx_entry) {
 		WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
 
 		perf_ctx_lock(cpuctx, cpuctx->task_ctx);


