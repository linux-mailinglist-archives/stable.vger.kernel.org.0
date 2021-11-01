Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C913C4418DA
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhKAJwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234338AbhKAJu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7939261440;
        Mon,  1 Nov 2021 09:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759117;
        bh=k3DGIGYaL2a2FLNzzaRgVwn4VxEXPM8t0vO5IUhvdfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVlrkxHcak869SHGTKq5ID6PaI9kA7nwirL6ue4nrO3ZPYr4Fuzwy11JreCTNDdYy
         YSUPPRc9GFOevurVdNpYWWuo4gX3VyrsML0CZ7D1+OyS6u0Vv3qCwxBVL5VFuPOsp+
         QuZZxwxcxczk6D3c8S8476Qbqmg6i/C86Sf73jQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 122/125] KVM: x86/xen: Fix kvm_xen_has_interrupt() sleeping in kvm_vcpu_block()
Date:   Mon,  1 Nov 2021 10:18:15 +0100
Message-Id: <20211101082556.140315642@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

commit 0985dba842eaa391858972cfe2724c3c174a2827 upstream.

In kvm_vcpu_block, the current task is set to TASK_INTERRUPTIBLE before
making a final check whether the vCPU should be woken from HLT by any
incoming interrupt.

This is a problem for the get_user() in __kvm_xen_has_interrupt(), which
really shouldn't be sleeping when the task state has already been set.
I think it's actually harmless as it would just manifest itself as a
spurious wakeup, but it's causing a debug warning:

[  230.963649] do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000b6bcdbc9>] prepare_to_swait_exclusive+0x30/0x80

Fix the warning by turning it into an *explicit* spurious wakeup. When
invoked with !task_is_running(current) (and we might as well add
in_atomic() there while we're at it), just return 1 to indicate that
an IRQ is pending, which will cause a wakeup and then something will
call it again in a context that *can* sleep so it can fault the page
back in.

Cc: stable@vger.kernel.org
Fixes: 40da8ccd724f ("KVM: x86/xen: Add event channel interrupt vector upcall")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <168bf8c689561da904e48e2ff5ae4713eaef9e2d.camel@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -191,6 +191,7 @@ void kvm_xen_update_runstate_guest(struc
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 {
+	int err;
 	u8 rc = 0;
 
 	/*
@@ -217,13 +218,29 @@ int __kvm_xen_has_interrupt(struct kvm_v
 	if (likely(slots->generation == ghc->generation &&
 		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
 		/* Fast path */
-		__get_user(rc, (u8 __user *)ghc->hva + offset);
-	} else {
-		/* Slow path */
-		kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
-					     sizeof(rc));
+		pagefault_disable();
+		err = __get_user(rc, (u8 __user *)ghc->hva + offset);
+		pagefault_enable();
+		if (!err)
+			return rc;
 	}
 
+	/* Slow path */
+
+	/*
+	 * This function gets called from kvm_vcpu_block() after setting the
+	 * task to TASK_INTERRUPTIBLE, to see if it needs to wake immediately
+	 * from a HLT. So we really mustn't sleep. If the page ended up absent
+	 * at that point, just return 1 in order to trigger an immediate wake,
+	 * and we'll end up getting called again from a context where we *can*
+	 * fault in the page and wait for it.
+	 */
+	if (in_atomic() || !task_is_running(current))
+		return 1;
+
+	kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
+				     sizeof(rc));
+
 	return rc;
 }
 


