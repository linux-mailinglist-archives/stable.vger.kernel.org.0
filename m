Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9B2B297A
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 01:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgKNAFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 19:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKNAFr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 19:05:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E63721D7F;
        Sat, 14 Nov 2020 00:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605312346;
        bh=maE3CWq0LKHBcuYR6Vh3zhjKT04SDwzKni7EmIH2f2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kc7c3b+OC7oeO3NCydiGyURV5Uj0zP+66qdEhEZRxuURA6ZOXUa/1b0wrV824cg5B
         0tyTWRDHp8bit473oxX72VSz9onkMJG8G3pzkHcvTORdmzJ5cyFJ9Vp+/suCbotS/Q
         f40AqpUzbOmB0TVDkqlzoHsS8ueg8vUHN3hu5xYw=
Date:   Sat, 14 Nov 2020 01:06:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4.19] netfilter: use actual socket sk rather than skb sk
 when routing harder
Message-ID: <X68fk6C8jDiAiXvF@kroah.com>
References: <X6rMJe+bF+/ZyyTz@kroah.com>
 <20201113224936.2969548-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113224936.2969548-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 13, 2020 at 11:49:36PM +0100, Jason A. Donenfeld wrote:
> [ Upstream commit 46d6c5ae953cc0be38efd0e469284df7c4328cf8 ]
> 
> If netfilter changes the packet mark when mangling, the packet is
> rerouted using the route_me_harder set of functions. Prior to this
> commit, there's one big difference between route_me_harder and the
> ordinary initial routing functions, described in the comment above
> __ip_queue_xmit():
> 
>    /* Note: skb->sk can be different from sk, in case of tunnels */
>    int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
> 
> That function goes on to correctly make use of sk->sk_bound_dev_if,
> rather than skb->sk->sk_bound_dev_if. And indeed the comment is true: a
> tunnel will receive a packet in ndo_start_xmit with an initial skb->sk.
> It will make some transformations to that packet, and then it will send
> the encapsulated packet out of a *new* socket. That new socket will
> basically always have a different sk_bound_dev_if (otherwise there'd be
> a routing loop). So for the purposes of routing the encapsulated packet,
> the routing information as it pertains to the socket should come from
> that socket's sk, rather than the packet's original skb->sk. For that
> reason __ip_queue_xmit() and related functions all do the right thing.
> 
> One might argue that all tunnels should just call skb_orphan(skb) before
> transmitting the encapsulated packet into the new socket. But tunnels do
> *not* do this -- and this is wisely avoided in skb_scrub_packet() too --
> because features like TSQ rely on skb->destructor() being called when
> that buffer space is truely available again. Calling skb_orphan(skb) too
> early would result in buffers filling up unnecessarily and accounting
> info being all wrong. Instead, additional routing must take into account
> the new sk, just as __ip_queue_xmit() notes.
> 
> So, this commit addresses the problem by fishing the correct sk out of
> state->sk -- it's already set properly in the call to nf_hook() in
> __ip_local_out(), which receives the sk as part of its normal
> functionality. So we make sure to plumb state->sk through the various
> route_me_harder functions, and then make correct use of it following the
> example of __ip_queue_xmit().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Reviewed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> [Jason: backported to 4.19 from Sasha's 5.4 backport]
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Now queued up, thanks!

greg k-h
