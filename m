Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B683AA8BD
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 03:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhFQBpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 21:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhFQBpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 21:45:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B6266112D;
        Thu, 17 Jun 2021 01:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623894197;
        bh=TfsTygI0gHSyYhqOTv8VBGgCJP8Jiua6aKYAwmvNJu4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s6O005oO2/PzdpyTrKmakB40bKNOrYWA2pCHsqCb/lj8RcTdEk/QdqeLLUNgiDETI
         vjXn+LONvLpOv6Xo43pBx7iyGYdlHgCKNZJlFJBohiUnfOqBDpyH7mfVn9+hqqa5Tu
         EVuFxR9mIN1BSLO3el+UC5XzlUDqB/NVQFu73k6c=
Date:   Wed, 16 Jun 2021 18:43:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     linux-mm@kvack.org, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org, kaleshsingh@google.com,
        npiggin@gmail.com, joel@joelfernandes.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v2 6/6] mm/mremap: hold the rmap lock in write mode when
 moving page table entries.
Message-Id: <20210616184316.17229c71508fbd536afa3662@linux-foundation.org>
In-Reply-To: <20210616045239.370802-7-aneesh.kumar@linux.ibm.com>
References: <20210616045239.370802-1-aneesh.kumar@linux.ibm.com>
        <20210616045239.370802-7-aneesh.kumar@linux.ibm.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Jun 2021 10:22:39 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> wrote:

> To avoid a race between rmap walk and mremap, mremap does take_rmap_locks().
> The lock was taken to ensure that rmap walk don't miss a page table entry due to
> PTE moves via move_pagetables(). The kernel does further optimization of
> this lock such that if we are going to find the newly added vma after the
> old vma, the rmap lock is not taken. This is because rmap walk would find the
> vmas in the same order and if we don't find the page table attached to
> older vma we would find it with the new vma which we would iterate later.
> 
> As explained in commit eb66ae030829 ("mremap: properly flush TLB before releasing the page")
> mremap is special in that it doesn't take ownership of the page. The
> optimized version for PUD/PMD aligned mremap also doesn't hold the ptl lock.
> This can result in stale TLB entries as show below.
> 
> ...
>
> Cc: stable@vger.kernel.org

Sneaking a -stable patch into the middle of all of this was ... sneaky :(

It doesn't actually apply to current mainline either.

I think I'll pretend I didn't notice.  Please sort this out with Greg
when he reports this back to you.
