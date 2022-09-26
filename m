Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9931C5EA286
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiIZLJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237562AbiIZLIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:08:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B1213E3B;
        Mon, 26 Sep 2022 03:34:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C62B3B8055F;
        Mon, 26 Sep 2022 10:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FB3C43470;
        Mon, 26 Sep 2022 10:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188385;
        bh=pzMMc/rrr8/BIG2UvjVlrU5b7Zno70ul6tQWG10YCW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CoBKZJxlYd+dqM9IfCeo2iW/ul6SUWn26BKGkyCnnzYEaRpk21qrRmCF/AWUzP90A
         mdFKAAj8loE4Pq8+sgAGElxSiBZp3KLC3atecwqFRVJn2gE6uQnNhcRE5ahQQBmwN9
         4NflYhpWEuNZgBeR3jgOKZ8AB3ON2B+7lOoi5W7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/141] workqueue: dont skip lockdep work dependency in cancel_work_sync()
Date:   Mon, 26 Sep 2022 12:12:39 +0200
Message-Id: <20220926100759.271132854@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit c0feea594e058223973db94c1c32a830c9807c86 ]

Like Hillf Danton mentioned

  syzbot should have been able to catch cancel_work_sync() in work context
  by checking lockdep_map in __flush_work() for both flush and cancel.

in [1], being unable to report an obvious deadlock scenario shown below is
broken. From locking dependency perspective, sync version of cancel request
should behave as if flush request, for it waits for completion of work if
that work has already started execution.

  ----------
  #include <linux/module.h>
  #include <linux/sched.h>
  static DEFINE_MUTEX(mutex);
  static void work_fn(struct work_struct *work)
  {
    schedule_timeout_uninterruptible(HZ / 5);
    mutex_lock(&mutex);
    mutex_unlock(&mutex);
  }
  static DECLARE_WORK(work, work_fn);
  static int __init test_init(void)
  {
    schedule_work(&work);
    schedule_timeout_uninterruptible(HZ / 10);
    mutex_lock(&mutex);
    cancel_work_sync(&work);
    mutex_unlock(&mutex);
    return -EINVAL;
  }
  module_init(test_init);
  MODULE_LICENSE("GPL");
  ----------

The check this patch restores was added by commit 0976dfc1d0cd80a4
("workqueue: Catch more locking problems with flush_work()").

Then, lockdep's crossrelease feature was added by commit b09be676e0ff25bd
("locking/lockdep: Implement the 'crossrelease' feature"). As a result,
this check was once removed by commit fd1a5b04dfb899f8 ("workqueue: Remove
now redundant lock acquisitions wrt. workqueue flushes").

But lockdep's crossrelease feature was removed by commit e966eaeeb623f099
("locking/lockdep: Remove the cross-release locking checks"). At this
point, this check should have been restored.

Then, commit d6e89786bed977f3 ("workqueue: skip lockdep wq dependency in
cancel_work_sync()") introduced a boolean flag in order to distinguish
flush_work() and cancel_work_sync(), for checking "struct workqueue_struct"
dependency when called from cancel_work_sync() was causing false positives.

Then, commit 87915adc3f0acdf0 ("workqueue: re-add lockdep dependencies for
flushing") tried to restore "struct work_struct" dependency check, but by
error checked this boolean flag. Like an example shown above indicates,
"struct work_struct" dependency needs to be checked for both flush_work()
and cancel_work_sync().

Link: https://lkml.kernel.org/r/20220504044800.4966-1-hdanton@sina.com [1]
Reported-by: Hillf Danton <hdanton@sina.com>
Suggested-by: Lai Jiangshan <jiangshanlai@gmail.com>
Fixes: 87915adc3f0acdf0 ("workqueue: re-add lockdep dependencies for flushing")
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fdf5fa4bf444..0cc2a62e88f9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3047,10 +3047,8 @@ static bool __flush_work(struct work_struct *work, bool from_cancel)
 	if (WARN_ON(!work->func))
 		return false;
 
-	if (!from_cancel) {
-		lock_map_acquire(&work->lockdep_map);
-		lock_map_release(&work->lockdep_map);
-	}
+	lock_map_acquire(&work->lockdep_map);
+	lock_map_release(&work->lockdep_map);
 
 	if (start_flush_work(work, &barr, from_cancel)) {
 		wait_for_completion(&barr.done);
-- 
2.35.1



