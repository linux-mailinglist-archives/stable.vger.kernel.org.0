Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544CE494BFA
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 11:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiATKnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 05:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243288AbiATKnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 05:43:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0E6C061574;
        Thu, 20 Jan 2022 02:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RUxAMIPHh8EnpD7PkzX4ApuOdrcdTPZnoa+y0am0Ul0=; b=E5o6FGrXSZ1r9rnEjy8o+ycLlk
        FAE77GFFmK1xFTUF8V3yI/pRFm9u8ipxwYnGaGMbTSS4vvJbTofWtLgpOv0Xg/uzwmw1yC9KEACRA
        4We19fE6P33qJcUSpx0jzDb4FYIpO8t1uNWiwvLFWmaJtGSYQRzv1yb8iTpvenavYLHNisQuiQPhy
        enPckymC/F4GPe1oBe39u2M54k4nAGBJBnN8k/TUBETZttv8W5a95qjZlF69MDS/qGyw3+7JYstY0
        kVf3lKkPkxzlmUAXQJCvq5QATbtZDqMLPTloG5X5lcH3SAxA5X7d+QFKZXYrxr/S0QqTiXyvI7WsP
        xgVGvoeg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nAUul-00E9Vb-L1; Thu, 20 Jan 2022 10:43:36 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1045F3002F1;
        Thu, 20 Jan 2022 11:43:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E320C2C4BFBCC; Thu, 20 Jan 2022 11:43:32 +0100 (CET)
Date:   Thu, 20 Jan 2022 11:43:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/mmzone.c: fix page_cpupid_xchg_last() to READ_ONCE()
 the page flags
Message-ID: <Yek81DNvQAXMxHwB@hirez.programming.kicks-ass.net>
References: <20220118230539.323058-1-pcc@google.com>
 <Yefh00fKOIPj+kYC@hirez.programming.kicks-ass.net>
 <CAMn1gO5n6GofyRv6dvpEe0xRekRx=wneQzwP-n=9Qj6Pez6eEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMn1gO5n6GofyRv6dvpEe0xRekRx=wneQzwP-n=9Qj6Pez6eEg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 03:28:32PM -0800, Peter Collingbourne wrote:
> On Wed, Jan 19, 2022 at 2:03 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Tue, Jan 18, 2022 at 03:05:39PM -0800, Peter Collingbourne wrote:
> > > After submitting a patch with a compare-exchange loop similar to this
> > > one to set the KASAN tag in the page flags, Andrey Konovalov pointed
> > > out that we should be using READ_ONCE() to read the page flags. Fix
> > > it here.
> >
> > What does it actually fix? If it manages to split the read and read
> > garbage the cmpxchg will fail and we go another round, no harm done.
> 
> What I wasn't sure about was whether the compiler would be allowed to
> break this code by hoisting the read of page->flags out of the loop
> (because nothing in the loop actually writes to page->flags aside from
> the compare-exchange, and if that succeeds we're *leaving* the loop).

The cmpxchg is a barrier() and as such I don't think it's allowed to
hoist anything out of the loop. Except perhaps since it's do-while, it
could try and unroll the first iteration and wreck that something
fierce.

The bigger problem is I think that page_cpuid_last() usage which does a
second load of page->flags, and given sufficient races that could
actually load a different value and then things would be screwy. But
that's not actually fixed.

> > > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > > Link: https://linux-review.googlesource.com/id/I2e1f5b5b080ac9c4e0eb7f98768dba6fd7821693
> >
> > That's that doing here?
> 
> I upload my changes to Gerrit and link to them here so that I (and
> others) can see the progression of the patch via the web UI.

What's the life-time guarantee for that URL existing? Because if it
becomes part of the git commit, it had better stay around 'forever'
etc..
