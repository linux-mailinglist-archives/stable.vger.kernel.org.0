Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFED3351FF5
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbhDATiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234565AbhDATiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 15:38:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA87360241;
        Thu,  1 Apr 2021 19:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617305897;
        bh=uOOaIddINYtFI1rB62AhT2r+hHCGkCQ7KIHGOn93qVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HE+d3lJT+q/UdQqPV0y7CH5H2aEz1o2+8ke1WrJHNq4kI972+Yay1CfVIGhokWHyo
         XnNlRWlHo8uiHwXfZtohGfne5M0hwCsp4fbK8oODCpVxph0+6pkvo7LlRKQsWvbOu0
         XtCAkqDccob/v5raqpLwS9pd2cstJZc52lGNeW34=
Date:   Thu, 1 Apr 2021 21:38:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     stable@vger.kernel.org, jannh@google.com, ktkhai@virtuozzo.com,
        torvalds@linux-foundation.org, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Yang Shi <yang.shi@linux.alibaba.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
        Rik van Riel <riel@surriel.com>,
        Huang Ying <ying.huang@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] mm: reuse only-pte-mapped KSM page in do_wp_page()
Message-ID: <YGYhJxFpfCx9VqZS@kroah.com>
References: <20210401181741.168763-1-surenb@google.com>
 <20210401181741.168763-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401181741.168763-2-surenb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 01, 2021 at 11:17:37AM -0700, Suren Baghdasaryan wrote:
> From: Kirill Tkhai <ktkhai@virtuozzo.com>
> 
> Add an optimization for KSM pages almost in the same way that we have
> for ordinary anonymous pages.  If there is a write fault in a page,
> which is mapped to an only pte, and it is not related to swap cache; the
> page may be reused without copying its content.
> 
> [ Note that we do not consider PageSwapCache() pages at least for now,
>   since we don't want to complicate __get_ksm_page(), which has nice
>   optimization based on this (for the migration case). Currenly it is
>   spinning on PageSwapCache() pages, waiting for when they have
>   unfreezed counters (i.e., for the migration finish). But we don't want
>   to make it also spinning on swap cache pages, which we try to reuse,
>   since there is not a very high probability to reuse them. So, for now
>   we do not consider PageSwapCache() pages at all. ]
> 
> So in reuse_ksm_page() we check for 1) PageSwapCache() and 2)
> page_stable_node(), to skip a page, which KSM is currently trying to
> link to stable tree.  Then we do page_ref_freeze() to prohibit KSM to
> merge one more page into the page, we are reusing.  After that, nobody
> can refer to the reusing page: KSM skips !PageSwapCache() pages with
> zero refcount; and the protection against of all other participants is
> the same as for reused ordinary anon pages pte lock, page lock and
> mmap_sem.
> 
> [akpm@linux-foundation.org: replace BUG_ON()s with WARN_ON()s]
> Link: http://lkml.kernel.org/r/154471491016.31352.1168978849911555609.stgit@localhost.localdomain
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
> Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  include/linux/ksm.h |  7 +++++++
>  mm/ksm.c            | 30 ++++++++++++++++++++++++++++--
>  mm/memory.c         | 16 ++++++++++++++--
>  3 files changed, 49 insertions(+), 4 deletions(-)

You forgot to put the git commit id of the upstream commit in here
somewhere so we can properly reference it and track it.

When/if you resend this, please add it to all of the commits.

thanks,

greg k-h
