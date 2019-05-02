Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D6711E4C
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfEBP15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbfEBP14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:27:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC33208C4;
        Thu,  2 May 2019 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810875;
        bh=p9wiho0nLVbrFdCsWLg0R4hkONVO5o1ERRoa9QyeSr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0plwntIx1FxMn/iilRCwB5Awz5wsjCZiG5Zwu5+YK5d9h4BZUjODLpypbJv1tGl4m
         dMAZS/PczOuRAotH3tRs03UclPbOvx7NsTAShCGFSo+3JtnI09XLlBf43cX5j3G9+y
         oVmFIzrgGAJHJzLPxEGdtvBI8eEEqQSRAiZnucRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralph Campbell <rcampbell@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Craig Bergstrom <craigb@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Sean Young <sean@mess.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 63/72] x86/mm: Dont exceed the valid physical address space
Date:   Thu,  2 May 2019 17:21:25 +0200
Message-Id: <20190502143338.351579083@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 92c77f7c4d5dfaaf45b2ce19360e69977c264766 ]

valid_phys_addr_range() is used to sanity check the physical address range
of an operation, e.g., access to /dev/mem. It uses __pa(high_memory)
internally.

If memory is populated at the end of the physical address space, then
__pa(high_memory) is outside of the physical address space because:

   high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;

For the comparison in valid_phys_addr_range() this is not an issue, but if
CONFIG_DEBUG_VIRTUAL is enabled, __pa() maps to __phys_addr(), which
verifies that the resulting physical address is within the valid physical
address space of the CPU. So in the case that memory is populated at the
end of the physical address space, this is not true and triggers a
VIRTUAL_BUG_ON().

Use __pa(high_memory - 1) to prevent the conversion from going beyond
the end of valid physical addresses.

Fixes: be62a3204406 ("x86/mm: Limit mmap() of /dev/mem to valid physical addresses")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Craig Bergstrom <craigb@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Sean Young <sean@mess.org>

Link: https://lkml.kernel.org/r/20190326001817.15413-2-rcampbell@nvidia.com
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/x86/mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 1e95d57760cf..b69f7d428443 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -230,7 +230,7 @@ bool mmap_address_hint_valid(unsigned long addr, unsigned long len)
 /* Can we access it for direct reading/writing? Must be RAM: */
 int valid_phys_addr_range(phys_addr_t addr, size_t count)
 {
-	return addr + count <= __pa(high_memory);
+	return addr + count - 1 <= __pa(high_memory - 1);
 }
 
 /* Can we access it through mmap? Must be a valid physical address: */
-- 
2.19.1



