Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A57173B6A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392104AbfGXT7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405059AbfGXT7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:59:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D232C205C9;
        Wed, 24 Jul 2019 19:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998392;
        bh=NticxMVj6PBShtH547aOCNGgY2tsGGfYAZD4CXLmEJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTbS00asD+5RpqyicCz9cUR7fzhNdCkJjoWqbkYxcEguh/9xUFOpXTEMvvyUvKv11
         NZxFyFMmqyqsjiqQ0b3plxVfxm5cDNV/QcDpzkvwurnlGpfox8D50fh/loxhb+RwvT
         dYqc6MQltqHhbK8R24cd8IIgNyOXjaiFb2fq8uag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 350/371] powerpc/mm/32s: fix condition that is always true
Date:   Wed, 24 Jul 2019 21:21:42 +0200
Message-Id: <20190724191750.125329395@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Schwab <schwab@linux-m68k.org>

commit 46c2478af610efb3212b8b08f74389d69899ef70 upstream.

Move a misplaced paren that makes the condition always true.

Fixes: 63b2bc619565 ("powerpc/mm/32s: Use BATs for STRICT_KERNEL_RWX")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/pgtable_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -353,7 +353,7 @@ void mark_initmem_nx(void)
 	unsigned long numpages = PFN_UP((unsigned long)_einittext) -
 				 PFN_DOWN((unsigned long)_sinittext);
 
-	if (v_block_mapped((unsigned long)_stext) + 1)
+	if (v_block_mapped((unsigned long)_stext + 1))
 		mmu_mark_initmem_nx();
 	else
 		change_page_attr(page, numpages, PAGE_KERNEL);


