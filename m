Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847F19E063
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732221AbfH0IDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732213AbfH0IDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD4F42184D;
        Tue, 27 Aug 2019 08:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892989;
        bh=dyjZHILtQTS0ehIpD3DGAVTw3m4jcFLb84TCYisqpdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/0YEeKHhkRpEGf8uUgPi/6pveJX8HgurArPZLJjdPzYtWh7Rcn5kRsE7IkRw6/xW
         gJGYZlnNda5/TVBNiMWnIQnQGRSrgdcsgpK53aB1+lFCXJEvNI1fJzsqs0DSrRgubJ
         X6oSJNITDegYs1crLBdTroKRqckkJkvfbZMo9QrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Kralevich <nnk@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        lizefan@huawei.com, mingo@redhat.com, akpm@linux-foundation.org,
        kernel-team@android.com, dennisszhou@gmail.com, dennis@kernel.org,
        hannes@cmpxchg.org, axboe@kernel.dk,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 084/162] sched/psi: Do not require setsched permission from the trigger creator
Date:   Tue, 27 Aug 2019 09:50:12 +0200
Message-Id: <20190827072741.055271779@linuxfoundation.org>
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



