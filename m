Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA5032673F
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 20:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhBZTKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 14:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhBZTKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 14:10:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 749E264F2A;
        Fri, 26 Feb 2021 19:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614366593;
        bh=/3kxvNjF1Sa6PvBx3RXF1h02Nby9cgLfYpaVKzVpAHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g1RggvNwBNhbCc5ssFMm2vxNfTJlB0kvlnk+YR9bDkipJaXmMb8I/4jNc9nIyhsH1
         UBYjVSP94H/mA0nC1/CV37mOn+NojiurYwIlc+cwl1jtDnplnngbkOO3TuzjWd/DTg
         tgETwyXZoMYedsdOn3g7YCfNvrTJGaSlgn9naFFPdTa6VDce06TeQZA7I04wNtPAgX
         fhwD4zogLil4j5O6JRL0LUmjEtdBIqX3lZ/u7yyILzv96NuCW7YvkLEOXF7DL3gEKC
         cugK+6qIO/xDNVit0NnynTAsy05OnHKY4h3f8/P4vLMn1JwqB06sxZ5yyqLETqdXvI
         RxC9fqnhSwZtg==
Date:   Fri, 26 Feb 2021 14:09:52 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 4.9 STABLE] mm, thp: make do_huge_pmd_wp_page() lock page
 for testing mapcount
Message-ID: <20210226190952.GC473487@sasha-vm>
References: <26569718-050f-fc90-e3ac-79edfaae9ac7@suse.cz>
 <20210226162200.20548-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210226162200.20548-1-vbabka@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 26, 2021 at 05:22:00PM +0100, Vlastimil Babka wrote:
>Jann reported [1] a race between __split_huge_pmd_locked() and
>page_trans_huge_map_swapcount() which can result in a page to be reused
>instead of COWed. This was later assigned CVE-2020-29368.
>
>This was fixed by commit c444eb564fb1 ("mm: thp: make the THP mapcount atomic
>against __split_huge_pmd_locked()") by doing the split under the page lock,
>while all users of page_trans_huge_map_swapcount() were already also under page
>lock. The fix was backported also to 4.9 stable series.
>
>When testing the backport on a 4.12 based kernel, Nicolai noticed the POC from
>[1] still reproduces after backporting c444eb564fb1 and identified a missing
>page lock in do_huge_pmd_wp_page() around the call to
>page_trans_huge_mapcount(). The page lock was only added in ba3c4ce6def4 ("mm,
>THP, swap: make reuse_swap_page() works for THP swapped out") in 4.14. The
>commit also wrapped page_trans_huge_mapcount() into
>page_trans_huge_map_swapcount() for the purposes of COW decisions.
>
>I have verified that 4.9.y indeed also reproduces with the POC. Backporting
>ba3c4ce6def4 alone however is not possible as it's part of a larger effort of
>optimizing THP swapping, which would be risky to backport fully.
>
>Therefore this 4.9-stable-only patch just wraps page_trans_huge_mapcount()
>in page_trans_huge_mapcount() under page lock the same way as ba3c4ce6def4
>does, but without the page_trans_huge_map_swapcount() part. Other callers
>of page_trans_huge_mapcount() are all under page lock already. I have verified
>the POC no longer reproduces afterwards.
>
>[1] https://bugs.chromium.org/p/project-zero/issues/detail?id=2045
>
>Reported-by: Nicolai Stange <nstange@suse.de>
>Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Queued up, thanks!

-- 
Thanks,
Sasha
