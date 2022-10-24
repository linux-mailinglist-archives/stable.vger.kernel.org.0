Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4455F60B07E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiJXQGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiJXQEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:04:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD47111BBB;
        Mon, 24 Oct 2022 07:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA310B8163A;
        Mon, 24 Oct 2022 12:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBD4C433C1;
        Mon, 24 Oct 2022 12:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613939;
        bh=QU6jcTM5tFiqBhEpEDUebcCTZlgBib+XeTwuUsseiyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAuStvL8n+lQiHWahcSDtFr7g52zwqg7u/XJ6cuwOM8+L9RYBMnWwqFhpLZOLWiqR
         ngeOD0JjjfPuWMPCzp1qsFSDKNRKHe1iVNCjUAPSQLMELOQp1MW2FOk0jlLUtRx++t
         JZTk1TYn9Hr0lL+ia4mCbUclVpBWjfE2n+YU7mqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        Breno Leitao <leitao@debian.org>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, stable@kernel.org
Subject: [PATCH 5.10 071/390] livepatch: fix race between fork and KLP transition
Date:   Mon, 24 Oct 2022 13:27:48 +0200
Message-Id: <20221024113025.612651507@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

commit 747f7a2901174c9afa805dddfb7b24db6f65e985 upstream.

The KLP transition code depends on the TIF_PATCH_PENDING and
the task->patch_state to stay in sync. On a normal (forward)
transition, TIF_PATCH_PENDING will be set on every task in
the system, while on a reverse transition (after a failed
forward one) first TIF_PATCH_PENDING will be cleared from
every task, followed by it being set on tasks that need to
be transitioned back to the original code.

However, the fork code copies over the TIF_PATCH_PENDING flag
from the parent to the child early on, in dup_task_struct and
setup_thread_stack. Much later, klp_copy_process will set
child->patch_state to match that of the parent.

However, the parent's patch_state may have been changed by KLP loading
or unloading since it was initially copied over into the child.

This results in the KLP code occasionally hitting this warning in
klp_complete_transition:

        for_each_process_thread(g, task) {
                WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_PATCH_PENDING));
                task->patch_state = KLP_UNDEFINED;
        }

Set, or clear, the TIF_PATCH_PENDING flag in the child task
depending on whether or not it is needed at the time
klp_copy_process is called, at a point in copy_process where the
tasklist_lock is held exclusively, preventing races with the KLP
code.

The KLP code does have a few places where the state is changed
without the tasklist_lock held, but those should not cause
problems because klp_update_patch_state(current) cannot be
called while the current task is in the middle of fork,
klp_check_and_switch_task() which is called under the pi_lock,
which prevents rescheduling, and manipulation of the patch
state of idle tasks, which do not fork.

This should prevent this warning from triggering again in the
future, and close the race for both normal and reverse transitions.

Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Fixes: d83a7cb375ee ("livepatch: change to a per-task consistency model")
Cc: stable@kernel.org
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220808150019.03d6a67b@imladris.surriel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/livepatch/transition.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -611,9 +611,23 @@ void klp_reverse_transition(void)
 /* Called from copy_process() during fork */
 void klp_copy_process(struct task_struct *child)
 {
-	child->patch_state = current->patch_state;
 
-	/* TIF_PATCH_PENDING gets copied in setup_thread_stack() */
+	/*
+	 * The parent process may have gone through a KLP transition since
+	 * the thread flag was copied in setup_thread_stack earlier. Bring
+	 * the task flag up to date with the parent here.
+	 *
+	 * The operation is serialized against all klp_*_transition()
+	 * operations by the tasklist_lock. The only exception is
+	 * klp_update_patch_state(current), but we cannot race with
+	 * that because we are current.
+	 */
+	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
+		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
+	else
+		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
+
+	child->patch_state = current->patch_state;
 }
 
 /*


