Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6A91C1644
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgEANnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729460AbgEANnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1DE5205C9;
        Fri,  1 May 2020 13:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340583;
        bh=T8vE2KCs+XlTESLXlZtTjlKssSt3/I7jjgiBCUKln74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eev9ZTwVMha0tk+HFz7qRKVEyPMVG9/JQ9VrGWeLz5Rdgu3s2xIF60NWCs/yepoVP
         1HRDJTDnXvlhfNWigs31QF228RocyKcH/JhDUz2H5oxFDGA4ypmZNMhR5Kg4nwETE7
         4tCeKwckQlPqdVUcovZC0bqIPkwXuiHsMbILFH7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chitti Babu Theegala <ctheegal@codeaurora.org>,
        Quentin Perret <qperret@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Patrick Bellasi <patrick.bellasi@matbug.net>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: [PATCH 5.6 053/106] sched/core: Fix reset-on-fork from RT with uclamp
Date:   Fri,  1 May 2020 15:23:26 +0200
Message-Id: <20200501131550.015692678@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

commit eaf5a92ebde5bca3bb2565616115bd6d579486cd upstream.

uclamp_fork() resets the uclamp values to their default when the
reset-on-fork flag is set. It also checks whether the task has a RT
policy, and sets its uclamp.min to 1024 accordingly. However, during
reset-on-fork, the task's policy is lowered to SCHED_NORMAL right after,
hence leading to an erroneous uclamp.min setting for the new task if it
was forked from RT.

Fix this by removing the unnecessary check on rt_task() in
uclamp_fork() as this doesn't make sense if the reset-on-fork flag is
set.

Fixes: 1a00d999971c ("sched/uclamp: Set default clamps for RT tasks")
Reported-by: Chitti Babu Theegala <ctheegal@codeaurora.org>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Patrick Bellasi <patrick.bellasi@matbug.net>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/20200416085956.217587-1-qperret@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1239,13 +1239,8 @@ static void uclamp_fork(struct task_stru
 		return;
 
 	for_each_clamp_id(clamp_id) {
-		unsigned int clamp_value = uclamp_none(clamp_id);
-
-		/* By default, RT tasks always get 100% boost */
-		if (unlikely(rt_task(p) && clamp_id == UCLAMP_MIN))
-			clamp_value = uclamp_none(UCLAMP_MAX);
-
-		uclamp_se_set(&p->uclamp_req[clamp_id], clamp_value, false);
+		uclamp_se_set(&p->uclamp_req[clamp_id],
+			      uclamp_none(clamp_id), false);
 	}
 }
 


