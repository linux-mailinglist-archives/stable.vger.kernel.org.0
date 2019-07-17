Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EAF6C22B
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 22:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfGQUfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 16:35:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37726 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfGQUfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 16:35:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so11412144pfa.4
        for <stable@vger.kernel.org>; Wed, 17 Jul 2019 13:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qsETDEtqoC6wZqeMHNNL2k3ThjGUEJ7OY24+mdzYGvE=;
        b=ihyzTcK7JVop6p+eazZEYQk8gbk8e0qb7StAZaXVxEorK6jDOApVyfeQh4g2sSQtS3
         b/dyVwtRslA3iV0Br6NeP841AqKxBPd24SxgRQ89/QnsCF6kHtUyFSHKb0I4awO0klUB
         BFFBzc3+bWOJ3p7EXkQRU4UlgLd131gD2E0Lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qsETDEtqoC6wZqeMHNNL2k3ThjGUEJ7OY24+mdzYGvE=;
        b=TAxIM3jJ0Eh+/6RYOn/9ZybMNNSqqk8GEywKfH15BAdvjYm7BESguNKqSJnqTH0AoH
         xgq/hL0Gc4wlfrX/a5qDzuUGVutK2QnvLT5gg7a1MRh1BRQH6QcAGpHYH2fHO/C93c9j
         fuqrrdJEhurl7L6shi7EIQCn+MVQDMHFlOQC4+Kiz1iYByQFOy5m70YG3oRrgIalXXZi
         p9AikEW9sbwjiKJz2DLqyGTFujBB5OfcJGRUR0jtyDB+ueWw/woeVVpsDB8/3m1CRuDD
         15HRYqB9YTycT6nLvKAEdWX001tWqu77Zx3zAm99ijWRXEDJTrAzuw9DWjey1cLCs46C
         EfAw==
X-Gm-Message-State: APjAAAV5p7AWjJaNgNYqt05Eq9Z7dMSXuOKvn8LHDmkpp4B1u4gtmSu2
        8l+RWY+SJIITYOLDf4RTvAQu/p7+438=
X-Google-Smtp-Source: APXvYqwzDLDGsthekha5NDPTZwgsgiacklSDSg/oKiYGPEr+ddienIDsTglpCvgKpc0lL2shJtgahA==
X-Received: by 2002:a63:b20f:: with SMTP id x15mr44723638pge.453.1563395705375;
        Wed, 17 Jul 2019 13:35:05 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id m6sm24704449pfb.151.2019.07.17.13.35.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 13:35:04 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@google.com, groeck@chromium.org, pbonzini@redhat.com,
        rkrcmar@redhat.com
Subject: [PATCH v4.4.y] KVM: x86: protect KVM_CREATE_PIT/KVM_CREATE_PIT2 with kvm->lock
Date:   Wed, 17 Jul 2019 13:35:01 -0700
Message-Id: <20190717203501.240981-1-zsm@chromium.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 250715a6171a076748be8ab88b274e72f0cfb435 upstream.

The syzkaller folks reported a NULL pointer dereference that seems
to be cause by a race between KVM_CREATE_IRQCHIP and KVM_CREATE_PIT2.
The former takes kvm->lock (except when registering the devices,
which needs kvm->slots_lock); the latter takes kvm->slots_lock only.
Change KVM_CREATE_PIT2 to follow the same model as KVM_CREATE_IRQCHIP.

