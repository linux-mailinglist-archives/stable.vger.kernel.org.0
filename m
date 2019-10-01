Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021A1C3D8F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbfJAQkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbfJAQkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2CCB21906;
        Tue,  1 Oct 2019 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948031;
        bh=rmFIcT6ApW+UImpgfJcNSApiJXk5nsSOmBRfCxYD6bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTNeQzVBBatwciIIfhVtmpOzgU4BI9AYtuD1JcgjPjVwrTWp0A1XfKi+/qVVz8Y/S
         dEGNXi6B1QcEuY9rWRIKEWgdcy6e8tUZVveCruX2H1+41lBPQeTzolZsSnz/rhegDU
         v8q9lTj+zmcHdUoTPs4QUPlFaKcpJx3QiUv55FEE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@ezchip.com>,
        Christoph Lameter <cl@linux.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kirill Tkhai <tkhai@yandex.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 46/71] sched/membarrier: Fix private expedited registration check
Date:   Tue,  1 Oct 2019 12:38:56 -0400
Message-Id: <20191001163922.14735-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit fc0d77387cb5ae883fd774fc559e056a8dde024c ]

Fix a logic flaw in the way membarrier_register_private_expedited()
handles ready state checks for private expedited sync core and private
expedited registrations.

If a private expedited membarrier registration is first performed, and
then a private expedited sync_core registration is performed, the ready
state check will skip the second registration when it really should not.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190919173705.2181-2-mathieu.desnoyers@efficios.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/membarrier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index aa8d758041088..5110d91b1b0ea 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -226,7 +226,7 @@ static int membarrier_register_private_expedited(int flags)
 	 * groups, which use the same mm. (CLONE_VM but not
 	 * CLONE_THREAD).
 	 */
-	if (atomic_read(&mm->membarrier_state) & state)
+	if ((atomic_read(&mm->membarrier_state) & state) == state)
 		return 0;
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED, &mm->membarrier_state);
 	if (flags & MEMBARRIER_FLAG_SYNC_CORE)
-- 
2.20.1

