Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8262C9DBE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389475AbgLAJ1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:27:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387838AbgLAJDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00F9D22247;
        Tue,  1 Dec 2020 09:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813365;
        bh=CovXMxwo9io+S+W2Luos3DCSphJxlNAhJaZ1ZeUyvpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSZBcMc3BW+GM94mPm7FsiDwmrE/JCql/M1NjsmFWJflFg+/9GrOpWvQ7pErfuE5n
         sT1kF4lyK8nZycmOjKHqEqo3EYT+6jnfRnCRxCTL54iy9givMkgpZd+6gKaXpix5+3
         w8QfOfEwJ0+lp8E1uOxLTwuGVMYvd9q2vtLsMUZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keqian Zhu <zhukeqian1@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 5.4 15/98] KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace
Date:   Tue,  1 Dec 2020 09:52:52 +0100
Message-Id: <20201201084654.714300227@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

commit 23bde34771f1ea92fb5e6682c0d8c04304d34b3b upstream.

It was recently reported that if GICR_TYPER is accessed before the RD base
address is set, we'll suffer from the unset @rdreg dereferencing. Oops...

	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;

It's "expected" that users will access registers in the redistributor if
the RD has been properly configured (e.g., the RD base address is set). But
it hasn't yet been covered by the existing documentation.

Per discussion on the list [1], the reporting of the GICR_TYPER.Last bit
for userspace never actually worked. And it's difficult for us to emulate
it correctly given that userspace has the flexibility to access it any
time. Let's just drop the reporting of the Last bit for userspace for now
(userspace should have full knowledge about it anyway) and it at least
prevents kernel from panic ;-)

[1] https://lore.kernel.org/kvmarm/c20865a267e44d1e2c0d52ce4e012263@kernel.org/

Fixes: ba7b3f1275fd ("KVM: arm/arm64: Revisit Redistributor TYPER last bit computation")
Reported-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20201117151629.1738-1-yuzenghui@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -223,6 +223,23 @@ static unsigned long vgic_mmio_read_v3r_
 	return extract_bytes(value, addr & 7, len);
 }
 
+static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
+						 gpa_t addr, unsigned int len)
+{
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	int target_vcpu_id = vcpu->vcpu_id;
+	u64 value;
+
+	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
+	value |= ((target_vcpu_id & 0xffff) << 8);
+
+	if (vgic_has_its(vcpu->kvm))
+		value |= GICR_TYPER_PLPIS;
+
+	/* reporting of the Last bit is not supported for userspace */
+	return extract_bytes(value, addr & 7, len);
+}
+
 static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
@@ -528,8 +545,9 @@ static const struct vgic_register_region
 	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
 		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
-		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_TYPER,
+		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi,
+		vgic_uaccess_read_v3r_typer, vgic_mmio_uaccess_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,


