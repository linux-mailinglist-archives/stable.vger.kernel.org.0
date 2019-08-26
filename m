Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0027E9CC81
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 11:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfHZJXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 05:23:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbfHZJXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 05:23:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2KBUYcIEMh8CbI2PPoE5kOoIKtOGa1DHFxKeskY4Qlk=; b=aZd6f2fvSGtnTzhxj37lD+Gdd
        feaLc4us57oYUJCpRf63+PtXp2xoF+FsBuCKvxUA8q7t+RXVGH6KWS+75mPQnH39rHMiFNGewlQzY
        u6Kq1C4ysxWRUTbnm/SrJt4VpgJHSHy5sNzOdyCnSCVAx6dBftJQ+fN7K0ntkcTLgE2Kc7qIA5dpc
        ZsBa9RgPe886KK58t75r8hhXisol3nilmufWhLyY+mt3wi8yUxmc5VlVIeIoEOZp/ojdGRSwuuNGt
        CZiQYyH7P/jB6CDfKjVOpZiElQyFtkjLjhBhXpJkYAyB8d3M7rf0lEUJZ3vEs33VaGxS/k8hm4Iix
        plKHNfhxA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i2BDL-0005j9-6Z; Mon, 26 Aug 2019 09:23:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 03BA8301FF9;
        Mon, 26 Aug 2019 11:22:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3F8602022F842; Mon, 26 Aug 2019 11:23:00 +0200 (CEST)
Date:   Mon, 26 Aug 2019 11:23:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "sbsiddha@gmail.com" <sbsiddha@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Message-ID: <20190826092300.GN2369@hirez.programming.kicks-ass.net>
References: <20190823052335.572133-1-songliubraving@fb.com>
 <20190823093637.GH2369@hirez.programming.kicks-ass.net>
 <164D1F08-80F7-4E13-94FC-78F33B3E299F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164D1F08-80F7-4E13-94FC-78F33B3E299F@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 04:40:23AM +0000, Song Liu wrote:
> Cc: Steven Rostedt and Suresh Siddha
> 
> Hi Peter, 
> 
> > On Aug 23, 2019, at 2:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > On Thu, Aug 22, 2019 at 10:23:35PM -0700, Song Liu wrote:
> >> As 4k pages check was removed from cpa [1], set_kernel_text_rw() leads to
> >> split_large_page() for all kernel text pages. This means a single kprobe
> >> will put all kernel text in 4k pages:
> >> 
> >>  root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
> >>  0xffffffff81000000-0xffffffff82400000     20M  ro    PSE      x  pmd
> >> 
> >>  root@ ~# echo ONE_KPROBE >> /sys/kernel/debug/tracing/kprobe_events
> >>  root@ ~# echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
> >> 
> >>  root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
> >>  0xffffffff81000000-0xffffffff82400000     20M  ro             x  pte
> >> 
> >> To fix this issue, introduce CPA_FLIP_TEXT_RW to bypass "Text RO" check
> >> in static_protections().
> >> 
> >> Two helper functions set_text_rw() and set_text_ro() are added to flip
> >> _PAGE_RW bit for kernel text.
> >> 
> >> [1] commit 585948f4f695 ("x86/mm/cpa: Avoid the 4k pages check completely")
> > 
> > ARGH; so this is because ftrace flips the whole kernel range to RW and
> > back for giggles? I'm thinking _that_ is a bug, it's a clear W^X
> > violation.
> 
> Thanks for your comments. Yes, it is related to ftrace, as we have
> CONFIG_KPROBES_ON_FTRACE. However, after digging around, I am not sure
> what is the expected behavior.

It changed recently; that is we got a lot more strict wrt W^X mappings.
IIRC ftrace is the only known violator of W^X at this time.

> Kernel text region has two mappings to it. For x86_64 and four-level 
> page table, there are: 
> 
> 	1. kernel identity mapping, from 0xffff888000100000; 
> 	2. kernel text mapping, from 0xffffffff81000000, 

Right; AFAICT this is so that kernel text fits in s32 immediates.

> Per comments in arch/x86/mm/init_64.c:set_kernel_text_rw():
> 
>         /*
>          * Make the kernel identity mapping for text RW. Kernel text
>          * mapping will always be RO. Refer to the comment in
>          * static_protections() in pageattr.c
>          */
> 	set_memory_rw(start, (end - start) >> PAGE_SHIFT);

So only the high mapping is ever executable; the identity map should not
be. Both should be RO.

> kprobe (with CONFIG_KPROBES_ON_FTRACE) should work on kernel identity
> mapping. 

Please provide more information; kprobes shouldn't be touching either
mapping. That is, afaict kprobes uses text_poke() which uses a temporary
mapping (in 'userspace' even) to alias the high text mapping.

I'm also not sure how it would then result in any 4k text maps. Yes the
alias is 4k, but it should not affect the actual high text map in any
way.

kprobes also allocates executable slots, but it does that in the module
range (afaict), so that, again, should not affect the high text mapping.

> We found with 5.2 kernel (no CONFIG_PAGE_TABLE_ISOLATION, w/ 
> CONFIG_KPROBES_ON_FTRACE), a single kprobe will split _all_ PMDs in 
> kernel text mapping into pte-mapped pages. This increases iTLB 
> miss rate from about 300 per million instructions to about 700 per
> million instructions (for the application I test with). 
> 
> Per bisect, we found this behavior happens after commit 585948f4f695 
> ("x86/mm/cpa: Avoid the 4k pages check completely"). That's why I 
> proposed this PATCH to fix/workaround this issue. However, per
> Peter's comment and my study of the code, this doesn't seem the 
> real problem or the only here. 
> 
> I also tested that the PMD split issue doesn't happen w/o 
> CONFIG_KPROBES_ON_FTRACE. 

Right, because then ftrace doesn't flip the whole kernel map writable;
which it _really_ should stop doing anyway.

But I'm still wondering what causes that first 4k split...
