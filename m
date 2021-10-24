Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9684388C1
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJXL7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXL7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3D3F60524;
        Sun, 24 Oct 2021 11:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635076631;
        bh=rRlNDbh9/DqEkYBJ4BtlhsbqREtPLe7GXrIz0zuCL0A=;
        h=Subject:To:Cc:From:Date:From;
        b=xCxdKBf9bMpq8LPMSgITbyzb4kEfzsWskho3uZAfxY41h/I7CBAW9q/1xiQxTW75V
         yR49yKx+xPPx2VU/HJ8yCjw9oO8JiZhwy5WdYEnRoH908FjI/Lzr6yhXkMW+nbEuQh
         5PmGnTUOZZwTh810S89i7XQL7Pvi9JygR4FHIOac=
Subject: FAILED: patch "[PATCH] KVM: x86: check for interrupts before deciding whether to" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:57:09 +0200
Message-ID: <16350766297207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From de7cd3f6761f49bef044ec49493d88737a70f1a6 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 20 Oct 2021 06:27:36 -0400
Subject: [PATCH] KVM: x86: check for interrupts before deciding whether to
 exit the fast path

The kvm_x86_sync_pir_to_irr callback can sometimes set KVM_REQ_EVENT.
If that happens exactly at the time that an exit is handled as
EXIT_FASTPATH_REENTER_GUEST, vcpu_enter_guest will go incorrectly
through the loop that calls kvm_x86_run, instead of processing
the request promptly.

Fixes: 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt delivery for timer fastpath")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c8b5129effd..381384a54790 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9643,14 +9643,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
-                if (unlikely(kvm_vcpu_exit_request(vcpu))) {
+		if (vcpu->arch.apicv_active)
+			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+
+		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
 			break;
 		}
-
-		if (vcpu->arch.apicv_active)
-			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
-        }
+	}
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And

