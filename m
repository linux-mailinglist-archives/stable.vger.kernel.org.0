Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FCE2DD296
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 15:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgLQOEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 09:04:22 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:42116 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgLQOEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 09:04:22 -0500
X-Greylist: delayed 1029 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2020 09:04:21 EST
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1kptcO-0007O0-36; Thu, 17 Dec 2020 14:46:56 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org
Subject: [PATCH] KVM: mmu: Fix SPTE encoding of MMIO generation upper half
Date:   Thu, 17 Dec 2020 14:46:49 +0100
Message-Id: <f5cb26d9a45cbaf617928d1314e7c0efea597e05.1608169775.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1607955407131211@kroah.com>
References: <1607955407131211@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
cleaned up the computation of MMIO generation SPTE masks, however it
introduced a bug how the upper part was encoded:
SPTE bits 52-61 were supposed to contain bits 10-19 of the current
generation number, however a missing shift encoded bits 1-10 there instead
(mostly duplicating the lower part of the encoded generation number that
then consisted of bits 1-9).

In the meantime, the upper part was shrunk by one bit and moved by
subsequent commits to become an upper half of the encoded generation number
(bits 9-17 of bits 0-17 encoded in a SPTE).

In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
has changed the SPTE bit range assigned to encode the generation number and
the total number of bits encoded but did not update them in the comment
attached to their defines, nor in the KVM MMU doc.
Let's do it here, too, since it is too trivial thing to warrant a separate
commit.

This is a backport of the upstream commit for 5.9.x stable series, in which
the x86 KVM MMU SPTE handling isn't yet split out to spte.{c,h} files.
Other than that, it's a straightforward port.

Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
[Reorganize macros so that everything is computed from the bit ranges. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit 34c0f6f2695a2db81e09a3ab7bdb2853f45d4d3d)
Cc: stable@vger.kernel.org # 5.9.x
---
 Documentation/virt/kvm/mmu.rst |  2 +-
 arch/x86/kvm/mmu/mmu.c         | 29 ++++++++++++++++++++---------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 1c030dbac7c4..5bfe28b0728e 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -455,7 +455,7 @@ If the generation number of the spte does not equal the global generation
 number, it will ignore the cached MMIO information and handle the page
 fault through the slow path.
 
-Since only 19 bits are used to store generation-number on mmio spte, all
+Since only 18 bits are used to store generation-number on mmio spte, all
 pages are zapped when there is an overflow.
 
 Unfortunately, a single memory access might access kvm_memslots(kvm) multiple
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d0ca3ab38952..c1b48d04a306 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -402,11 +402,11 @@ static inline bool is_access_track_spte(u64 spte)
 }
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
  * the memslots generation and is derived as follows:
  *
  * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-18 of the MMIO generation are propagated to spte bits 52-61
+ * Bits 9-17 of the MMIO generation are propagated to spte bits 54-62
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -415,18 +415,29 @@ static inline bool is_access_track_spte(u64 spte)
  * requires a full MMU zap).  The flag is instead explicitly queried when
  * checking for MMIO spte cache hits.
  */
-#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
 
 #define MMIO_SPTE_GEN_LOW_START		3
 #define MMIO_SPTE_GEN_LOW_END		11
-#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
-						    MMIO_SPTE_GEN_LOW_START)
 
 #define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
 #define MMIO_SPTE_GEN_HIGH_END		62
+
+#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
+						    MMIO_SPTE_GEN_LOW_START)
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
 
+#define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
+#define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
+
+/* remember to adjust the comment above as well if you change these */
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 9);
+
+#define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
+#define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
+
+#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
+
 static u64 generation_mmio_spte_mask(u64 gen)
 {
 	u64 mask;
@@ -434,8 +445,8 @@ static u64 generation_mmio_spte_mask(u64 gen)
 	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
 	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
 
-	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
-	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
+	mask = (gen << MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_SPTE_GEN_LOW_MASK;
+	mask |= (gen << MMIO_SPTE_GEN_HIGH_SHIFT) & MMIO_SPTE_GEN_HIGH_MASK;
 	return mask;
 }
 
@@ -443,8 +454,8 @@ static u64 get_mmio_spte_generation(u64 spte)
 {
 	u64 gen;
 
-	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
-	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
+	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_SHIFT;
+	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_SHIFT;
 	return gen;
 }
 
