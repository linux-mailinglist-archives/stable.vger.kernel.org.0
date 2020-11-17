Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BCD2B6384
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732618AbgKQNit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732672AbgKQNis (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 099FC207BC;
        Tue, 17 Nov 2020 13:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620327;
        bh=ukp620K4yYyVPbyJ05RHjLjLRFfL43RGcfN+nHHVND8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lhzip1FqOA1JgtoKA38vNNnRAOk3zS/PNP9giMY4H5reqtaHy5Q7PeoAoeZXOBIBL
         G8EIHRk56NnDqz2R6xMyQWPqnNTghN9GQhCjn7F/o5pWC7nHvLi+VY4icC4EjB9T+2
         ic0AzGFzzVRcAZOtsD8Ry9konhccEJ/gDv1xZJhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 181/255] perf: Fix event multiplexing for exclusive groups
Date:   Tue, 17 Nov 2020 14:05:21 +0100
Message-Id: <20201117122147.736654851@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2714c3962f304d031d5016c963c4b459337b0749 ]

Commit 9e6302056f80 ("perf: Use hrtimers for event multiplexing")
placed the hrtimer (re)start call in the wrong place.  Instead of
capturing all scheduling failures, it only considered the PMU failure.

The result is that groups using perf_event_attr::exclusive are no
longer rotated.

Fixes: 9e6302056f80 ("perf: Use hrtimers for event multiplexing")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201029162902.038667689@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c245ccd426b71..a06ac60d346f1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2597,7 +2597,6 @@ group_error:
 
 error:
 	pmu->cancel_txn(pmu);
-	perf_mux_hrtimer_restart(cpuctx);
 	return -EAGAIN;
 }
 
@@ -3653,6 +3652,7 @@ static int merge_sched_in(struct perf_event *event, void *data)
 
 		*can_add_hw = 0;
 		ctx->rotate_necessary = 1;
+		perf_mux_hrtimer_restart(cpuctx);
 	}
 
 	return 0;
-- 
2.27.0



