Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F11185152
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 22:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgCMVnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 17:43:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57426 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726534AbgCMVnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 17:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584135823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z+yNqTPhCKvphPybR67u1KFL4j6tDivUDXMnB6tP/Oo=;
        b=ClOsabtYUV0ZxHw7znGKkIW/RWZkLDy2b8ZNxIGImMOcGo8A/igsT6OhOkOWWaixA2ja97
        Pl/OKhlF5m1l3hdWHXjG3Tgv27qRevlwYs92F2toYr2+/p4jBnvyyWgrNddzn89dHli2dl
        OgUU224l2Gr7qA9JeRf6N7Wkd/EZ9Yg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-SS9mUficM269v4rFOovXnQ-1; Fri, 13 Mar 2020 17:43:40 -0400
X-MC-Unique: SS9mUficM269v4rFOovXnQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54850800D48;
        Fri, 13 Mar 2020 21:43:37 +0000 (UTC)
Received: from t490s (ovpn-120-126.rdu2.redhat.com [10.10.120.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3686B9A6A;
        Fri, 13 Mar 2020 21:43:36 +0000 (UTC)
Date:   Fri, 13 Mar 2020 17:43:32 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     Qian Cai <cai@lca.pw>
Cc:     akpm@linux-foundation.org, ying.huang@intel.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] page-flags: fix a crash at SetPageError(THP_SWAP)
Message-ID: <20200313214332.GA14055@t490s>
References: <20200310235846.1319-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310235846.1319-1-cai@lca.pw>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 07:58:46PM -0400, Qian Cai wrote:
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
> -- 
> 2.21.0 (Apple Git-122.2)
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

