Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED952B757
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 16:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfE0OMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 10:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfE0OM3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 10:12:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9560C2184E;
        Mon, 27 May 2019 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558966349;
        bh=WnV1TRooHjYgaOaThTWOyj0EiWdGjr+IfVGymFWCYZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P2V9c6Ct1uHuH1L7UUsVV2/qo+s4gcXNPoa/GNOu3XCieoJDu8i7prMkI/e5tWRM4
         mfBMk1kPdlRh/WWS9/bz2525AC7o24JIBm0G36nRbs/sifcFa7VSBaoE4FU9s9PyKy
         cTTeRJWRYPNaven26VcCx8uAY33ldJV5DrkY3KQA=
Date:   Mon, 27 May 2019 16:12:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     akpm@linux-foundation.org, dbueso@suse.de, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] hugetlb: use same fault hash key for
 shared and private" failed to apply to 4.4-stable tree
Message-ID: <20190527141209.GA23196@kroah.com>
References: <1558105205227215@kroah.com>
 <d7d4ab79-bb4a-224f-9614-225070f3b78e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7d4ab79-bb4a-224f-9614-225070f3b78e@oracle.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 04:41:24PM -0700, Mike Kravetz wrote:
> On 5/17/19 8:00 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> From: Mike Kravetz <mike.kravetz@oracle.com>
> Date: Thu, 23 May 2019 13:52:15 -0700
> Subject: [PATCH] hugetlb: use same fault hash key for shared and private
>  mappings
> 
> commit 1b426bac66e6cc83c9f2d92b96e4e72acf43419a upstream.
> 
> hugetlb uses a fault mutex hash table to prevent page faults of the
> same pages concurrently.  The key for shared and private mappings is
> different.  Shared keys off address_space and file index.  Private
> keys off mm and virtual address.  Consider a private mappings of a
> populated hugetlbfs file.  A fault will map the page from the file
> and if needed do a COW to map a writable page.
> 
> Hugetlbfs hole punch uses the fault mutex to prevent mappings of file
> pages.  It uses the address_space file index key.  However, private
> mappings will use a different key and could race with this code to map
> the file page.  This causes problems (BUG) for the page cache remove
> code as it expects the page to be unmapped.  A sample stack is:
> 
> page dumped because: VM_BUG_ON_PAGE(page_mapped(page))
> kernel BUG at mm/filemap.c:169!
> ...
> RIP: 0010:unaccount_page_cache_page+0x1b8/0x200
> ...
> Call Trace:
> __delete_from_page_cache+0x39/0x220
> delete_from_page_cache+0x45/0x70
> remove_inode_hugepages+0x13c/0x380
> ? __add_to_page_cache_locked+0x162/0x380
> hugetlbfs_fallocate+0x403/0x540
> ? _cond_resched+0x15/0x30
> ? __inode_security_revalidate+0x5d/0x70
> ? selinux_file_permission+0x100/0x130
> vfs_fallocate+0x13f/0x270
> ksys_fallocate+0x3c/0x80
> __x64_sys_fallocate+0x1a/0x20
> do_syscall_64+0x5b/0x180
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> There seems to be another potential COW issue/race with this approach
> of different private and shared keys as noted in commit 8382d914ebf7
> ("mm, hugetlb: improve page-fault scalability").
> 
> Since every hugetlb mapping (even anon and private) is actually a file
> mapping, just use the address_space index key for all mappings.  This
> results in potentially more hash collisions.  However, this should not
> be the common case.
> 
> Link: http://lkml.kernel.org/r/20190328234704.27083-3-mike.kravetz@oracle.com
> Link: http://lkml.kernel.org/r/20190412165235.t4sscoujczfhuiyt@linux-r8p5
> Fixes: b5cec28d36f5 ("hugetlbfs: truncate_hugepages() takes a range of pages")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>  fs/hugetlbfs/inode.c    |  7 ++-----
>  include/linux/hugetlb.h |  4 +---
>  mm/hugetlb.c            | 19 +++++--------------
>  3 files changed, 8 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 27c4e2ac39a9..c9f288dbe734 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -414,9 +414,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>  			if (next >= end)
>  				break;
>  
> -			hash = hugetlb_fault_mutex_hash(h, current->mm,
> -							&pseudo_vma,
> -							mapping, next, 0);
> +			hash = hugetlb_fault_mutex_hash(h, mapping, next, 0);
>  			mutex_lock(&hugetlb_fault_mutex_table[hash]);
>  
>  			lock_page(page);
> @@ -633,8 +631,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  		addr = index * hpage_size;
>  
>  		/* mutex taken here, fault path and hole punch */
> -		hash = hugetlb_fault_mutex_hash(h, mm, &pseudo_vma, mapping,
> -						index, addr);
> +		hash = hugetlb_fault_mutex_hash(h, mapping, index, addr);
>  		mutex_lock(&hugetlb_fault_mutex_table[hash]);
>  
>  		/* See if already present in mapping to avoid alloc/free */

Note, this backport causes this warning:
fs/hugetlbfs/inode.c: In function hugetlbfs_fallocate:
fs/hugetlbfs/inode.c:570:20: warning: unused variable mm [-Wunused-variable]
  struct mm_struct *mm = current->mm;
                    ^~

So I'll go delete that line as well.

thanks,

greg k-h
