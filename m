Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8079E061
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbfH0IDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731696AbfH0IDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2D40206BA;
        Tue, 27 Aug 2019 08:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892986;
        bh=MhsFc+QRsWTNNcT+24bWzeeQwJHKtt8UKjhaEbwPOEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCfdAL81DhghY1pNDndVOgeWfrq4C41v5mTQQXNCLG7LSxZUiXqxZ65cSn6zhkYXI
         sg6gZovsXfsX79gqIEqS5JFNqrQFgjvWwqJ/8c5ig09a+7ZLsKWZ8sZNSAvoqbeDBd
         2qBfs9FtgW7uJnOVVt0IpFnVE/tRWJtOwgo/191s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 083/162] sched/psi: Reduce psimon FIFO priority
Date:   Tue, 27 Aug 2019 09:50:11 +0200
Message-Id: <20190827072741.016547724@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 14f5c7b46a41a595fc61db37f55721714729e59e ]

PSI defaults to a FIFO-99 thread, reduce this to FIFO-1.

FIFO-99 is the very highest priority available to SCHED_FIFO and
it not a suitable default; it would indicate the psi work is the
most important work on the machine.

Since Real-Time tasks will have pre-allocated memory and locked it in
place, Real-Time tasks do not care about PSI. All it needs is to be
above OTHER.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 7acc632c3b82b..7fe2c5fd26b54 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1051,7 +1051,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 
 	if (!rcu_access_pointer(group->poll_kworker)) {
 		struct sched_param param = {
-			.sched_priority = MAX_RT_PRIO - 1,
+			.sched_priority = 1,
 		};
 		struct kthread_worker *kworker;
 
-- 
2.20.1



