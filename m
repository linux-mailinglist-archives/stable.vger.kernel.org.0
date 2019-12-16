Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B110120EA5
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 16:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfLPP5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 10:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbfLPP5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 10:57:21 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2DEF206EC;
        Mon, 16 Dec 2019 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576511840;
        bh=RBxfY+RxlqnAmFLMh/V+81voCNuCNSfoKyR1ut3zkvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HCJcD9S10e+sg5jJVcSEDcQJz1hiHqa5sk7SSGbCHlZebGD1Mp3i3xpuNTn/Bpa+t
         bY53eD8rB/xSO3L+Lm4zC/1EzQ5yvmE2jUQGHUdMhQ7M/C1ZUi4OA/0ZejdrR0y8WR
         AjNyIIGOuG1gvP7Do6jE467r3zf3vSNYf6FXWRxg=
Date:   Mon, 16 Dec 2019 10:57:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org, mhocko@suse.com
Cc:     thellstrom@vmware.com, akpm@linux-foundation.org, arnd@arndb.de,
        kirill.shutemov@linux.intel.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm/memory.c: fix a huge pud insertion
 race during faulting" failed to apply to 4.19-stable tree
Message-ID: <20191216155718.GF17708@sasha-vm>
References: <1576497644874@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576497644874@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 01:00:44PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 625110b5e9dae9074d8a7e67dd07f821a053eed7 Mon Sep 17 00:00:00 2001
>From: Thomas Hellstrom <thellstrom@vmware.com>
>Date: Sat, 30 Nov 2019 17:51:32 -0800
>Subject: [PATCH] mm/memory.c: fix a huge pud insertion race during faulting
>
>A huge pud page can theoretically be faulted in racing with pmd_alloc()
>in __handle_mm_fault().  That will lead to pmd_alloc() returning an
>invalid pmd pointer.
>
>Fix this by adding a pud_trans_unstable() function similar to
>pmd_trans_unstable() and check whether the pud is really stable before
>using the pmd pointer.
>
>Race:
>  Thread 1:             Thread 2:                 Comment
>  create_huge_pud()                               Fallback - not taken.
>                        create_huge_pud()         Taken.
>  pmd_alloc()                                     Returns an invalid pointer.
>
>This will result in user-visible huge page data corruption.
>
>Note that this was caught during a code audit rather than a real
>experienced problem.  It looks to me like the only implementation that
>currently creates huge pud pagetable entries is dev_dax_huge_fault()
>which doesn't appear to care much about private (COW) mappings or
>write-tracking which is, I believe, a prerequisite for create_huge_pud()
>falling back on thread 1, but not in thread 2.
>
>Link: http://lkml.kernel.org/r/20191115115808.21181-2-thomas_os@shipmail.org
>Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
>Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>Cc: Arnd Bergmann <arnd@arndb.de>
>Cc: Matthew Wilcox <willy@infradead.org>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

This one doesn't apply cleanly because 7635d9cbe832 ("mm, thp, proc:
report THP eligibility for each vma") has changed what
transparent_hugepage_enabled() does.

The "right" backport here would be to simply change from calling
__transparent_hugepage_enabled() to calling
transparent_hugepage_enabled() as we don't have 7635d9cbe832 in older
kernels, but I worry that if we do end up backporting some part of that
logic change later it will diverge us from upstream and will cause for
subtle issues that are difficult to debug.

So unless Michal / Andrew yell at me for this, I'm going to take in
7635d9cbe832 even though it's clearly a new feature just to make
625110b5e9da and future patches apply cleanly, and avoid future issues.

-- 
Thanks,
Sasha
