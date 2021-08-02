Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A9E3DD872
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhHBNwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhHBNvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7382A60F6D;
        Mon,  2 Aug 2021 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912249;
        bh=9o16gPzS/KDaIxvlKZ6tdpwutcU0Jo6AZP1S3JwO9Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5d+ROhLF2LiwnwdOUDaalIt529ESV3P6t+ldu7XG78PwTjM8ARN6d7zCRFF/rMK6
         6cf+cn3TMamPCJVwqr351RD3dC7V9gMNcj4eQntRlSwwvxN7/0iuuW7Uw/cPsRDjCY
         AtcRSstZ15dF40grsK1hgCmmLWl57c9t7ITAAvXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 07/40] KVM: add missing compat KVM_CLEAR_DIRTY_LOG
Date:   Mon,  2 Aug 2021 15:44:47 +0200
Message-Id: <20210802134335.634793928@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
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
@@ -3570,6 +3570,16 @@ struct compat_kvm_dirty_log {
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
@@ -3579,6 +3589,24 @@ static long kvm_vm_compat_ioctl(struct f
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


