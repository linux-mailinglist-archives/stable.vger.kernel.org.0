Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2152AB4E0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgKIK2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:28:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgKIK2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 05:28:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52E5D206E3;
        Mon,  9 Nov 2020 10:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604917694;
        bh=F4DJfBvLNERc4ObqNHuoqD0PrLer0QzMxjwGTa9K7V0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BpY/bMSz5HZFttESVRrZzFD+mpD0ZfIPSjZqbDXLh+i2AbG/nrL074Z18cO9YQW6V
         24eT54LJ6QQjNIpG9rM9frhZ/tJLCYCCEhHXZY94w1Yu+If31ccCo2ha5y3xWBD2+R
         ElwYQeHkuqmmgGnc9HrSznCu+t6kw8hMiJpVLLTU=
Date:   Mon, 9 Nov 2020 11:29:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waldemar Brodkorb <wbx@uclibc-ng.org>
Subject: Re: [PATCH] Revert "ARC: entry: fix potential EFA clobber when
 TIF_SYSCALL_TRACE"
Message-ID: <20201109102914.GD1238638@kroah.com>
References: <20201020021957.1260521-1-vgupta@synopsys.com>
 <9cec26bd-6839-b90d-9bda-44936457e883@synopsys.com>
 <20201107141006.GB28983@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201107141006.GB28983@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 07, 2020 at 03:10:06PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Nov 06, 2020 at 08:27:44PM +0000, Vineet Gupta wrote:
> > Hi Stable Team,
> > 
> > On 10/19/20 7:19 PM, Vineet Gupta wrote:
> > > This reverts commit 00fdec98d9881bf5173af09aebd353ab3b9ac729.
> > > (but only from 5.2 and prior kernels)
> > > 
> > > The original commit was a preventive fix based on code-review and was
> > > auto-picked for stable back-port (for better or worse).
> > > It was OK for v5.3+ kernels, but turned up needing an implicit change
> > > 68e5c6f073bcf70 "(ARC: entry: EV_Trap expects r10 (vs. r9) to have
> > >  exception cause)" merged in v5.3 which itself was not backported.
> > > So to summarize the stable backport of this patch for v5.2 and prior
> > > kernels is busted and it won't boot.
> > > 
> > > The obvious solution is backport 68e5c6f073bcf70 but that is a pain as
> > > it doesn't revert cleanly and each of affected kernels (so far v4.19,
> > > v4.14, v4.9, v4.4) needs a slightly different massaged varaint.
> > > So the easier fix is to simply revert the backport from 5.2 and prior.
> > > The issue was not a big deal as it would cause strace to sporadically
> > > not work correctly.
> > > 
> > > Waldemar Brodkorb first reported this when running ARC uClibc regressions
> > > on latest stable kernels (with offending backport). Once he bisected it,
> > > the analysis was trivial, so thx to him for this.
> > > 
> > > Reported-by: Waldemar Brodkorb <wbx@uclibc-ng.org>
> > > Bisected-by: Waldemar Brodkorb <wbx@uclibc-ng.org>
> > > Cc: stable <stable@vger.kernel.org> # 5.2 and prior
> > > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> > 
> > Can this revert be please applied to 4.19 and older kernels for the next cycle.
> > 
> > Or is there is a procedural issue given this revert is not in mainline. I've
> > described the issue in detail above so if there's a better/desirable way of
> > reverting it from backports, please let me know.
> 
> THis is fine, sorry, it's just in a backlog of lots of stable patches...
> 
> We will get to it soon.

Now queued up, thanks.

gre gk-h
