Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11B2241795
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 09:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgHKHtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 03:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgHKHtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 03:49:32 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DB1C06174A;
        Tue, 11 Aug 2020 00:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+TJ/vqDKzK90+hFON4erIAG/H/xM0Uf9CVDVNzbr/jk=; b=vUsE5pszqbqW+rNKIucpamldWG
        3N4ra9yWtZ2GOn2xWUVuvTb/C4UYILB8oGyLb8Z8s/UXVDkudXC2uNvkaWG48NBaZgjYj865BvILd
        79eNl4Yc0PcNTEbS/sdRdfujaQBVIws9QUB9KuLSyVDIRnDPmGVBO+LEAngsK5chgDEdpXEGUYHki
        sVuy7bpLgdQzz1E5ODMSYsHgQ5YceLrGjwJmY2VuUfVfRW4VOZSOBd/sEBxtvSo+6ymAmTDrInC4V
        eoFKmvSjnPisOvi0NLuEwHRSl6mRAROd+OrCVG+iWUMwakhfxvpPRFQIMl2iqSKHzumeMsdgL1UgP
        qrMbHwkg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5P2F-0000at-Cy; Tue, 11 Aug 2020 07:49:27 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 915A0980C9D; Tue, 11 Aug 2020 09:49:25 +0200 (CEST)
Date:   Tue, 11 Aug 2020 09:49:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200811074925.GT3982@worktop.programming.kicks-ass.net>
References: <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
 <20200811064516.GA21797@redhat.com>
 <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
 <20200811071401.GB21797@redhat.com>
 <20200811072637.GC21797@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811072637.GC21797@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 09:26:37AM +0200, Oleg Nesterov wrote:
> On 08/11, Oleg Nesterov wrote:
> >
> > On 08/11, Peter Zijlstra wrote:
> > >
> > > On Tue, Aug 11, 2020 at 08:45:16AM +0200, Oleg Nesterov wrote:
> > > >
> > > > ->jobctl is always modified with ->siglock held, do we really need
> > > > WRITE_ONCE() ?
> > >
> > > In theory, yes. The compiler doesn't know about locks, it can tear
> > > writes whenever it feels like it.
> >
> > Yes, but why does this matter? Could you spell please?
> 
> Do you mean that compiler can temporary set/clear JOBCTL_TASK_WORK
> when it sets/clears another bit?

Possibly, afaict the compiler is allowed to 'spill' intermediate state
into the variable. If any intermediate state has the bit clear,...
