Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA053D754D
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 14:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhG0MtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 08:49:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52890 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231840AbhG0MtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 08:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627390148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BdtEDp0+lwUk+eK3IyiXj+lptHD+lclVaf4zplQ8FEI=;
        b=ZlFbBqXY0gr6fjSz+i4FyIy9n3zMLH7VY248Qn2RCcujfu4z3Xi4wQPNYJ7TGNnOe4E/Kt
        NMr/2LkQQeATIgTfQW8lb9r34xGUOoGiO7BG6GfPR0CAWVFUKjyT3xlAAGg6qheYVLpgMT
        O107H0h3DspF/6/t//9ARRtlgzcr8/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-sQIj6EnLNridOslQXE-snA-1; Tue, 27 Jul 2021 08:49:06 -0400
X-MC-Unique: sQIj6EnLNridOslQXE-snA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3D1218C89DD;
        Tue, 27 Jul 2021 12:49:05 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD079226E7;
        Tue, 27 Jul 2021 12:49:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, stable@vger.kernel.org
Subject: [PATCH] KVM: add missing compat KVM_CLEAR_DIRTY_LOG
Date:   Tue, 27 Jul 2021 08:49:01 -0400
Message-Id: <20210727124901.1466039-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The arguments to the KVM_CLEAR_DIRTY_LOG ioctl include a pointer,
therefore it needs a compat ioctl implementation.  Otherwise,
32-bit userspace fails to invoke it on 64-bit kernels; for x86
it might work fine by chance if the padding is zero, but not
on big-endian architectures.

Reported-by: Thomas Sattler
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0d732813fa80..d20fba0fc290 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4391,6 +4391,16 @@ struct compat_kvm_dirty_log {
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
@@ -4400,6 +4410,24 @@ static long kvm_vm_compat_ioctl(struct file *filp,
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
-- 
2.27.0

