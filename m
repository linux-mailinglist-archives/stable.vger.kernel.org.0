Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD3624B192
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgHTIzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHTIzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:55:15 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CB4C061757
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 01:55:14 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t14so877284wmi.3
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 01:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=voASvK7r1byQAfyQeIK2SDinl0Ei0791L3Y2GBJM1PQ=;
        b=Xp45Rdn7tWT2+E7OM4t3jZz8Yyv4M0+ZTWZlDOMove11iZCH0JSl+2wmo2hjjxAVUW
         OGk5tUqlT6y1lsE61RW4nyep/nlna7Or7k7cUBV7hIjkbfPPs0ZHPRuXzPLuE5liHcJv
         CuFDETPMXUPWRkVK+S1McWsLEiS2qyAUz4DlYXR4MrW2yCRv6TumkzbdqAYwmOFJPc5l
         kuUQqba/VwxVnPslCQP57D6yHmPIOXPtV3c8xTtkge0ZpKgyMAzHH78PZZRSNxNB5tlQ
         anzsf1BTSpX6n3rwIvIIY1DCGAl1Y3fS63LFEebmNoiwRp9GVIJdYjlnndNKo2VbxqEW
         pSyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=voASvK7r1byQAfyQeIK2SDinl0Ei0791L3Y2GBJM1PQ=;
        b=S1q4oUjrUg2kSUmfGrZDwegVlK1Q7oEjOx9VYwdpI30Oh3YTl2Y/1HLyeTcgJkGd1i
         H0t9qlfgzXS2NWvxz4JO3M6s2Qjl7Sr/+ASQX34mI0BkOuqUxI83Du1u5uLaRaMBNbZ3
         nASrBOBl+BYgasD1CVQUF4XdaHmvMFVmRHn8QVeq3ZwS00PMHemfn974LAi31SabQPsZ
         B0X/yIs4sgl2pQVDol/CHYHRV0HuTGaEbtOptQfeOS+zN1X4p6fL/DnZRVtkEA97wqmT
         qs2gqQXBYIcr4T2//j+lOWx5MAs8dw3bPz2Os1poj3X1+i5eAYl1NyJc5EkP9AiOfoRM
         klcA==
X-Gm-Message-State: AOAM530tCIvN6HfGrb+4mRpW45mHsW5+zC6GuSI5zkHpJuQ76f1/Eekd
        eujF/AocF34weh/RQKkK6iLgEA==
X-Google-Smtp-Source: ABdhPJyeIA0FZmudDJs3TWWtQckRu0HML4rkC008XynFtPlMe2ZxUQX/QWMHMB66etBUto4EMkW5Dg==
X-Received: by 2002:a7b:cb47:: with SMTP id v7mr2620395wmj.129.1597913713402;
        Thu, 20 Aug 2020 01:55:13 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:7220:84ff:fe09:7d5c])
        by smtp.gmail.com with ESMTPSA id o66sm3173820wmb.27.2020.08.20.01.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 01:55:12 -0700 (PDT)
Date:   Thu, 20 Aug 2020 09:55:11 +0100
From:   Alessio Balsini <balsini@android.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        syzbot+01400f5fc51cf4747bec@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.4] ipv6: check skb->protocol before lookup for nexthop
Message-ID: <20200820085511.GA1708325@google.com>
References: <20200819201117.1511154-1-balsini@android.com>
 <20200820080902.GC4049659@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820080902.GC4049659@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 10:09:02AM +0200, Greg KH wrote:
> On Wed, Aug 19, 2020 at 09:11:17PM +0100, Alessio Balsini wrote:
> > From: WANG Cong <xiyou.wangcong@gmail.com>
> > 
> > [ Upstream commit 199ab00f3cdb6f154ea93fa76fd80192861a821d ]
> > 
> > Andrey reported a out-of-bound access in ip6_tnl_xmit(), this
> > is because we use an ipv4 dst in ip6_tnl_xmit() and cast an IPv4
> > neigh key as an IPv6 address:
> > 
> >         neigh = dst_neigh_lookup(skb_dst(skb),
> >                                  &ipv6_hdr(skb)->daddr);
> >         if (!neigh)
> >                 goto tx_err_link_failure;
> > 
> >         addr6 = (struct in6_addr *)&neigh->primary_key; // <=== HERE
> >         addr_type = ipv6_addr_type(addr6);
> > 
> >         if (addr_type == IPV6_ADDR_ANY)
> >                 addr6 = &ipv6_hdr(skb)->daddr;
> > 
> >         memcpy(&fl6->daddr, addr6, sizeof(fl6->daddr));
> > 
> > Also the network header of the skb at this point should be still IPv4
> > for 4in6 tunnels, we shold not just use it as IPv6 header.
> > 
> > This patch fixes it by checking if skb->protocol is ETH_P_IPV6: if it
> > is, we are safe to do the nexthop lookup using skb_dst() and
> > ipv6_hdr(skb)->daddr; if not (aka IPv4), we have no clue about which
> > dest address we can pick here, we have to rely on callers to fill it
> > from tunnel config, so just fall to ip6_route_output() to make the
> > decision.
> > 
> > Fixes: ea3dc9601bda ("ip6_tunnel: Add support for wildcard tunnel endpoints.")
> > Reported-by: Andrey Konovalov <andreyknvl@google.com>
> > Reported-by: syzbot+01400f5fc51cf4747bec@syzkaller.appspotmail.com
> > Tested-by: Andrey Konovalov <andreyknvl@google.com>
> > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Alessio Balsini <balsini@android.com>
> > ---
> >  net/ipv6/ip6_tunnel.c | 32 +++++++++++++++++---------------
> >  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> This was already applied to the 4.4.66 kernel release
> 
> But this patch applies to the 4.4.y tree.  Which is really really odd,
> what is going on here?
> 
> confused,
> 
> greg k-h

Totally odd... Now that you gave me this heads up, I can see that the
patch was applied to v4.4.66 and for some reason dropped since v4.4.118.

Can you please take a look? Thanks!

Alessio
