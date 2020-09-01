Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C39A259943
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgIAQhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbgIAP3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CC952078B;
        Tue,  1 Sep 2020 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974162;
        bh=R0XxSbfrLVwICHrnsH7Xar5Vs4cETwab++Aw5zZAgJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pi9QFiI3k73Q8kcAIw3SGQs6c+igEu/AaPnbYg8GsfAh6VzxqB1ZE6zlSTUzOoPZ7
         Mpx1MvrJmlo+XZoYHY611Nd47WUodtH0mwreGA4e0DX4CBdZ/pfCvgcgJIPBEN/rui
         /9tXKBPp1mlKDJ4uyNAB9ZNb7UBG6XGORaR7j+sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/214] sched/uclamp: Fix a deadlock when enabling uclamp static key
Date:   Tue,  1 Sep 2020 17:09:09 +0200
Message-Id: <20200901150956.280896723@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit e65855a52b479f98674998cb23b21ef5a8144b04 ]

The following splat was caught when setting uclamp value of a task:

  BUG: sleeping function called from invalid context at ./include/linux/percpu-rwsem.h:49

   cpus_read_lock+0x68/0x130
   static_key_enable+0x1c/0x38
   __sched_setscheduler+0x900/0xad8

Fix by ensuring we enable the key outside of the critical section in
__sched_setscheduler()

Fixes: 46609ce22703 ("sched/uclamp: Protect uclamp fast path code with static key")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200716110347.19553-4-qais.yousef@arm.com
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a8ab68aa189a9..352239c411a44 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1249,6 +1249,15 @@ static int uclamp_validate(struct task_struct *p,
 	if (upper_bound > SCHED_CAPACITY_SCALE)
 		return -EINVAL;
 
+	/*
+	 * We have valid uclamp attributes; make sure uclamp is enabled.
+	 *
+	 * We need to do that here, because enabling static branches is a
+	 * blocking operation which obviously cannot be done while holding
+	 * scheduler locks.
+	 */
+	static_branch_enable(&sched_uclamp_used);
+
 	return 0;
 }
 
@@ -1279,8 +1288,6 @@ static void __setscheduler_uclamp(struct task_struct *p,
 	if (likely(!(attr->sched_flags & SCHED_FLAG_UTIL_CLAMP)))
 		return;
 
-	static_branch_enable(&sched_uclamp_used);
-
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
 		uclamp_se_set(&p->uclamp_req[UCLAMP_MIN],
 			      attr->sched_util_min, true);
-- 
2.25.1



