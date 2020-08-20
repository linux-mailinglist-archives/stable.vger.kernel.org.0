Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B25D24B59A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgHTKZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731621AbgHTKZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:25:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D56620658;
        Thu, 20 Aug 2020 10:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597919106;
        bh=VbvB5sOswCyUX+MC7czXC7El9bgsOs2ET9JHWs2bW1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NMIhr0R06cNcYqhhlkfgXSJmOQqId6EhdoXCBRYLNBG9zUM1w7IxE1MYykNmHD3l1
         wLDUJMiyCjDLN+rfSNAx/o0UteT6wgpRNYowIKeJbsFDKGngDFjFkyzcZeNSGeI38Z
         jQTE4zlfja4RYtWFMicFhzbZegnz2vBCZc7OOXCY=
Date:   Thu, 20 Aug 2020 12:00:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alessio Balsini <balsini@android.com>
Cc:     stable@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        syzbot+01400f5fc51cf4747bec@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.4] ipv6: check skb->protocol before lookup for nexthop
Message-ID: <20200820100020.GA1309765@kroah.com>
References: <20200819201117.1511154-1-balsini@android.com>
 <20200820080902.GC4049659@kroah.com>
 <20200820085511.GA1708325@google.com>
 <20200820090620.GA1116598@kroah.com>
 <20200820093157.GB1708325@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820093157.GB1708325@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 10:31:57AM +0100, Alessio Balsini wrote:
> On Thu, Aug 20, 2020 at 11:06:20AM +0200, Greg KH wrote:
> > On Thu, Aug 20, 2020 at 09:55:11AM +0100, Alessio Balsini wrote:
> > > On Thu, Aug 20, 2020 at 10:09:02AM +0200, Greg KH wrote:
> > > > On Wed, Aug 19, 2020 at 09:11:17PM +0100, Alessio Balsini wrote:
> > > > > From: WANG Cong <xiyou.wangcong@gmail.com>
> > > > > 
> > > > > [ Upstream commit 199ab00f3cdb6f154ea93fa76fd80192861a821d ]
> > > > > 
> > > > > Andrey reported a out-of-bound access in ip6_tnl_xmit(), this
> > > > > is because we use an ipv4 dst in ip6_tnl_xmit() and cast an IPv4
> > > > > neigh key as an IPv6 address:
> > > > > 
> > > > >         neigh = dst_neigh_lookup(skb_dst(skb),
> > > > >                                  &ipv6_hdr(skb)->daddr);
> > > > >         if (!neigh)
> > > > >                 goto tx_err_link_failure;
> > > > > 
> > > > >         addr6 = (struct in6_addr *)&neigh->primary_key; // <=== HERE
> > > > >         addr_type = ipv6_addr_type(addr6);
> > > > > 
> > > > >         if (addr_type == IPV6_ADDR_ANY)
> > > > >                 addr6 = &ipv6_hdr(skb)->daddr;
> > > > > 
> > > > >         memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
> > > > > 
> > > > > Also the network header of the skb at this point should be still IPv4
> > > > > for 4in6 tunnels, we shold not just use it as IPv6 header.
> > > > > 
> > > > > This patch fixes it by checking if skb->protocol is ETH_P_IPV6: if it
> > > > > is, we are safe to do the nexthop lookup using skb_dst() and
> > > > > ipv6_hdr(skb)->daddr; if not (aka IPv4), we have no clue about which
> > > > > dest address we can pick here, we have to rely on callers to fill it
> > > > > from tunnel config, so just fall to ip6_route_output() to make the
> > > > > decision.
> > > > > 
> > > > > Fixes: ea3dc9601bda ("ip6_tunnel: Add support for wildcard tunnel endpoints.")
> > > > > Reported-by: Andrey Konovalov <andreyknvl@google.com>
> > > > > Reported-by: syzbot+01400f5fc51cf4747bec@syzkaller.appspotmail.com
> > > > > Tested-by: Andrey Konovalov <andreyknvl@google.com>
> > > > > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > > > > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > > > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Signed-off-by: Alessio Balsini <balsini@android.com>
> > > > > ---
> > > > >  net/ipv6/ip6_tunnel.c | 32 +++++++++++++++++---------------
> > > > >  1 file changed, 17 insertions(+), 15 deletions(-)
> > > > 
> > > > This was already applied to the 4.4.66 kernel release
> > > > 
> > > > But this patch applies to the 4.4.y tree.  Which is really really odd,
> > > > what is going on here?
> > > > 
> > > > confused,
> > > > 
> > > > greg k-h
> > > 
> > > Totally odd... Now that you gave me this heads up, I can see that the
> > > patch was applied to v4.4.66 and for some reason dropped since v4.4.118.
> > > 
> > > Can you please take a look? Thanks!
> > 
> > What dropped it?  Fixes that resolved other things?  Are you sure this
> > is still needed?
> > 
> > That's all I can tell, you can see the kernel branch as well as I can :)
> > 
> > greg k-h
> 
> It looks like upstream 607f725f6f7d (net: replace dst_cache ip6_tunnel
> implementation with the generic one), had some extra code removed when
> backported as b8c7f80cbdcd in v4.4.118, resulting in a complete, hidden
> revert of the patch proposed in this thread.

Odd, ok, I've queued this up now, thanks!

greg k-h
