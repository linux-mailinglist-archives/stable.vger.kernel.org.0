Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCE055D1C
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 02:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFZA4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 20:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfFZA4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 20:56:31 -0400
Received: from localhost (unknown [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 024322085A;
        Wed, 26 Jun 2019 00:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561510590;
        bh=W0a6w7n3NwwgpMsIk3UGanvkzmcJbz3SR2PttPPYxhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fo5AZxxBxmMijX0ZW5vTrWCO1gPYIKLOxC4s0Eq8Wlu978KtIqSvpST81oDbVo5Cl
         NlWzGtl7+TcsXbuICiiSmt+ZrfLqWLFw4Tl95S+vHZ5nSbMTC1oNCVH7w5XQHbtZc7
         F+nENRpW1e4/sZWHknLghqGvy9Oqklu3EmsR8tu4=
Date:   Wed, 26 Jun 2019 08:48:46 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Josh Hunt <johunt@akamai.com>
Cc:     Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
Message-ID: <20190626004846.GA21530@kroah.com>
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
 <20190625202626.GD7898@sasha-vm>
 <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
 <20190625221821.GA17994@kroah.com>
 <7282e627-edd6-51cb-ad9d-d9f34b2e9628@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7282e627-edd6-51cb-ad9d-d9f34b2e9628@akamai.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 03:49:33PM -0700, Josh Hunt wrote:
> On 6/25/19 3:18 PM, Greg KH wrote:
> > On Tue, Jun 25, 2019 at 01:29:35PM -0700, Josh Hunt wrote:
> > > On 6/25/19 1:26 PM, Sasha Levin wrote:
> > > > On Tue, Jun 25, 2019 at 01:19:37PM -0400, Josh Hunt wrote:
> > > > > Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:
> > > > 
> > > > You probably meant b6653b3629e5b88202be3c9abc44713973f5c4b4 here.
> > > 
> > > I wasn't sure if I should reference the upstream commit or stable commit.
> > 
> > The upstream commit please.
> 
> Thanks. I'll fix for next version.
> 
> > 
> > > dad3a9314 is the version of the commit from linux-4.14.y. There may be a
> > > similar issue with the Fixes tag below since that also references the 4.14
> > > vers of the change.
> > > 
> > > > 
> > > > > tcp_fragment() might be called for skbs in the write queue.
> > > > > 
> > > > > Memory limits might have been exceeded because tcp_sendmsg() only
> > > > > checks limits at full skb (64KB) boundaries.
> > > > > 
> > > > > Therefore, we need to make sure tcp_fragment() wont punish applications
> > > > > that might have setup very low SO_SNDBUF values.
> > > > > 
> > > > > Backport notes:
> > > > > Initial version used tcp_queue type which is not present in older
> > > > > kernels,
> > > > > so added a new arg to tcp_fragment() to determine whether this is a
> > > > > retransmit or not.
> > > > > 
> > > > > Fixes: 9daf226ff926 ("tcp: tcp_fragment() should apply sane memory
> > > > > limits")
> > > > > Signed-off-by: Josh Hunt <johunt@akamai.com>
> > > > > Reviewed-by: Jason Baron <jbaron@akamai.com>
> > > > > ---
> > > > > 
> > > > > Eric/Greg - This applies on top of v4.14.130. I did not see anything come
> > > > > through for the older (<4.19) stable kernels yet. Without this change
> > > > > Christoph Paasch's packetrill script (https://lore.kernel.org/netdev/CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com/)
> > > > > 
> > > > > will fail on 4.14 stable kernels, but passes with this change.
> > > > 
> > > > Eric, it would be great if you could Ack this, it's very different from
> > > > your original patch.
> > > 
> > > Yes, that would be great.
> > 
> > I would prefer if this looks a bit more like the upstream fix, perhaps a
> > backport of the function that added the "direction" of the packet first,
> > and then Eric's patch?  As it is, this patch adds a different parameter
> > to the function than what is in Linus's tree, and I bet will cause
> > problems at some later point in time.
> 
> The commit which introduced the fn arguments is part of a much larger change
> that created a separate rb-tree for the retransmit queue:
> 
> commit 75c119afe14f74b4dd967d75ed9f57ab6c0ef045
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Oct 5 22:21:27 2017 -0700
> 
>     tcp: implement rb-tree based retransmit queue
> 
> I can backport the portion of this change which basically does this:
> 
> +enum tcp_queue {
> +       TCP_FRAG_IN_WRITE_QUEUE,
> +       TCP_FRAG_IN_RTX_QUEUE,
> +};
> +int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
> +                struct sk_buff *skb, u32 len,
> +                unsigned int mss_now, gfp_t gfp);
> 
> and the corresponding call-sites of tcp_fragment(). If we do that then
> Eric's fix (b6653b3629e5b88202be3c9abc44713973f5c4b4) should apply cleanly
> on top of linux-4.14.y. I'm happy to do that if you'd rather go that route.

Yes, that is what I was thinking of, thanks.  You expressed it much
better than I could have before my morning coffee :)

> If you want the full rb-tree change into 4.14 then I would defer that to
> Eric, but would argue that IMHO is probably too invasive of a change for a
> LTS kernel.

No, I don't think we should do that work for 4.14.

Also, your change would be suitable for backporting to the older stable
kernels that also need this (4.9.y and 4.4.y.)

thanks,

greg k-h
