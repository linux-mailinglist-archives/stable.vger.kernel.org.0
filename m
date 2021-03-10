Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747E0334726
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhCJSux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:50:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233425AbhCJSup (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 13:50:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3075764DFD;
        Wed, 10 Mar 2021 18:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615402245;
        bh=7EMDjMedyrLG3zrgNV64e8xd6a+Bn6iIf+l9PAZ1tGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nmWbZHfB9JtBuSkosE6pT/lAzdo4BKucpd7KEi+VVGn/LYd6RN9xO/ngy6DC3ed/K
         RHAHp91+DHRvhjCfzRt298Q3XxxqcNrFZNA7IrfJFYOuf+AvT2a3qy3b47poe93CRH
         7/FP6KhfHm+SjguqTAcD1BvPLPnPLyJ1SBzNWl0Y=
Date:   Wed, 10 Mar 2021 19:50:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Jann Horn <jannh@google.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4.14 27/50] mm, slub: consider rest of partial list if
 acquire_slab() fails
Message-ID: <YEkVA764JLFuGV9B@kroah.com>
References: <20210122135735.176469491@linuxfoundation.org>
 <20210122135736.291270624@linuxfoundation.org>
 <CAHk-=wiAafgm4fu-+NNfd5MA_0v7o5Spma-KH82eyJzY_q8-9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiAafgm4fu-+NNfd5MA_0v7o5Spma-KH82eyJzY_q8-9A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 10:43:33AM -0800, Linus Torvalds wrote:
> Just a note to the stable tree: this commit has been reverted
> upstream, because it causes a huge performance drop (admittedly on a
> load and setup that may not be all that relevant to most people).
> 
> It was applied to 4.4, 4.9 and 4.12, because the commit it was marked
> as "fixing" is from 2012, but it turns out that the early exit from
> the loop in that commit was very much intentional, and very much shows
> up on scalability benchmarks.
> 
> I don't think this is likely to be a big deal for the stable kernels -
> we're basically talking tuning for special cases, and while it is
> reverted in my tree now, the "correct" thing to do is likely to be a
> bit more flexible than either "exit loop immediately" or "loop for as
> long as we have contention".
> 
> In practice, most machines probably won't see either case - or it will
> at least be rare enough that you can't tell.
> 
> The machine that reports a huge performance drop was a multi-socket
> machine under fairly extreme conditions, and these contention issues
> are often close to exponential - a smaller machine (or a slighly less
> extreme load) would never see the issue at all either way.
> 
> See
> 
>     https://lore.kernel.org/lkml/20210301080404.GF12822@xsang-OptiPlex-9020/
> 
> for details if you care. I don't think this has to necessarily be
> undone in the stable trees, this email is more of an incidental note
> just as a heads-up.

Thanks for the details, I'll look into reverting it in a future stable
release.

greg k-h
