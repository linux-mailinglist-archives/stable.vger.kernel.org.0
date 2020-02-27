Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87AD3171DD5
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389201AbgB0OO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:14:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389213AbgB0OO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:14:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3C520801;
        Thu, 27 Feb 2020 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812896;
        bh=lqpYNNcrPhcEJCoVEm5zSXwt3P8XbK0+uztpjf3ftmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RF+R/LW5iD0KvWYtjNTN04RcafeBZ8yVIxmgQijbKlWxyD20MIZ2wDWC43AoaZBuH
         dfL4nByHbcZWsaFev37t3XMeATgj0I2KdbrEPH+LOcoLFNOf7VQX2gl/zZcDqwzYKw
         EBM6iZe0nVrKk7dqTrCKtyTy8qjmecDzPfJcLaNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.5 056/150] powerpc/hugetlb: Fix 8M hugepages on 8xx
Date:   Thu, 27 Feb 2020 14:36:33 +0100
Message-Id: <20200227132241.367939382@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 50a175dd18de7a647e72aca7daf4744e3a5a81e3 upstream.

With HW assistance all page tables must be 4k aligned, the 8xx drops
the last 12 bits during the walk.

Redefine HUGEPD_SHIFT_MASK to mask last 12 bits out. HUGEPD_SHIFT_MASK
is used to for alignment of page table cache.

Fixes: 22569b881d37 ("powerpc/8xx: Enable 8M hugepage support with HW assistance")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/778b1a248c4c7ca79640eeff7740044da6a220a0.1581264115.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/page.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -295,8 +295,13 @@ static inline bool pfn_valid(unsigned lo
 /*
  * Some number of bits at the level of the page table that points to
  * a hugepte are used to encode the size.  This masks those bits.
+ * On 8xx, HW assistance requires 4k alignment for the hugepte.
  */
+#ifdef CONFIG_PPC_8xx
+#define HUGEPD_SHIFT_MASK     0xfff
+#else
 #define HUGEPD_SHIFT_MASK     0x3f
+#endif
 
 #ifndef __ASSEMBLY__
 


