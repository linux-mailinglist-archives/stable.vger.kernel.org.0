Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFBD3137E1
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhBHPcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233940AbhBHP2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:28:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1441264DFF;
        Mon,  8 Feb 2021 15:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797388;
        bh=YccDqjeajWkEGxaKkOyAcu5JCWanzuFJHF2TtT2eRg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okd9l0tMkMpj2CVjJKdDmpafm13ByfD4cGsm/ek6bcbhyoabILrwt4yJ/zSL7He1a
         RRxih9JUNSKZiYViNtFFsrG5m+2BwWWd/Pt8M8/eq2YH5VsL6edXnF+LwhlLWAFbSO
         am913Qnx26ipm2iIhZaBgXZvCbB4gMYaz5WSmF48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Michael Roth <michael.roth@amd.com.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 091/120] KVM: x86: fix CPUID entries returned by KVM_GET_CPUID2 ioctl
Date:   Mon,  8 Feb 2021 16:01:18 +0100
Message-Id: <20210208145822.032288504@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

commit 181f494888d5b178ffda41bed965f187d5e5c432 upstream.

Recent commit 255cbecfe0 modified struct kvm_vcpu_arch to make
'cpuid_entries' a pointer to an array of kvm_cpuid_entry2 entries
rather than embedding the array in the struct. KVM_SET_CPUID and
KVM_SET_CPUID2 were updated accordingly, but KVM_GET_CPUID2 was missed.

As a result, KVM_GET_CPUID2 currently returns random fields from struct
kvm_vcpu_arch to userspace rather than the expected CPUID values. Fix
this by treating 'cpuid_entries' as a pointer when copying its
contents to userspace buffer.

Fixes: 255cbecfe0c9 ("KVM: x86: allocate vcpu->arch.cpuid_entries dynamically")
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com.com>
Message-Id: <20210128024451.1816770-1-michael.roth@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -320,7 +320,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm
 	if (cpuid->nent < vcpu->arch.cpuid_nent)
 		goto out;
 	r = -EFAULT;
-	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
+	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
 			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	return 0;


