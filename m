Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C065419F25
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 21:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbhI0Tac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 15:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbhI0Tab (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 15:30:31 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C836C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 12:28:53 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id cu18-20020a05621417d200b003822ed8f245so45025385qvb.8
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 12:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=rxCiDFrfA5bXOV+pULGeWj1OAyCxc4GhOwgKIj0DBzQ=;
        b=XLImSIYiZWFdaPU4sCd5EyuFNauDEaClmHA9vTbc+sRjfxdyzXFc4J3kwN+8WPTOam
         3zHbtlL85FiGxXEmMZ8jm/CAaZxM8QqsTHI0ATRSQu1OHJMY4U7nrqCSznuzwY4iE7iz
         XDEIQpuu9ZJLidxD09nNwKEfDaut5GnsTmKKE6uWt06kQgFmVxCCoufuIiJBpCA7sidv
         klUyqNUBcj/9nx0jGyyDXzDSsNFz262dW/cMCeQgL2KHLsvwK3QvhVdzValzxaKe2t6H
         uQezeVx3X2VRdjLcSu2HDudKv88JG0cjrDIOhrL+wbf5Dvc0kDm19u4Je7dvlJWvfNQb
         JMlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=rxCiDFrfA5bXOV+pULGeWj1OAyCxc4GhOwgKIj0DBzQ=;
        b=ql5xpP7VwV+51D69exI0yB5hPnLmZLJApQAjqj5RBo+gzFL4x0WA3hGiwcVYRYmNx4
         IemJrfi+Fu/4YU8qG35M6RRIN99zr/RQhsGcB4xt5k64U552LTDq4OFQwtAwxHUkKgZE
         fzvHhcI3p5tIJguw4LVhxhZ1PhXzxPb4DOvuirWO8njEqXmpnqrGDG8RoIohKeMchJiR
         YR6jmGPxPpGiaJsLx6vhJsPGAbMoowFP11CqMJlftj+hV0GhvIbs6KgobKTn1BvzOct8
         NkFgj7CmX+xUk/JO+orF7QMzsNYxZZ7uTqqlbwJpWg5lRJB7DljTRzWSkRIBa/R+RN15
         t7Zw==
X-Gm-Message-State: AOAM530MokRIt0QlFYf/z7XD0skRP7LWq5t5GMH4uqKfZZoC/k8gPNAr
        cL591Cy5/0GoYiZcWrZlSZHmcX+5voA=
X-Google-Smtp-Source: ABdhPJzXhwrJwyco2YTJp9dJEFpzKHV34jonQOtxUGz5IeMwQWyVdg9JJab+CrGRpp2MxVwpZD/GHawXnVQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:9819:77b0:abed:c10c])
 (user=seanjc job=sendgmr) by 2002:a0c:f20b:: with SMTP id h11mr1594443qvk.66.1632770932719;
 Mon, 27 Sep 2021 12:28:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 27 Sep 2021 12:28:46 -0700
Message-Id: <20210927192846.1533905-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 5.10] KVM: rseq: Update rseq when processing NOTIFY_RESUME on
 xfer to KVM guest
From:   Sean Christopherson <seanjc@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Peter Foley <pefoley@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 kernel/entry/kvm.c |  4 +++-
 kernel/rseq.c      | 13 ++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index b6678a5e3cf6..2a3139dab109 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -16,8 +16,10 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 		if (ti_work & _TIF_NEED_RESCHED)
 			schedule();
 
-		if (ti_work & _TIF_NOTIFY_RESUME)
+		if (ti_work & _TIF_NOTIFY_RESUME) {
 			tracehook_notify_resume(NULL);
+			rseq_handle_notify_resume(NULL, NULL);
+		}
 
 		ret = arch_xfer_to_guest_mode_handle_work(vcpu, ti_work);
 		if (ret)
diff --git a/kernel/rseq.c b/kernel/rseq.c
index a4f86a9d6937..0077713bf240 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -268,9 +268,16 @@ void __rseq_handle_notify_resume(struct ksignal *ksig, struct pt_regs *regs)
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
-- 
2.33.0.685.g46640cef36-goog

