Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A51534C7C1
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhC2ISJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233142AbhC2IQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:16:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06E74619B6;
        Mon, 29 Mar 2021 08:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005757;
        bh=EOa11RZwNgvPKh4FIH77lBDp4EpkgIU/FYcA/vOLmv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2qETX3HfxWm/DAxf+ZjinZpf3IzxpWXOG9kkiZrtlnIrXHFX8tlyAORYmT/0d5f/
         tYrJee6SSai9BoVt5Z6Ynbb1DOapYk6nuzEYS00s3t6wjpV7sTGbtE1xfH2scjQbLz
         +X3NZAAtBsZL7KrChR+1TfrtC/szNTIKiajLpQ40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 5.4 105/111] x86/mem_encrypt: Correct physical address calculation in __set_clr_pte_enc()
Date:   Mon, 29 Mar 2021 09:58:53 +0200
Message-Id: <20210329075618.706472734@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

commit 8249d17d3194eac064a8ca5bc5ca0abc86feecde upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/mem_encrypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -229,7 +229,7 @@ static void __init __set_clr_pte_enc(pte
 	if (pgprot_val(old_prot) == pgprot_val(new_prot))
 		return;
 
-	pa = pfn << page_level_shift(level);
+	pa = pfn << PAGE_SHIFT;
 	size = page_level_size(level);
 
 	/*


