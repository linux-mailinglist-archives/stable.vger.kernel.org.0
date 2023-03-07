Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23286AED22
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjCGSBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCGSBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:01:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9571396C0E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 229DA61527
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A685C433D2;
        Tue,  7 Mar 2023 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211702;
        bh=txwgCUkEjGwACtdhd+vQYoGz1Go1Lauqqofk/lf6iVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/qIlqoJp2NGZl7pSNYKY8fCFXWRV52ypwp3s8Hk10UDk5vrwnpZkfv4zt5qSvb5w
         Ic8QQVDzQRMTdBdT3Wgt0+3ZFc+2HIoGu89kH/OUlv2arkoHu2o+UTi1dkxwroaQ72
         GByEYmuOd+0pbBusgOf6TnDmgjpj1/imIH8tJ4rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengfei Xu <pengfei.xu@intel.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 0948/1001] kprobes: Fix to handle forcibly unoptimized kprobes on freeing_list
Date:   Tue,  7 Mar 2023 18:02:00 +0100
Message-Id: <20230307170103.282846471@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 4fbd2f83fda0ca44a2ec6421ca3508b355b31858 upstream.

Since forcibly unoptimized kprobes will be put on the freeing_list directly
in the unoptimize_kprobe(), do_unoptimize_kprobes() must continue to check
the freeing_list even if unoptimizing_list is empty.

This bug can happen if a kprobe is put in an instruction which is in the
middle of the jump-replaced instruction sequence of an optprobe, *and* the
optprobe is recently unregistered and queued on unoptimizing_list.
In this case, the optprobe will be unoptimized forcibly (means immediately)
and put it into the freeing_list, expecting the optprobe will be handled in
do_unoptimize_kprobe().
But if there is no other optprobes on the unoptimizing_list, current code
returns from the do_unoptimize_kprobe() soon and does not handle the
optprobe which is on the freeing_list. Then the optprobe will hit the
WARN_ON_ONCE() in the do_free_cleaned_kprobes(), because it is not handled
in the latter loop of the do_unoptimize_kprobe().

To solve this issue, do not return from do_unoptimize_kprobes() immediately
even if unoptimizing_list is empty.

Moreover, this change affects another case. kill_optimized_kprobes() expects
kprobe_optimizer() will just free the optprobe on freeing_list.
So I changed it to just do list_move() to freeing_list if optprobes are on
unoptimizing list. And the do_unoptimize_kprobe() will skip
arch_disarm_kprobe() if the probe on freeing_list has gone flag.

Link: https://lore.kernel.org/all/Y8URdIfVr3pq2X8w@xpf.sh.intel.com/
Link: https://lore.kernel.org/all/167448024501.3253718.13037333683110512967.stgit@devnote3/

Fixes: e4add247789e ("kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -555,17 +555,15 @@ static void do_unoptimize_kprobes(void)
 	/* See comment in do_optimize_kprobes() */
 	lockdep_assert_cpus_held();
 
-	/* Unoptimization must be done anytime */
-	if (list_empty(&unoptimizing_list))
-		return;
+	if (!list_empty(&unoptimizing_list))
+		arch_unoptimize_kprobes(&unoptimizing_list, &freeing_list);
 
-	arch_unoptimize_kprobes(&unoptimizing_list, &freeing_list);
-	/* Loop on 'freeing_list' for disarming */
+	/* Loop on 'freeing_list' for disarming and removing from kprobe hash list */
 	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
 		/* Switching from detour code to origin */
 		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
-		/* Disarm probes if marked disabled */
-		if (kprobe_disabled(&op->kp))
+		/* Disarm probes if marked disabled and not gone */
+		if (kprobe_disabled(&op->kp) && !kprobe_gone(&op->kp))
 			arch_disarm_kprobe(&op->kp);
 		if (kprobe_unused(&op->kp)) {
 			/*
@@ -797,14 +795,13 @@ static void kill_optimized_kprobe(struct
 	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
 
 	if (kprobe_unused(p)) {
-		/* Enqueue if it is unused */
-		list_add(&op->list, &freeing_list);
 		/*
-		 * Remove unused probes from the hash list. After waiting
-		 * for synchronization, this probe is reclaimed.
-		 * (reclaiming is done by do_free_cleaned_kprobes().)
+		 * Unused kprobe is on unoptimizing or freeing list. We move it
+		 * to freeing_list and let the kprobe_optimizer() remove it from
+		 * the kprobe hash list and free it.
 		 */
-		hlist_del_rcu(&op->kp.hlist);
+		if (optprobe_queued_unopt(op))
+			list_move(&op->list, &freeing_list);
 	}
 
 	/* Don't touch the code, because it is already freed. */


