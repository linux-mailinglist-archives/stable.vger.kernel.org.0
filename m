Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC21C3C4F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733261AbfJAQn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733241AbfJAQn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B43F2205C9;
        Tue,  1 Oct 2019 16:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948238;
        bh=BMf+rEzR1w5ipbPXpmKEKTOY4qdBzIQWERfWjHJQs6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bxp+uGXwgS7O4E+AAxXyOVccn/mB2ZsV6rIyC8N3pGT+G5v2GZg8mq5Pn6RLXmNM9
         cEiS2CTWHZI2NKX+gL180zPO4gvJpXgZhMMD3k/KaZy87cNzmhPX2PM7ZtZrBqD+Pm
         KnSeYwrUNyPBwbnKyp0IWFz81nnoOBjgeWqzpGq8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@ezchip.com>,
        Christoph Lameter <cl@linux.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kirill Tkhai <tkhai@yandex.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 31/43] sched/membarrier: Call sync_core only before usermode for same mm
Date:   Tue,  1 Oct 2019 12:42:59 -0400
Message-Id: <20191001164311.15993-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 2840cf02fae627860156737e83326df354ee4ec6 ]

When the prev and next task's mm change, switch_mm() provides the core
serializing guarantees before returning to usermode. The only case
where an explicit core serialization is needed is when the scheduler
keeps the same mm for prev and next.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190919173705.2181-4-mathieu.desnoyers@efficios.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/mm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 0d10b7ce0da74..e9d4e389aed93 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -330,6 +330,8 @@ enum {
 
 static inline void membarrier_mm_sync_core_before_usermode(struct mm_struct *mm)
 {
+	if (current->mm != mm)
+		return;
 	if (likely(!(atomic_read(&mm->membarrier_state) &
 		     MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE)))
 		return;
-- 
2.20.1

