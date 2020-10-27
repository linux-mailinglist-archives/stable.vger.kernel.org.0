Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0171F29B98F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802600AbgJ0Pu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801357AbgJ0Pku (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:40:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2BFA223C6;
        Tue, 27 Oct 2020 15:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813250;
        bh=GDSMBjCL9OHw1/+EmJjPSRUJSITBmz9VBnGIrzCMWRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiZoVCHA0De1JvxD5rtrKBAD8HB3+c1zInqlhq4wamujMS80UxW5dhdsmS4UMQc00
         jbOIgcyJVQvgbEziRn4lbg6Xt+eiQR7Zbn/FiWYx24s9tqgql5UZ0/mVQsPyZsvB/W
         BBd7KXg8VJdQJ2e4jVnG5Y3IpIUBMscw6d/vCn8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 489/757] powerpc/book3s64/radix: Make radix_mem_block_size 64bit
Date:   Tue, 27 Oct 2020 14:52:19 +0100
Message-Id: <20201027135513.413505026@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 950805f4d90eda14325ceab56b0f00d034baa8bc ]

Similar to commit 89c140bbaeee ("pseries: Fix 64 bit logical memory block panic")
make sure different variables tracking lmb_size are updated to be 64 bit.

Fixes: af9d00e93a4f ("powerpc/mm/radix: Create separate mappings for hot-plugged memory")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201007114836.282468-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/mmu.h | 2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/mmu.h b/arch/powerpc/include/asm/book3s/64/mmu.h
index b392384a3b150..86173bfc39feb 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu.h
@@ -85,7 +85,7 @@ extern unsigned int mmu_base_pid;
 /*
  * memory block size used with radix translation.
  */
-extern unsigned int __ro_after_init radix_mem_block_size;
+extern unsigned long __ro_after_init radix_mem_block_size;
 
 #define PRTB_SIZE_SHIFT	(mmu_pid_bits + 4)
 #define PRTB_ENTRIES	(1ul << mmu_pid_bits)
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index d5f0c10d752a3..aae8550379bae 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -34,7 +34,7 @@
 
 unsigned int mmu_pid_bits;
 unsigned int mmu_base_pid;
-unsigned int radix_mem_block_size __ro_after_init;
+unsigned long radix_mem_block_size __ro_after_init;
 
 static __ref void *early_alloc_pgtable(unsigned long size, int nid,
 			unsigned long region_start, unsigned long region_end)
-- 
2.25.1



