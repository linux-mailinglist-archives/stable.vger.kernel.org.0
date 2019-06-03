Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7776233A5A
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 23:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfFCVzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 17:55:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCVzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 17:55:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D16C14D79773
        for <stable@vger.kernel.org>; Mon,  3 Jun 2019 13:38:27 -0700 (PDT)
Date:   Mon, 03 Jun 2019 13:38:26 -0700 (PDT)
Message-Id: <20190603.133826.250539503495002779.davem@davemloft.net>
To:     stable@vger.kernel.org
Subject: [PATCH] Sparc
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Mon_Jun__3_13_38_26_2019_231)--"
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 13:38:27 -0700 (PDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----Next_Part(Mon_Jun__3_13_38_26_2019_231)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Please queue up the attached sparc64 bug fix to all active -stable
branches.

Thank you.

----Next_Part(Mon_Jun__3_13_38_26_2019_231)--
Content-Type: Text/X-Patch; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-sparc64-Fix-regression-in-non-hypervisor-TLB-flush-x.patch"

From d3c976c14ad8af421134c428b0a89ff8dd3bd8f8 Mon Sep 17 00:00:00 2001
From: James Clarke <jrtc27@jrtc27.com>
Date: Wed, 29 May 2019 22:31:31 +0100
Subject: [PATCH] sparc64: Fix regression in non-hypervisor TLB flush xcall

[ Upstream commit d3c976c14ad8af421134c428b0a89ff8dd3bd8f8 ]

Previously, %g2 would end up with the value PAGE_SIZE, but after the
commit mentioned below it ends up with the value 1 due to being reused
for a different purpose. We need it to be PAGE_SIZE as we use it to step
through pages in our demap loop, otherwise we set different flags in the
low 12 bits of the address written to, thereby doing things other than a
nucleus page flush.

Fixes: a74ad5e660a9 ("sparc64: Handle extremely large kernel TLB range flushes more gracefully.")
Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: James Clarke <jrtc27@jrtc27.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/mm/ultra.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/mm/ultra.S b/arch/sparc/mm/ultra.S
index d245f89d1395..d220b6848746 100644
--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -587,7 +587,7 @@ xcall_flush_tlb_kernel_range:	/* 44 insns */
 	sub		%g7, %g1, %g3
 	srlx		%g3, 18, %g2
 	brnz,pn		%g2, 2f
-	 add		%g2, 1, %g2
+	 sethi		%hi(PAGE_SIZE), %g2
 	sub		%g3, %g2, %g3
 	or		%g1, 0x20, %g1		! Nucleus
 1:	stxa		%g0, [%g1 + %g3] ASI_DMMU_DEMAP
@@ -751,7 +751,7 @@ __cheetah_xcall_flush_tlb_kernel_range:	/* 44 insns */
 	sub		%g7, %g1, %g3
 	srlx		%g3, 18, %g2
 	brnz,pn		%g2, 2f
-	 add		%g2, 1, %g2
+	 sethi		%hi(PAGE_SIZE), %g2
 	sub		%g3, %g2, %g3
 	or		%g1, 0x20, %g1		! Nucleus
 1:	stxa		%g0, [%g1 + %g3] ASI_DMMU_DEMAP
-- 
2.20.1


----Next_Part(Mon_Jun__3_13_38_26_2019_231)----
