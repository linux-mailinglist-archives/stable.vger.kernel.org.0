Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC24D23EE
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388935AbfJJIrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389467AbfJJIrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B235208C3;
        Thu, 10 Oct 2019 08:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697244;
        bh=BMf+rEzR1w5ipbPXpmKEKTOY4qdBzIQWERfWjHJQs6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9/8ps6wYNe9TXjTT+UM5BtzawXYJTD/Jc09vvspA1+Zz+YV2pHMhVehjKmJ1lnBx
         4Kcda6y5aUlKisB/Lcd29rl+aMe6Fh7XaHOTFpsj1B7wTYue3vOVbHApI8QZ1gE4z2
         Sz0T9vbufNYbQH+VA1ArsUTSUSvYszEvm+WUAwzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@ezchip.com>,
        Christoph Lameter <cl@linux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kirill Tkhai <tkhai@yandex.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/114] sched/membarrier: Call sync_core only before usermode for same mm
Date:   Thu, 10 Oct 2019 10:36:17 +0200
Message-Id: <20191010083611.479840071@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



