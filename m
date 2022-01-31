Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B704A435A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359484AbiAaLVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35628 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377330AbiAaLSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:18:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB0FDB82A5F;
        Mon, 31 Jan 2022 11:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C979C340E8;
        Mon, 31 Jan 2022 11:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627880;
        bh=6nGHR68tqwvSOPGIC33WzZoogKKn5O2wpwNOB+osxdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JD5A+vo1ergqxa74UUvw2tYTMojzNlwRQ3B2kcLO3LCfTRztAtC/cws5Q58hRRbh/
         UFICmOOFVxw6KdNS37HQ4/B2rRb3cgcfKt+6whPfYxZhRvqhgsW5csa5p1vdi618A1
         WubVcZT2AjqjaMAMbqAhy7IYy7i8MmfNPmUwkTNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+be576ad7655690586eec@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 053/200] KVM: x86: Free kvm_cpuid_entry2 array on post-KVM_RUN KVM_SET_CPUID{,2}
Date:   Mon, 31 Jan 2022 11:55:16 +0100
Message-Id: <20220131105235.355525631@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 811f95ff95270e6048197821434d9301e3d7f07c upstream.

Free the "struct kvm_cpuid_entry2" array on successful post-KVM_RUN
KVM_SET_CPUID{,2} to fix a memory leak, the callers of kvm_set_cpuid()
free the array only on failure.

 BUG: memory leak
 unreferenced object 0xffff88810963a800 (size 2048):
  comm "syz-executor025", pid 3610, jiffies 4294944928 (age 8.080s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 0d 00 00 00  ................
    47 65 6e 75 6e 74 65 6c 69 6e 65 49 00 00 00 00  GenuntelineI....
  backtrace:
    [<ffffffff814948ee>] kmalloc_node include/linux/slab.h:604 [inline]
    [<ffffffff814948ee>] kvmalloc_node+0x3e/0x100 mm/util.c:580
    [<ffffffff814950f2>] kvmalloc include/linux/slab.h:732 [inline]
    [<ffffffff814950f2>] vmemdup_user+0x22/0x100 mm/util.c:199
    [<ffffffff8109f5ff>] kvm_vcpu_ioctl_set_cpuid2+0x8f/0xf0 arch/x86/kvm/cpuid.c:423
    [<ffffffff810711b9>] kvm_arch_vcpu_ioctl+0xb99/0x1e60 arch/x86/kvm/x86.c:5251
    [<ffffffff8103e92d>] kvm_vcpu_ioctl+0x4ad/0x950 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4066
    [<ffffffff815afacc>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff815afacc>] __do_sys_ioctl fs/ioctl.c:874 [inline]
    [<ffffffff815afacc>] __se_sys_ioctl fs/ioctl.c:860 [inline]
    [<ffffffff815afacc>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:860
    [<ffffffff844a3335>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff844a3335>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c6617c61e8fe ("KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN")
Cc: stable@vger.kernel.org
Reported-by: syzbot+be576ad7655690586eec@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220125210445.2053429-1-seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -338,8 +338,14 @@ static int kvm_set_cpuid(struct kvm_vcpu
 	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
 	 * whether the supplied CPUID data is equal to what's already set.
 	 */
-	if (vcpu->arch.last_vmentry_cpu != -1)
-		return kvm_cpuid_check_equal(vcpu, e2, nent);
+	if (vcpu->arch.last_vmentry_cpu != -1) {
+		r = kvm_cpuid_check_equal(vcpu, e2, nent);
+		if (r)
+			return r;
+
+		kvfree(e2);
+		return 0;
+	}
 
 	r = kvm_check_cpuid(e2, nent);
 	if (r)


