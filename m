Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119DC4BA8FB
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 19:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbiBQS5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 13:57:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244739AbiBQS5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 13:57:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFF05DE6B;
        Thu, 17 Feb 2022 10:56:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A9A8CE2F35;
        Thu, 17 Feb 2022 18:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C2CC340ED;
        Thu, 17 Feb 2022 18:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645124214;
        bh=SzRfITzmZDpTf4VtVgjCwYgty8C/1w3Inqwuld1XblY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RR+8c3SRiQrf0EGrmR6ZcwogGHtv1IBxtyeThyVUFhhQyk3vr8y2RDZcNIKE5NnDO
         ltoqfUkXVu/szr03UFuT4UYS7inhS23ep4SPmxewD36uNvP/uKANKKoTIMcccKbdQr
         Srz/s5ppm4hKfl1G42+to5xelgC7lrp3o6SZs0Nw=
Date:   Thu, 17 Feb 2022 19:56:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     adobriyan@gmail.com, akpm@linux-foundation.org, david@redhat.com,
        jannh@google.com, kirill.shutemov@linux.intel.com,
        nathan@kernel.org, willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [stable-5.15 PATCH] fs/proc: task_mmu.c: don't read mapcount for
 migration entry
Message-ID: <Yg6ac8WlwtnDH6M0@kroah.com>
References: <20220215221503.855815-1-shy828301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215221503.855815-1-shy828301@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 02:15:03PM -0800, Yang Shi wrote:
> commit 24d7275ce2791829953ed4e72f68277ceb2571c6 upstream
> 
> The syzbot reported the below BUG:
> 
>   kernel BUG at include/linux/page-flags.h:785!
>   invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>   CPU: 1 PID: 4392 Comm: syz-executor560 Not tainted 5.16.0-rc6-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
>   RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
>   Call Trace:
>     page_mapcount include/linux/mm.h:837 [inline]
>     smaps_account+0x470/0xb10 fs/proc/task_mmu.c:466
>     smaps_pte_entry fs/proc/task_mmu.c:538 [inline]
>     smaps_pte_range+0x611/0x1250 fs/proc/task_mmu.c:601
>     walk_pmd_range mm/pagewalk.c:128 [inline]
>     walk_pud_range mm/pagewalk.c:205 [inline]
>     walk_p4d_range mm/pagewalk.c:240 [inline]
>     walk_pgd_range mm/pagewalk.c:277 [inline]
>     __walk_page_range+0xe23/0x1ea0 mm/pagewalk.c:379
>     walk_page_vma+0x277/0x350 mm/pagewalk.c:530
>     smap_gather_stats.part.0+0x148/0x260 fs/proc/task_mmu.c:768
>     smap_gather_stats fs/proc/task_mmu.c:741 [inline]
>     show_smap+0xc6/0x440 fs/proc/task_mmu.c:822
>     seq_read_iter+0xbb0/0x1240 fs/seq_file.c:272
>     seq_read+0x3e0/0x5b0 fs/seq_file.c:162
>     vfs_read+0x1b5/0x600 fs/read_write.c:479
>     ksys_read+0x12d/0x250 fs/read_write.c:619
>     do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The reproducer was trying to read /proc/$PID/smaps when calling
> MADV_FREE at the mean time.  MADV_FREE may split THPs if it is called
> for partial THP.  It may trigger the below race:
> 
>            CPU A                         CPU B
>            -----                         -----
>   smaps walk:                      MADV_FREE:
>   page_mapcount()
>     PageCompound()
>                                    split_huge_page()
>     page = compound_head(page)
>     PageDoubleMap(page)
> 
> When calling PageDoubleMap() this page is not a tail page of THP anymore
> so the BUG is triggered.
> 
> This could be fixed by elevated refcount of the page before calling
> mapcount, but that would prevent it from counting migration entries, and
> it seems overkilling because the race just could happen when PMD is
> split so all PTE entries of tail pages are actually migration entries,
> and smaps_account() does treat migration entries as mapcount == 1 as
> Kirill pointed out.
> 
> Add a new parameter for smaps_account() to tell this entry is migration
> entry then skip calling page_mapcount().  Don't skip getting mapcount
> for device private entries since they do track references with mapcount.
> 
> Pagemap also has the similar issue although it was not reported.  Fixed
> it as well.
> 
> [shy828301@gmail.com: v4]
>   Link: https://lkml.kernel.org/r/20220203182641.824731-1-shy828301@gmail.com
> [nathan@kernel.org: avoid unused variable warning in pagemap_pmd_range()]
>   Link: https://lkml.kernel.org/r/20220207171049.1102239-1-nathan@kernel.org
> Link: https://lkml.kernel.org/r/20220120202805.3369-1-shy828301@gmail.com
> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
> Signed-off-by: Yang Shi <shy828301@gmail.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  fs/proc/task_mmu.c | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)


Both backports applied, thanks.

greg k-h
