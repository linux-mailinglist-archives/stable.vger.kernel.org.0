Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A6E378692
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhEJLJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhEJK7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E04361613;
        Mon, 10 May 2021 10:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643981;
        bh=kwOyVJpLtd8gheGbQRqdFlIORGINOYnXM+3NvNS/wfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtQPx4JCbFpwhGpWlxQAGCAoBcvjfi/79Ftr/LKO3zm2d9NErpFTFcey1xyYEiCFf
         bzq3b6FzO8NY4jZdlUao4+ZaA3Me1jBfghvI797B/sJ2hdl2X6KTPjAArGq62TPmwv
         dLQH7cjvlTRjaWDa9vLplXIf+ajvg49YhOhIhDz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 238/342] sched,psi: Handle potential task count underflow bugs more gracefully
Date:   Mon, 10 May 2021 12:20:28 +0200
Message-Id: <20210510102017.949638928@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Reddy <charante@codeaurora.org>

[ Upstream commit 9d10a13d1e4c349b76f1c675a874a7f981d6d3b4 ]

psi_group_cpu->tasks, represented by the unsigned int, stores the
number of tasks that could be stalled on a psi resource(io/mem/cpu).
Decrementing these counters at zero leads to wrapping which further
leads to the psi_group_cpu->state_mask is being set with the
respective pressure state. This could result into the unnecessary time
sampling for the pressure state thus cause the spurious psi events.
This can further lead to wrong actions being taken at the user land
based on these psi events.

Though psi_bug is set under these conditions but that just for debug
purpose. Fix it by decrementing the ->tasks count only when it is
non-zero.

Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lkml.kernel.org/r/1618585336-37219-1-git-send-email-charante@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 967732c0766c..651218ded981 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -711,14 +711,15 @@ static void psi_group_change(struct psi_group *group, int cpu,
 	for (t = 0, m = clear; m; m &= ~(1 << t), t++) {
 		if (!(m & (1 << t)))
 			continue;
-		if (groupc->tasks[t] == 0 && !psi_bug) {
+		if (groupc->tasks[t]) {
+			groupc->tasks[t]--;
+		} else if (!psi_bug) {
 			printk_deferred(KERN_ERR "psi: task underflow! cpu=%d t=%d tasks=[%u %u %u %u] clear=%x set=%x\n",
 					cpu, t, groupc->tasks[0],
 					groupc->tasks[1], groupc->tasks[2],
 					groupc->tasks[3], clear, set);
 			psi_bug = 1;
 		}
-		groupc->tasks[t]--;
 	}
 
 	for (t = 0; set; set &= ~(1 << t), t++)
-- 
2.30.2



