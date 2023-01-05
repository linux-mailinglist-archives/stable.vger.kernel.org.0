Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2441865EAD9
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjAEMn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjAEMn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:43:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083264FCF2
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:43:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A23BBB81ACB
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E44C433D2;
        Thu,  5 Jan 2023 12:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672922631;
        bh=hO8lmdn9cvMFhcrdH6uDVRVs3epAzzjJPzMpIvGttRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R53y8smt5Cny4LxqboymVNT+NGE3ePHKKsH5rrG1ddL6boQGim7EeRhoEf6egpS1o
         mEvPKN3NbB+xOGfoYrtG0TNWJgpvCUiI+9QMso608Q7tpz5NH+s6BMJBZmPzmzBPPV
         Y21WN9nIdZEnQe9ivEVj4wseAuCd+KKUnvg6ziEE=
Date:   Thu, 5 Jan 2023 13:43:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 stable 4.9,4.14 1/2] mm/khugepaged: fix GUP-fast
 interaction by sending IPI
Message-ID: <Y7bF/nFdc7WWgQKf@kroah.com>
References: <20230103171416.286579-1-jannh@google.com>
 <CAG48ez1mCg4ROuMdTsJZScCZqNSurP0qk7cOkZKEOQT+JgJMUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1mCg4ROuMdTsJZScCZqNSurP0qk7cOkZKEOQT+JgJMUw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 06:16:36PM +0100, Jann Horn wrote:
> On Tue, Jan 3, 2023 at 6:14 PM Jann Horn <jannh@google.com> wrote:
> > Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
> > collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
> > ensure that the page table was not removed by khugepaged in between.
> >
> > However, lockless_pages_from_mm() still requires that the page table is
> > not concurrently freed.  Fix it by sending IPIs (if the architecture uses
> > semi-RCU-style page table freeing) before freeing/reusing page tables.
> >
> > Link: https://lkml.kernel.org/r/20221129154730.2274278-2-jannh@google.com
> > Link: https://lkml.kernel.org/r/20221128180252.1684965-2-jannh@google.com
> > Link: https://lkml.kernel.org/r/20221125213714.4115729-2-jannh@google.com
> > Fixes: ba76149f47d8 ("thp: khugepaged")
> > Signed-off-by: Jann Horn <jannh@google.com>
> > Reviewed-by: Yang Shi <shy828301@gmail.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > [manual backport: two of the three places in khugepaged that can free
> > ptes were refactored into a common helper between 5.15 and 6.0;
> > TLB flushing was refactored between 5.4 and 5.10;
> > TLB flushing was refactored between 4.19 and 5.4;
> > pmd collapse for PTE-mapped THP was only added in 5.4;
> > ugly hack for s390 and arm in <=4.19]
> 
> Or if you just want a fixup commit, you can add this to 4.9, 4.14 and 4.19:
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 0f217bb9b534..0a4cace1cfc4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -24,7 +24,7 @@
>  #include "internal.h"
> 
>  /* gross hack for <=4.19 stable */
> -#ifdef CONFIG_S390
> +#if defined(CONFIG_S390) || defined(CONFIG_ARM)
>  static void tlb_remove_table_smp_sync(void *arg)
>  {
>          /* Simply deliver the interrupt */
> 
> Let me know if you want me to send a fixup instead, since the
> broken-on-arm version of this patch is already in a stable RC...

This works, now all fixed up in all 3 queues, thanks!

greg k-h
