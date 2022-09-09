Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721B95B2E25
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 07:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIIFe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 01:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIIFe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 01:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB9E222B4;
        Thu,  8 Sep 2022 22:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A9C861EA6;
        Fri,  9 Sep 2022 05:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ACCC433B5;
        Fri,  9 Sep 2022 05:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662701677;
        bh=FftL+/rX8uVcJtKMuxks7ytNZrKVramsaEYvfPTDuCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Va2L0J/OnDvxeGB5/MfZxf9iOQAD6qwFI+nP1mLL34p+Ewd2gfSVLjuCNvhNRF+99
         LNyjuUuD2lVy01V5C5W1uE/XuoTk3vlCXFqddBDqOrsYrOrE/YTcY75qBxwY2OTjrx
         29kCT6NhpYIEg7WMh7rUiyGcnOLE/VdhUZKU3jpE=
Date:   Fri, 9 Sep 2022 07:34:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] mm: bring back update_mmu_cache() to finish_fault()
Message-ID: <YxrQalMUwtw4FWEE@kroah.com>
References: <20220908204809.2012451-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908204809.2012451-1-saproj@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 08, 2022 at 11:48:09PM +0300, Sergei Antonov wrote:
> Running this test program on ARMv4 a few times (sometimes just once)
> reproduces the bug.
> 
> int main()
> {
>         unsigned i;
>         char paragon[SIZE];
>         void* ptr;
> 
>         memset(paragon, 0xAA, SIZE);
>         ptr = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
>                    MAP_ANON | MAP_SHARED, -1, 0);
>         if (ptr == MAP_FAILED) return 1;
>         printf("ptr = %p\n", ptr);
>         for (i=0;i<10000;i++){
>                 memset(ptr, 0xAA, SIZE);
>                 if (memcmp(ptr, paragon, SIZE)) {
>                         printf("Unexpected bytes on iteration %u!!!\n", i);
>                         break;
>                 }
>         }
>         munmap(ptr, SIZE);
> }
> 
> In the "ptr" buffer there appear runs of zero bytes which are aligned
> by 16 and their lengths are multiple of 16.
> 
> Linux v5.11 does not have the bug, "git bisect" finds the first bad commit:
> f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
> 
> Before the commit update_mmu_cache() was called during a call to
> filemap_map_pages() as well as finish_fault(). After the commit
> finish_fault() lacks it.
> 
> Bring back update_mmu_cache() to finish_fault() to fix the bug.
> Also call update_mmu_tlb() only when returning VM_FAULT_NOPAGE to more
> closely reproduce the code of alloc_set_pte() function that existed before
> the commit.
> 
> On many platforms update_mmu_cache() is nop:
>  x86, see arch/x86/include/asm/pgtable
>  ARMv6+, see arch/arm/include/asm/tlbflush.h
> So, it seems, few users ran into this bug.
> 
> Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  mm/memory.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
