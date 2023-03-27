Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1C06CAAED
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 18:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjC0QsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 12:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjC0QsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 12:48:25 -0400
Received: from out-9.mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE91273C
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 09:48:23 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679935701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=26ASLZzvtwpxd5jfyHIWcVRSQ7YpE37eck4ePYcf8P8=;
        b=ISsGSZB/uiHcidMma7FV2pz/mGEImp5bNpnu3Lsba4ZMJkoAzpyzzpur8uTDCcL7x25enF
        pXE4844dJwJAy+LHnKxQvvdI4J/BjONjgAfYWu88BZKK9K17c0WZ+p12iA8ey4Kk0HjMaY
        gGjGWD1zmjZbk26/UuC6v5LRC8dKh5E=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.linux.dev, Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Christopherson <seanjc@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>, stable@vger.kernel.org
Subject: [PATCH v3 4/4] KVM: arm64: Use config_lock to protect vgic state
Date:   Mon, 27 Mar 2023 16:47:47 +0000
Message-Id: <20230327164747.2466958-5-oliver.upton@linux.dev>
In-Reply-To: <20230327164747.2466958-1-oliver.upton@linux.dev>
References: <20230327164747.2466958-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Almost all of the vgic state is VM-scoped but accessed from the context
of a vCPU. These accesses were serialized on the kvm->lock which cannot
be nested within a vcpu->mutex critical section.

Move over the vgic state to using the config_lock. Tweak the lock
ordering where necessary to ensure that the config_lock is acquired
after the vcpu->mutex. Acquire the config_lock in kvm_vgic_create() to
avoid a race between the converted flows and GIC creation. Where
necessary, continue to acquire kvm->lock to avoid a race with vCPU
creation (i.e. flows that use lock_all_vcpus()).

Finally, promote the locking expectations in comments to lockdep
assertions and update the locking documentation for the config_lock as
well as vcpu->mutex.

Cc: stable@vger.kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-debug.c      |  8 ++---
 arch/arm64/kvm/vgic/vgic-init.c       | 36 ++++++++++++--------
 arch/arm64/kvm/vgic/vgic-its.c        | 18 ++++++----
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 47 ++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  4 +--
 arch/arm64/kvm/vgic/vgic-mmio.c       | 12 +++----
 arch/arm64/kvm/vgic/vgic-v4.c         | 11 ++++---
 arch/arm64/kvm/vgic/vgic.c            | 12 ++++---
 8 files changed, 88 insertions(+), 60 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 78cde687383c..07aa0437125a 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -85,7 +85,7 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 	struct kvm *kvm = s->private;
 	struct vgic_state_iter *iter;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	iter = kvm->arch.vgic.iter;
 	if (iter) {
 		iter = ERR_PTR(-EBUSY);
@@ -104,7 +104,7 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 	if (end_of_vgic(iter))
 		iter = NULL;
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 	return iter;
 }
 
@@ -132,12 +132,12 @@ static void vgic_debug_stop(struct seq_file *s, void *v)
 	if (IS_ERR(v))
 		return;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	iter = kvm->arch.vgic.iter;
 	kfree(iter->lpi_array);
 	kfree(iter);
 	kvm->arch.vgic.iter = NULL;
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 }
 
 static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index cd134db41a57..9d42c7cb2b58 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -74,9 +74,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	unsigned long i;
 	int ret;
 
-	if (irqchip_in_kernel(kvm))
-		return -EEXIST;
-
 	/*
 	 * This function is also called by the KVM_CREATE_IRQCHIP handler,
 	 * which had no chance yet to check the availability of the GICv2
@@ -87,10 +84,20 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		!kvm_vgic_global_state.can_emulate_gicv2)
 		return -ENODEV;
 
+	/* Must be held to avoid race with vCPU creation */
+	lockdep_assert_held(&kvm->lock);
+
 	ret = -EBUSY;
 	if (!lock_all_vcpus(kvm))
 		return ret;
 
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (irqchip_in_kernel(kvm)) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_has_run_once(vcpu))
 			goto out_unlock;
@@ -118,6 +125,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
 out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
 	unlock_all_vcpus(kvm);
 	return ret;
 }
@@ -227,9 +235,9 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	 * KVM io device for the redistributor that belongs to this VCPU.
 	 */
 	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		mutex_lock(&vcpu->kvm->lock);
+		mutex_lock(&vcpu->kvm->arch.config_lock);
 		ret = vgic_register_redist_iodev(vcpu);
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
 	}
 	return ret;
 }
