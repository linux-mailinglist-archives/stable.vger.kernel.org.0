Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF0A12EC0A
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgABWOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgABWOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750D121D7D;
        Thu,  2 Jan 2020 22:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003277;
        bh=y39XHn13WKrb3P2w/HCNKsTKr5QrxtrqjPkgUGvJwbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4KxmqRGmAw4aPgAHyZhawTxSKNC8n0tvTFBTLt4sl/9VBg2FUO3bV3kkBcNTKluz
         y4jXiO/YlXJiHCm/+G9dJscX8gsY2OZdep9R37fZUO+QTohLpW4WHpQOHeyb3ndJ+r
         B4j2BHxCTBAJyic9cDzQp97AUSOXrvibVbwQsokA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/191] powerpc/fixmap: Use __fix_to_virt() instead of fix_to_virt()
Date:   Thu,  2 Jan 2020 23:06:08 +0100
Message-Id: <20200102215839.149918121@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 77693a5fb57be4606a6024ec8e3076f9499b906b ]

Modify back __set_fixmap() to using __fix_to_virt() instead
of fix_to_virt() otherwise the following happens because it
seems GCC doesn't see idx as a builtin const.

  CC      mm/early_ioremap.o
In file included from ./include/linux/kernel.h:11:0,
                 from mm/early_ioremap.c:11:
In function ‘fix_to_virt’,
    inlined from ‘__set_fixmap’ at ./arch/powerpc/include/asm/fixmap.h:87:2,
    inlined from ‘__early_ioremap’ at mm/early_ioremap.c:156:4:
./include/linux/compiler.h:350:38: error: call to ‘__compiletime_assert_32’ declared with attribute error: BUILD_BUG_ON failed: idx >= __end_of_fixed_addresses
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                      ^
./include/linux/compiler.h:331:4: note: in definition of macro ‘__compiletime_assert’
    prefix ## suffix();    \
    ^
./include/linux/compiler.h:350:2: note: in expansion of macro ‘_compiletime_assert’
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^
./include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^
./include/linux/build_bug.h:50:2: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
  ^
./include/asm-generic/fixmap.h:32:2: note: in expansion of macro ‘BUILD_BUG_ON’
  BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
  ^

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 4cfac2f9c7f1 ("powerpc/mm: Simplify __set_fixmap()")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/f4984c615f90caa3277775a68849afeea846850d.1568295907.git.christophe.leroy@c-s.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/fixmap.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/fixmap.h b/arch/powerpc/include/asm/fixmap.h
index 0cfc365d814b..722289a1d000 100644
--- a/arch/powerpc/include/asm/fixmap.h
+++ b/arch/powerpc/include/asm/fixmap.h
@@ -77,7 +77,12 @@ enum fixed_addresses {
 static inline void __set_fixmap(enum fixed_addresses idx,
 				phys_addr_t phys, pgprot_t flags)
 {
-	map_kernel_page(fix_to_virt(idx), phys, flags);
+	if (__builtin_constant_p(idx))
+		BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
+	else if (WARN_ON(idx >= __end_of_fixed_addresses))
+		return;
+
+	map_kernel_page(__fix_to_virt(idx), phys, flags);
 }
 
 #endif /* !__ASSEMBLY__ */
-- 
2.20.1



