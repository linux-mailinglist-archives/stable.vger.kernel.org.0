Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F666085DB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiJVHj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiJVHjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:39:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6550A83229;
        Sat, 22 Oct 2022 00:36:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3259DB82DF2;
        Sat, 22 Oct 2022 07:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84130C433C1;
        Sat, 22 Oct 2022 07:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424185;
        bh=Y4qDb4mZNU20ip9zLWEr74fGK+TtVytsTmrTYBy7Its=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyH7GbTu/y47N2jCKFOUmXbudbPBIxOSckrRKn0TuFGOdZqwJ60oRyYMiuQVywpKv
         13ZAXhxukUS5/FAr5NzVY+dogwfDuih+sBim0IX8NUi93HJ9Bb3l+zQ6QouoFpbePZ
         zsXSsQvtu4MHS1XjmZtjmkHPxF/ogYAkQvVceWWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.19 054/717] parisc: Fix userspace graphics card breakage due to pgtable special bit
Date:   Sat, 22 Oct 2022 09:18:53 +0200
Message-Id: <20221022072424.651114285@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 70be49f2f6223ddd2fcddb0089a40864c37e1494 upstream.

Commit df24e1783e6e ("parisc: Add vDSO support") introduced the vDSO
support, for which a _PAGE_SPECIAL page table flag was needed.  Since we
wanted to keep every page table entry in 32-bits, this patch re-used the
existing - but yet unused - _PAGE_DMB flag (which triggers a hardware break
if a page is accessed) to store the special bit.

But when graphics card memory is mmapped into userspace, the kernel uses
vm_iomap_memory() which sets the the special flag. So, with the DMB bit
set, every access to the graphics memory now triggered a hardware
exception and segfaulted the userspace program.

Fix this breakage by dropping the DMB bit when writing the page
protection bits to the CPU TLB.

In addition this patch adds a small optimization: if huge pages aren't
configured (which is at least the case for 32-bit kernels), then the
special bit is stored in the hpage (HUGE PAGE) bit instead. That way we
can skip to reset the DMB bit.

Fixes: df24e1783e6e ("parisc: Add vDSO support")
Cc: <stable@vger.kernel.org> # 5.18+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/pgtable.h |    7 ++++++-
 arch/parisc/kernel/entry.S        |    8 ++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -192,6 +192,11 @@ extern void __update_cache(pte_t pte);
 #define _PAGE_PRESENT_BIT  22   /* (0x200) Software: translation valid */
 #define _PAGE_HPAGE_BIT    21   /* (0x400) Software: Huge Page */
 #define _PAGE_USER_BIT     20   /* (0x800) Software: User accessible page */
+#ifdef CONFIG_HUGETLB_PAGE
+#define _PAGE_SPECIAL_BIT  _PAGE_DMB_BIT  /* DMB feature is currently unused */
+#else
+#define _PAGE_SPECIAL_BIT  _PAGE_HPAGE_BIT /* use unused HUGE PAGE bit */
+#endif
 
 /* N.B. The bits are defined in terms of a 32 bit word above, so the */
 /*      following macro is ok for both 32 and 64 bit.                */
@@ -219,7 +224,7 @@ extern void __update_cache(pte_t pte);
 #define _PAGE_PRESENT  (1 << xlate_pabit(_PAGE_PRESENT_BIT))
 #define _PAGE_HUGE     (1 << xlate_pabit(_PAGE_HPAGE_BIT))
 #define _PAGE_USER     (1 << xlate_pabit(_PAGE_USER_BIT))
-#define _PAGE_SPECIAL  (_PAGE_DMB)
+#define _PAGE_SPECIAL  (1 << xlate_pabit(_PAGE_SPECIAL_BIT))
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_SPECIAL)
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -499,6 +499,10 @@
 	 * Finally, _PAGE_READ goes in the top bit of PL1 (so we
 	 * trigger an access rights trap in user space if the user
 	 * tries to read an unreadable page */
+#if _PAGE_SPECIAL_BIT == _PAGE_DMB_BIT
+	/* need to drop DMB bit, as it's used as SPECIAL flag */
+	depi		0,_PAGE_SPECIAL_BIT,1,\pte
+#endif
 	depd            \pte,8,7,\prot
 
 	/* PAGE_USER indicates the page can be read with user privileges,
@@ -529,6 +533,10 @@
 	 * makes the tlb entry for the differently formatted pa11
 	 * insertion instructions */
 	.macro		make_insert_tlb_11	spc,pte,prot
+#if _PAGE_SPECIAL_BIT == _PAGE_DMB_BIT
+	/* need to drop DMB bit, as it's used as SPECIAL flag */
+	depi		0,_PAGE_SPECIAL_BIT,1,\pte
+#endif
 	zdep		\spc,30,15,\prot
 	dep		\pte,8,7,\prot
 	extru,=		\pte,_PAGE_NO_CACHE_BIT,1,%r0


