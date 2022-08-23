Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EC459EF61
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 00:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiHWWpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 18:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiHWWpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 18:45:30 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088557FFA5
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:45:30 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id x66so6203009vkb.8
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=lKR1LPWV5JYNJ2MF97LLJcPqSX2EDVC07cmQNstoLM8=;
        b=FKfVx2kFpiXPjaveiV3/KqPqJ90UUq8BDS+B6Q6meDoFBSZYDPP7LzvMNFRtnr8IKu
         yqk2TZFqw3e+lPU4trDjsvjvpgOhc5Y2QnDlMKR54ZONC4O2056A4zSi5EBYG43hbClf
         2xFqt9E3rMprMaaLWA3ru/F/ZJL+8R8la6+gfQ7yPyDo2iBbkk8l0J+uhr8m1CbMSz+w
         1oC9axEZJjyZrBGOzVCTLEpcy+AhBX3VlEss8NzshQXPeFLFcgzJLI0rwa8ZKa7xo+9f
         O/EHt9cgK2Q14ci/Jkz3VLCX21cUSwfqX92if5pnl6vwadDAN2SfKQbycvjP4iDf6nE0
         4Aiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lKR1LPWV5JYNJ2MF97LLJcPqSX2EDVC07cmQNstoLM8=;
        b=D5LEENx+EOGDSJ/swNU0+AOz1lHyxVSKLofyUfS0hzIGLhAQ7/nA3U95u56IzrZ3Y9
         XRfJ72f/QYrWovSme+hlG1UjPtvXXt80KM6bT9vMVla/4Et4XLdzSa4ELwYJapD1S3Es
         JUPDBhaFNsN/4/1P0YdjJiGu/RD1vFroU1Qrcx+wGpkP2HE1ktl5DbEoT2Y25zn8FsC5
         Fdi7IY27ubgb818TH9uy9WKmBqaBGSGGUhZ8GuC7BIX7UKk75vd0QNZ2Zh1UCSmPubwH
         EkGCfFEaUR9fKEtGGCGJ3CM18eamcjJyrdOjY/NexCsLZKtuvQOg0tL/gyvfVt/Yl8YA
         X6nQ==
X-Gm-Message-State: ACgBeo2JK//PM9iJWrUhT0iz+qn1McwZ/GewSJ4JB2wRSD5aPU8OA61B
        s9FlOFnsYcV4ll8sk2NT4CwfGTt2JBPsf0xREM08oQ==
X-Google-Smtp-Source: AA6agR4hnPm8HQUZjP3vxa46EViMW812XPaXdP3DMiFa61+rBxn3KXQ9a+ZX8y+EYAVxlMVrlvOJ72psvNRw7Yr8NBY=
X-Received: by 2002:a1f:2ad4:0:b0:38c:5a9c:2d98 with SMTP id
 q203-20020a1f2ad4000000b0038c5a9c2d98mr6090772vkq.24.1661294729024; Tue, 23
 Aug 2022 15:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220823221138.45602-1-peterx@redhat.com>
In-Reply-To: <20220823221138.45602-1-peterx@redhat.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 23 Aug 2022 16:44:51 -0600
Message-ID: <CAOUHufbcxL5GcqQFJHEzsLTV8htAuZ1qucRGBhNQBg65Q4JYuw@mail.gmail.com>
Subject: Re: [PATCH] mm/mprotect: Only reference swap pfn page if type match
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        David Hildenbrand <david@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 4:11 PM Peter Xu <peterx@redhat.com> wrote:
>
> Yu Zhao reported a bug after the commit "mm/swap: Add swp_offset_pfn() to
> fetch PFN from swap entry" added a check in swp_offset_pfn() for swap type [1]:
>
>   kernel BUG at include/linux/swapops.h:117!
>   CPU: 46 PID: 5245 Comm: EventManager_De Tainted: G S         O L 6.0.0-dbg-DEV #2
>   RIP: 0010:pfn_swap_entry_to_page+0x72/0xf0
>   Code: c6 48 8b 36 48 83 fe ff 74 53 48 01 d1 48 83 c1 08 48 8b 09 f6
>   c1 01 75 7b 66 90 48 89 c1 48 8b 09 f6 c1 01 74 74 5d c3 eb 9e <0f> 0b
>   48 ba ff ff ff ff 03 00 00 00 eb ae a9 ff 0f 00 00 75 13 48
>   RSP: 0018:ffffa59e73fabb80 EFLAGS: 00010282
>   RAX: 00000000ffffffe8 RBX: 0c00000000000000 RCX: ffffcd5440000000
>   RDX: 1ffffffffff7a80a RSI: 0000000000000000 RDI: 0c0000000000042b
>   RBP: ffffa59e73fabb80 R08: ffff9965ca6e8bb8 R09: 0000000000000000
>   R10: ffffffffa5a2f62d R11: 0000030b372e9fff R12: ffff997b79db5738
>   R13: 000000000000042b R14: 0c0000000000042b R15: 1ffffffffff7a80a
>   FS:  00007f549d1bb700(0000) GS:ffff99d3cf680000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000440d035b3180 CR3: 0000002243176004 CR4: 00000000003706e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    <TASK>
>    change_pte_range+0x36e/0x880
>    change_p4d_range+0x2e8/0x670
>    change_protection_range+0x14e/0x2c0
>    mprotect_fixup+0x1ee/0x330
>    do_mprotect_pkey+0x34c/0x440
>    __x64_sys_mprotect+0x1d/0x30
>
> It triggers because pfn_swap_entry_to_page() could be called upon e.g. a
> genuine swap entry.
>
> Fix it by only calling it when it's a write migration entry where the page*
> is used.
>
> [1] https://lore.kernel.org/lkml/CAOUHufaVC2Za-p8m0aiHw6YkheDcrO-C3wRGixwDS32VTS+k1w@mail.gmail.com/
>
> Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
> Cc: David Hildenbrand <david@redhat.com>
> Cc: <stable@vger.kernel.org>
> Reported-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>

Thanks for the quick turnaround!

Tested-by: Yu Zhao <yuzhao@google.com>
