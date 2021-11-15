Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E3D4514BA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349444AbhKOUMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233026AbhKOTZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4D53636F2;
        Mon, 15 Nov 2021 19:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003223;
        bh=HcYYH8irgmea996FAzwQCUuREuFh69Rkamg2+JgvnSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2l7Mlr7eWlQAqzHafPJzA5UUX+h/0QwleO4/B7SPGvFMLpp1vmD28vPORfxpu0qK
         Jj+tJWLdbSctJbUWT9K2xM5RUmx42HYCn9oe5ZI6crNkWH09BIgSScQGWWy/u4zCjy
         09T+qJlXx5WnOoGpmZSHpnxbNcB0dzfigZNEAMeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 857/917] KVM: x86: move guest_pv_has out of user_access section
Date:   Mon, 15 Nov 2021 18:05:52 +0100
Message-Id: <20211115165458.090152864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 3e067fd8503d6205aa0c1c8f48f6b209c592d19c upstream.

When UBSAN is enabled, the code emitted for the call to guest_pv_has
includes a call to __ubsan_handle_load_invalid_value.  objtool
complains that this call happens with UACCESS enabled; to avoid
the warning, pull the calls to user_access_begin into both arms
of the "if" statement, after the check for guest_pv_has.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3227,9 +3227,6 @@ static void record_steal_time(struct kvm
 	}
 
 	st = (struct kvm_steal_time __user *)ghc->hva;
-	if (!user_access_begin(st, sizeof(*st)))
-		return;
-
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
@@ -3238,6 +3235,9 @@ static void record_steal_time(struct kvm
 		u8 st_preempted = 0;
 		int err = -EFAULT;
 
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
+
 		asm volatile("1: xchgb %0, %2\n"
 			     "xor %1, %1\n"
 			     "2:\n"
@@ -3260,6 +3260,9 @@ static void record_steal_time(struct kvm
 		if (!user_access_begin(st, sizeof(*st)))
 			goto dirty;
 	} else {
+		if (!user_access_begin(st, sizeof(*st)))
+			return;
+
 		unsafe_put_user(0, &st->preempted, out);
 		vcpu->arch.st.preempted = 0;
 	}


