Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0970560427E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiJSLFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiJSLEL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:04:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB1914DF0B;
        Wed, 19 Oct 2022 03:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE8E6187A;
        Wed, 19 Oct 2022 09:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F4AC433D6;
        Wed, 19 Oct 2022 09:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170412;
        bh=VHFS+tnidvdu/bK8WD7Sf1hdnURQhrZG9a3fUJ2k0dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBHluHFFnEizbPAcmCVtVvFgxgp4GM5i4+UjOkbPIX+EGGWGNOCGiQxYvwjE7q0G+
         xXbeTztZ0dmt0IPhKWQ3vraNzvwXqXV+7kkGTLECoc5P8No4i294qV539k1BAjgWK6
         797FTz1uSf7UNI+g813l0QYG7RWPazmPaDF0rpME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <song@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [PATCH 6.0 646/862] ftrace: Fix recursive locking direct_mutex in ftrace_modify_direct_caller
Date:   Wed, 19 Oct 2022 10:32:13 +0200
Message-Id: <20221019083318.458903314@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <song@kernel.org>

[ Upstream commit 9d2ce78ddcee159eb6a97449e9c68b6d60b9cec4 ]

Naveen reported recursive locking of direct_mutex with sample
ftrace-direct-modify.ko:

[   74.762406] WARNING: possible recursive locking detected
[   74.762887] 6.0.0-rc6+ #33 Not tainted
[   74.763216] --------------------------------------------
[   74.763672] event-sample-fn/1084 is trying to acquire lock:
[   74.764152] ffffffff86c9d6b0 (direct_mutex){+.+.}-{3:3}, at: \
    register_ftrace_function+0x1f/0x180
[   74.764922]
[   74.764922] but task is already holding lock:
[   74.765421] ffffffff86c9d6b0 (direct_mutex){+.+.}-{3:3}, at: \
    modify_ftrace_direct+0x34/0x1f0
[   74.766142]
[   74.766142] other info that might help us debug this:
[   74.766701]  Possible unsafe locking scenario:
[   74.766701]
[   74.767216]        CPU0
[   74.767437]        ----
[   74.767656]   lock(direct_mutex);
[   74.767952]   lock(direct_mutex);
[   74.768245]
[   74.768245]  *** DEADLOCK ***
[   74.768245]
[   74.768750]  May be due to missing lock nesting notation
[   74.768750]
[   74.769332] 1 lock held by event-sample-fn/1084:
[   74.769731]  #0: ffffffff86c9d6b0 (direct_mutex){+.+.}-{3:3}, at: \
    modify_ftrace_direct+0x34/0x1f0
[   74.770496]
[   74.770496] stack backtrace:
[   74.770884] CPU: 4 PID: 1084 Comm: event-sample-fn Not tainted ...
[   74.771498] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
[   74.772474] Call Trace:
[   74.772696]  <TASK>
[   74.772896]  dump_stack_lvl+0x44/0x5b
[   74.773223]  __lock_acquire.cold.74+0xac/0x2b7
[   74.773616]  lock_acquire+0xd2/0x310
[   74.773936]  ? register_ftrace_function+0x1f/0x180
[   74.774357]  ? lock_is_held_type+0xd8/0x130
[   74.774744]  ? my_tramp2+0x11/0x11 [ftrace_direct_modify]
[   74.775213]  __mutex_lock+0x99/0x1010
[   74.775536]  ? register_ftrace_function+0x1f/0x180
[   74.775954]  ? slab_free_freelist_hook.isra.43+0x115/0x160
[   74.776424]  ? ftrace_set_hash+0x195/0x220
[   74.776779]  ? register_ftrace_function+0x1f/0x180
[   74.777194]  ? kfree+0x3e1/0x440
[   74.777482]  ? my_tramp2+0x11/0x11 [ftrace_direct_modify]
[   74.777941]  ? __schedule+0xb40/0xb40
[   74.778258]  ? register_ftrace_function+0x1f/0x180
[   74.778672]  ? my_tramp1+0xf/0xf [ftrace_direct_modify]
[   74.779128]  register_ftrace_function+0x1f/0x180
[   74.779527]  ? ftrace_set_filter_ip+0x33/0x70
[   74.779910]  ? __schedule+0xb40/0xb40
[   74.780231]  ? my_tramp1+0xf/0xf [ftrace_direct_modify]
[   74.780678]  ? my_tramp2+0x11/0x11 [ftrace_direct_modify]
[   74.781147]  ftrace_modify_direct_caller+0x5b/0x90
[   74.781563]  ? 0xffffffffa0201000
[   74.781859]  ? my_tramp1+0xf/0xf [ftrace_direct_modify]
[   74.782309]  modify_ftrace_direct+0x1b2/0x1f0
[   74.782690]  ? __schedule+0xb40/0xb40
[   74.783014]  ? simple_thread+0x2a/0xb0 [ftrace_direct_modify]
[   74.783508]  ? __schedule+0xb40/0xb40
[   74.783832]  ? my_tramp2+0x11/0x11 [ftrace_direct_modify]
[   74.784294]  simple_thread+0x76/0xb0 [ftrace_direct_modify]
[   74.784766]  kthread+0xf5/0x120
[   74.785052]  ? kthread_complete_and_exit+0x20/0x20
[   74.785464]  ret_from_fork+0x22/0x30
[   74.785781]  </TASK>

Fix this by using register_ftrace_function_nolock in
ftrace_modify_direct_caller.

Link: https://lkml.kernel.org/r/20220927004146.1215303-1-song@kernel.org

Fixes: 53cd885bc5c3 ("ftrace: Allow IPMODIFY and DIRECT ops on the same function")
Reported-and-tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2edda4962367..83362a155791 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5439,6 +5439,8 @@ static struct ftrace_ops stub_ops = {
  * it is safe to modify the ftrace record, where it should be
  * currently calling @old_addr directly, to call @new_addr.
  *
+ * This is called with direct_mutex locked.
+ *
  * Safety checks should be made to make sure that the code at
  * @rec->ip is currently calling @old_addr. And this must
  * also update entry->direct to @new_addr.
@@ -5451,6 +5453,8 @@ int __weak ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 	unsigned long ip = rec->ip;
 	int ret;
 
+	lockdep_assert_held(&direct_mutex);
+
 	/*
 	 * The ftrace_lock was used to determine if the record
 	 * had more than one registered user to it. If it did,
@@ -5473,7 +5477,7 @@ int __weak ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 	if (ret)
 		goto out_lock;
 
-	ret = register_ftrace_function(&stub_ops);
+	ret = register_ftrace_function_nolock(&stub_ops);
 	if (ret) {
 		ftrace_set_filter_ip(&stub_ops, ip, 1, 0);
 		goto out_lock;
-- 
2.35.1



