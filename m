Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488B4331D34
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 04:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCIC71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 21:59:27 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13871 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCIC7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 21:59:17 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DvfyJ5nCkz8vQj;
        Tue,  9 Mar 2021 10:57:28 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 10:59:06 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <lee.jones@linaro.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <tglx@linutronix.de>, <cj.chengjian@huawei.com>,
        <judy.chenhui@huawei.com>, <zhangjinhao2@huawei.com>,
        <nixiaoming@huawei.com>
Subject: [PATCH 4.4 3/3] futex: fix dead code in attach_to_pi_owner()
Date:   Tue, 9 Mar 2021 11:06:05 +0800
Message-ID: <20210309030605.3295183-4-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309030605.3295183-1-zhengyejian1@huawei.com>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The handle_exit_race() function is defined in commit 9c3f39860367
 ("futex: Cure exit race"), which never returns -EBUSY. This results
in a small piece of dead code in the attach_to_pi_owner() function:

	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
	...
	if (ret == -EBUSY)
		*exiting = p; /* dead code */

The return value -EBUSY is added to handle_exit_race() in upsteam
commit ac31c7ff8624409 ("futex: Provide distinct return value when
owner is exiting"). This commit was incorporated into v4.9.255, before
the function handle_exit_race() was introduced, whitout Modify
handle_exit_race().

To fix dead code, extract the change of handle_exit_race() from
commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
 is exiting"), re-incorporated.

Lee writes:

This commit takes the remaining functional snippet of:

 ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")

... and is the correct fix for this issue.

Fixes: 9c3f39860367 ("futex: Cure exit race")
Cc: stable@vger.kernel.org # v4.9.258
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Reviewed-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 kernel/futex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 116766ef7de6..98c65b3c3a00 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1202,11 +1202,11 @@ static int handle_exit_race(u32 __user *uaddr, u32 uval,
 	u32 uval2;
 
 	/*
-	 * If the futex exit state is not yet FUTEX_STATE_DEAD, wait
-	 * for it to finish.
+	 * If the futex exit state is not yet FUTEX_STATE_DEAD, tell the
+	 * caller that the alleged owner is busy.
 	 */
 	if (tsk && tsk->futex_state != FUTEX_STATE_DEAD)
-		return -EAGAIN;
+		return -EBUSY;
 
 	/*
 	 * Reread the user space value to handle the following situation:
-- 
2.25.4

