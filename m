Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A78321F521
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgGNOob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgGNOjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:39:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E47EA2253A;
        Tue, 14 Jul 2020 14:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737558;
        bh=QoEuy0hJIJikJq+yXPq8PDA+ZuxirAj2PA6pqi5aF04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAKck29qGHrWok7TAjuCazyaaYhECVZmGLTj+Vs7h9ARRO3dAz8u1LZqowLRX8K+x
         hOidSXp4ACVpPvnAD1cSt9FqJfF3bbIw1ETeavkzHgr8NVjpdb3b0nF+bhN+/zfd9z
         JBW8r2RQDRQ31PPZ1vsZBUf9uV8xkiEM6Do599CM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/18] KVM: s390: reduce number of IO pins to 1
Date:   Tue, 14 Jul 2020 10:38:59 -0400
Message-Id: <20200714143914.4035489-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714143914.4035489-1-sashal@kernel.org>
References: <20200714143914.4035489-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

[ Upstream commit 774911290c589e98e3638e73b24b0a4d4530e97c ]

The current number of KVM_IRQCHIP_NUM_PINS results in an order 3
allocation (32kb) for each guest start/restart. This can result in OOM
killer activity even with free swap when the memory is fragmented
enough:

kernel: qemu-system-s39 invoked oom-killer: gfp_mask=0x440dc0(GFP_KERNEL_ACCOUNT|__GFP_COMP|__GFP_ZERO), order=3, oom_score_adj=0
kernel: CPU: 1 PID: 357274 Comm: qemu-system-s39 Kdump: loaded Not tainted 5.4.0-29-generic #33-Ubuntu
kernel: Hardware name: IBM 8562 T02 Z06 (LPAR)
kernel: Call Trace:
kernel: ([<00000001f848fe2a>] show_stack+0x7a/0xc0)
kernel:  [<00000001f8d3437a>] dump_stack+0x8a/0xc0
kernel:  [<00000001f8687032>] dump_header+0x62/0x258
kernel:  [<00000001f8686122>] oom_kill_process+0x172/0x180
kernel:  [<00000001f8686abe>] out_of_memory+0xee/0x580
kernel:  [<00000001f86e66b8>] __alloc_pages_slowpath+0xd18/0xe90
kernel:  [<00000001f86e6ad4>] __alloc_pages_nodemask+0x2a4/0x320
kernel:  [<00000001f86b1ab4>] kmalloc_order+0x34/0xb0
kernel:  [<00000001f86b1b62>] kmalloc_order_trace+0x32/0xe0
kernel:  [<00000001f84bb806>] kvm_set_irq_routing+0xa6/0x2e0
kernel:  [<00000001f84c99a4>] kvm_arch_vm_ioctl+0x544/0x9e0
kernel:  [<00000001f84b8936>] kvm_vm_ioctl+0x396/0x760
kernel:  [<00000001f875df66>] do_vfs_ioctl+0x376/0x690
kernel:  [<00000001f875e304>] ksys_ioctl+0x84/0xb0
kernel:  [<00000001f875e39a>] __s390x_sys_ioctl+0x2a/0x40
kernel:  [<00000001f8d55424>] system_call+0xd8/0x2c8

As far as I can tell s390x does not use the iopins as we bail our for
anything other than KVM_IRQ_ROUTING_S390_ADAPTER and the chip/pin is
only used for KVM_IRQ_ROUTING_IRQCHIP. So let us use a small number to
reduce the memory footprint.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200617083620.5409-1-borntraeger@de.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index abe60268335d2..0fe5600a037e4 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -31,12 +31,12 @@
 #define KVM_USER_MEM_SLOTS 32
 
 /*
- * These seem to be used for allocating ->chip in the routing table,
- * which we don't use. 4096 is an out-of-thin-air value. If we need
- * to look at ->chip later on, we'll need to revisit this.
+ * These seem to be used for allocating ->chip in the routing table, which we
+ * don't use. 1 is as small as we can get to reduce the needed memory. If we
+ * need to look at ->chip later on, we'll need to revisit this.
  */
 #define KVM_NR_IRQCHIPS 1
-#define KVM_IRQCHIP_NUM_PINS 4096
+#define KVM_IRQCHIP_NUM_PINS 1
 #define KVM_HALT_POLL_NS_DEFAULT 50000
 
 /* s390-specific vcpu->requests bit members */
-- 
2.25.1

