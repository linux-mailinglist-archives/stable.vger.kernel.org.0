Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E1737CE22
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbhELRDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244104AbhELQmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B0D561D31;
        Wed, 12 May 2021 16:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835844;
        bh=l53qjLtTzEQnkdS0F5TN+5MEX+fHKQbbD5Dpr9JVCBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsSo/cr5/4ZWrADmoYTou27P1qdhvdZzTUuFmtWuYb3+GHncxxsAM8Ep704Bm7jhh
         f+L0raYLkDVWds51IeBsLJGDBQBTj2HFKyE6ASsCqXIkFHFsRs1uylr2AXKMLTZc2D
         UzDN+DjS7V34XYbsDVZeb5CQnC3eMsdDdkK4RGAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 507/677] powerpc/pseries: Add key to flags in pSeries_lpar_hpte_updateboltedpp()
Date:   Wed, 12 May 2021 16:49:13 +0200
Message-Id: <20210512144854.227562877@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit b56d55a5aa4aa9fc166595a7feb57f153ef7b555 ]

The flags argument to plpar_pte_protect() (aka. H_PROTECT), includes
the key in bits 9-13, but currently we always set those bits to zero.

In the past that hasn't been a problem because we always used key 0
for the kernel, and updateboltedpp() is only used for kernel mappings.

However since commit d94b827e89dc ("powerpc/book3s64/kuap: Use Key 3
for kernel mapping with hash translation") we are now inadvertently
changing the key (to zero) when we call plpar_pte_protect().

That hasn't broken anything because updateboltedpp() is only used for
STRICT_KERNEL_RWX, which is currently disabled on 64s due to other
bugs.

But we want to fix that, so first we need to pass the key correctly to
plpar_pte_protect(). We can't pass our newpp value directly in, we
have to convert it into the form expected by the hcall.

The hcall we're using here is H_PROTECT, which is specified in section
14.5.4.1.6 of LoPAPR v1.1.

It takes a `flags` parameter, and the description for flags says:

 * flags: AVPN, pp0, pp1, pp2, key0-key4, n, and for the CMO
   option: CMO Option flags as defined in Table 189‚

If you then go to the start of the parent section, 14.5.4.1, on page
405, it says:

Register Linkage (For hcall() tokens 0x04 - 0x18)
 * On Call
   * R3 function call token
   * R4 flags (see Table 178‚ “Page Frame Table Access flags field
     definition‚” on page 401)

Then you have to go to section 14.5.3, and on page 394 there is a list
of hcalls and their tokens (table 176), and there you can see that
H_PROTECT == 0x18.

Finally you can look at table 178, on page 401, where it specifies the
layout of the bits for the key:

 Bit     Function
 -----------------
 50-54 | key0-key4

Those are big-endian bit numbers, converting to normal bit numbers you
get bits 9-13, or 0x3e00.

In the kernel we have:

  #define HPTE_R_KEY_HI		ASM_CONST(0x3000000000000000)
  #define HPTE_R_KEY_LO		ASM_CONST(0x0000000000000e00)

So the LO bits of newpp are already in the right place, and the HI
bits need to be shifted down by 48.

Fixes: d94b827e89dc ("powerpc/book3s64/kuap: Use Key 3 for kernel mapping with hash translation")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210331003845.216246-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lpar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 3805519a6469..cd38bd421f38 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -977,11 +977,13 @@ static void pSeries_lpar_hpte_updateboltedpp(unsigned long newpp,
 	slot = pSeries_lpar_hpte_find(vpn, psize, ssize);
 	BUG_ON(slot == -1);
 
-	flags = newpp & 7;
+	flags = newpp & (HPTE_R_PP | HPTE_R_N);
 	if (mmu_has_feature(MMU_FTR_KERNEL_RO))
 		/* Move pp0 into bit 8 (IBM 55) */
 		flags |= (newpp & HPTE_R_PP0) >> 55;
 
+	flags |= ((newpp & HPTE_R_KEY_HI) >> 48) | (newpp & HPTE_R_KEY_LO);
+
 	lpar_rc = plpar_pte_protect(flags, slot, 0);
 
 	BUG_ON(lpar_rc != H_SUCCESS);
-- 
2.30.2



