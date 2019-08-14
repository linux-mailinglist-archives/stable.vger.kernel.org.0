Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908598C8CE
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfHNCeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbfHNCN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93EA20874;
        Wed, 14 Aug 2019 02:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748838;
        bh=JNv2gFzP+RnTEDS7OuB7IGueNTnDrUTOFAb4QKt/GIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1EedLFRpazo+1Th8xl98nhpiMKE2c8LOQSdgFoiRIWWvvISDiQnq1GhpAyWhGAYbd
         H0wwSTyOSBua6O+kGdBUlKMs6AaayjxYIhocChFpeC6GZ/rpGe9ixUmiudUOr+kOi1
         nRRG/F5TOiOz7/nAqgLMCqTeeo8ac0pwfxt1i4aQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Nick Kralevich <nnk@google.com>,
        Peter Zijlstra <peterz@infradead.org>, lizefan@huawei.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        kernel-team@android.com, dennisszhou@gmail.com, dennis@kernel.org,
        hannes@cmpxchg.org, axboe@kernel.dk,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 096/123] sched/psi: Do not require setsched permission from the trigger creator
Date:   Tue, 13 Aug 2019 22:10:20 -0400
Message-Id: <20190814021047.14828-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit 04e048cf09d7b5fc995817cdc5ae1acd4482429c ]

When a process creates a new trigger by writing into /proc/pressure/*
files, permissions to write such a file should be used to determine whether
the process is allowed to do so or not. Current implementation would also
require such a process to have setsched capability. Setting of psi trigger
thread's scheduling policy is an implementation detail and should not be
exposed to the user level. Remove the permission check by using _nocheck
version of the function.

Suggested-by: Nick Kralevich <nnk@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: lizefan@huawei.com
Cc: mingo@redhat.com
Cc: akpm@linux-foundation.org
Cc: kernel-team@android.com
Cc: dennisszhou@gmail.com
Cc: dennis@kernel.org
Cc: hannes@cmpxchg.org
Cc: axboe@kernel.dk
Link: https://lkml.kernel.org/r/20190730013310.162367-1-surenb@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 7fe2c5fd26b54..23fbbcc414d5d 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1061,7 +1061,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			mutex_unlock(&group->trigger_lock);
 			return ERR_CAST(kworker);
 		}
-		sched_setscheduler(kworker->task, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(kworker->task, SCHED_FIFO, &param);
 		kthread_init_delayed_work(&group->poll_work,
 				psi_poll_work);
 		rcu_assign_pointer(group->poll_kworker, kworker);
-- 
2.20.1

