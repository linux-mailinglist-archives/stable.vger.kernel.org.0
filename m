Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BDFB1F8E
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390026AbfIMNU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390585AbfIMNU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:20:29 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C888C206A5;
        Fri, 13 Sep 2019 13:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380827;
        bh=qpbOWO+zrWgyAtT0LnYY1NoXF/KCnjnX6qTUJK2PId4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WyNf6fiNMtwuEnNDGi8Z2SANW7aIOPuN5hFzuD0YjyfUzX611B84Dbkvdgl292QHp
         6o7ORojN9yv6qt26nqXN1TiP9TzWRjQhuXT8Xhk6bnziwpNgKZlMmrLVOp8izSkQDS
         GAW0WUgGd4mfRkJo92EE79DFsU7QLs1ANUn6V5NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 169/190] powerpc/mm: Limit rma_size to 1TB when running without HV mode
Date:   Fri, 13 Sep 2019 14:07:04 +0100
Message-Id: <20190913130613.327025482@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



