Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1AA32111B
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 08:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhBVHE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 02:04:27 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12630 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBVHE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 02:04:26 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DkY5T4tmhz16BKd;
        Mon, 22 Feb 2021 15:02:05 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Feb 2021 15:03:31 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>
CC:     <nixiaoming@huawei.com>, <wangle6@huawei.com>,
        <zhengyejian1@huawei.com>
Subject: [PATCH stable-rc queue/4.9 0/1] repatch 
Date:   Mon, 22 Feb 2021 15:03:27 +0800
Message-ID: <20210222070328.102384-1-nixiaoming@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I found a dead code in the queue/4.9 branch of the stable-rc repository.

2021-02-03:
commit c27f392040e2f6 ("futex: Provide distinct return value when
 owner is exiting")
	The function handle_exit_race does not exist. Therefore, the
	change in handle_exit_race() is ignored in the patch round.

2021-02-22:
commit e55cb811e612 ("futex: Cure exit race")
	Define the handle_exit_race() function,
	but no branch in the function returns EBUSY.
	As a result, dead code occurs in the attach_to_pi_owner():

		int ret = handle_exit_race(uaddr, uval, p);
		...
		if (ret == -EBUSY)
			*exiting = p; /* dead code */

To fix the dead code, modify the commit e55cb811e612 ("futex: Cure exit race"), 
or install a patch to incorporate the changes in handle_exit_race().

I am unfamiliar with the processing of the stable-rc queue branch,
and I cannot find the patch mail of the current branch in
	https://lore.kernel.org/lkml/?q=%22futex%3A+Cure+exit+race%22
Therefore, I re-integrated commit ac31c7ff8624 ("futex: Provide distinct
 return value when owner is exiting").

-----

Thomas Gleixner (1):
  futex: Provide distinct return value when owner is exiting

 kernel/futex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.27.0

