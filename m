Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0A43DD97E
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhHBOAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235207AbhHBN5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 231D260527;
        Mon,  2 Aug 2021 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912500;
        bh=9EanXT9K/lLuEddXNAYery6xH4iprDKzrwQNVyDUSw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqxzP6idXx8bstakSoqelFQzjhfuSAA1G/U68Tq7VH//poBTKm73ANYYCagiAC3Hs
         0X4ANLOrHKsFdpg5JJqQgSKRVZ0GjBl9mNtpPtW7sjThba3WWWdOm8So0QKHoaCOf3
         aR305P9xCu4/oAOJk68ADS4It3AIcoE94+9tlJc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 009/104] KVM: add missing compat KVM_CLEAR_DIRTY_LOG
Date:   Mon,  2 Aug 2021 15:44:06 +0200
Message-Id: <20210802134344.322905923@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 8750f9bbda115f3f79bfe43be85551ee5e12b6ff upstream.

The arguments to the KVM_CLEAR_DIRTY_LOG ioctl include a pointer,
therefore it needs a compat ioctl implementation.  Otherwise,
32-bit userspace fails to invoke it on 64-bit kernels; for x86
it might work fine by chance if the padding is zero, but not
on big-endian architectures.

Reported-by: Thomas Sattler
Cc: stable@vger.kernel.org
Fixes: 2a31b9db1535 ("kvm: introduce manual dirty log reprotect")
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4183,6 +4183,16 @@ struct compat_kvm_dirty_log {
 	};
 };
 
+struct compat_kvm_clear_dirty_log {
+	__u32 slot;
+	__u32 num_pages;
+	__u64 first_page;
+	union {
+		compat_uptr_t dirty_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
 static long kvm_vm_compat_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4192,6 +4202,24 @@ static long kvm_vm_compat_ioctl(struct f
 	if (kvm->mm != current->mm)
 		return -EIO;
 	switch (ioctl) {
+#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	case KVM_CLEAR_DIRTY_LOG: {
+		struct compat_kvm_clear_dirty_log compat_log;
+		struct kvm_clear_dirty_log log;
+
+		if (copy_from_user(&compat_log, (void __user *)arg,
+				   sizeof(compat_log)))
+			return -EFAULT;
+		log.slot	 = compat_log.slot;
+		log.num_pages	 = compat_log.num_pages;
+		log.first_page	 = compat_log.first_page;
+		log.padding2	 = compat_log.padding2;
+		log.dirty_bitmap = compat_ptr(compat_log.dirty_bitmap);
+
+		r = kvm_vm_ioctl_clear_dirty_log(kvm, &log);
+		break;
+	}
+#endif
 	case KVM_GET_DIRTY_LOG: {
 		struct compat_kvm_dirty_log compat_log;
 		struct kvm_dirty_log log;


