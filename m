Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6218D6C647
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391994AbfGRDPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391985AbfGRDPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:15:18 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0189D21849;
        Thu, 18 Jul 2019 03:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419717;
        bh=RqHs4PD78dqw4xd7ttlwOYA6we00lDzzgKgXO/uJ2ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq8QFYq6S9xQNOgP5Dl4sKunvUd+MwmmET8eJ01WzV73DSC7qlUMWiBXlxfZBpOAo
         r8fpFtTS032MMRJcYYMNLUsFOza5BHh8EleuO6FRlVy4Xf/XJNCvAC1o7CWSHrTjMU
         tD1HzKIvrxa2I3gH+plmyZmfKtgEMeK+qmzZefOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Zubin Mithra <zsm@google.com>
Subject: [PATCH 4.4 40/40] KVM: x86: protect KVM_CREATE_PIT/KVM_CREATE_PIT2 with kvm->lock
Date:   Thu, 18 Jul 2019 12:02:36 +0900
Message-Id: <20190718030050.616694335@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/i8254.c |    5 +++--
 arch/x86/kvm/x86.c   |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -678,7 +678,6 @@ static const struct kvm_io_device_ops sp
 	.write    = speaker_ioport_write,
 };
 
-/* Caller must hold slots_lock */
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
@@ -733,6 +732,7 @@ struct kvm_pit *kvm_create_pit(struct kv
 	pit->mask_notifier.func = pit_mask_notifer;
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
+	mutex_lock(&kvm->slots_lock);
 	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
 	ret = kvm_io_bus_register_dev(kvm, KVM_PIO_BUS, KVM_PIT_BASE_ADDRESS,
 				      KVM_PIT_MEM_LENGTH, &pit->dev);
@@ -747,13 +747,14 @@ struct kvm_pit *kvm_create_pit(struct kv
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
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3867,7 +3867,7 @@ long kvm_arch_vm_ioctl(struct file *filp
 				   sizeof(struct kvm_pit_config)))
 			goto out;
 	create_pit:
-		mutex_lock(&kvm->slots_lock);
+		mutex_lock(&kvm->lock);
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
@@ -3876,7 +3876,7 @@ long kvm_arch_vm_ioctl(struct file *filp
 		if (kvm->arch.vpit)
 			r = 0;
 	create_pit_unlock:
-		mutex_unlock(&kvm->slots_lock);
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_GET_IRQCHIP: {
 		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */


