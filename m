Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715D460D00D
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 17:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiJYPMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 11:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiJYPL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 11:11:59 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FC9FBCF7
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 08:11:57 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id m6so8249229qkm.4
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 08:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M79Zo45I4bE9WQNkOFTdWrsHTrfrgiJTHtIWiYegoZg=;
        b=FX9N/s9/SutgcW/9gcbePP3lroDMrQICKB6xcxQVBj4qtH8fmRaBUvZHexK1tfGk1v
         uKyM+qQHZbOOY1CWZPaShmnA2n/NLOn7R+ImH/Mmv8B2BwoohpGZ3Z1TTVD52vYZsrgD
         G/OgMCKF1T6Zq1ULEGFTjvYWuPWBuO5TabbyDsPyC82NHSV4b/MWyKxUeFU6mIgr5TWA
         Siju8v07GQvikO4Q81JV2VfCoAX6lJIoHPFdvTBWGxHnBbHT8MAuA8GBNsbHWZhHHpAp
         32eGFEih6wnI57wCKepW1niVlOP6YSn1l3lloG8co96YKbVIG12l4rONXoH4iDctBmzk
         Wq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M79Zo45I4bE9WQNkOFTdWrsHTrfrgiJTHtIWiYegoZg=;
        b=jZWA6x6CTeBuRB+25SZBwjYYRzjiNVwKpGgN/XKPIFkCqikFyDszFlipMHxLhvOawa
         H6AjRXrTyvTPj31SnQbsMQ6ysHLBTcDrZ9dYyYrsLricgdFwbpoUKDVE0L3Q6l618Ucv
         tZ94VNEsEvHYcBNKDb5bVexU+KInfSK7JPRZtO3a8AizrNZC7Rw4ZY/MQInBV8f9+qnt
         J/kY+WvHwdzsGloJ3omZeyFX5DQkY51nybp6Y45hRM4nPQZcge/48tWT/zj4hlJqAs6B
         +HRuCclzbn2d3bpohMQQNJbI8ynQEMnWkVXytJMr+YLxzVnQBsCVEAEtq5AuGb2kX0Zd
         1g6A==
X-Gm-Message-State: ACrzQf1xQyMPlcgOFiAuuMFaaGy6ZBM5T7IGDGozbXpMGbSBNFUU9J05
        vqD8gxFwZIPvWrGAxU/GCYLGQQ==
X-Google-Smtp-Source: AMsMyM4uLvCMD1LrvZe04wjR7BhAlI/BQUBp5sxVyjBzG/zAe7JuqyUG2sW/PMNqosjXoH9UhK1MEA==
X-Received: by 2002:a37:c203:0:b0:6ee:a214:a560 with SMTP id i3-20020a37c203000000b006eea214a560mr20946826qkm.528.1666710716191;
        Tue, 25 Oct 2022 08:11:56 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id fp9-20020a05622a508900b0039a08c0a594sm1694087qtb.82.2022.10.25.08.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 08:11:55 -0700 (PDT)
Date:   Tue, 25 Oct 2022 08:11:44 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mel Gorman <mgorman@techsingularity.net>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Yang Shi <shy828301@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Seth Jennings <sjenning@redhat.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: Re: [PATCH 6.0 19/20] mm/huge_memory: do not clobber swp_entry_t
 during THP split
