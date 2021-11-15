Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1631F452741
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbhKPCUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238032AbhKORmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:42:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51C646326C;
        Mon, 15 Nov 2021 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997265;
        bh=N8CmbRp3P63AxRCfx5q5HTRJgHnvsLt6cSXDoEWAxYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMzwDCJWoanjT4G/OYb58LgQHVy+/lg7qq7+NLkYTmU6FAmzTboxjRGW36KmbwDW1
         RV/5Feeu6KcHCNf8/OmG8YnmlMsV2ur9AbCGAcJ7PTbIWBC3QoixY9xJ4FB2LeNaXC
         D/6fui3Sy8h2KQPQPmwCNkBr3jEYZgLvJ8vASbnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 086/575] KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup
Date:   Mon, 15 Nov 2021 17:56:51 +0100
Message-Id: <20211115165346.618974047@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit ec5a4919fa7b7d8c7a2af1c7e799b1fe4be84343 upstream.

Unregister KVM's posted interrupt wakeup handler during unsetup so that a
spurious interrupt that arrives after kvm_intel.ko is unloaded doesn't
call into freed memory.

Fixes: bf9f6ac8d749 ("KVM: Update Posted-Interrupts Descriptor when vCPU is blocked")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211009001107.3936588-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7586,6 +7586,8 @@ static void vmx_migrate_timers(struct kv
 
 static void hardware_unsetup(void)
 {
+	kvm_set_posted_intr_wakeup_handler(NULL);
+
 	if (nested)
 		nested_vmx_hardware_unsetup();
 
@@ -7877,8 +7879,6 @@ static __init int hardware_setup(void)
 		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
-	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
-
 	kvm_mce_cap_supported |= MCG_LMCE_P;
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
@@ -7900,6 +7900,9 @@ static __init int hardware_setup(void)
 	r = alloc_kvm_area();
 	if (r)
 		nested_vmx_hardware_unsetup();
+
+	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
+
 	return r;
 }
 


