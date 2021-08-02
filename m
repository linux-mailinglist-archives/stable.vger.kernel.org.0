Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2853DD7CF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhHBNsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7917 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbhHBNrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 09:47:35 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GdfNB5NzHz83CY;
        Mon,  2 Aug 2021 21:43:22 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:11 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 21:47:11 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4.4 00/11] Fix a potential infinite loop in RT futex-pi scenarios
Date:   Mon, 2 Aug 2021 21:46:13 +0800
Message-ID: <20210802134624.1934-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 73d786bd043e "futex: Rework inconsistent rt_mutex/futex_q state"
mentions that it could cause an infinite loop, and will fix it in the later
patches:
bebe5b514345f09 futex: Futex_unlock_pi() determinism
cfafcd117da0216 futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()

But at the moment they're not backported. In a single-core environment, the
probability of triggering is high.

I also backported commit b4abf91047cf ("rtmutex: Make wait_lock irq safe"),
it fixes a potential deadlock problem. Although it hasn't actually been
triggered in our environment at the moment.

Other patches are used to resolve conflicts or fix problems caused by new
patches.


Anna-Maria Gleixner (1):
  rcu: Update documentation of rcu_read_unlock()

Mike Galbraith (1):
  futex: Handle transient "ownerless" rtmutex state correctly

Peter Zijlstra (6):
  futex: Cleanup refcounting
  futex,rt_mutex: Introduce rt_mutex_init_waiter()
  futex: Pull rt_mutex_futex_unlock() out from under hb->lock
  futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
  futex: Futex_unlock_pi() determinism
  futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()

Thomas Gleixner (3):
  futex: Rename free_pi_state() to put_pi_state()
  rtmutex: Make wait_lock irq safe
  futex: Avoid freeing an active timer

 include/linux/rcupdate.h        |   4 +-
 kernel/futex.c                  | 245 +++++++++++++++++++++-----------
 kernel/locking/rtmutex.c        | 185 +++++++++++++-----------
 kernel/locking/rtmutex_common.h |   2 +-
 4 files changed, 262 insertions(+), 174 deletions(-)

-- 
2.26.0.106.g9fadedd

