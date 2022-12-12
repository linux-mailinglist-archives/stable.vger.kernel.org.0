Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB964981E
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 04:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiLLDEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 22:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiLLDEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 22:04:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD89CE39
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 19:04:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E006EB80B08
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 03:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310C7C433D2;
        Mon, 12 Dec 2022 03:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670814276;
        bh=HbA5Zgx41eawFHhW/N+/WIIBPSfbr05XzOMBzkOGgk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aO5NLxMRQNXQeVDIogTBM70ZA6Ow1RQhGO1cTPKWvrvaZlKcMiVdnWRrBlrGXBiN3
         y9iNeengsLs2TVyNRBDAvhyz+BzFSd0lkL3ju92/8JkaGyeAaqDgfB3pd74BJtG9LW
         BIUaWSiTBTZADS4TaaQMrQp2YH3u6TpUKbzosSmqXZv8keV6xiGp64GLzeTqTH+SkC
         OWfBd+8hD5nqMXDDCfJ3xgS2y0AhCQT8E8MZT5CQqKGEfFEGKRIoghBWrxXXCiuxsB
         ZveEv9rMuZ5vYxzV7tFHchx8n3+AOdbFwLsJ2ZSsVwvrNAGCmM7SNSea+BI7DQmCD0
         5sk/jKDYxOeFg==
Date:   Sun, 11 Dec 2022 22:04:34 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.19 1/2] mm/khugepaged: fix GUP-fast interaction
 by sending IPI
Message-ID: <Y5aaQqNH71IMVks0@sashalap>
References: <20221206171614.1183048-1-jannh@google.com>
 <20221206171614.1183048-6-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221206171614.1183048-6-jannh@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 06:16:07PM +0100, Jann Horn wrote:
>commit 2ba99c5e08812494bc57f319fb562f527d9bacd8 upstream.
>
>Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
>collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
>ensure that the page table was not removed by khugepaged in between.
>
>However, lockless_pages_from_mm() still requires that the page table is
>not concurrently freed.  Fix it by sending IPIs (if the architecture uses
>semi-RCU-style page table freeing) before freeing/reusing page tables.
>
>Link: https://lkml.kernel.org/r/20221129154730.2274278-2-jannh@google.com
>Link: https://lkml.kernel.org/r/20221128180252.1684965-2-jannh@google.com
>Link: https://lkml.kernel.org/r/20221125213714.4115729-2-jannh@google.com
>Fixes: ba76149f47d8 ("thp: khugepaged")
>Signed-off-by: Jann Horn <jannh@google.com>
>Reviewed-by: Yang Shi <shy828301@gmail.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Cc: John Hubbard <jhubbard@nvidia.com>
>Cc: Peter Xu <peterx@redhat.com>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>[manual backport: two of the three places in khugepaged that can free
>ptes were refactored into a common helper between 5.15 and 6.0;
>TLB flushing was refactored between 5.4 and 5.10;
>TLB flushing was refactored between 4.19 and 5.4;
>pmd collapse for PTE-mapped THP was only added in 5.4]
>Signed-off-by: Jann Horn <jannh@google.com>

This one actually fails on v4.19:

mm/khugepaged.c: In function 'collapse_huge_page':
mm/khugepaged.c:1048:9: error: implicit declaration of function 'tlb_remove_table_sync_one'; did you mean 'tlb_remove_page_size'? [-Werror=implicit-function-declaration]
  1048 |         tlb_remove_table_sync_one();
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~
       |         tlb_remove_page_size

Presumably because we don't have 9de7d833e370 ("s390/tlb: Convert to
generic mmu_gather") on those kernels.

I'll drop both backports from <= 4.19 kernels.

-- 
Thanks,
Sasha
