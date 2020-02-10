Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AF1157A96
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgBJNXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:23:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbgBJMhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:09 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B5624680;
        Mon, 10 Feb 2020 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338228;
        bh=0hUqVKT7/W0yjEgpVt1a7FXsMlToeWZgxqCMyLt2ZmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRg44rM4CgG5p4wPhOZ6elEHZ0NqXW1RTxlBLX0cxaGn/B4o5TkyMzNWsKCw5UXPv
         la7LZJ5oqEhu9TdsNJ5R1ipZbEzx/JQglBwO9+JRsSjEI8sdY2whIiuHHkI97SAKse
         k5PHXIsAKdR44HYPK+kZnRMZkQfhg3QKJ0Lftiss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 069/309] KVM: arm64: Only sign-extend MMIO up to register width
Date:   Mon, 10 Feb 2020 04:30:25 -0800
Message-Id: <20200210122412.532185578@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

commit b6ae256afd32f96bec0117175b329d0dd617655e upstream.

On AArch64 you can do a sign-extended load to either a 32-bit or 64-bit
register, and we should only sign extend the register up to the width of
the register as specified in the operation (by using the 32-bit Wn or
64-bit Xn register specifier).

As it turns out, the architecture provides this decoding information in
the SF ("Sixty-Four" -- how cute...) bit.

Let's take advantage of this with the usual 32-bit/64-bit header file
dance and do the right thing on AArch64 hosts.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191212195055.5541-1-christoffer.dall@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/kvm_emulate.h   |    5 +++++
 arch/arm/include/asm/kvm_mmio.h      |    2 ++
 arch/arm64/include/asm/kvm_emulate.h |    5 +++++
 arch/arm64/include/asm/kvm_mmio.h    |    6 ++----
 virt/kvm/arm/mmio.c                  |    6 ++++++
 5 files changed, 20 insertions(+), 4 deletions(-)

--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -194,6 +194,11 @@ static inline bool kvm_vcpu_dabt_issext(
 	return kvm_vcpu_get_hsr(vcpu) & HSR_SSE;
 }
 
+static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline int kvm_vcpu_dabt_get_rd(struct kvm_vcpu *vcpu)
 {
 	return (kvm_vcpu_get_hsr(vcpu) & HSR_SRT_MASK) >> HSR_SRT_SHIFT;
--- a/arch/arm/include/asm/kvm_mmio.h
+++ b/arch/arm/include/asm/kvm_mmio.h
@@ -14,6 +14,8 @@
 struct kvm_decode {
 	unsigned long rt;
 	bool sign_extend;
+	/* Not used on 32-bit arm */
+	bool sixty_four;
 };
 
 void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -295,6 +295,11 @@ static inline bool kvm_vcpu_dabt_issext(
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SSE);
 }
 
+static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
+{
+	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SF);
+}
+
 static inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 {
 	return (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
--- a/arch/arm64/include/asm/kvm_mmio.h
+++ b/arch/arm64/include/asm/kvm_mmio.h
@@ -10,13 +10,11 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_arm.h>
 
-/*
- * This is annoying. The mmio code requires this, even if we don't
- * need any decoding. To be fixed.
- */
 struct kvm_decode {
 	unsigned long rt;
 	bool sign_extend;
+	/* Witdth of the register accessed by the faulting instruction is 64-bits */
+	bool sixty_four;
 };
 
 void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -105,6 +105,9 @@ int kvm_handle_mmio_return(struct kvm_vc
 			data = (data ^ mask) - mask;
 		}
 
+		if (!vcpu->arch.mmio_decode.sixty_four)
+			data = data & 0xffffffff;
+
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
 			       &data);
 		data = vcpu_data_host_to_guest(vcpu, data, len);
@@ -125,6 +128,7 @@ static int decode_hsr(struct kvm_vcpu *v
 	unsigned long rt;
 	int access_size;
 	bool sign_extend;
+	bool sixty_four;
 
 	if (kvm_vcpu_dabt_iss1tw(vcpu)) {
 		/* page table accesses IO mem: tell guest to fix its TTBR */
@@ -138,11 +142,13 @@ static int decode_hsr(struct kvm_vcpu *v
 
 	*is_write = kvm_vcpu_dabt_iswrite(vcpu);
 	sign_extend = kvm_vcpu_dabt_issext(vcpu);
+	sixty_four = kvm_vcpu_dabt_issf(vcpu);
 	rt = kvm_vcpu_dabt_get_rd(vcpu);
 
 	*len = access_size;
 	vcpu->arch.mmio_decode.sign_extend = sign_extend;
 	vcpu->arch.mmio_decode.rt = rt;
+	vcpu->arch.mmio_decode.sixty_four = sixty_four;
 
 	return 0;
 }


