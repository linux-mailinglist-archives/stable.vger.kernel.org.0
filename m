Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8B53CCACD
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 23:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhGRVZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 17:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhGRVZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 17:25:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA33C061762;
        Sun, 18 Jul 2021 14:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=bkAVAt/3DQZ7jiAuNPkT7sUY+jmd1SQANJgkqozmmAM=; b=p/n16vws4Zla/DwGh1eH9QPXEY
        M9stV+oN/cgZvQdGQcpGvAIhLq5q8OtH1Dg+kUM/3VScbgd9OCORaqVtdQ3TcaS0Odp8Ffx/vQsWZ
        gnTJ8g3liZXHJWqnfHI+oYHfScJTDt6HUAz/i7LSUabLIBtq6C6OG2ixxwLf502wwO30EV94e00iZ
        K43DIB3ACwQ35uTIK7UwqmFjZSG0UkynrvQ/Sf6GJ6rsXYxzQp9IYhdpMg1NH1wAIjqRTp0zksGZ7
        RPGDa2NxZvzGOzM7MJXZzpb1VxR9LmHmRLRd/IrPX/88nW2bmtFX2zmSGZBCA7qRlzwR9L0px0QAD
        djAR8qZg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5EEv-006Iqu-RN; Sun, 18 Jul 2021 21:22:28 +0000
Date:   Sun, 18 Jul 2021 22:22:21 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Message-ID: <YPSbjXrBYsRZagAv@casper.infradead.org>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name>
 <6698965.kvI7vG0SvZ@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6698965.kvI7vG0SvZ@natalenko.name>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 18, 2021 at 11:03:51PM +0200, Oleksandr Natalenko wrote:
> + stable@vger.kernel.org
> 
> On neděle 18. července 2021 23:01:24 CEST Oleksandr Natalenko wrote:
> > Hello.
> > 
> > On sobota 17. července 2021 22:22:08 CEST Chris Clayton wrote:
> > > I checked the output from dmesg yesterday and found the following warning:
> > > 
> > > [Fri Jul 16 09:15:29 2021] ------------[ cut here ]------------
> > > [Fri Jul 16 09:15:29 2021] WARNING: CPU: 11 PID: 2701 at
> > > kernel/rcu/tree_plugin.h:359 rcu_note_context_switch+0x37/0x3d0 [Fri Jul

Could you run ./scripts/faddr2line vmlinux rcu_note_context_switch+0x37/0x3d0

> > > [Fri Jul 16 09:15:29 2021] Call Trace:
> > > [Fri Jul 16 09:15:29 2021]  __schedule+0x86/0x810
> > > [Fri Jul 16 09:15:29 2021]  schedule+0x40/0xe0
> > > [Fri Jul 16 09:15:29 2021]  io_schedule+0x3d/0x60
> > > [Fri Jul 16 09:15:29 2021]  wait_on_page_bit_common+0x129/0x390
> > > [Fri Jul 16 09:15:29 2021]  ? __filemap_set_wb_err+0x10/0x10
> > > [Fri Jul 16 09:15:29 2021]  __lock_page_or_retry+0x13f/0x1d0
> > > [Fri Jul 16 09:15:29 2021]  do_swap_page+0x335/0x5b0
> > > [Fri Jul 16 09:15:29 2021]  __handle_mm_fault+0x444/0xb20
> > > [Fri Jul 16 09:15:29 2021]  handle_mm_fault+0x5c/0x170

You were handling a page fault at the time.  The page you wanted was
on swap and this warning fired as a result of waiting for the page
to come back in from swap.  There are a number of warnings in that
function, so it'd be good to track down exactly which one it is.

