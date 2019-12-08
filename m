Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A9C116238
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfLHN6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:58:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60052 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726653AbfLHNyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0007e1-DS; Sun, 08 Dec 2019 13:54:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002Mo-EY; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tiejun Chen" <tiejun.chen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date:   Sun, 08 Dec 2019 13:53:14 +0000
Message-ID: <lsq.1575813165.982457359@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 30/72] KVM: mmio: cleanup kvm_set_mmio_spte_mask
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tiejun Chen <tiejun.chen@intel.com>

commit d143148383d0395539073dd6c2f25ddf6656bdcc upstream.

Just reuse rsvd_bits() inside kvm_set_mmio_spte_mask()
for slightly better code.

Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.16 as dependency of commit 16cfacc80857
 "KVM: x86: Manually calculate reserved bits when loading PDPTRS"]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/mmu.c | 5 -----
 arch/x86/kvm/mmu.h | 5 +++++
 arch/x86/kvm/x86.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -295,11 +295,6 @@ static bool check_mmio_spte(struct kvm *
 	return likely(kvm_gen == spte_gen);
 }
 
-static inline u64 rsvd_bits(int s, int e)
-{
-	return ((1ULL << (e - s + 1)) - 1) << s;
-}
-
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask)
 {
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -56,6 +56,11 @@
 #define PFERR_RSVD_MASK (1U << PFERR_RSVD_BIT)
 #define PFERR_FETCH_MASK (1U << PFERR_FETCH_BIT)
 
+static inline u64 rsvd_bits(int s, int e)
+{
+	return ((1ULL << (e - s + 1)) - 1) << s;
+}
+
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5689,7 +5689,7 @@ static void kvm_set_mmio_spte_mask(void)
 	 * entry to generate page fault with PFER.RSV = 1.
 	 */
 	 /* Mask the reserved physical address bits. */
-	mask = ((1ull << (51 - maxphyaddr + 1)) - 1) << maxphyaddr;
+	mask = rsvd_bits(maxphyaddr, 51);
 
 	/* Bit 62 is always reserved for 32bit host. */
 	mask |= 0x3ull << 62;

