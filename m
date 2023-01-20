Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F37675738
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 15:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjATOcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 09:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjATOcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 09:32:12 -0500
X-Greylist: delayed 2131 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Jan 2023 06:32:11 PST
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A23393D3;
        Fri, 20 Jan 2023 06:32:11 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4Nz16x3JJMz9v7VH;
        Fri, 20 Jan 2023 21:48:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.206.134.113])
        by APP2 (Coremail) with SMTP id GxC2BwDnu2J0ncpj_ryvAA--.23516S2;
        Fri, 20 Jan 2023 14:56:15 +0100 (CET)
From:   Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        longman@redhat.com, boqun.feng@gmail.com, akpm@osdl.org,
        arjan@linux.intel.com, tglx@linutronix.de, joel@joelfernandes.org,
        paulmck@kernel.org, stern@rowland.harvard.edu,
        diogo.behrens@huawei.com, jonas.oberhauser@huawei.com
Cc:     linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH] Fix data race in mark_rt_mutex_waiters
Date:   Fri, 20 Jan 2023 14:55:25 +0100
Message-Id: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwDnu2J0ncpj_ryvAA--.23516S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ArW5Gr4kJrWDuw4rtF1rXrb_yoW8JFW3pF
        W5C3yUG3yqgr1vgrWDW3Z29ayUJ395CrWxW3Z7JryxWr15t3ZFgr9rC3WUWr1FvFWkKFWa
        vF1Yqr10qrW3Za7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r106r1rM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42
        IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: xkhu0tnqos00pfhgvzhhrqqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hernan Ponce de Leon <hernanl.leon@huawei.com>

Following the defition of data race in
tools/memory-model/linux-kernel.cat the dartagnan tool
https://github.com/hernanponcedeleon/Dat3M
reported a race between mark_rt_mutex_waiters and rt_mutex_cmpxchg_release.

Commit 23f78d4a03c5 ("[PATCH] pi-futex: rt mutex core")
later removed in commit d0aa7a70bf03 ("futex_requeue_pi optimization")
and reverted in commit bd197234b0a6
("Revert "futex_requeue_pi optimization"")

The original commit introduced the data race.

Cc: stable@vger.kernel.org # v2.6.18.x
Fixes: 23f78d4a03c5 ("[PATCH] pi-futex: rt mutex core")
Signed-off-by: Hernan Ponce de Leon <hernanl.leon@huawei.com>
---
 kernel/locking/rtmutex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 010cf4e6d0b8..7ed9472edd48 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -235,7 +235,7 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
 	unsigned long owner, *p = (unsigned long *) &lock->owner;
 
 	do {
-		owner = *p;
+		owner = READ_ONCE(*p);
 	} while (cmpxchg_relaxed(p, owner,
 				 owner | RT_MUTEX_HAS_WAITERS) != owner);
 
-- 
2.25.1

