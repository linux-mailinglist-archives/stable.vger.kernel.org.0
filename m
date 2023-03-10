Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EA76B44E7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjCJO3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjCJO3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D505119970
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:27:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18EF061380
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F547C433EF;
        Fri, 10 Mar 2023 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458448;
        bh=43NltWjxz6IrNrf3liamglzjREjqK25Zn5kwODxAtgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsPCWsLCTqDFivbk+YGKhTKPPCb6SQoGerzVmL8CWdBYW8rSkE2scHTd5hMBEd0tT
         X8A0xomi+rFlCRPacfWrAfCrP5GjkEmwCP/L6lmea4XXDAXB9/hI/Sti/gxSd4uoLM
         kVHlTe91AlB+M/1WL6om/wJeKRlu772G0vKZpezI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/357] sched/rt: pick_next_rt_entity(): check list_entry
Date:   Fri, 10 Mar 2023 14:35:19 +0100
Message-Id: <20230310133735.348339085@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 7c4a5b89a0b5a57a64b601775b296abf77a9fe97 ]

Commit 326587b84078 ("sched: fix goto retry in pick_next_task_rt()")
removed any path which could make pick_next_rt_entity() return NULL.
However, BUG_ON(!rt_se) in _pick_next_task_rt() (the only caller of
pick_next_rt_entity()) still checks the error condition, which can
never happen, since list_entry() never returns NULL.
Remove the BUG_ON check, and instead emit a warning in the only
possible error condition here: the queue being empty which should
never happen.

Fixes: 326587b84078 ("sched: fix goto retry in pick_next_task_rt()")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20230128-list-entry-null-check-sched-v3-1-b1a71bd1ac6b@diag.uniroma1.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/rt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e5d42947e57ab..186e7d78ded5c 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1561,6 +1561,8 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
 	BUG_ON(idx >= MAX_RT_PRIO);
 
 	queue = array->queue + idx;
+	if (SCHED_WARN_ON(list_empty(queue)))
+		return NULL;
 	next = list_entry(queue->next, struct sched_rt_entity, run_list);
 
 	return next;
@@ -1573,7 +1575,8 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 
 	do {
 		rt_se = pick_next_rt_entity(rt_rq);
-		BUG_ON(!rt_se);
+		if (unlikely(!rt_se))
+			return NULL;
 		rt_rq = group_rt_rq(rt_se);
 	} while (rt_rq);
 
-- 
2.39.2



