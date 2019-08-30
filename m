Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7654A2D2D
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 05:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfH3DLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 23:11:42 -0400
Received: from smtpbgbr2.qq.com ([54.207.22.56]:37565 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfH3DLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 23:11:41 -0400
X-QQ-mid: bizesmtp19t1567134684ts7kai77
Received: from localhost.localdomain (unknown [218.76.23.26])
        by esmtp10.qq.com (ESMTP) with 
        id ; Fri, 30 Aug 2019 11:11:21 +0800 (CST)
X-QQ-SSF: 01400000000000J0NG52B00A0000000
X-QQ-FEAT: WprnQFiC4i7wt9xCzpbWIKtcSzJD2CcXr65d/Hyk24ASsOPOOYqg18wj+zczL
        6+5z/+IPaAWMlSqpoLhu4WZnxl7X+iNFs3SQxEI7iEunuqMHmggxQIY4tj2VAQOQ2KZMzRb
        UwpSOXGwCCt45zUCX4bvHXCYfai9TlKB3LfgJLJ+YWc9h5iKJs2UMkoNMT2wDB/Y35Pnfs0
        BuzkZba25jhxGzO/JoYEfZd+ZemBZD+ZuLB4AnTduGgUtYlrC+7WSUZz3WWusNYTEuRUZQO
        PMT0cu4qAnGtc3cUyaXj1WxzR+8ECR34BNClKQI/ciJGV1GEPS2CpvonXjIEyWXcjfSNfu1
        Gub1CsMZB8d7BcIll4=
X-QQ-GoodBg: 2
From:   Ke Sun <sunke@kylinos.cn>
To:     sunke@kylinos.cn
Cc:     Andre Przywara <andre.przywara@arm.com>, stable@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v1 03/38] KVM: arm/arm64: vgic: Prevent access to invalid SPIs
Date:   Fri, 30 Aug 2019 11:10:28 +0800
Message-Id: <20190830031103.15927-4-sunke@kylinos.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830031103.15927-1-sunke@kylinos.cn>
References: <20190830031103.15927-1-sunke@kylinos.cn>
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

In our VGIC implementation we limit the number of SPIs to a number
that the userland application told us. Accordingly we limit the
allocation of memory for virtual IRQs to that number.
However in our MMIO dispatcher we didn't check if we ever access an
IRQ beyond that limit, leading to out-of-bound accesses.
Add a test against the number of allocated SPIs in check_region().
Adjust the VGIC_ADDR_TO_INT macro to avoid an actual division, which
is not implemented on ARM(32).

[maz: cleaned-up original patch]

Cc: stable@vger.kernel.org
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 41 +++++++++++++++++++++++------------
 virt/kvm/arm/vgic/vgic-mmio.h | 14 ++++++------
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 3bad3c5ed..d1b080ca8 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -453,17 +453,33 @@ struct vgic_io_device *kvm_to_vgic_iodev(const struct kvm_io_device *dev)
 	return container_of(dev, struct vgic_io_device, dev);
 }
 
-static bool check_region(const struct vgic_register_region *region,
+static bool check_region(const struct kvm *kvm,
+			 const struct vgic_register_region *region,
 			 gpa_t addr, int len)
 {
-	if ((region->access_flags & VGIC_ACCESS_8bit) && len == 1)
-		return true;
-	if ((region->access_flags & VGIC_ACCESS_32bit) &&
-	    len == sizeof(u32) && !(addr & 3))
-		return true;
-	if ((region->access_flags & VGIC_ACCESS_64bit) &&
-	    len == sizeof(u64) && !(addr & 7))
-		return true;
+	int flags, nr_irqs = kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+
+	switch (len) {
+	case sizeof(u8):
+		flags = VGIC_ACCESS_8bit;
+		break;
+	case sizeof(u32):
+		flags = VGIC_ACCESS_32bit;
+		break;
+	case sizeof(u64):
+		flags = VGIC_ACCESS_64bit;
+		break;
+	default:
+		return false;
+	}
+
+	if ((region->access_flags & flags) && IS_ALIGNED(addr, len)) {
+		if (!region->bits_per_irq)
+			return true;
+
+		/* Do we access a non-allocated IRQ? */
+		return VGIC_ADDR_TO_INTID(addr, region->bits_per_irq) < nr_irqs;
+	}
 
 	return false;
 }
@@ -477,7 +493,7 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
 				       addr - iodev->base_addr);
-	if (!region || !check_region(region, addr, len)) {
+	if (!region || !check_region(vcpu->kvm, region, addr, len)) {
 		memset(val, 0, len);
 		return 0;
 	}
@@ -510,10 +526,7 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
 				       addr - iodev->base_addr);
-	if (!region)
-		return 0;
-
-	if (!check_region(region, addr, len))
+	if (!region || !check_region(vcpu->kvm, region, addr, len))
 		return 0;
 
 	switch (iodev->iodev_type) {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 0b3ecf9d1..ba63d91d2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -50,15 +50,15 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
 #define VGIC_ADDR_IRQ_MASK(bits) (((bits) * 1024 / 8) - 1)
 
 /*
- * (addr & mask) gives us the byte offset for the INT ID, so we want to
- * divide this with 'bytes per irq' to get the INT ID, which is given
- * by '(bits) / 8'.  But we do this with fixed-point-arithmetic and
- * take advantage of the fact that division by a fraction equals
- * multiplication with the inverted fraction, and scale up both the
- * numerator and denominator with 8 to support at most 64 bits per IRQ:
+ * (addr & mask) gives us the _byte_ offset for the INT ID.
+ * We multiply this by 8 the get the _bit_ offset, then divide this by
+ * the number of bits to learn the actual INT ID.
+ * But instead of a division (which requires a "long long div" implementation),
+ * we shift by the binary logarithm of <bits>.
+ * This assumes that <bits> is a power of two.
  */
 #define VGIC_ADDR_TO_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
-					64 / (bits) / 8)
+					8 >> ilog2(bits))
 
 /*
  * Some VGIC registers store per-IRQ information, with a different number
-- 
2.17.1



