Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9199CE2A
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 13:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbfHZLdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 07:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbfHZLdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 07:33:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42DD9217F5;
        Mon, 26 Aug 2019 11:33:10 +0000 (UTC)
Date:   Mon, 26 Aug 2019 07:33:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kernel-team@fb.com, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Nadav Amit <namit@vmware.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Message-ID: <20190826073308.6e82589d@gandalf.local.home>
In-Reply-To: <20190823093637.GH2369@hirez.programming.kicks-ass.net>
References: <20190823052335.572133-1-songliubraving@fb.com>
        <20190823093637.GH2369@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 23 Aug 2019 11:36:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Aug 22, 2019 at 10:23:35PM -0700, Song Liu wrote:
> > As 4k pages check was removed from cpa [1], set_kernel_text_rw() leads to
> > split_large_page() for all kernel text pages. This means a single kprobe
> > will put all kernel text in 4k pages:
> > 
> >   root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
> >   0xffffffff81000000-0xffffffff82400000     20M  ro    PSE      x  pmd
> > 
> >   root@ ~# echo ONE_KPROBE >> /sys/kernel/debug/tracing/kprobe_events
> >   root@ ~# echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
> > 
> >   root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
> >   0xffffffff81000000-0xffffffff82400000     20M  ro             x  pte
> > 
> > To fix this issue, introduce CPA_FLIP_TEXT_RW to bypass "Text RO" check
> > in static_protections().
> > 
> > Two helper functions set_text_rw() and set_text_ro() are added to flip
> > _PAGE_RW bit for kernel text.
> > 
> > [1] commit 585948f4f695 ("x86/mm/cpa: Avoid the 4k pages check completely")  
> 
> ARGH; so this is because ftrace flips the whole kernel range to RW and
> back for giggles? I'm thinking _that_ is a bug, it's a clear W^X
> violation.

Since ftrace did this way before text_poke existed and way before
anybody cared (back in 2007), it's not really a bug.

Anyway, I believe Nadav has some patches that converts ftrace to use
the shadow page modification trick somewhere.

Or we also need the text_poke batch processing (did that get upstream?).

Mapping in 40,000 pages one at a time is noticeable from a human stand
point.

-- Steve
