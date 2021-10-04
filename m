Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3C3420E72
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbhJDNZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236510AbhJDNWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:22:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9CA61B62;
        Mon,  4 Oct 2021 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352967;
        bh=OSvn5waHUs7w7ltyhQovFUEu+eYst4bz4nJT96TImdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kS29P+p+ME3n6vKWertgBApUDbeAy/tWtRy3CfrA0Jy1jrZs8cCHLaU7lyaH8gSs8
         ylfqwPe2Ji778RejMpexamNTMPmb/d2nvhl3DcjvPKom7OJxMQFqJ9uwS5qtdEBHLJ
         Y39zWXuVKOKVaoMgwW111MsxCUqCM70ljS4LN9t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Foley <pefoley@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shakeel Butt <shakeelb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Doug Evans <dje@google.com>
Subject: [PATCH 5.10 20/93] KVM: rseq: Update rseq when processing NOTIFY_RESUME on xfer to KVM guest
Date:   Mon,  4 Oct 2021 14:52:18 +0200
Message-Id: <20211004125035.248048862@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 8646e53633f314e4d746a988240d3b951a92f94a upstream.

Invoke rseq's NOTIFY_RESUME handler when processing the flag prior to
transferring to a KVM guest, which is roughly equivalent to an exit to
userspace and processes many of the same pending actions.  While the task
cannot be in an rseq critical section as the KVM path is reachable only
by via ioctl(KVM_RUN), the side effects that apply to rseq outside of a
critical section still apply, e.g. the current CPU needs to be updated if
the task is migrated.

Clearing TIF_NOTIFY_RESUME without informing rseq can lead to segfaults
and other badness in userspace VMMs that use rseq in combination with KVM,
e.g. due to the CPU ID being stale after task migration.

Fixes: 72c3c0fe54a3 ("x86/kvm: Use generic xfer to guest work function")
Reported-by: Peter Foley <pefoley@google.com>
Bisected-by: Doug Evans <dje@google.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210901203030.1292304-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: Resolve benign conflict due to unrelated access_ok() check in 5.10]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/entry/kvm.c |    4 +++-
 kernel/rseq.c      |   13 ++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -16,8 +16,10 @@ static int xfer_to_guest_mode_work(struc
 		if (ti_work & _TIF_NEED_RESCHED)
 			schedule();
 
-		if (ti_work & _TIF_NOTIFY_RESUME)
+		if (ti_work & _TIF_NOTIFY_RESUME) {
 			tracehook_notify_resume(NULL);
+			rseq_handle_notify_resume(NULL, NULL);
+		}
 
 		ret = arch_xfer_to_guest_mode_handle_work(vcpu, ti_work);
 		if (ret)
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -268,9 +268,16 @@ void __rseq_handle_notify_resume(struct
 		return;
 	if (unlikely(!access_ok(t->rseq, sizeof(*t->rseq))))
 		goto error;
-	ret = rseq_ip_fixup(regs);
-	if (unlikely(ret < 0))
-		goto error;
+	/*
+	 * regs is NULL if and only if the caller is in a syscall path.  Skip
+	 * fixup and leave rseq_cs as is so that rseq_sycall() will detect and
+	 * kill a misbehaving userspace on debug kernels.
+	 */
+	if (regs) {
+		ret = rseq_ip_fixup(regs);
+		if (unlikely(ret < 0))
+			goto error;
+	}
 	if (unlikely(rseq_update_cpu_id(t)))
 		goto error;
 	return;


