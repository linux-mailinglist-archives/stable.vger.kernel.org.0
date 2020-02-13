Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA7415C2F8
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgBMPiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387813AbgBMP3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:11 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C002624677;
        Thu, 13 Feb 2020 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607749;
        bh=9TzQP5GwF4uTtO1+JG5dhg7Vcb7eHZ1g0mrxjSP/EG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoGDJF9Vj00geVP8tWVhrOXAZRRyBD7lm8U8FmDOmgRIGQUplD5FJpZ+PwcnV5n6X
         GvmY9gwVWwrW3AzCMTQXwPa7XjNDhLYsxBgW38JJdSRFhuwfht6lAKf8jpXa+BUUms
         TdSrt4jGogo7+X01xjCr2UEWpmP/rdK8XA1tnaiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.5 092/120] arm64: kvm: Fix IDMAP overlap with HYP VA
Date:   Thu, 13 Feb 2020 07:21:28 -0800
Message-Id: <20200213151932.068698138@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit f5523423defb0d929e23813c8dd16c0131043a8c upstream.

Booting 5.4 on LX2160A reveals that KVM is non-functional:

kvm: Limiting the IPA size due to kernel Virtual Address limit
kvm [1]: IPA Size Limit: 43bits
kvm [1]: IDMAP intersecting with HYP VA, unable to continue
kvm [1]: error initializing Hyp mode: -22

Debugging shows:

kvm [1]: IDMAP page: 81a26000
kvm [1]: HYP VA range: 0:22ffffffff

as RAM is located at:

80000000-fbdfffff : System RAM
2080000000-237fffffff : System RAM

Comparing this with the same kernel on Armada 8040 shows:

kvm: Limiting the IPA size due to kernel Virtual Address limit
kvm [1]: IPA Size Limit: 43bits
kvm [1]: IDMAP page: 2a26000
kvm [1]: HYP VA range: 4800000000:493fffffff
...
kvm [1]: Hyp mode initialized successfully

which indicates that hyp_va_msb is set, and is always set to the
opposite value of the idmap page to avoid the overlap. This does not
happen with the LX2160A.

Further debugging shows vabits_actual = 39, kva_msb = 38 on LX2160A and
kva_msb = 33 on Armada 8040. Looking at the bit layout of the HYP VA,
there is still one bit available for hyp_va_msb. Set this bit
appropriately. This allows KVM to be functional on the LX2160A, but
without any HYP VA randomisation:

kvm: Limiting the IPA size due to kernel Virtual Address limit
kvm [1]: IPA Size Limit: 43bits
kvm [1]: IDMAP page: 81a24000
kvm [1]: HYP VA range: 4000000000:62ffffffff
...
kvm [1]: Hyp mode initialized successfully

Fixes: ed57cac83e05 ("arm64: KVM: Introduce EL2 VA randomisation")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
[maz: small additional cleanups, preserved case where the tag
 is legitimately 0 and we can just use the mask, Fixes tag]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/E1ilAiY-0000MA-RG@rmk-PC.armlinux.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/va_layout.c |   56 ++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -13,52 +13,46 @@
 #include <asm/kvm_mmu.h>
 
 /*
- * The LSB of the random hyp VA tag or 0 if no randomization is used.
+ * The LSB of the HYP VA tag
  */
 static u8 tag_lsb;
 /*
- * The random hyp VA tag value with the region bit if hyp randomization is used
+ * The HYP VA tag value with the region bit
  */
 static u64 tag_val;
 static u64 va_mask;
 
+/*
+ * We want to generate a hyp VA with the following format (with V ==
+ * vabits_actual):
+ *
+ *  63 ... V |     V-1    | V-2 .. tag_lsb | tag_lsb - 1 .. 0
+ *  ---------------------------------------------------------
+ * | 0000000 | hyp_va_msb |   random tag   |  kern linear VA |
+ *           |--------- tag_val -----------|----- va_mask ---|
+ *
+ * which does not conflict with the idmap regions.
+ */
 __init void kvm_compute_layout(void)
 {
 	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
 	u64 hyp_va_msb;
-	int kva_msb;
 
 	/* Where is my RAM region? */
 	hyp_va_msb  = idmap_addr & BIT(vabits_actual - 1);
 	hyp_va_msb ^= BIT(vabits_actual - 1);
 
-	kva_msb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
+	tag_lsb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
 			(u64)(high_memory - 1));
 
-	if (kva_msb == (vabits_actual - 1)) {
-		/*
-		 * No space in the address, let's compute the mask so
-		 * that it covers (vabits_actual - 1) bits, and the region
-		 * bit. The tag stays set to zero.
-		 */
-		va_mask  = BIT(vabits_actual - 1) - 1;
-		va_mask |= hyp_va_msb;
-	} else {
-		/*
-		 * We do have some free bits to insert a random tag.
-		 * Hyp VAs are now created from kernel linear map VAs
-		 * using the following formula (with V == vabits_actual):
-		 *
-		 *  63 ... V |     V-1    | V-2 .. tag_lsb | tag_lsb - 1 .. 0
-		 *  ---------------------------------------------------------
-		 * | 0000000 | hyp_va_msb |    random tag  |  kern linear VA |
-		 */
-		tag_lsb = kva_msb;
-		va_mask = GENMASK_ULL(tag_lsb - 1, 0);
-		tag_val = get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
-		tag_val |= hyp_va_msb;
-		tag_val >>= tag_lsb;
+	va_mask = GENMASK_ULL(tag_lsb - 1, 0);
+	tag_val = hyp_va_msb;
+
+	if (tag_lsb != (vabits_actual - 1)) {
+		/* We have some free bits to insert a random tag. */
+		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
 	}
+	tag_val >>= tag_lsb;
 }
 
 static u32 compute_instruction(int n, u32 rd, u32 rn)
@@ -117,11 +111,11 @@ void __init kvm_update_va_mask(struct al
 		 * VHE doesn't need any address translation, let's NOP
 		 * everything.
 		 *
-		 * Alternatively, if we don't have any spare bits in
-		 * the address, NOP everything after masking that
-		 * kernel VA.
+		 * Alternatively, if the tag is zero (because the layout
+		 * dictates it and we don't have any spare bits in the
+		 * address), NOP everything after masking the kernel VA.
 		 */
-		if (has_vhe() || (!tag_lsb && i > 0)) {
+		if (has_vhe() || (!tag_val && i > 0)) {
 			updptr[i] = cpu_to_le32(aarch64_insn_gen_nop());
 			continue;
 		}


