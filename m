Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDDE33B52B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCONxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229874AbhCONxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 441EF64EF9;
        Mon, 15 Mar 2021 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816383;
        bh=qaz12JiLe/Ys9E2n86Og5/hr3vi/49HOTrA/XwLcJrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNVJxop/0yHYGh4afbsb0XfeqjsNQ/PMML1WireISbB6nHRjjpC4ZLusN+8ljhxx4
         CxtbniT9A4r+ZCuhTrUApiK5XVT8yF1YUxOWwDiGpD/rmnDxkdcGxlxXnu09x/tHCp
         K92/bnRw+6VqUlaaiHRj6P+UWzhimR5GR41ubMbc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Lee Jones <lee.jones@linaro.org>,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 4.4 13/75] futex: fix dead code in attach_to_pi_owner()
Date:   Mon, 15 Mar 2021 14:51:27 +0100
Message-Id: <20210315135208.696700074@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

This patch comes directly from an origin patch (commit
91509e84949fc97e7424521c32a9e227746e0b85) in v4.9.
And it is part of a full patch which was originally back-ported
to v4.14 as commit e6e00df182908f34360c3c9f2d13cc719362e9c0

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1204,11 +1204,11 @@ static int handle_exit_race(u32 __user *
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


