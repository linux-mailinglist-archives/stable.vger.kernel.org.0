Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D1757FC1D
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 11:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiGYJPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 05:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiGYJPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 05:15:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6496913F40
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 02:15:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBEAE61228
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 09:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727AAC341C6;
        Mon, 25 Jul 2022 09:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658740499;
        bh=EtsI0ZSqISg8iyK5l7eAmMUkjbsJmlmRm5GcfaPYsEQ=;
        h=Subject:To:Cc:From:Date:From;
        b=00j+Nc6UJiIPZz+a+LkuCokCzB/U9rDDNstM41s25fsSWYndWlT44oZTLsy+5JBjz
         gnbNh/szsfQIxU71bozQhKLpVvSOMqalkqz5Zi+3Ol2u/StP5Y3/sfV4+p9DXcfNv7
         HVnzlgR9f44CZ0OjJdgl0IedB6St5jchoT3LhJSY=
Subject: FAILED: patch "[PATCH] sched/deadline: Fix BUG_ON condition for deboosted tasks" failed to apply to 4.9-stable tree
To:     juri.lelli@redhat.com, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jul 2022 11:14:46 +0200
Message-ID: <165874048681191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ddfc710395cccc61247348df9eb18ea50321cbed Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@redhat.com>
Date: Thu, 14 Jul 2022 17:19:08 +0200
Subject: [PATCH] sched/deadline: Fix BUG_ON condition for deboosted tasks

Tasks the are being deboosted from SCHED_DEADLINE might enter
enqueue_task_dl() one last time and hit an erroneous BUG_ON condition:
since they are not boosted anymore, the if (is_dl_boosted()) branch is
not taken, but the else if (!dl_prio) is and inside this one we
BUG_ON(!is_dl_boosted), which is of course false (BUG_ON triggered)
otherwise we had entered the if branch above. Long story short, the
current condition doesn't make sense and always leads to triggering of a
BUG.

Fix this by only checking enqueue flags, properly: ENQUEUE_REPLENISH has
to be present, but additional flags are not a problem.

Fixes: 64be6f1f5f71 ("sched/deadline: Don't replenish from a !SCHED_DEADLINE entity")
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220714151908.533052-1-juri.lelli@redhat.com

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b5152961b743..7bf561262cb8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1701,7 +1701,10 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 		 * the throttle.
 		 */
 		p->dl.dl_throttled = 0;
-		BUG_ON(!is_dl_boosted(&p->dl) || flags != ENQUEUE_REPLENISH);
+		if (!(flags & ENQUEUE_REPLENISH))
+			printk_deferred_once("sched: DL de-boosted task PID %d: REPLENISH flag missing\n",
+					     task_pid_nr(p));
+
 		return;
 	}
 

