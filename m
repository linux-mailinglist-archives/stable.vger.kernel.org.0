Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE2B73BE6
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392557AbfGXUEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388474AbfGXUEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:04:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2744206BA;
        Wed, 24 Jul 2019 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998679;
        bh=gpfuLwKhDUkEH91KgfTVRSPBq/E06F3TEoS/Veb1RGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aEJ+JIUKQxyYj9w0rICA2h67b8tKTMHv+xswUmhsjrO98CfiJSYrQia9rA09tM81
         mrwgJn/NQMIlFZ6KlBVy+VRx792d2Zhhz6MaPEX45dAT4EtcMMsgfsmYLnAwJN2+1B
         YZfXwe7w/SLl/0G52toTZAohqsplTPVexgn/lj4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jilong Kou <koujilong@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miao Xie <miaoxie@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/271] sched/core: Add __sched tag for io_schedule()
Date:   Wed, 24 Jul 2019 21:19:05 +0200
Message-Id: <20190724191701.705278119@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e3b929b0a184edb35531153c5afcaebb09014f9d ]

Non-inline io_schedule() was introduced in:

  commit 10ab56434f2f ("sched/core: Separate out io_schedule_prepare() and io_schedule_finish()")

Keep in line with io_schedule_timeout(), otherwise "/proc/<pid>/wchan" will
report io_schedule() rather than its callers when waiting for IO.

Reported-by: Jilong Kou <koujilong@huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 10ab56434f2f ("sched/core: Separate out io_schedule_prepare() and io_schedule_finish()")
Link: https://lkml.kernel.org/r/20190603091338.2695-1-gaoxiang25@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6859ea1d5c04..795c63ca44a9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5133,7 +5133,7 @@ long __sched io_schedule_timeout(long timeout)
 }
 EXPORT_SYMBOL(io_schedule_timeout);
 
-void io_schedule(void)
+void __sched io_schedule(void)
 {
 	int token;
 
-- 
2.20.1



