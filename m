Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D825437CB4B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242584AbhELQfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241651AbhELQ1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4354E61DFC;
        Wed, 12 May 2021 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834887;
        bh=XOx3ooyZZwVTj8R8rCIoyKLHFyPwTQt/vwyUps0+C9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZ+dklIwHeQFqmz7qEDwRu19/LGw+Lhajl6Lb1Ckhnym/TUS/5e+FtWfxdEHdyMWM
         T7KK8AZ2Qt6KC3WvMLt3HMMwUYLBBO7eFnBba5r+s5VJbMoywzX+/vZYeev65LSO8u
         W8GuiN1PQk33ng+LuC5G2jG/QYyYF3PUH/F9sw9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Sun <sunhao.th@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 124/677] KVM: Stop looking for coalesced MMIO zones if the bus is destroyed
Date:   Wed, 12 May 2021 16:42:50 +0200
Message-Id: <20210512144841.336486133@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 5d3c4c79384af06e3c8e25b7770b6247496b4417 upstream.

Abort the walk of coalesced MMIO zones if kvm_io_bus_unregister_dev()
fails to allocate memory for the new instance of the bus.  If it can't
instantiate a new bus, unregister_dev() destroys all devices _except_ the
target device.   But, it doesn't tell the caller that it obliterated the
bus and invoked the destructor for all devices that were on the bus.  In
the coalesced MMIO case, this can result in a deleted list entry
dereference due to attempting to continue iterating on coalesced_zones
after future entries (in the walk) have been deleted.

Opportunistically add curly braces to the for-loop, which encompasses
many lines but sneaks by without braces due to the guts being a single
if statement.

Fixes: f65886606c2d ("KVM: fix memory leak in kvm_io_bus_unregister_dev()")
Cc: stable@vger.kernel.org
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210412222050.876100-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h  |    4 ++--
 virt/kvm/coalesced_mmio.c |   19 +++++++++++++++++--
 virt/kvm/kvm_main.c       |   10 +++++-----
 3 files changed, 24 insertions(+), 9 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -192,8 +192,8 @@ int kvm_io_bus_read(struct kvm_vcpu *vcp
 		    int len, void *val);
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev);
-void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-			       struct kvm_io_device *dev);
+int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
+			      struct kvm_io_device *dev);
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 					 gpa_t addr);
 
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -174,21 +174,36 @@ int kvm_vm_ioctl_unregister_coalesced_mm
 					   struct kvm_coalesced_mmio_zone *zone)
 {
 	struct kvm_coalesced_mmio_dev *dev, *tmp;
+	int r;
 
 	if (zone->pio != 1 && zone->pio != 0)
 		return -EINVAL;
 
 	mutex_lock(&kvm->slots_lock);
 
-	list_for_each_entry_safe(dev, tmp, &kvm->coalesced_zones, list)
+	list_for_each_entry_safe(dev, tmp, &kvm->coalesced_zones, list) {
 		if (zone->pio == dev->zone.pio &&
 		    coalesced_mmio_in_range(dev, zone->addr, zone->size)) {
-			kvm_io_bus_unregister_dev(kvm,
+			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
 			kvm_iodevice_destructor(&dev->dev);
+
+			/*
+			 * On failure, unregister destroys all devices on the
+			 * bus _except_ the target device, i.e. coalesced_zones
+			 * has been modified.  No need to restart the walk as
+			 * there aren't any zones left.
+			 */
+			if (r)
+				break;
 		}
+	}
 
 	mutex_unlock(&kvm->slots_lock);
 
+	/*
+	 * Ignore the result of kvm_io_bus_unregister_dev(), from userspace's
+	 * perspective, the coalesced MMIO is most definitely unregistered.
+	 */
 	return 0;
 }
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4486,15 +4486,15 @@ int kvm_io_bus_register_dev(struct kvm *
 }
 
 /* Caller must hold slots_lock. */
-void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
-			       struct kvm_io_device *dev)
+int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
+			      struct kvm_io_device *dev)
 {
 	int i, j;
 	struct kvm_io_bus *new_bus, *bus;
 
 	bus = kvm_get_bus(kvm, bus_idx);
 	if (!bus)
-		return;
+		return 0;
 
 	for (i = 0; i < bus->dev_count; i++)
 		if (bus->range[i].dev == dev) {
@@ -4502,7 +4502,7 @@ void kvm_io_bus_unregister_dev(struct kv
 		}
 
 	if (i == bus->dev_count)
-		return;
+		return 0;
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
 			  GFP_KERNEL_ACCOUNT);
@@ -4527,7 +4527,7 @@ void kvm_io_bus_unregister_dev(struct kv
 	}
 
 	kfree(bus);
-	return;
+	return new_bus ? 0 : -ENOMEM;
 }
 
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,


