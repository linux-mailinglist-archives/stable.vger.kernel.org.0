Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839C076C1F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfGZOyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727172AbfGZOyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 10:54:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79B72070B;
        Fri, 26 Jul 2019 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564152882;
        bh=gGl9USF6emdxxDmy62/p86tB76QQQkpMveALm288CQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P4aPWad454cEG2dHgRAQsWJLlr+KPFPu2AK3ePCcn26NzFybZnAcR+OYjjhMh+dy1
         YjuKCtLFuFwvtQA2IeCrxf9piuacTQ9LsHg8LvWNj006fQqRF2s1sNc4Qe7n31IWZR
         qSVxlRrE+YT19B68HGF/QgQWrEX8+h/LuI4qEKjw=
Date:   Fri, 26 Jul 2019 16:54:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Andrew Prout <aprout@ll.mit.edu>,
        Christoph Paasch <cpaasch@apple.com>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jonathan Looney <jtl@netflix.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tcp: be more careful in tcp_fragment()"
 failed to apply to 4.14-stable tree
Message-ID: <20190726145439.GA10750@kroah.com>
References: <1564144694159130@kroah.com>
 <20190726124517.GA8301@kroah.com>
 <CANn89iKr7vYoLD_o-zhR72rQ8a4OQr=VW6oVRCYBDi1kmN6=dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKr7vYoLD_o-zhR72rQ8a4OQr=VW6oVRCYBDi1kmN6=dg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 04:39:48PM +0200, Eric Dumazet wrote:
> On Fri, Jul 26, 2019 at 2:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jul 26, 2019 at 02:38:14PM +0200, gregkh@linuxfoundation.org wrote:
> > >
> > > The patch below does not apply to the 4.14-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > ------------------ original commit in Linus's tree ------------------
> > >
> > > >From b617158dc096709d8600c53b6052144d12b89fab Mon Sep 17 00:00:00 2001
> > > From: Eric Dumazet <edumazet@google.com>
> > > Date: Fri, 19 Jul 2019 11:52:33 -0700
> > > Subject: [PATCH] tcp: be more careful in tcp_fragment()
> > >
> > > Some applications set tiny SO_SNDBUF values and expect
> > > TCP to just work. Recent patches to address CVE-2019-11478
> > > broke them in case of losses, since retransmits might
> > > be prevented.
> > >
> > > We should allow these flows to make progress.
> > >
> > > This patch allows the first and last skb in retransmit queue
> > > to be split even if memory limits are hit.
> > >
> > > It also adds the some room due to the fact that tcp_sendmsg()
> > > and tcp_sendpage() might overshoot sk_wmem_queued by about one full
> > > TSO skb (64KB size). Note this allowance was already present
> > > in stable backports for kernels < 4.15
> > >
> > > Note for < 4.15 backports :
> > >  tcp_rtx_queue_tail() will probably look like :
> > >
> > > static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
> > > {
> > >       struct sk_buff *skb = tcp_send_head(sk);
> > >
> > >       return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
> > > }
> >
> >
> > Note, I tried the above, but still ran into problems a 4.14 does not
> > have tcp_rtx_queue_head() and while I could guess as to what it would be
> > (tcp_sent_head()?), I figured it would be safer to ask for a backport :)
> >
> 
> 
> tcp_rtx_queue_head(sk) would be implemented by :
> {
>   struct sk_buff *skb = tcp_write_queue_head(sk);
>   if (skb == tcp_send_head(sk))
>     skb = NULL;
>   return skb;
> }
> 
> I can provide the backport, of course.

A backport would be great to ensure I didn't mess it up :)

thanks,

greg k-h
