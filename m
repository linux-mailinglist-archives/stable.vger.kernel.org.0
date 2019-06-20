Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EAF4D066
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 16:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFTO3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 10:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbfFTO3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 10:29:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017FD206E0;
        Thu, 20 Jun 2019 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561040960;
        bh=jGmcXFeW7D8HKNyL/7thTeEj0zTlF5U4/cIcsDDUCcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bWZIWH1KS7f4YtgkdDQ1w1wqZnbknVtlEjsKM3/0EvS2BVM9DQEtY3E8AbvcgmQ5j
         +9V/tRmfj/fFD1RtgIAerM3bvwacNNtvsKzpzC+csNmLj2Oy1HYI3wIAn8J0Eddrl6
         qA8Hk0xtO2X6F75FZY+zij/t168hRiOm0RZ10QK0=
Date:   Thu, 20 Jun 2019 16:29:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Stable tree <stable@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH stable-4.4 v3] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Message-ID: <20190620142918.GE9832@kroah.com>
References: <20190610074635.2319-1-mhocko@kernel.org>
 <20190617065824.28305-1-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617065824.28305-1-mhocko@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 08:58:24AM +0200, Michal Hocko wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> Upstream 04f5866e41fb70690e28397487d8bd8eea7d712a commit.
> 
> The core dumping code has always run without holding the mmap_sem for
> writing, despite that is the only way to ensure that the entire vma
> layout will not change from under it.  Only using some signal
> serialization on the processes belonging to the mm is not nearly enough.
> This was pointed out earlier.  For example in Hugh's post from Jul 2017:
> 
>   https://lkml.kernel.org/r/alpine.LSU.2.11.1707191716030.2055@eggly.anvils
> 
>   "Not strictly relevant here, but a related note: I was very surprised
>    to discover, only quite recently, how handle_mm_fault() may be called
>    without down_read(mmap_sem) - when core dumping. That seems a
>    misguided optimization to me, which would also be nice to correct"
> 
> In particular because the growsdown and growsup can move the
> vm_start/vm_end the various loops the core dump does around the vma will
> not be consistent if page faults can happen concurrently.
> 
> Pretty much all users calling mmget_not_zero()/get_task_mm() and then
> taking the mmap_sem had the potential to introduce unexpected side
> effects in the core dumping code.
> 
> Adding mmap_sem for writing around the ->core_dump invocation is a
> viable long term fix, but it requires removing all copy user and page
> faults and to replace them with get_dump_page() for all binary formats
> which is not suitable as a short term fix.
> 
> For the time being this solution manually covers the places that can
> confuse the core dump either by altering the vma layout or the vma flags
> while it runs.  Once ->core_dump runs under mmap_sem for writing the
> function mmget_still_valid() can be dropped.
> 
> Allowing mmap_sem protected sections to run in parallel with the
> coredump provides some minor parallelism advantage to the swapoff code
> (which seems to be safe enough by never mangling any vma field and can
> keep doing swapins in parallel to the core dumping) and to some other
> corner case.
> 
> In order to facilitate the backporting I added "Fixes: 86039bd3b4e6"
> however the side effect of this same race condition in /proc/pid/mem
> should be reproducible since before 2.6.12-rc2 so I couldn't add any
> other "Fixes:" because there's no hash beyond the git genesis commit.
> 
> Because find_extend_vma() is the only location outside of the process
> context that could modify the "mm" structures under mmap_sem for
> reading, by adding the mmget_still_valid() check to it, all other cases
> that take the mmap_sem for reading don't need the new check after
> mmget_not_zero()/get_task_mm().  The expand_stack() in page fault
> context also doesn't need the new check, because all tasks under core
> dumping are frozen.
> 
> Link: http://lkml.kernel.org/r/20190325224949.11068-1-aarcange@redhat.com
> Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Reported-by: Jann Horn <jannh@google.com>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Acked-by: Jason Gunthorpe <jgg@mellanox.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
> [mhocko@suse.com: stable 4.4 backport
>  - drop infiniband part because of missing 5f9794dc94f59
>  - drop userfaultfd_event_wait_completion hunk because of
>    missing 9cd75c3cd4c3d]
>  - handle binder_update_page_range because of missing 720c241924046
>  - handle mlx5_ib_disassociate_ucontext - akaher@vmware.com
> ]
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---
>  drivers/android/binder.c          |  6 ++++++
>  drivers/infiniband/hw/mlx4/main.c |  3 +++
>  fs/proc/task_mmu.c                | 18 ++++++++++++++++++
>  fs/userfaultfd.c                  | 10 ++++++++--
>  include/linux/mm.h                | 21 +++++++++++++++++++++
>  mm/mmap.c                         |  7 ++++++-
>  6 files changed, 62 insertions(+), 3 deletions(-)

I've queued this up now, as it looks like everyone agrees with it.  What
about a 4.9.y backport?

thanks,

greg k-h
