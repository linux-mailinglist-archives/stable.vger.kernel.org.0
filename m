Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446592E41AE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391707AbgL1OH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391702AbgL1OHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F583207AB;
        Mon, 28 Dec 2020 14:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164404;
        bh=IF5gIABbZd5/ffjrnxQ1CF9OCFUMmkAf++QrNYLfP0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2KHqS7jmS58eU3z5R5SPgNNKffmQyuYX6iJlhx9kB9svTAgqi4zXmn3lmg5DC3RU
         twa9yKF9PDKlAeGw236mWGy1SxurVF2iCLMon/1RNFAfMzBwN8kZ5vNNZW++twv7bC
         qQpNjtEM+vjT2+YpaXHb3nDepLq7qIdRhVG18QZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/717] rcu,ftrace: Fix ftrace recursion
Date:   Mon, 28 Dec 2020 13:42:46 +0100
Message-Id: <20201228125029.005848859@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d2098b4440981705e844c50254540ba7b5f82795 ]

Kim reported that perf-ftrace made his box unhappy. It turns out that
commit:

  ff5c4f5cad33 ("rcu/tree: Mark the idle relevant functions noinstr")

removed one too many notrace qualifiers, probably due to there not being
a helpful comment.

This commit therefore reinstates the notrace and adds a comment to avoid
losing it again.

[ paulmck: Apply Steven Rostedt's feedback on the comment. ]
Fixes: ff5c4f5cad33 ("rcu/tree: Mark the idle relevant functions noinstr")
Reported-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 655ade095e043..585bf112ee08d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1093,8 +1093,11 @@ static void rcu_disable_urgency_upon_qs(struct rcu_data *rdp)
  * CPU can safely enter RCU read-side critical sections.  In other words,
  * if the current CPU is not in its idle loop or is in an interrupt or
  * NMI handler, return true.
+ *
+ * Make notrace because it can be called by the internal functions of
+ * ftrace, and making this notrace removes unnecessary recursion calls.
  */
-bool rcu_is_watching(void)
+notrace bool rcu_is_watching(void)
 {
 	bool ret;
 
-- 
2.27.0



