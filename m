Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7397532149D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBVK7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 05:59:12 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12935 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhBVK7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 05:59:10 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DkfJl5797zjPvL;
        Mon, 22 Feb 2021 18:57:11 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 18:58:22 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>,
        <lee.jones@linaro.org>, <tglx@linutronix.de>
Subject: [PATCH 4.9.257 0/1] Bugfix for 781691c797de ("futex: Avoid violating the 10th rule of futex")
Date:   Mon, 22 Feb 2021 19:05:41 +0800
Message-ID: <20210222110542.3531596-1-zhengyejian1@huawei.com>
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
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/kernel/futex.c?h=linux-4.9.y&id=282aeb477a10d09cc5c4d73c54bb996964723f96

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

 kernel/futex.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
2.25.4

