Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB42D2404
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389612AbfJJIsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389601AbfJJIsJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:48:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 164C0208C3;
        Thu, 10 Oct 2019 08:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697288;
        bh=dTmsqtgyR61mF8BwJ3Q1DjH7pm/mxnHGdYfe/UOyPlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ma92/3ubo/UX/ElYjqt7eIAPb6RnUAUxlJrR/QOU3s5pr2qEwPEj3usZiKczi934t
         GVQ63ObMuxpAjp2RdLtJ/XWvXThv9kbdr1doJaw2GRD/+Z65p0HwabzKg9qfBZdFdb
         QSukKqOmI/TYoQhUFAtHiK/X949k2rjp1wFsCWmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, loobinliu@tencent.com,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 4.19 043/114] Revert "locking/pvqspinlock: Dont wait if vCPU is preempted"
Date:   Thu, 10 Oct 2019 10:35:50 +0200
Message-Id: <20191010083606.862006127@linuxfoundation.org>
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

From: Wanpeng Li <wanpengli@tencent.com>

commit 89340d0935c9296c7b8222b6eab30e67cb57ab82 upstream.

This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't
wait if vCPU is preempted).  A large performance regression was caused
by this commit.  on over-subscription scenarios.

The test was run on a Xeon Skylake box, 2 sockets, 40 cores, 80 threads,
with three VMs of 80 vCPUs each.  The score of ebizzy -M is reduced from
13000-14000 records/s to 1700-1800 records/s:

          Host                Guest                score

vanilla w/o kvm optimizations     upstream    1700-1800 records/s
vanilla w/o kvm optimizations     revert      13000-14000 records/s
vanilla w/ kvm optimizations      upstream    4500-5000 records/s
vanilla w/ kvm optimizations      revert      14000-15500 records/s

Exit from aggressive wait-early mechanism can result in premature yield
and extra scheduling latency.

Actually, only 6% of wait_early events are caused by vcpu_is_preempted()
being true.  However, when one vCPU voluntarily releases its vCPU, all
the subsequently waiters in the queue will do the same and the cascading
effect leads to bad performance.

kvm optimizations:
[1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts)
[2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption)

Tested-by: loobinliu@tencent.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: loobinliu@tencent.com
Cc: stable@vger.kernel.org
Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is preempted)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/locking/qspinlock_paravirt.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/locking/qspinlock_paravirt.h
+++ b/kernel/locking/qspinlock_paravirt.h
@@ -271,7 +271,7 @@ pv_wait_early(struct pv_node *prev, int
 	if ((loop & PV_PREV_CHECK_MASK) != 0)
 		return false;
 
-	return READ_ONCE(prev->state) != vcpu_running || vcpu_is_preempted(prev->cpu);
+	return READ_ONCE(prev->state) != vcpu_running;
 }
 
 /*


