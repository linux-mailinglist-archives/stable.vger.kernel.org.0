Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E60F3217B8
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhBVMzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:55:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12636 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbhBVMyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 07:54:46 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dkhsn199xz16BC4;
        Mon, 22 Feb 2021 20:52:29 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 20:53:57 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>, <lee.jones@linaro.org>
CC:     <nixiaoming@huawei.com>, <wangle6@huawei.com>,
        <zhengyejian1@huawei.com>
Subject: [PATCH] futex: fix dead code in attach_to_pi_owner()
Date:   Mon, 22 Feb 2021 20:53:52 +0800
Message-ID: <20210222125352.110124-1-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The handle_exit_race() function is defined in commit c158b461306df82
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

Fixes: c158b461306df82 ("futex: Cure exit race")
Cc: stable@vger.kernel.org # 4.9.258-rc1
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
---
 kernel/futex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b65dbb5d60bb..0fd785410150 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1207,11 +1207,11 @@ static int handle_exit_race(u32 __user *uaddr, u32 uval,
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
2.27.0

