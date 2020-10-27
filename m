Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A3729B261
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1749921AbgJ0Oko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761466AbgJ0Ojz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25D2206B2;
        Tue, 27 Oct 2020 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809594;
        bh=1BcVye8HRxyDPFVEqpme3Hjykoavb1YY5uMUVusMe8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEXaTHX9R2SujslLq0fkYzZmc9/QtYYQT82u/DbFNuQzL/bTCg+Wg7SRrIg2FiOxW
         IAjbdefD8zRn0uvLS/hZcxYA7SToEIwf40Lwf3mhZ7bsdo7o8CP2uQx05COPRtdLx3
         x7jVAZxWU64OXQtMFecCgSox3dGOA7+UP/aijg/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Berkenpas <cam@neo-zeon.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 222/408] powerpc/book3s64/hash/4k: Support large linear mapping range with 4K
Date:   Tue, 27 Oct 2020 14:52:40 +0100
Message-Id: <20201027135505.379479621@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 7746406baa3bc9e23fdd7b7da2f04d86e25ab837 ]

With commit: 0034d395f89d ("powerpc/mm/hash64: Map all the kernel
regions in the same 0xc range"), we now split the 64TB address range
into 4 contexts each of 16TB. That implies we can do only 16TB linear
mapping.

On some systems, eg. Power9, memory attached to nodes > 0 will appear
above 16TB in the linear mapping. This resulted in kernel crash when
we boot such systems in hash translation mode with 4K PAGE_SIZE.

This patch updates the kernel mapping such that we now start supporting upto
61TB of memory with 4K. The kernel mapping now looks like below 4K PAGE_SIZE
and hash translation.

    vmalloc start     = 0xc0003d0000000000
    IO start          = 0xc0003e0000000000
    vmemmap start     = 0xc0003f0000000000

Our MAX_PHYSMEM_BITS for 4K is still 64TB even though we can only map 61TB.
We prevent bolt mapping anything outside 61TB range by checking against
H_VMALLOC_START.

Fixes: 0034d395f89d ("powerpc/mm/hash64: Map all the kernel regions in the same 0xc range")
Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200608070904.387440-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/hash-4k.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
index 3f9ae3585ab98..80c9534148821 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -13,20 +13,19 @@
  */
 #define MAX_EA_BITS_PER_CONTEXT		46
 
-#define REGION_SHIFT		(MAX_EA_BITS_PER_CONTEXT - 2)
 
 /*
- * Our page table limit us to 64TB. Hence for the kernel mapping,
- * each MAP area is limited to 16 TB.
- * The four map areas are:  linear mapping, vmap, IO and vmemmap
+ * Our page table limit us to 64TB. For 64TB physical memory, we only need 64GB
+ * of vmemmap space. To better support sparse memory layout, we use 61TB
+ * linear map range, 1TB of vmalloc, 1TB of I/O and 1TB of vmememmap.
  */
+#define REGION_SHIFT		(40)
 #define H_KERN_MAP_SIZE		(ASM_CONST(1) << REGION_SHIFT)
 
 /*
- * Define the address range of the kernel non-linear virtual area
- * 16TB
+ * Define the address range of the kernel non-linear virtual area (61TB)
  */
-#define H_KERN_VIRT_START	ASM_CONST(0xc000100000000000)
+#define H_KERN_VIRT_START	ASM_CONST(0xc0003d0000000000)
 
 #ifndef __ASSEMBLY__
 #define H_PTE_TABLE_SIZE	(sizeof(pte_t) << H_PTE_INDEX_SIZE)
-- 
2.25.1



