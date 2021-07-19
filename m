Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD753CE1BE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbhGSP1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348180AbhGSPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1316B606A5;
        Mon, 19 Jul 2021 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710553;
        bh=gkXu3sbTGyTrqtfgG5j2rg5rnTqyL/1tASBndj4S7fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqjHYO3TjnUVUVEBpfpm4AdYfyp6WxoS5CGRM98VwRbFuOaU+JreS6kq/0g9Fv7If
         BByr6JqlDm2NPOC86npBdJtGhv8wmdG6sc7Btf/K8njZ6bprIcFfNzvuuSDpgbSD6n
         W2/uQuo1S4DDrF5orGFaB8AaCn3dbuyexgPbE0PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 5.13 004/351] KVM: mmio: Fix use-after-free Read in kvm_vm_ioctl_unregister_coalesced_mmio
Date:   Mon, 19 Jul 2021 16:49:10 +0200
Message-Id: <20210719144944.680407844@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 23fa2e46a5556f787ce2ea1a315d3ab93cced204 upstream.

BUG: KASAN: use-after-free in kvm_vm_ioctl_unregister_coalesced_mmio+0x7c/0x1ec arch/arm64/kvm/../../../virt/kvm/coalesced_mmio.c:183
Read of size 8 at addr ffff0000c03a2500 by task syz-executor083/4269

CPU: 5 PID: 4269 Comm: syz-executor083 Not tainted 5.10.0 #7
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace+0x0/0x2d0 arch/arm64/kernel/stacktrace.c:132
 show_stack+0x28/0x34 arch/arm64/kernel/stacktrace.c:196
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x110/0x164 lib/dump_stack.c:118
 print_address_description+0x78/0x5c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report+0x148/0x1e4 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:183 [inline]
 __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
 kvm_vm_ioctl_unregister_coalesced_mmio+0x7c/0x1ec arch/arm64/kvm/../../../virt/kvm/coalesced_mmio.c:183
 kvm_vm_ioctl+0xe30/0x14c4 arch/arm64/kvm/../../../virt/kvm/kvm_main.c:3755
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __arm64_sys_ioctl+0xf88/0x131c fs/ioctl.c:739
 __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
 el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
 do_el0_svc+0x120/0x290 arch/arm64/kernel/syscall.c:220
 el0_svc+0x1c/0x28 arch/arm64/kernel/entry-common.c:367
 el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
 el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670

Allocated by task 4269:
 stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0xdc/0x120 mm/kasan/common.c:461
 kasan_kmalloc+0xc/0x14 mm/kasan/common.c:475
 kmem_cache_alloc_trace include/linux/slab.h:450 [inline]
 kmalloc include/linux/slab.h:552 [inline]
 kzalloc include/linux/slab.h:664 [inline]
 kvm_vm_ioctl_register_coalesced_mmio+0x78/0x1cc arch/arm64/kvm/../../../virt/kvm/coalesced_mmio.c:146
 kvm_vm_ioctl+0x7e8/0x14c4 arch/arm64/kvm/../../../virt/kvm/kvm_main.c:3746
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __arm64_sys_ioctl+0xf88/0x131c fs/ioctl.c:739
 __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
 el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
 do_el0_svc+0x120/0x290 arch/arm64/kernel/syscall.c:220
 el0_svc+0x1c/0x28 arch/arm64/kernel/entry-common.c:367
 el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
 el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670

Freed by task 4269:
 stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x38/0x6c mm/kasan/common.c:56
 kasan_set_free_info+0x20/0x40 mm/kasan/generic.c:355
 __kasan_slab_free+0x124/0x150 mm/kasan/common.c:422
 kasan_slab_free+0x10/0x1c mm/kasan/common.c:431
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook mm/slub.c:1577 [inline]
 slab_free mm/slub.c:3142 [inline]
 kfree+0x104/0x38c mm/slub.c:4124
 coalesced_mmio_destructor+0x94/0xa4 arch/arm64/kvm/../../../virt/kvm/coalesced_mmio.c:102
 kvm_iodevice_destructor include/kvm/iodev.h:61 [inline]
 kvm_io_bus_unregister_dev+0x248/0x280 arch/arm64/kvm/../../../virt/kvm/kvm_main.c:4374
 kvm_vm_ioctl_unregister_coalesced_mmio+0x158/0x1ec arch/arm64/kvm/../../../virt/kvm/coalesced_mmio.c:186
 kvm_vm_ioctl+0xe30/0x14c4 arch/arm64/kvm/../../../virt/kvm/kvm_main.c:3755
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __arm64_sys_ioctl+0xf88/0x131c fs/ioctl.c:739
 __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
 el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
 do_el0_svc+0x120/0x290 arch/arm64/kernel/syscall.c:220
 el0_svc+0x1c/0x28 arch/arm64/kernel/entry-common.c:367
 el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
 el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670

If kvm_io_bus_unregister_dev() return -ENOMEM, we already call kvm_iodevice_destructor()
inside this function to delete 'struct kvm_coalesced_mmio_dev *dev' from list
and free the dev, but kvm_iodevice_destructor() is called again, it will lead
the above issue.

Let's check the the return value of kvm_io_bus_unregister_dev(), only call
kvm_iodevice_destructor() if the return value is 0.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-Id: <20210626070304.143456-1-wangkefeng.wang@huawei.com>
Cc: stable@vger.kernel.org
Fixes: 5d3c4c79384a ("KVM: Stop looking for coalesced MMIO zones if the bus is destroyed", 2021-04-20)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/coalesced_mmio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -186,7 +186,6 @@ int kvm_vm_ioctl_unregister_coalesced_mm
 		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
 			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
-			kvm_iodevice_destructor(&dev->dev);
 
 			/*
 			 * On failure, unregister destroys all devices on the
@@ -196,6 +195,7 @@ int kvm_vm_ioctl_unregister_coalesced_mm
 			 */
 			if (r)
 				break;
+			kvm_iodevice_destructor(&dev->dev);
 		}
 	}
 