In-Reply-To: <20221024112935.173960536@linuxfoundation.org>
Message-ID: <f6d7b68a-a5ae-2f85-49b7-f4666eb3a8c9@google.com>
References: <20221024112934.415391158@linuxfoundation.org> <20221024112935.173960536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022, Greg Kroah-Hartman wrote:
> From: Mel Gorman <mgorman@techsingularity.net>
> 
> commit 71e2d666ef85d51834d658830f823560c402b8b6 upstream.
> 
> The following has been observed when running stressng mmap since commit
> b653db77350c ("mm: Clear page->private when splitting or migrating a page")
> 
>    watchdog: BUG: soft lockup - CPU#75 stuck for 26s! [stress-ng:9546]
>    CPU: 75 PID: 9546 Comm: stress-ng Tainted: G            E      6.0.0-revert-b653db77-fix+ #29 0357d79b60fb09775f678e4f3f64ef0579ad1374
>    Hardware name: SGI.COM C2112-4GP3/X10DRT-P-Series, BIOS 2.0a 05/09/2016
>    RIP: 0010:xas_descend+0x28/0x80
>    Code: cc cc 0f b6 0e 48 8b 57 08 48 d3 ea 83 e2 3f 89 d0 48 83 c0 04 48 8b 44 c6 08 48 89 77 18 48 89 c1 83 e1 03 48 83 f9 02 75 08 <48> 3d fd 00 00 00 76 08 88 57 12 c3 cc cc cc cc 48 c1 e8 02 89 c2
>    RSP: 0018:ffffbbf02a2236a8 EFLAGS: 00000246
>    RAX: ffff9cab7d6a0002 RBX: ffffe04b0af88040 RCX: 0000000000000002
>    RDX: 0000000000000030 RSI: ffff9cab60509b60 RDI: ffffbbf02a2236c0
>    RBP: 0000000000000000 R08: ffff9cab60509b60 R09: ffffbbf02a2236c0
>    R10: 0000000000000001 R11: ffffbbf02a223698 R12: 0000000000000000
>    R13: ffff9cab4e28da80 R14: 0000000000039c01 R15: ffff9cab4e28da88
>    FS:  00007fab89b85e40(0000) GS:ffff9cea3fcc0000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 00007fab84e00000 CR3: 00000040b73a4003 CR4: 00000000003706e0
>    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>    Call Trace:
>     <TASK>
>     xas_load+0x3a/0x50
>     __filemap_get_folio+0x80/0x370
>     ? put_swap_page+0x163/0x360
>     pagecache_get_page+0x13/0x90
>     __try_to_reclaim_swap+0x50/0x190
>     scan_swap_map_slots+0x31e/0x670
>     get_swap_pages+0x226/0x3c0
>     folio_alloc_swap+0x1cc/0x240
>     add_to_swap+0x14/0x70
>     shrink_page_list+0x968/0xbc0
>     reclaim_page_list+0x70/0xf0
>     reclaim_pages+0xdd/0x120
>     madvise_cold_or_pageout_pte_range+0x814/0xf30
>     walk_pgd_range+0x637/0xa30
>     __walk_page_range+0x142/0x170
>     walk_page_range+0x146/0x170
>     madvise_pageout+0xb7/0x280
>     ? asm_common_interrupt+0x22/0x40
>     madvise_vma_behavior+0x3b7/0xac0
>     ? find_vma+0x4a/0x70
>     ? find_vma+0x64/0x70
>     ? madvise_vma_anon_name+0x40/0x40
>     madvise_walk_vmas+0xa6/0x130
>     do_madvise+0x2f4/0x360
>     __x64_sys_madvise+0x26/0x30
>     do_syscall_64+0x5b/0x80
>     ? do_syscall_64+0x67/0x80
>     ? syscall_exit_to_user_mode+0x17/0x40
>     ? do_syscall_64+0x67/0x80
>     ? syscall_exit_to_user_mode+0x17/0x40
>     ? do_syscall_64+0x67/0x80
>     ? do_syscall_64+0x67/0x80
>     ? common_interrupt+0x8b/0xa0
>     entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The problem can be reproduced with the mmtests config
> config-workload-stressng-mmap.  It does not always happen and when it
> triggers is variable but it has happened on multiple machines.
> 
> The intent of commit b653db77350c patch was to avoid the case where
> PG_private is clear but folio->private is not-NULL.  However, THP tail
> pages uses page->private for "swp_entry_t if folio_test_swapcache()" as
> stated in the documentation for struct folio.  This patch only clobbers
> page->private for tail pages if the head page was not in swapcache and
> warns once if page->private had an unexpected value.
> 
> Link: https://lkml.kernel.org/r/20221019134156.zjyyn5aownakvztf@techsingularity.net
> Fixes: b653db77350c ("mm: Clear page->private when splitting or migrating a page")
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: Brian Foster <bfoster@redhat.com>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Greg, this patch from Mel is important,
but introduces a warning which is giving Tvrtko trouble - see linux-mm
https://lore.kernel.org/linux-mm/1596edbb-02ad-6bdf-51b8-15c2d2e08b76@linux.intel.com/

We already have the fix for the warning, it's making its way through the
system, and is marked for stable, but it has not reached Linus's tree yet.

Please drop this 19/20 from 6.0.4, then I'll reply to this to let you know
when the fix does reach Linus's tree - hopefully the two can go together
in the next 6.0-stable.

I apologize for not writing yesterday: gmail had gathered together
different threads with the same subject, I thought you and stable
were Cc'ed on the linux-mm mail and you would immediately drop it
yourself, but in fact you were not on that thread at all.

Thanks,
Hugh
