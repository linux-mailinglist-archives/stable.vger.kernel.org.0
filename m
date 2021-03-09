Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6190331D35
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 04:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCIC70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 21:59:26 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13873 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhCIC7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 21:59:16 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DvfyJ6HPqz8vQn;
        Tue,  9 Mar 2021 10:57:28 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 10:59:04 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <tglx@linutronix.de>, <cj.chengjian@huawei.com>,
        <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH 4.4 0/3] Backport patch series to update Futex from 4.9
Date:   Tue, 9 Mar 2021 11:06:02 +0800
Message-ID: <20210309030605.3295183-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lee sent a patchset to update Futex for 4.9, see https://www.spinics.net/lists/stable/msg443081.html,
Then Xiaoming sent a follow-up patch for it, see https://lore.kernel.org/lkml/20210225093120.GD641347@dell/.

These patchsets may also resolve following issues in 4.4.260 which have been reported in 4.9,
see https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/?h=linux-4.4.y&id=319f66f08de1083c1fe271261665c209009dd65a
      > /*
      >  * The task is on the way out. When the futex state is
      >  * FUTEX_STATE_DEAD, we know that the task has finished
      >  * the cleanup:
      >  */
      > int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;

    Here may be:
      int ret = (p->futex_state == FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;

      > raw_spin_unlock_irq(&p->pi_lock);
      > /*
      >  * If the owner task is between FUTEX_STATE_EXITING and
      >  * FUTEX_STATE_DEAD then store the task pointer and keep
      >  * the reference on the task struct. The calling code will
      >  * drop all locks, wait for the task to reach
      >  * FUTEX_STATE_DEAD and then drop the refcount. This is
      >  * required to prevent a live lock when the current task
      >  * preempted the exiting task between the two states.
      >  */
      > if (ret == -EBUSY)

    And here, the variable "ret" may only be "-ESRCH" or "-EAGAIN", but not "-EBUSY".

      > 	*exiting = p;
      > else
      > 	put_task_struct(p);

Since 074e7d515783 ("futex: Ensure the correct return value from futex_lock_pi()") has
been merged in 4.4.260, I send the remain 3 patches.

Peter Zijlstra (1):
  futex: Change locking rules

Thomas Gleixner (2):
  futex: Cure exit race
  futex: fix dead code in attach_to_pi_owner()

 kernel/futex.c | 209 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 177 insertions(+), 32 deletions(-)

-- 
2.25.4

