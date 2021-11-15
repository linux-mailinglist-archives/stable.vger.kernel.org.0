Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9371845249D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356529AbhKPBk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:40:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241365AbhKOS1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:27:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFFCB63333;
        Mon, 15 Nov 2021 17:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999013;
        bh=TbQ/2XRT61/Y54P7sZuYOGP/oLn2Hkxo8uUqDFLHkwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqGRefLD6u49YdsypH+irD1urP7HiyHBf6eI8ZqF6ynfCt8q0KKsyPeC+ZiCAPBhY
         k3z7DjtxLuRIkdyp4Bpi/0dozWYW9ZLYtDweMQHhSo4c7uiG65l2++cecyl5R7RvNQ
         157sjp+KfRAaPhBMJt7iY/UFE2KNycSQMR6aOgxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 101/849] KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup
Date:   Mon, 15 Nov 2021 17:53:04 +0100
Message-Id: <20211115165423.506317966@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -7517,6 +7517,8 @@ static void vmx_migrate_timers(struct kv
 
 static void hardware_unsetup(void)
 {
+	kvm_set_posted_intr_wakeup_handler(NULL);
+
 	if (nested)
 		nested_vmx_hardware_unsetup();
 
@@ -7844,8 +7846,6 @@ static __init int hardware_setup(void)
 		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
-	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
-
 	kvm_mce_cap_supported |= MCG_LMCE_P;
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
@@ -7869,6 +7869,9 @@ static __init int hardware_setup(void)
 	r = alloc_kvm_area();
 	if (r)
 		nested_vmx_hardware_unsetup();
+
+	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
+
 	return r;
 }
 


