Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840945B34DA
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 12:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiIIKK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 06:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiIIKKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 06:10:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7678E32AAD;
        Fri,  9 Sep 2022 03:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D279AB8248A;
        Fri,  9 Sep 2022 10:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBBAC433C1;
        Fri,  9 Sep 2022 10:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662718239;
        bh=ThKc/LNks2uiEwibtZIMonrODWHgA8V6ISnUWceg9VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JmgQnTSyduTWZtYc6DODkU0So3JcJ218EbkSzoY/dgU3Zm56uGjgw02ef25ftWUbW
         ft/mVHJRUfvEr8L3IpZK28TBYphWGB2loiVTm9EOSQ1REIu+kTHPiyGH1ttTMNKv1O
         OH8lklSHvtWxgwDalvI/0oszE8XSNNjneTsZOcXo55Rq97+gmAP5+GHre3WS5yXxiT
         x4h0JsVjQjfZaKbh3T0wVdny69SN2QiTP1wN+qpBJboyanMv2V/pAc5cQ9woB70o6b
         VYhQqS03VVlenck24B+QAUKBx1lum28864MwmcZYhxN8hrnSihqQLTF0YnXXBLRv5o
         hgh08i87IptXg==
Date:   Fri, 9 Sep 2022 11:10:34 +0100
From:   Will Deacon <will@kernel.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Sergei Antonov <saproj@gmail.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] mm: bring back update_mmu_cache() to finish_fault()
Message-ID: <20220909101032.GA32507@willie-the-truck>
References: <20220908204809.2012451-1-saproj@gmail.com>
 <20220908222410.yg2sqqdezzwfi5mj@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908222410.yg2sqqdezzwfi5mj@box.shutemov.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 09, 2022 at 01:24:10AM +0300, Kirill A. Shutemov wrote:
> On Thu, Sep 08, 2022 at 11:48:09PM +0300, Sergei Antonov wrote:
> > Running this test program on ARMv4 a few times (sometimes just once)
> > reproduces the bug.
> > 
> > int main()
> > {
> >         unsigned i;
> >         char paragon[SIZE];
> >         void* ptr;
> > 
> >         memset(paragon, 0xAA, SIZE);
> >         ptr = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
> >                    MAP_ANON | MAP_SHARED, -1, 0);
> >         if (ptr == MAP_FAILED) return 1;
> >         printf("ptr = %p\n", ptr);
> >         for (i=0;i<10000;i++){
> >                 memset(ptr, 0xAA, SIZE);
> >                 if (memcmp(ptr, paragon, SIZE)) {
> >                         printf("Unexpected bytes on iteration %u!!!\n", i);
> >                         break;
> >                 }
> >         }
> >         munmap(ptr, SIZE);
> > }
> > 
> > In the "ptr" buffer there appear runs of zero bytes which are aligned
> > by 16 and their lengths are multiple of 16.
> > 
> > Linux v5.11 does not have the bug, "git bisect" finds the first bad commit:
> > f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
> > 
> > Before the commit update_mmu_cache() was called during a call to
> > filemap_map_pages() as well as finish_fault(). After the commit
> > finish_fault() lacks it.
> > 
> > Bring back update_mmu_cache() to finish_fault() to fix the bug.
> > Also call update_mmu_tlb() only when returning VM_FAULT_NOPAGE to more
> > closely reproduce the code of alloc_set_pte() function that existed before
> > the commit.
> > 
> > On many platforms update_mmu_cache() is nop:
> >  x86, see arch/x86/include/asm/pgtable
> >  ARMv6+, see arch/arm/include/asm/tlbflush.h
> > So, it seems, few users ran into this bug.
> > 
> > Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
> > Signed-off-by: Sergei Antonov <saproj@gmail.com>
> > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> 
> +Will.
> 
> Seems I confused update_mmu_tlb() with update_mmu_cache() :/

Urgh, that thing is pretty horrible! But anyway, I agree that this change
looks correct based on the other callers in the file.

> Looks good to me:
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

I'm assuming Andrew will pick this up. Otherwise, please let me know if
I should route it via the arm64 tree.

Will
