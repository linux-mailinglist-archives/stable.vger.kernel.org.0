Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6D22C0A37
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732606AbgKWMmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732607AbgKWMlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45B3E20732;
        Mon, 23 Nov 2020 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135265;
        bh=0hvS3SBApzgsAyvRK+olxZamNr3ivgLb6WJc8oClCv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpBTK4eMF3YGlOtIpVVJenQZWRrMTfAoIxsFvsdyeMfFdjhABamlikU8DzGx/ELC+
         RaI+VRe2dKC2pC4OhCRfHX9t72RHAUIOemD2J3TC2p1GXVGJTJQSFDRmi1AoKDjGNQ
         +3oB++BV+l91vBiW3ZiafY5R587Jlu4Z8MfKUp60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Yiu <rickyiu@google.com>,
        Quentin Perret <qperret@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH 5.4 158/158] sched/fair: Fix overutilized update in enqueue_task_fair()
Date:   Mon, 23 Nov 2020 13:23:06 +0100
Message-Id: <20201123121827.556725409@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

commit 8e1ac4299a6e8726de42310d9c1379f188140c71 upstream.

enqueue_task_fair() attempts to skip the overutilized update for new
tasks as their util_avg is not accurate yet. However, the flag we check
to do so is overwritten earlier on in the function, which makes the
condition pretty much a nop.

Fix this by saving the flag early on.

Fixes: 2802bf3cd936 ("sched/fair: Add over-utilization/tipping point indicator")
Reported-by: Rick Yiu <rickyiu@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20201112111201.2081902-1-qperret@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5228,6 +5228,7 @@ enqueue_task_fair(struct rq *rq, struct
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 	int idle_h_nr_running = task_has_idle_policy(p);
+	int task_new = !(flags & ENQUEUE_WAKEUP);
 
 	/*
 	 * The code below (indirectly) updates schedutil which looks at
@@ -5299,7 +5300,7 @@ enqueue_throttle:
 		 * into account, but that is not straightforward to implement,
 		 * and the following generally works well enough in practice.
 		 */
-		if (flags & ENQUEUE_WAKEUP)
+		if (!task_new)
 			update_overutilized_status(rq);
 
 	}


