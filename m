Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA90124BEA3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgHTJcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbgHTJcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 05:32:03 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B309C061757
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 02:32:02 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d190so971457wmd.4
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 02:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ibBsTdIPUT9J/f3DHP06VncDMYNWSy1uleOHstrXmo=;
        b=XPkTPdDR1f4+jMQpb+XC1VRV38nuhgXBGGKUQoryTuJqAg2zcBulzmQejxHXyMIDUz
         8EqoxHnuvfw+qD9nEVKv3zy+qJCxW7o8g4hsHyQdkblFo/4OXzGUSFOZZTGkD/9NF+4K
         BRSAHeq4zoKm7vPuP1I6Fyr6wxmCtdHJl1qlRAtep1NWAVFPSayiHcYDZILPbCLrMBeC
         PVp38oEFDtM4mxxEfPdJkxTriBNYmPm6p3D940uZilS+E2ABoSgKHiOdVvY9dSrbOjCd
         8W2pURXy9gjO/VzO/Nt/5kRWoz7aXGsXHaRL8VTrEqjsKp7XmhRyWqpM4EuvrtKxALzZ
         zMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ibBsTdIPUT9J/f3DHP06VncDMYNWSy1uleOHstrXmo=;
        b=Sm23o1dm6TFDtwaNxWiDpX0fnYdvs68pGFzDeyIZEDKVWwlgjhHTxp7StbHq5imjaH
         GHIKJrrN33q2Sf66ZOnrgJHPLBhz15bwjYBaSDLP6jy5qLUwV0yRZlLS8FNV4v2ELwRB
         CMcIhnQ6lpLtGrv6u2kSpqAvaIYuL5qmPKswpwgwTMwQbp4H+ICMyCMXacefljxx7EVN
         NX9cnIsg9XPNcTyAefJaKPmFHmv3N6YFFEmrsiZdPuAdYuYirgdb0lEpAGkdvIZweKGu
         mcWaLoeWGX/AqT/K81R2Qq+EAH2KRwWj0DOBMaCKh/cjJ8nxQv8FB5u+O97U0FQRZEq+
         r52A==
X-Gm-Message-State: AOAM530hQ5/bfOiSCqKCdVYmcO5+gTmYszFS1NEt+w3VsGFFC7aEcK8a
        wVfr/3LRjBOAFvZVud6ONeJEPM73baXEyKGB
X-Google-Smtp-Source: ABdhPJyjlFyKYBzcmWO49BeIpBigTqXRJ7CVlH0UYZhNAvY86+U2EtjKUokh6NPdoIepGdTlHoey0Q==
X-Received: by 2002:a1c:49c6:: with SMTP id w189mr2488840wma.97.1597915919859;
        Thu, 20 Aug 2020 02:31:59 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:7220:84ff:fe09:7d5c])
        by smtp.gmail.com with ESMTPSA id b7sm2788182wrs.67.2020.08.20.02.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 02:31:59 -0700 (PDT)
Date:   Thu, 20 Aug 2020 10:31:57 +0100
From:   Alessio Balsini <balsini@android.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        syzbot+01400f5fc51cf4747bec@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.4] ipv6: check skb->protocol before lookup for nexthop
Message-ID: <20200820093157.GB1708325@google.com>
References: <20200819201117.1511154-1-balsini@android.com>
 <20200820080902.GC4049659@kroah.com>
 <20200820085511.GA1708325@google.com>
 <20200820090620.GA1116598@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820090620.GA1116598@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:06:20AM +0200, Greg KH wrote:
> On Thu, Aug 20, 2020 at 09:55:11AM +0100, Alessio Balsini wrote:
> > On Thu, Aug 20, 2020 at 10:09:02AM +0200, Greg KH wrote:
> > > On Wed, Aug 19, 2020 at 09:11:17PM +0100, Alessio Balsini wrote:
> > > > From: WANG Cong <xiyou.wangcong@gmail.com>
> > > > 
> > > > [ Upstream commit 199ab00f3cdb6f154ea93fa76fd80192861a821d ]
> > > > 
> > > > Andrey reported a out-of-bound access in ip6_tnl_xmit(), this
> > > > is because we use an ipv4 dst in ip6_tnl_xmit() and cast an IPv4
> > > > neigh key as an IPv6 address:
> > > > 
> > > >         neigh = dst_neigh_lookup(skb_dst(skb),
> > > >                                  &ipv6_hdr(skb)->daddr);
> > > >         if (!neigh)
> > > >                 goto tx_err_link_failure;
> > > > 
> > > >         addr6 = (struct in6_addr *)&neigh->primary_key; // <=== HERE
> > > >         addr_type = ipv6_addr_type(addr6);
> > > > 
> > > >         if (addr_type == IPV6_ADDR_ANY)
> > > >                 addr6 = &ipv6_hdr(skb)->daddr;
> > > > 
> > > >         memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
> > > > 
> > > > Also the network header of the skb at this point should be still IPv4
> > > > for 4in6 tunnels, we shold not just use it as IPv6 header.
> > > > 
> > > > This patch fixes it by checking if skb->protocol is ETH_P_IPV6: if it
> > > > is, we are safe to do the nexthop lookup using skb_dst() and
> > > > ipv6_hdr(skb)->daddr; if not (aka IPv4), we have no clue about which
> > > > dest address we can pick here, we have to rely on callers to fill it
> > > > from tunnel config, so just fall to ip6_route_output() to make the
> > > > decision.
> > > > 
> > > > Fixes: ea3dc9601bda ("ip6_tunnel: Add support for wildcard tunnel endpoints.")
> > > > Reported-by: Andrey Konovalov <andreyknvl@google.com>
> > > > Reported-by: syzbot+01400f5fc51cf4747bec@syzkaller.appspotmail.com
> > > > Tested-by: Andrey Konovalov <andreyknvl@google.com>
> > > > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > > > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Alessio Balsini <balsini@android.com>
> > > > ---
> > > >  net/ipv6/ip6_tunnel.c | 32 +++++++++++++++++---------------
> > > >  1 file changed, 17 insertions(+), 15 deletions(-)
> > > 
> > > This was already applied to the 4.4.66 kernel release
> > > 
> > > But this patch applies to the 4.4.y tree.  Which is really really odd,
> > > what is going on here?
> > > 
> > > confused,
> > > 
> > > greg k-h
> > 
> > Totally odd... Now that you gave me this heads up, I can see that the
> > patch was applied to v4.4.66 and for some reason dropped since v4.4.118.
> > 
> > Can you please take a look? Thanks!
> 
> What dropped it?  Fixes that resolved other things?  Are you sure this
> is still needed?
> 
> That's all I can tell, you can see the kernel branch as well as I can :)
> 
> greg k-h

It looks like upstream 607f725f6f7d (net: replace dst_cache ip6_tunnel
implementation with the generic one), had some extra code removed when
backported as b8c7f80cbdcd in v4.4.118, resulting in a complete, hidden
revert of the patch proposed in this thread.

Alessio
