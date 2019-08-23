Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1AF39AB77
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 11:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733013AbfHWJhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 05:37:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36708 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfHWJhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 05:37:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=npY3kxMBkpg6StNbFZw2v3WvWnwH4EGOxrS2hJvkUAQ=; b=QYnL2t5MsjdvI+dwV/uz9x/ny
        w4l7H3zbjU9ULp8rqmNsdkMzJefwulHzT674UaVXVW2ZOxGNk2IPoyDOVYwxdlw2/cUrKB2IuCmzk
        UFf3j6w6pZBxPDIBCztDYsTGYBwpd2G/WFNNpuW/cqSeOLJdLz2CvmEqnVpO7gFMO3i7gP79I0hrQ
        PnrgbnRKx5QW5wmGNN0cHJoBXpzj4VZ/EfwacdpQ1zfnNaHhHt6Bv/aWXHXIiY6jseD6krryICT92
        bfZ6I3NLzuSNC85WpvHObD0w9bp2jOXxOTUBKMCaXC47F2BAJ83x4nEeaGSMW+OLfKDn7VfnST5Xb
        njK0EEvPQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i15zt-0007yJ-1Y; Fri, 23 Aug 2019 09:36:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A175E307603;
        Fri, 23 Aug 2019 11:36:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DEFD920BF0F18; Fri, 23 Aug 2019 11:36:37 +0200 (CEST)
Date:   Fri, 23 Aug 2019 11:36:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-team@fb.com, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Message-ID: <20190823093637.GH2369@hirez.programming.kicks-ass.net>
References: <20190823052335.572133-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823052335.572133-1-songliubraving@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 10:23:35PM -0700, Song Liu wrote:
> As 4k pages check was removed from cpa [1], set_kernel_text_rw() leads to
> split_large_page() for all kernel text pages. This means a single kprobe
> will put all kernel text in 4k pages:
> 
>   root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
>   0xffffffff81000000-0xffffffff82400000     20M  ro    PSE      x  pmd
> 
>   root@ ~# echo ONE_KPROBE >> /sys/kernel/debug/tracing/kprobe_events
>   root@ ~# echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
> 
>   root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
>   0xffffffff81000000-0xffffffff82400000     20M  ro             x  pte
> 
> To fix this issue, introduce CPA_FLIP_TEXT_RW to bypass "Text RO" check
> in static_protections().
> 
> Two helper functions set_text_rw() and set_text_ro() are added to flip
> _PAGE_RW bit for kernel text.
> 
> [1] commit 585948f4f695 ("x86/mm/cpa: Avoid the 4k pages check completely")

ARGH; so this is because ftrace flips the whole kernel range to RW and
back for giggles? I'm thinking _that_ is a bug, it's a clear W^X
violation.
