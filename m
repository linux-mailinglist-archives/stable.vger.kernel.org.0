Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675CE4888A7
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 11:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiAIKHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 05:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiAIKHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 05:07:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D793C06173F
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 02:07:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0812DB80C98
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 10:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B34C36AE3;
        Sun,  9 Jan 2022 10:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641722829;
        bh=LU5nflu69PNsnG2uKowQC9Ph7zfnACVZ0UMFcITFss0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nn9LU237IVNkK34Y+/DJNKS0D8CY2RwxW+KKHX9k5/+U3sc48PVEpuG9wVIFF9jVX
         x1ZTdOtQX9oW2VNqUV83vUok3Cc2hZCNORSqvCpEIqno1kjLOwIytNd20dpFkBY16o
         gJJW+Pa9FjLDs8o89bHfuDCf5l4gzn2QouOFxSgU=
Date:   Sun, 9 Jan 2022 11:07:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     dsahern@kernel.org, davem@davemloft.net, nicolas.dichtel@6wind.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipv6: Check attribute length for
 RTA_GATEWAY in multipath" failed to apply to 4.4-stable tree
Message-ID: <YdqzyV0RdLFZDqqI@kroah.com>
References: <164156331217042@kroah.com>
 <20220109093058.GA8434@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109093058.GA8434@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 09, 2022 at 10:30:59AM +0100, Pavel Machek wrote:
> Hi!
> 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I could not find better place to reply.
> 
> I see this patch is queued for 5.10 and 4.19. But it is wrong:
> 
> > >From 4619bcf91399f00a40885100fb61d594d8454033 Mon Sep 17 00:00:00 2001
> > From: David Ahern <dsahern@kernel.org>
> > Date: Thu, 30 Dec 2021 17:36:33 -0700
> > Subject: [PATCH] ipv6: Check attribute length for RTA_GATEWAY in multipath
> >  route
> > 
> > Commit referenced in the Fixes tag used nla_memcpy for RTA_GATEWAY as
> > does the current nla_get_in6_addr. nla_memcpy protects against accessing
> > memory greater than what is in the attribute, but there is no check
> > requiring the attribute to have an IPv6 address. Add it.
> > 
> > Fixes: 51ebd3181572 ("ipv6: add support of equal cost multipath
> > (ECMP)")
> 
> ...> @@ -5264,7 +5277,13 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
> >  
> >  			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
> >  			if (nla) {
> > -				r_cfg.fc_gateway = nla_get_in6_addr(nla);
> > +				int ret;
> > +
> > +				ret = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
> > +							extack);
> > +				if (ret)
> > +					return ret;
> > +
> 
> Direct return may not be used here. It needs to goto cleanup.
> 
> It is already fixed in mainline, so you can probably just cherry-pick
> followup patch, too.

What is the follow-up patch git id?

thanks,

greg k-h
