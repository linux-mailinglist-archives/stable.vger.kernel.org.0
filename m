Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5D531AF5
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbiEWRck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240874AbiEWR3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:29:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216531E3EF;
        Mon, 23 May 2022 10:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A526B81216;
        Mon, 23 May 2022 17:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47D4C385AA;
        Mon, 23 May 2022 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326060;
        bh=jydNrHBro0hUXzM5ccI1XyLjAw4x1Am2+1BWEGm+Jds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9xm/fktKhkj3qagwEY74WnZjYHsnuiko4XPU5A9jN4304ejU/fs3FefBbnX6KboI
         KiyFs4ytVtsz3MgobISuoZec0JHiLi8AgfQMg7/XwLFwQTz8/fcLmpcHIuSqSPGcdw
         7pzEMnvgT3b25v8CQEZXQob48nF/+MInrElGHpLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Slusarek <nslusarek@gmx.net>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 27/68] perf: Fix sys_perf_event_open() race against self
Date:   Mon, 23 May 2022 19:04:54 +0200
Message-Id: <20220523165807.096871574@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 3ac6487e584a1eb54071dbe1212e05b884136704 upstream.

Norbert reported that it's possible to race sys_perf_event_open() such
that the looser ends up in another context from the group leader,
triggering many WARNs.

The move_group case checks for races against itself, but the
!move_group case doesn't, seemingly relying on the previous
group_leader->ctx == ctx check. However, that check is racy due to not
holding any locks at that time.

Therefore, re-check the result after acquiring locks and bailing
if they no longer match.

Additionally, clarify the not_move_group case from the
move_group-vs-move_group race.

Fixes: f63a8daa5812 ("perf: Fix event->ctx locking")
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11114,6 +11114,9 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * Do not allow to attach to a group in a different task
 		 * or CPU context. If we're moving SW events, we'll fix
 		 * this up later, so allow that.
+		 *
+		 * Racy, not holding group_leader->ctx->mutex, see comment with
+		 * perf_event_ctx_lock().
 		 */
 		if (!move_group && group_leader->ctx != ctx)
 			goto err_context;
@@ -11181,6 +11184,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			} else {
 				perf_event_ctx_unlock(group_leader, gctx);
 				move_group = 0;
+				goto not_move_group;
 			}
 		}
 
@@ -11197,7 +11201,17 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	} else {
 		mutex_lock(&ctx->mutex);
+
+		/*
+		 * Now that we hold ctx->lock, (re)validate group_leader->ctx == ctx,
+		 * see the group_leader && !move_group test earlier.
+		 */
+		if (group_leader && group_leader->ctx != ctx) {
+			err = -EINVAL;
+			goto err_locked;
+		}
 	}
+not_move_group:
 
 	if (ctx->task == TASK_TOMBSTONE) {
 		err = -ESRCH;


