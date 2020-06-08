Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE41F2D00
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgFIA37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728862AbgFHXQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3632076C;
        Mon,  8 Jun 2020 23:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658160;
        bh=0pJkwuUJeLHTMORoq0l+vm0Yg1I8SYu5Hf8DC4q398M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m00qGvis09D4Pzp0TJhUgRYxDCl3U+8NUicV6i5mPYfpb1z6IZ6nd3Srf8tWM35XI
         MCXAUAZmK+DxO5DW0o3p/Uhu8ySRb5idkXhkZDrhUvrElWE+mMk8iuP9fMahjTKTkh
         u9bA0OW3z8b8IpImO/W99iaPM3E6YQuwfk3/sqIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        kbuild test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Anatoly Pugachev <matorola@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 190/606] sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()
Date:   Mon,  8 Jun 2020 19:05:15 -0400
Message-Id: <20200608231211.3363633-190-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit c2bc26f7ca1ff1165bb6669a7a4cccc20ffd2ced upstream.

The kbuild test robot reported the following warning:

  arch/sparc/mm/srmmu.c: In function 'srmmu_nocache_init': arch/sparc/mm/srmmu.c:300:9: error: variable 'pud' set but not used [-Werror=unused-but-set-variable]
  300 |  pud_t *pud;

This warning is caused by misprint in the page table traversal in
srmmu_nocache_init() function which accessed a PMD entry using PGD
rather than PUD.

Since sparc32 has only 3 page table levels, the PGD and PUD are
essentially the same and usage of __nocache_fix() removed the type
checking.

Use PUD for the consistency and to silence the compiler warning.

Fixes: 7235db268a2777bc38 ("sparc32: use pgtable-nopud instead of 4level-fixup")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anatoly Pugachev <matorola@gmail.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200520132005.GM1059226@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/srmmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index f56c3c9a9793..083ba02c94e6 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -333,7 +333,7 @@ static void __init srmmu_nocache_init(void)
 		pgd = pgd_offset_k(vaddr);
 		p4d = p4d_offset(__nocache_fix(pgd), vaddr);
 		pud = pud_offset(__nocache_fix(p4d), vaddr);
-		pmd = pmd_offset(__nocache_fix(pgd), vaddr);
+		pmd = pmd_offset(__nocache_fix(pud), vaddr);
 		pte = pte_offset_kernel(__nocache_fix(pmd), vaddr);
 
 		pteval = ((paddr >> 4) | SRMMU_ET_PTE | SRMMU_PRIV);
-- 
2.25.1

