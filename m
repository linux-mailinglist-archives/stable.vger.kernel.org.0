Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7603D328E3F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240769AbhCAT0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:26:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241058AbhCATVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C426E64DD3;
        Mon,  1 Mar 2021 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620856;
        bh=Zx9LDLiJDNi9Yp+SxQtDzp5TmEwpvydW9I5sVx36m6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TH4K+y8cwejo4i/tu3fpMaXXpxrgQTeMS9Ql+GquoX2tj+evD1tx9KXL4x4IxKGo8
         xBfvEmgvQS9pwCR+gigYsZ8asQE8v50871oeun+FmVPdeV4sRjE9b6IYS5mFwSFYdo
         GKSu4Gp+u6DmgwFEV87htgrYOiO5Ee3q+VPdYwGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 264/775] locking/lockdep: Avoid unmatched unlock
Date:   Mon,  1 Mar 2021 17:07:12 +0100
Message-Id: <20210301161214.673830138@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7f82e631d236cafd28518b998c6d4d8dc2ef68f6 ]

Commit f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI"
inversions") overlooked that print_usage_bug() releases the graph_lock
and called it without the graph lock held.

Fixes: f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI" inversions")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lkml.kernel.org/r/YBfkuyIfB1+VRxXP@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index bdaf4829098c0..780012eb2f3fe 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3707,7 +3707,7 @@ static void
 print_usage_bug(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
 {
-	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
+	if (!debug_locks_off() || debug_locks_silent)
 		return;
 
 	pr_warn("\n");
@@ -3748,6 +3748,7 @@ valid_state(struct task_struct *curr, struct held_lock *this,
 	    enum lock_usage_bit new_bit, enum lock_usage_bit bad_bit)
 {
 	if (unlikely(hlock_class(this)->usage_mask & (1 << bad_bit))) {
+		graph_unlock();
 		print_usage_bug(curr, this, bad_bit, new_bit);
 		return 0;
 	}
-- 
2.27.0



