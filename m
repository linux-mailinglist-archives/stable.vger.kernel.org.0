Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E8E45C5FA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347831AbhKXOEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350602AbhKXN7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:59:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3029E61207;
        Wed, 24 Nov 2021 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759328;
        bh=zcjsJaIFBEHf3pbsS61WfqHKWvuOCHZLYNHYISbWjo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11tV60jwkvZUbKfwjb+CjPYpVDbbPwUX2e7vg4RU1iAMSEjdz4NLsHb5Ua+VAnQD2
         fJOwJRjz+xojgtSet1ucsuJAhZhkBq47cr8UvhYAeCPpwniAkZwo7q0hPpb/9t3sCl
         nn9q0dz1FvhyaESSGsF33S8/sPQiUZYDNuSpF/6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Huang Le <huangle1@jd.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 205/279] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in vcpu_load_eoi_exitmap()
Date:   Wed, 24 Nov 2021 12:58:12 +0100
Message-Id: <20211124115725.829349163@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 黄乐 <huangle1@jd.com>

commit c5adbb3af051079f35abfa26551107e2c653087f upstream.

In vcpu_load_eoi_exitmap(), currently the eoi_exit_bitmap[4] array is
initialized only when Hyper-V context is available, in other path it is
just passed to kvm_x86_ops.load_eoi_exitmap() directly from on the stack,
which would cause unexpected interrupt delivery/handling issues, e.g. an
*old* linux kernel that relies on PIT to do clock calibration on KVM might
randomly fail to boot.

Fix it by passing ioapic_handled_vectors to load_eoi_exitmap() when Hyper-V
context is not available.

Fixes: f2bc14b69c38 ("KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Huang Le <huangle1@jd.com>
Message-Id: <62115b277dab49ea97da5633f8522daf@jd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9429,12 +9429,16 @@ static void vcpu_load_eoi_exitmap(struct
 	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
 		return;
 
-	if (to_hv_vcpu(vcpu))
+	if (to_hv_vcpu(vcpu)) {
 		bitmap_or((ulong *)eoi_exit_bitmap,
 			  vcpu->arch.ioapic_handled_vectors,
 			  to_hv_synic(vcpu)->vec_bitmap, 256);
+		static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
+		return;
+	}
 
-	static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
+	static_call(kvm_x86_load_eoi_exitmap)(
+		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
 }
 
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,


