Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD78D1BCADD
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgD1Swr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729468AbgD1Sfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABCD620B80;
        Tue, 28 Apr 2020 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098947;
        bh=gK5xCfOTtlvMjatEd51C5fLvcPSYeylI2SDKRJmuCCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eap1wBsYLIzp1G4VNh6aPGJlPVomhqtivLKkk7ZaqvVzMfW4in+fLr3FVJQfD7tk
         7dqmIhYOht2qYkEhgIt/bTZe6LygXAbKgbi7LuH54v5uzdzh8Ijz/M+JBWYViBXFFk
         PAZwQbp6E1Uvj+OR63J1BUcmVfgrTJD3RUTSYNXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 132/167] powerpc/8xx: Fix STRICT_KERNEL_RWX startup test failure
Date:   Tue, 28 Apr 2020 20:25:08 +0200
Message-Id: <20200428182242.111611060@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit b61c38baa98056d4802ff5be5cfb979efc2d0f7a upstream.

WRITE_RO lkdtm test works.

But when selecting CONFIG_DEBUG_RODATA_TEST, the kernel reports
	rodata_test: test data was not read only

This is because when rodata test runs, there are still old entries
in TLB.

Flush TLB after setting kernel pages RO or NX.

Fixes: d5f17ee96447 ("powerpc/8xx: don't disable large TLBs with CONFIG_STRICT_KERNEL_RWX")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/485caac75f195f18c11eb077b0031fdd2bb7fb9e.1587361039.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/nohash/8xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -185,6 +185,7 @@ void mmu_mark_initmem_nx(void)
 			mmu_mapin_ram_chunk(etext8, einittext8, PAGE_KERNEL);
 		}
 	}
+	_tlbil_all();
 }
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
@@ -199,6 +200,8 @@ void mmu_mark_rodata_ro(void)
 				      ~(LARGE_PAGE_SIZE_8M - 1)));
 	mmu_patch_addis(&patch__dtlbmiss_romem_top, -__pa(_sinittext));
 
+	_tlbil_all();
+
 	/* Update page tables for PTDUMP and BDI */
 	mmu_mapin_ram_chunk(0, sinittext, __pgprot(0));
 	mmu_mapin_ram_chunk(0, etext, PAGE_KERNEL_ROX);


