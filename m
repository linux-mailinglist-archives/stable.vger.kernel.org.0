Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2055FA6F7E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbfICQbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731303AbfICQbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:31:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C829B238F5;
        Tue,  3 Sep 2019 16:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528311;
        bh=Rc0nyCb11rtoLwKBSMsZv14/IRpM9ByxOTtCoc7QxmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wq6xJFgitu45ILS7zCsZPDOuyGMQU4rTRapwTtf/tPW0E7KVLR3TgEprQ2zzSiuYo
         Ukd07FOer0vvRzVe0CS+uU+GzLjDbltJcY5XDcMavKAaBcsvwnoWt2glBruJtjJzaZ
         Mtf/sqbtANuPvhkKumUsdbhpCCEdPgg4S1Al0GTs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 149/167] powerpc/mm: Limit rma_size to 1TB when running without HV mode
Date:   Tue,  3 Sep 2019 12:25:01 -0400
Message-Id: <20190903162519.7136-149-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

[ Upstream commit da0ef93310e67ae6902efded60b6724dab27a5d1 ]

The virtual real mode addressing (VRMA) mechanism is used when a
partition is using HPT (Hash Page Table) translation and performs real
mode accesses (MSR[IR|DR] = 0) in non-hypervisor mode. In this mode
effective address bits 0:23 are treated as zero (i.e. the access is
aliased to 0) and the access is performed using an implicit 1TB SLB
entry.

The size of the RMA (Real Memory Area) is communicated to the guest as
the size of the first memory region in the device tree. And because of
the mechanism described above can be expected to not exceed 1TB. In
the event that the host erroneously represents the RMA as being larger
than 1TB, guest accesses in real mode to memory addresses above 1TB
will be aliased down to below 1TB. This means that a memory access
performed in real mode may differ to one performed in virtual mode for
the same memory address, which would likely have unintended
consequences.

To avoid this outcome have the guest explicitly limit the size of the
RMA to the current maximum, which is 1TB. This means that even if the
first memory block is larger than 1TB, only the first 1TB should be
accessed in real mode.

Fixes: c610d65c0ad0 ("powerpc/pseries: lift RTAS limit for hash")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Tested-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190710052018.14628-1-sjitindarsingh@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/hash_utils_64.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index f23a89d8e4ce6..29fd8940867e5 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -1859,11 +1859,20 @@ void hash__setup_initial_memory_limit(phys_addr_t first_memblock_base,
 	 *
 	 * For guests on platforms before POWER9, we clamp the it limit to 1G
 	 * to avoid some funky things such as RTAS bugs etc...
+	 *
+	 * On POWER9 we limit to 1TB in case the host erroneously told us that
+	 * the RMA was >1TB. Effective address bits 0:23 are treated as zero
+	 * (meaning the access is aliased to zero i.e. addr = addr % 1TB)
+	 * for virtual real mode addressing and so it doesn't make sense to
+	 * have an area larger than 1TB as it can't be addressed.
 	 */
 	if (!early_cpu_has_feature(CPU_FTR_HVMODE)) {
 		ppc64_rma_size = first_memblock_size;
 		if (!early_cpu_has_feature(CPU_FTR_ARCH_300))
 			ppc64_rma_size = min_t(u64, ppc64_rma_size, 0x40000000);
+		else
+			ppc64_rma_size = min_t(u64, ppc64_rma_size,
+					       1UL << SID_SHIFT_1T);
 
 		/* Finally limit subsequent allocations */
 		memblock_set_current_limit(ppc64_rma_size);
-- 
2.20.1

