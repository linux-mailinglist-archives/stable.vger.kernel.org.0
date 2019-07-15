Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50672691C3
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403978AbfGOObn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403972AbfGOObl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:31:41 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64DC3212F5;
        Mon, 15 Jul 2019 14:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201100;
        bh=uwjIFx1FXlgJdZnkKZLG/LjhUIbAhZtoQxnoIbRpA58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wtWWLN2PUxxew+xJ/2KaAFrbFZQSogI9hZG0X1GvdpPmSk4JGrgF1GnL1CXutoRQj
         1+qbwFJbVvRmDhykkQK7JK+z67bH6TzRFZypKUJd4N2/w+C1WCQGYGzkGc9NnVNwVY
         FEsOxTTIDq20P/fbErDMg7rGdozYsVeM+YzJwSIE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gao Xiang <gaoxiang25@huawei.com>,
        Jilong Kou <koujilong@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miao Xie <miaoxie@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 052/105] sched/core: Add __sched tag for io_schedule()
Date:   Mon, 15 Jul 2019 10:27:46 -0400
Message-Id: <20190715142839.9896-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

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
index b3ff73d6a4c2..ff128e281d1c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5026,7 +5026,7 @@ long __sched io_schedule_timeout(long timeout)
 }
 EXPORT_SYMBOL(io_schedule_timeout);
 
-void io_schedule(void)
+void __sched io_schedule(void)
 {
 	int token;
 
-- 
2.20.1

