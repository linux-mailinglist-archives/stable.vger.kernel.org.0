Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57DE345D31
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 12:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhCWLnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 07:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhCWLmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 07:42:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199AAC061574;
        Tue, 23 Mar 2021 04:42:54 -0700 (PDT)
Date:   Tue, 23 Mar 2021 11:42:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616499772;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TL+sWqMVVotTl7gtK8FqiJgDWThyE/eYvJna6PLJvCQ=;
        b=ST6zRr4PxQxynKugKt5h640JZxZbt0tgx/ypTybj1WwC1P/p7vu0kAZnj/CLdmAoPZOenA
        ZZZ76a3UD9CKENfxfM48m7tM4HQzfM+a4m5rFVKYUY67jlI2bzIh72AHl3kThrOpmPGntq
        ERWGgiLoZfIFMqjSll5eguOmTAPuosomW7+cI1pZ+rEDLnw0tRTyYHukDHba2cYvq2z6k0
        C/9fIn5vWmw6g0rhHbk7isKay+0SnJIz+x5gKluCk2E2NXVNQ2U8+KCpVmBnWLhjZnKtnl
        S28g/5vJWTFq92tFxj+dfj5rr/v112ZaaMPNiPE09YMjYuH4PEpc2oeCMyyArw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616499772;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TL+sWqMVVotTl7gtK8FqiJgDWThyE/eYvJna6PLJvCQ=;
        b=g6y2CWGlBvt3hsvZ0pR6K54s3LJU4JtwyG0VdmSDSSqGq+041k+L14rOl5AhFWavWG7rSz
        za2X97JvHnmL0zBQ==
From:   "tip-bot2 for Isaku Yamahata" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mem_encrypt: Correct physical address
 calculation in __set_clr_pte_enc()
Cc:     Isaku Yamahata <isaku.yamahata@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C81abbae1657053eccc535c16151f63cd049dcb97=2E16160?=
 =?utf-8?q?98294=2Egit=2Eisaku=2Eyamahata=40intel=2Ecom=3E?=
References: =?utf-8?q?=3C81abbae1657053eccc535c16151f63cd049dcb97=2E161609?=
 =?utf-8?q?8294=2Egit=2Eisaku=2Eyamahata=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <161649977197.398.7928350891003410155.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     8249d17d3194eac064a8ca5bc5ca0abc86feecde
Gitweb:        https://git.kernel.org/tip/8249d17d3194eac064a8ca5bc5ca0abc86feecde
Author:        Isaku Yamahata <isaku.yamahata@intel.com>
AuthorDate:    Thu, 18 Mar 2021 13:26:57 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 23 Mar 2021 11:59:45 +01:00

x86/mem_encrypt: Correct physical address calculation in __set_clr_pte_enc()

The pfn variable contains the page frame number as returned by the
pXX_pfn() functions, shifted to the right by PAGE_SHIFT to remove the
page bits. After page protection computations are done to it, it gets
shifted back to the physical address using page_level_shift().

That is wrong, of course, because that function determines the shift
length based on the level of the page in the page table but in all the
cases, it was shifted by PAGE_SHIFT before.

Therefore, shift it back using PAGE_SHIFT to get the correct physical
address.

 [ bp: Rewrite commit message. ]

Fixes: dfaaec9033b8 ("x86: Add support for changing memory encryption attribute in early boot")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/81abbae1657053eccc535c16151f63cd049dcb97.1616098294.git.isaku.yamahata@intel.com
---
 arch/x86/mm/mem_encrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 4b01f7d..ae78cef 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -262,7 +262,7 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 	if (pgprot_val(old_prot) == pgprot_val(new_prot))
 		return;
 
-	pa = pfn << page_level_shift(level);
+	pa = pfn << PAGE_SHIFT;
 	size = page_level_size(level);
 
 	/*
