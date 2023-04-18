Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE96E5EC5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjDRKaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjDRKaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:30:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15BAE42;
        Tue, 18 Apr 2023 03:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=GmYJUEoN9b1IwEvqvj4hq5F8JH7LR4eoxY0r0IUp4is=; b=X71a/vVuffGAtOdLbnSUqd6k3a
        CmuDnVNRx3tLh+8p0Cc1CEG/1AZNjTZC3/xyNctLyPBm5R9JIogHiPeg5XdqvovLQVXsrBrmlJkg/
        J4+BuYbICNAgw2iiLrP3m1bb727tDsJjDqaUf3ijb0eP8dt2h/bOOmnIkXN/asfAQCT008rDCMQyU
        HGYVBZcVslhwSmnElfwkiC28UrjCV/jyHlTpX0vjQiCI3SttJa76PBK63yrCB0XPPNlugA+nlRPxj
        3BGnUYUVsBlzAHhZPfuaLCc0HQjOXEGPP1Si3BIIeaFZ8fQaeGnOSUP6DQ2KJXKfoCFVIowBxXMie
        idMc3ldQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1poibD-000R43-1G;
        Tue, 18 Apr 2023 10:30:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E9A2D300237;
        Tue, 18 Apr 2023 12:30:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C6E732C541614; Tue, 18 Apr 2023 12:30:10 +0200 (CEST)
Date:   Tue, 18 Apr 2023 12:30:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     John Stultz <jstultz@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Tim Murray <timmurray@google.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] locking/rwsem: Add __always_inline annotation to
 __down_read_common()
Message-ID: <20230418103010.GY4253@hirez.programming.kicks-ass.net>
References: <20230412023839.2869114-1-jstultz@google.com>
 <20230412035905.3184199-1-jstultz@google.com>
 <20230417111949.GJ83892@hirez.programming.kicks-ass.net>
 <CANDhNCp2WEAMjK1DUVKCen05-EdwVBYZxxLSP3ZSZvRh1ayAhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANDhNCp2WEAMjK1DUVKCen05-EdwVBYZxxLSP3ZSZvRh1ayAhQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 17, 2023 at 06:22:14PM +0200, John Stultz wrote:
> On Mon, Apr 17, 2023 at 1:19 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Wed, Apr 12, 2023 at 03:59:05AM +0000, John Stultz wrote:
> > > Apparently despite it being marked inline, the compiler
> > > may not inline __down_read_common() which makes it difficult
> > > to identify the cause of lock contention, as the blocked
> > > function will always be listed as __down_read_common().
> > >
> > > So this patch adds __always_inline annotation to the
> > > function to force it to be inlines so the calling function
> > > will be listed.
> >
> > I'm a wee bit confused; what are you looking at? Wchan?
> 
> Apologies! Yes, traceevent data via wchan, sorry I didn't make that clear.

No worries; good addition to the v3 Changelog ;-)

> > What is stopping
> > the compiler from now handing you
> > __down_read{,_interruptible,_killable}() instead? Is that fine?
> 
> No, we want to make the blocked calling function, rather than the
> locking functions, visible in the tracepoints captured. That said, the
> other __down_read* functions seem to be properly inlined in practice
> (Waiman's theory as to why sounds convincing to me).

Right, but we should not rely on the compiler heuristics for correctness
:-)

> If you'd like I can add those as well to be always_inline, as well so
> it's more consistent?

Yes please. I'm not sure I care much about the whole 'inline __sched' vs
'__always_inline' thing, but I do feel it should all be consistently
applied.
