Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3109E651F2
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 08:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfGKGp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 02:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfGKGp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 02:45:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A15420838;
        Thu, 11 Jul 2019 06:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562827555;
        bh=QO+IixaEINnRUlMplYokoVhew/W3TcWPGiXzmUqgm7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E4uwDe7hAN9V7ID7Uhs6z8LLObasbqynt8fY1jOyrIF2+mm5V1AucAT5rS8vAJvqM
         wIAqXgaIbvOCTAjumznze5OfEmXwOf8MaRD+PxoVYBSbL64P3L7OkWCL2SLTC0aVRw
         nudkd/v0vOH5s8bJH4EQrHWl+pE0He/XkxfFILgc=
Date:   Thu, 11 Jul 2019 08:45:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Juergen Gross <jgross@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        He Zhe <zhe.he@windriver.com>,
        Joel Fernandes <joel@joelfernandes.org>, devel@etsukata.com,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 5/7] x86/mm, tracing: Fix CR2 corruption
Message-ID: <20190711064552.GB10089@kroah.com>
References: <20190704195555.580363209@infradead.org>
 <20190704200050.534802824@infradead.org>
 <CALCETrXvTvFBaQB-kEe4cRTCXUyTbWLbcveWsH-kX4j915c_=w@mail.gmail.com>
 <CALCETrUzP4Wb=WNhGvc7k4oX7QQz1JXZ3-O8PQhs39kmZid0nw@mail.gmail.com>
 <CAHk-=wh+J7ts6OrzzscMj5FONd3TRAwAKPZ=BQmEb2E8_-RXTA@mail.gmail.com>
 <20190710162709.1c306f8a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710162709.1c306f8a@gandalf.local.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 10, 2019 at 04:27:09PM -0400, Steven Rostedt wrote:
> 
> [ added stable folks ]
> 
> On Sun, 7 Jul 2019 11:17:09 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sun, Jul 7, 2019 at 8:11 AM Andy Lutomirski <luto@kernel.org> wrote:
> > >
> > > FWIW, I'm leaning toward suggesting that we apply the trivial tracing
> > > fix and backport *that*.  Then, in -tip, we could revert it and apply
> > > this patch instead.  
> > 
> > You don't have to have the same fix in stable as in -tip.
> > 
> > It's fine to send something to stable that says "Fixed differently by
> > commit XYZ upstream". The main thing is to make sure that stable
> > doesn't have fixes that then get lost upstream (which we used to have
> > long long ago).
> > 
> 
> But isn't it easier for them to just pull the quick fix in, if it is in
> your tree? That is, it shouldn't be too hard to make the "quick fix"
> that gets backported on your tree (and probably better testing), and
> then add the proper fix on top of it. The stable folks will then just
> use the commit sha to know what to take, and feel more confident about
> taking it.

It all depends on what the "quick fix" is.  The reason I want to take
the exact same patch that is in Linus's tree is that 95% of the time
that we do a "one off" patch for stable only, it's wrong.  We _ALWAYS_
get it wrong somehow, it's crazy how bad we are at this.  I don't know
why this is, but we have the stats to prove it.

Because of this, I now require the "one off" stable only fixes to get a
bunch of people reviewing it and write up a bunch of explaination as to
why this is the way it is and why we can't just take whatever is in
mainline.

thanks,

greg k-h
