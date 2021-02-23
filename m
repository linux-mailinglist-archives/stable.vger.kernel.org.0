Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD47322C78
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhBWOgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:36:00 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12946 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbhBWOfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:35:54 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DlM3m0rbZzjQf7;
        Tue, 23 Feb 2021 22:33:24 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Feb 2021 22:34:32 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <tglx@linutronix.de>, <cj.chengjian@huawei.com>,
        <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>
Subject: [PATCH 4.9.y 0/1] Bugfix for 781691c797de ("futex: Avoid violating the 10th rule of futex")
Date:   Tue, 23 Feb 2021 22:41:50 +0800
Message-ID: <20210223144151.916675-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch may fix the following bug:

Link:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/?h=linux-4.9.y&id=5b1d078507bd33ebf6c2083fa363cf5832809c19

    > static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
    > 				  struct task_struct *argowner)
    > {
    > 	struct futex_pi_state *pi_state = q->pi_state;
    > 	struct task_struct *oldowner, *newowner;
    > 	u32 uval, curval, newval, newtid;
    > 	int err = 0;
    > 
    > 	oldowner = pi_state->owner;
    > 
    > 	/* Owner died? */
    > 	if (!pi_state->owner)
    > 		newtid |= FUTEX_OWNER_DIED;
Variable "newtid" is used without initialized.

Peter Zijlstra (1):
  futex: Fix OWNER_DEAD fixup

 kernel/futex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.25.4

