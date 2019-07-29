Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEC878FBC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbfG2PrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 11:47:02 -0400
Received: from mail.monom.org ([188.138.9.77]:50042 "EHLO mail.monom.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388211AbfG2PrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 11:47:02 -0400
Received: from mail.monom.org (localhost [127.0.0.1])
        by filter.mynetwork.local (Postfix) with ESMTP id 8A657500767;
        Mon, 29 Jul 2019 17:40:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.monom.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Received: from localhost (b9168f76.cgn.dg-w.de [185.22.143.118])
        by mail.monom.org (Postfix) with ESMTPSA id 56685500959;
        Mon, 29 Jul 2019 17:40:51 +0200 (CEST)
From:   Daniel Wagner <wagi@monom.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 4.4 1/2] vmstat: Remove BUG_ON from vmstat_update
Date:   Mon, 29 Jul 2019 17:40:45 +0200
Message-Id: <20190729154046.8824-2-wagi@monom.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729154046.8824-1-wagi@monom.org>
References: <20190729154046.8824-1-wagi@monom.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

[ Upstream commit 587198ba5206cdf0d30855f7361af950a4172cd6 ]

If we detect that there is nothing to do just set the flag and do not
check if it was already set before.  Races really do not matter.  If the
flag is set by any code then the shepherd will start dealing with the
situation and reenable the vmstat workers when necessary again.

Since commit 0eb77e988032 ("vmstat: make vmstat_updater deferrable again
and shut down on idle") quiet_vmstat might update cpu_stat_off and mark
a particular cpu to be handled by vmstat_shepherd.  This might trigger a
VM_BUG_ON in vmstat_update because the work item might have been
sleeping during the idle period and see the cpu_stat_off updated after
the wake up.  The VM_BUG_ON is therefore misleading and no more
appropriate.  Moreover it doesn't really suite any protection from real
bugs because vmstat_shepherd will simply reschedule the vmstat_work
anytime it sees a particular cpu set or vmstat_update would do the same
from the worker context directly.  Even when the two would race the
result wouldn't be incorrect as the counters update is fully idempotent.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Daniel Wagner <wagi@monom.org>
---
 mm/vmstat.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index dd0a13013cb4..233045057a30 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1407,17 +1407,7 @@ static void vmstat_update(struct work_struct *w)
 		 * Defer the checking for differentials to the
 		 * shepherd thread on a different processor.
 		 */
-		int r;
-		/*
-		 * Shepherd work thread does not race since it never
-		 * changes the bit if its zero but the cpu
-		 * online / off line code may race if
-		 * worker threads are still allowed during
-		 * shutdown / startup.
-		 */
-		r = cpumask_test_and_set_cpu(smp_processor_id(),
-			cpu_stat_off);
-		VM_BUG_ON(r);
+		cpumask_set_cpu(smp_processor_id(), cpu_stat_off);
 	}
 }
 
-- 
2.20.1
