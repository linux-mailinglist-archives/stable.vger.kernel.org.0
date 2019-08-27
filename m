Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA6F9E211
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfH0IQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbfH0HyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:54:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E5F206BF;
        Tue, 27 Aug 2019 07:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892455;
        bh=GfJ9CA+FnmOmJgMvLBMy5H/eRhMID16zoKjq6w4U1+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vlazf1BpXzqFhKrNNI0A15+ND7bqe1qiUMDfqH/mgL/olxFcgtb6Dia0S5JrEJFnM
         g3N3pLIuM0k++QpLpRfZ9XqKyl3aMWGSnTrnjRCUDXDD0wZIOYcJGL3iSX9kLD7ZQo
         wPLVKosFUuTm0eNoZOPm6IFMWeqt+VAQy8YdYjm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, alastair@d-silva.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 62/62] powerpc: Allow flush_(inval_)dcache_range to work across ranges >4GB
Date:   Tue, 27 Aug 2019 09:51:07 +0200
Message-Id: <20190827072704.089508645@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Alastair D'Silva <alastair@d-silva.org>

The upstream commit:
22e9c88d486a ("powerpc/64: reuse PPC32 static inline flush_dcache_range()")
has a similar effect, but since it is a rewrite of the assembler to C, is
too invasive for stable. This patch is a minimal fix to address the issue in
assembler.

This patch applies cleanly to v5.2, v4.19 & v4.14.

When calling flush_(inval_)dcache_range with a size >4GB, we were masking
off the upper 32 bits, so we would incorrectly flush a range smaller
than intended.

This patch replaces the 32 bit shifts with 64 bit ones, so that
the full size is accounted for.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/misc_64.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -134,7 +134,7 @@ _GLOBAL_TOC(flush_dcache_range)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5		/* ensure we get enough */
 	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of dcache block size */
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	beqlr				/* nothing to do? */
 	mtctr	r8
 0:	dcbst	0,r6
@@ -190,7 +190,7 @@ _GLOBAL(flush_inval_dcache_range)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5		/* ensure we get enough */
 	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)/* Get log-2 of dcache block size */
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	beqlr				/* nothing to do? */
 	sync
 	isync