@@ -250,7 +258,6 @@ static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
  * The function is generally called when nr_spis has been explicitly set
  * by the guest through the KVM DEVICE API. If not nr_spis is set to 256.
  * vgic_initialized() returns true when this function has succeeded.
- * Must be called with kvm->lock held!
  */
 int vgic_init(struct kvm *kvm)
 {
@@ -259,6 +266,8 @@ int vgic_init(struct kvm *kvm)
 	int ret = 0, i;
 	unsigned long idx;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	if (vgic_initialized(kvm))
 		return 0;
 
@@ -373,12 +382,13 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
-/* To be called with kvm->lock held */
 static void __kvm_vgic_destroy(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	vgic_debug_destroy(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
@@ -389,9 +399,9 @@ static void __kvm_vgic_destroy(struct kvm *kvm)
 
 void kvm_vgic_destroy(struct kvm *kvm)
 {
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	__kvm_vgic_destroy(kvm);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 }
 
 /**
@@ -414,9 +424,9 @@ int vgic_lazy_init(struct kvm *kvm)
 		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2)
 			return -EBUSY;
 
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.config_lock);
 		ret = vgic_init(kvm);
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.config_lock);
 	}
 
 	return ret;
@@ -441,7 +451,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (likely(vgic_ready(kvm)))
 		return 0;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	if (vgic_ready(kvm))
 		goto out;
 
@@ -459,7 +469,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 		dist->ready = true;
 
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2642e9ce2819..7713cd06104e 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2045,6 +2045,13 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
+	if (!lock_all_vcpus(dev->kvm)) {
+		mutex_unlock(&dev->kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&dev->kvm->arch.config_lock);
+
 	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base)) {
 		ret = -ENXIO;
 		goto out;
@@ -2058,11 +2065,6 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 		goto out;
 	}
 
-	if (!lock_all_vcpus(dev->kvm)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	addr = its->vgic_its_base + offset;
 
 	len = region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
@@ -2076,8 +2078,9 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
 	} else {
 		*reg = region->its_read(dev->kvm, its, addr, len);
 	}
-	unlock_all_vcpus(dev->kvm);
 out:
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 	return ret;
 }
@@ -2757,6 +2760,8 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		return -EBUSY;
 	}
 
+	mutex_lock(&kvm->arch.config_lock);
+
 	switch (attr) {
 	case KVM_DEV_ARM_ITS_CTRL_RESET:
 		vgic_its_reset(kvm, its);
@@ -2769,6 +2774,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		break;
 	}
 
+	mutex_unlock(&kvm->arch.config_lock);
 	unlock_all_vcpus(kvm);
 	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->lock);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index edeac2380591..07e727023deb 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -46,7 +46,7 @@ int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	int r;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	switch (FIELD_GET(KVM_ARM_DEVICE_TYPE_MASK, dev_addr->id)) {
 	case KVM_VGIC_V2_ADDR_TYPE_DIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
@@ -68,7 +68,7 @@ int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev
 		r = -ENODEV;
 	}
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 
 	return r;
 }
@@ -102,7 +102,7 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 		if (get_user(addr, uaddr))
 			return -EFAULT;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	switch (attr->attr) {
 	case KVM_VGIC_V2_ADDR_TYPE_DIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
@@ -191,7 +191,7 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_device_attr *attr, bool wri
 	}
 
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 
 	if (!r && !write)
 		r =  put_user(addr, uaddr);
@@ -227,7 +227,7 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 		    (val & 31))
 			return -EINVAL;
 
-		mutex_lock(&dev->kvm->lock);
+		mutex_lock(&dev->kvm->arch.config_lock);
 
 		if (vgic_ready(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
 			ret = -EBUSY;
@@ -235,16 +235,16 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 			dev->kvm->arch.vgic.nr_spis =
 				val - VGIC_NR_PRIVATE_IRQS;
 
-		mutex_unlock(&dev->kvm->lock);
+		mutex_unlock(&dev->kvm->arch.config_lock);
 
 		return ret;
 	}
 	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			mutex_lock(&dev->kvm->lock);
+			mutex_lock(&dev->kvm->arch.config_lock);
 			r = vgic_init(dev->kvm);
-			mutex_unlock(&dev->kvm->lock);
+			mutex_unlock(&dev->kvm->arch.config_lock);
 			return r;
 		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 			/*
@@ -260,7 +260,10 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 				mutex_unlock(&dev->kvm->lock);
 				return -EBUSY;
 			}
+
+			mutex_lock(&dev->kvm->arch.config_lock);
 			r = vgic_v3_save_pending_tables(dev->kvm);
+			mutex_unlock(&dev->kvm->arch.config_lock);
 			unlock_all_vcpus(dev->kvm);
 			mutex_unlock(&dev->kvm->lock);
 			return r;
@@ -411,15 +414,17 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
+	if (!lock_all_vcpus(dev->kvm)) {
+		mutex_unlock(&dev->kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&dev->kvm->arch.config_lock);
+
 	ret = vgic_init(dev->kvm);
 	if (ret)
 		goto out;
 
-	if (!lock_all_vcpus(dev->kvm)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
 		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &val);
@@ -432,8 +437,9 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
 		break;
 	}
 
-	unlock_all_vcpus(dev->kvm);
 out:
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 
 	if (!ret && !is_write)
@@ -569,12 +575,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (unlikely(!vgic_initialized(dev->kvm))) {
-		ret = -EBUSY;
-		goto out;
+	if (!lock_all_vcpus(dev->kvm)) {
+		mutex_unlock(&dev->kvm->lock);
+		return -EBUSY;
 	}
 
-	if (!lock_all_vcpus(dev->kvm)) {
+	mutex_lock(&dev->kvm->arch.config_lock);
+
+	if (unlikely(!vgic_initialized(dev->kvm))) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -609,8 +617,9 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		break;
 	}
 
-	unlock_all_vcpus(dev->kvm);
 out:
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
 
 	if (!ret && uaccess && !is_write) {
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 91201f743033..472b18ac92a2 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -111,7 +111,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 	case GICD_CTLR: {
 		bool was_enabled, is_hwsgi;
 
-		mutex_lock(&vcpu->kvm->lock);
+		mutex_lock(&vcpu->kvm->arch.config_lock);
 
 		was_enabled = dist->enabled;
 		is_hwsgi = dist->nassgireq;
@@ -139,7 +139,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		else if (!was_enabled && dist->enabled)
 			vgic_kick_vcpus(vcpu->kvm);
 
-		mutex_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
 		break;
 	}
 	case GICD_TYPER:
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index e67b3b2c8044..1939c94e0b24 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -530,13 +530,13 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 val;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	val = __vgic_mmio_read_active(vcpu, addr, len);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return val;
 }
@@ -625,13 +625,13 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_cactive(vcpu, addr, len, val);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 }
 
 int vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
@@ -662,13 +662,13 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_sactive(vcpu, addr, len, val);
 
 	vgic_access_active_finish(vcpu, intid);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 }
 
 int vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index a413718be92b..3bb003478060 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -232,9 +232,8 @@ int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq)
  * @kvm:	Pointer to the VM being initialized
  *
  * We may be called each time a vITS is created, or when the
- * vgic is initialized. This relies on kvm->lock to be
- * held. In both cases, the number of vcpus should now be
- * fixed.
+ * vgic is initialized. In both cases, the number of vcpus
+ * should now be fixed.
  */
 int vgic_v4_init(struct kvm *kvm)
 {
@@ -243,6 +242,8 @@ int vgic_v4_init(struct kvm *kvm)
 	int nr_vcpus, ret;
 	unsigned long i;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	if (!kvm_vgic_global_state.has_gicv4)
 		return 0; /* Nothing to see here... move along. */
 
@@ -309,14 +310,14 @@ int vgic_v4_init(struct kvm *kvm)
 /**
  * vgic_v4_teardown - Free the GICv4 data structures
  * @kvm:	Pointer to the VM being destroyed
- *
- * Relies on kvm->lock to be held.
  */
 void vgic_v4_teardown(struct kvm *kvm)
 {
 	struct its_vm *its_vm = &kvm->arch.vgic.its_vm;
 	int i;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	if (!its_vm->vpes)
 		return;
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d97e6080b421..0a005da83ae6 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -24,11 +24,13 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
 /*
  * Locking order is always:
  * kvm->lock (mutex)
- *   its->cmd_lock (mutex)
- *     its->its_lock (mutex)
- *       vgic_cpu->ap_list_lock		must be taken with IRQs disabled
- *         kvm->lpi_list_lock		must be taken with IRQs disabled
- *           vgic_irq->irq_lock		must be taken with IRQs disabled
+ *   vcpu->mutex (mutex)
+ *     kvm->arch.config_lock (mutex)
+ *       its->cmd_lock (mutex)
+ *         its->its_lock (mutex)
+ *           vgic_cpu->ap_list_lock		must be taken with IRQs disabled
+ *             kvm->lpi_list_lock		must be taken with IRQs disabled
+ *               vgic_irq->irq_lock		must be taken with IRQs disabled
  *
  * As the ap_list_lock might be taken from the timer interrupt handler,
  * we have to disable IRQs before taking this lock and everything lower
-- 
2.40.0.348.gf938b09366-goog

