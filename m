Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADCB7F126
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404182AbfHBJgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729530AbfHBJg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:36:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7B7B20679;
        Fri,  2 Aug 2019 09:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738588;
        bh=is7Trm1mO1xeHo+Z3lGqzzJbiQihkmFNJGKiCthNRH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtV7Ent28hKgjF41ZUbWqcjHtNsmmiXc5ekZyovvj/Q2MzBw7wj/IFYvx886GZ0Mm
         fOx+0Tk8p3kBhpgVJy1iCWOXRgh8jDoXx5DfbFg61ZBbF9nVapDL88Arkf+8kXOBe9
         LIPWRVEcyJvBe++qsLQN+/ENVp2W8QRbIGnSOjWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Wagner <wagi@monom.org>
Subject: [PATCH 4.4 148/158] vmstat: Remove BUG_ON from vmstat_update
Date:   Fri,  2 Aug 2019 11:29:29 +0200
Message-Id: <20190802092232.411961311@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

commit 587198ba5206cdf0d30855f7361af950a4172cd6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmstat.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1407,17 +1407,7 @@ static void vmstat_update(struct work_st
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
 