Testcase:

    #include <pthread.h>
    #include <linux/kvm.h>
    #include <fcntl.h>
    #include <sys/ioctl.h>
    #include <stdint.h>
    #include <string.h>
    #include <stdlib.h>
    #include <sys/syscall.h>
    #include <unistd.h>

    long r[23];

    void* thr1(void* arg)
    {
        struct kvm_pit_config pitcfg = { .flags = 4 };
        switch ((long)arg) {
        case 0: r[2]  = open("/dev/kvm", O_RDONLY|O_ASYNC);    break;
        case 1: r[3]  = ioctl(r[2], KVM_CREATE_VM, 0);         break;
        case 2: r[4]  = ioctl(r[3], KVM_CREATE_IRQCHIP, 0);    break;
        case 3: r[22] = ioctl(r[3], KVM_CREATE_PIT2, &pitcfg); break;
        }
        return 0;
    }

    int main(int argc, char **argv)
    {
        long i;
        pthread_t th[4];

        memset(r, -1, sizeof(r));
        for (i = 0; i < 4; i++) {
            pthread_create(&th[i], 0, thr, (void*)i);
            if (argc > 1 && rand()%2) usleep(rand()%1000);
        }
        usleep(20000);
        return 0;
    }

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Zubin Mithra <zsm@google.com>
---
Notes:
* Syzkaller triggered a GPF in kvm_pic_clear_all with the following stacktrace
when fuzzing a 4.4 kernel.
Call Trace:
 [<ffffffff81270a07>] lock_acquire+0x294/0x2f3 kernel/locking/lockdep.c:3592
 [<ffffffff832bd6f7>] __raw_spin_lock include/linux/spinlock_api_smp.h:144 [inline]
 [<ffffffff832bd6f7>] _raw_spin_lock+0x2f/0x3e kernel/locking/spinlock.c:151
 [<ffffffff81084dce>] spin_lock include/linux/spinlock.h:302 [inline]
 [<ffffffff81084dce>] pic_lock arch/x86/kvm/i8259.c:45 [inline]
 [<ffffffff81084dce>] kvm_pic_clear_all+0x33/0x5b arch/x86/kvm/i8259.c:213
 [<ffffffff810968fb>] kvm_free_irq_source_id+0xc8/0xde arch/x86/kvm/irq_comm.c:197
 [<ffffffff810926bb>] kvm_create_pit+0x24e/0x5c5 arch/x86/kvm/i8254.c:713
 [<ffffffff8103aabf>] kvm_arch_vm_ioctl+0x592/0x17db arch/x86/kvm/x86.c:3858
 [<ffffffff81013cb4>] kvm_vm_ioctl+0xb7d/0xbfa arch/x86/kvm/../../../virt/kvm/kvm_main.c:2959
 [<ffffffff8149dc2e>] vfs_ioctl fs/ioctl.c:43 [inline]
 [<ffffffff8149dc2e>] do_vfs_ioctl+0xcb0/0xd0f fs/ioctl.c:630
 [<ffffffff8149dcfe>] SYSC_ioctl fs/ioctl.c:645 [inline]
 [<ffffffff8149dcfe>] SyS_ioctl+0x71/0xad fs/ioctl.c:636
 [<ffffffff832be2fa>] entry_SYSCALL_64_fastpath+0x31/0xb3

* This patch resolves a conflict that arises in arch/x86/kvm/i8254.c:kvm_create_pit()

* This commit is present in linux-4.9.y

* Tests run: Chrome OS tryjobs, Syzkaller reproducer

 arch/x86/kvm/i8254.c | 5 +++--
 arch/x86/kvm/x86.c   | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index ab53187275794..ef56d70d10264 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -678,7 +678,6 @@ static const struct kvm_io_device_ops speaker_dev_ops = {
 	.write    = speaker_ioport_write,
 };
 
-/* Caller must hold slots_lock */
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
@@ -733,6 +732,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	pit->mask_notifier.func = pit_mask_notifer;
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
+	mutex_lock(&kvm->slots_lock);
 	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
 	ret = kvm_io_bus_register_dev(kvm, KVM_PIO_BUS, KVM_PIT_BASE_ADDRESS,
 				      KVM_PIT_MEM_LENGTH, &pit->dev);
@@ -747,13 +747,14 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 		if (ret < 0)
 			goto fail_unregister;
 	}
+	mutex_unlock(&kvm->slots_lock);
 
 	return pit;
 
 fail_unregister:
 	kvm_io_bus_unregister_dev(kvm, KVM_PIO_BUS, &pit->dev);
-
 fail:
+	mutex_unlock(&kvm->slots_lock);
 	kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	kvm_unregister_irq_ack_notifier(kvm, &pit_state->irq_ack_notifier);
 	kvm_free_irq_source_id(kvm, pit->irq_source_id);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 66adcd00b3ddd..ef95cb80cadc2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3867,7 +3867,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 				   sizeof(struct kvm_pit_config)))
 			goto out;
 	create_pit:
-		mutex_lock(&kvm->slots_lock);
+		mutex_lock(&kvm->lock);
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
@@ -3876,7 +3876,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (kvm->arch.vpit)
 			r = 0;
 	create_pit_unlock:
-		mutex_unlock(&kvm->slots_lock);
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_GET_IRQCHIP: {
 		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
-- 
2.22.0.510.g264f2c817a-goog

