Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08581796F4
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403774AbfG2Tza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404195AbfG2Tz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE3AE2054F;
        Mon, 29 Jul 2019 19:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430127;
        bh=jpiYO6UhX/+Nry9iVGij3iDA4znT7/AZPOkgIwLbhGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fE/lpywctwFWzThy8xJohc4S8PtP7Vfvy449f2OZ5k6xj5LT8zQiU2vN0zBZdvzXe
         OWoTrfQmZ6F9aS71fMfYF1U+Tl79xoi31TvPCseD8URWZ2GQ1KIMPaADPEBgH9IaM1
         T3+i/i11PfvD4kNlNQOKk1d7icPndQD7glsqKL2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 198/215] powerpc/mm: Limit rma_size to 1TB when running without HV mode
Date:   Mon, 29 Jul 2019 21:23:14 +0200
Message-Id: <20190729190814.236671780@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

commit da0ef93310e67ae6902efded60b6724dab27a5d1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/book3s64/hash_utils.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1901,11 +1901,20 @@ void hash__setup_initial_memory_limit(ph
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


