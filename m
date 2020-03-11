Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563AA180CFF
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 01:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgCKAsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 20:48:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:31891 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727591AbgCKAsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 20:48:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 17:48:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,538,1574150400"; 
   d="scan'208";a="277172633"
Received: from yhuang-dev.sh.intel.com (HELO yhuang-dev) ([10.239.159.23])
  by fmsmga002.fm.intel.com with ESMTP; 10 Mar 2020 17:48:47 -0700
From:   "Huang\, Ying" <ying.huang@intel.com>
To:     Qian Cai <cai@lca.pw>
Cc:     <akpm@linux-foundation.org>, <kirill.shutemov@linux.intel.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] page-flags: fix a crash at SetPageError(THP_SWAP)
References: <20200310235846.1319-1-cai@lca.pw>
Date:   Wed, 11 Mar 2020 08:48:47 +0800
In-Reply-To: <20200310235846.1319-1-cai@lca.pw> (Qian Cai's message of "Tue,
        10 Mar 2020 19:58:46 -0400")
Message-ID: <87pndjwwb4.fsf@yhuang-dev.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Qian Cai <cai@lca.pw> writes:

> The commit bd4c82c22c36 ("mm, THP, swap: delay splitting THP after
> swapped out") supported writing THP to a swap device but forgot to
> upgrade an older commit df8c94d13c7e ("page-flags: define behavior of
> FS/IO-related flags on compound pages") which could trigger a crash
> during THP swapping out with DEBUG_VM_PGFLAGS=y,
>
> kernel BUG at include/linux/page-flags.h:317!
>
> page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
> page:fffff3b2ec3a8000 refcount:512 mapcount:0 mapping:000000009eb0338c
> index:0x7f6e58200 head:fffff3b2ec3a8000 order:9 compound_mapcount:0
> compound_pincount:0
> anon flags:
> 0x45fffe0000d8454(uptodate|lru|workingset|owner_priv_1|writeback|head|reclaim|swapbacked)
>
> end_swap_bio_write()
>   SetPageError(page)
>     VM_BUG_ON_PAGE(1 && PageCompound(page))
>
> <IRQ>
> bio_endio+0x297/0x560
> dec_pending+0x218/0x430 [dm_mod]
> clone_endio+0xe4/0x2c0 [dm_mod]
> bio_endio+0x297/0x560
> blk_update_request+0x201/0x920
> scsi_end_request+0x6b/0x4b0
> scsi_io_completion+0x509/0x7e0
> scsi_finish_command+0x1ed/0x2a0
> scsi_softirq_done+0x1c9/0x1d0
> __blk_mqnterrupt+0xf/0x20
> </IRQ>
>
> Fix by checking PF_NO_TAIL in those places instead.
>
> Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qian Cai <cai@lca.pw>

Good catch!  Thanks!

Acked-by: "Huang, Ying" <ying.huang@intel.com>

> ---
>  include/linux/page-flags.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 1bf83c8fcaa7..77de28bfefb0 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -311,7 +311,7 @@ static inline int TestClearPage##uname(struct page *page) { return 0; }
>  
>  __PAGEFLAG(Locked, locked, PF_NO_TAIL)
>  PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD) __CLEARPAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
> -PAGEFLAG(Error, error, PF_NO_COMPOUND) TESTCLEARFLAG(Error, error, PF_NO_COMPOUND)
> +PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
>  PAGEFLAG(Referenced, referenced, PF_HEAD)
>  	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
>  	__SETPAGEFLAG(Referenced, referenced, PF_HEAD)
