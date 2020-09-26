Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A510279A72
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 17:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgIZPqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 11:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIZPqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 11:46:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5918121527;
        Sat, 26 Sep 2020 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601135183;
        bh=TZhjmcr8VBb2HsuIr9PXLqYwy3YlpUkT+H7f/gykJlU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e1KvFX/1u2YJrdGtkJLOLQwU13CcFwlP242OYfizkB3PUnttZrS9gkoO2LVQisLuz
         +Aq/MMM6CB7z1B+lAhYN0GzV+d7u6GzhN4cQ5NdFWdf6pFm/fSOWypsDZTvsMDqASB
         EvDg1yCUOihIIpJyhwMMYv8v5IeldatxQhC3hOPs=
Date:   Sat, 26 Sep 2020 17:46:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kfir Itzhak <mastertheknife@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 23/37] ipv4: Update exception handling for multipath
 routes via same device
Message-ID: <20200926154635.GA3347445@kroah.com>
References: <20200925124720.972208530@linuxfoundation.org>
 <20200925124724.448531559@linuxfoundation.org>
 <20200925165134.GA7253@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925165134.GA7253@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 06:51:34PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 2fbc6e89b2f1403189e624cabaf73e189c5e50c6 ]
> > 
> > Kfir reported that pmtu exceptions are not created properly for
> > deployments where multipath routes use the same device.
> 
> This is mismerged (in a way that does not affect functionality):
> 
> 
> > @@ -779,6 +779,8 @@ static void __ip_do_redirect(struct rtab
> >  			if (fib_lookup(net, fl4, &res, 0) == 0) {
> >  				struct fib_nh *nh = &FIB_RES_NH(res);
> >  
> > +				fib_select_path(net, &res, fl4, skb);
> > +				nh = &FIB_RES_NH(res);
> >  				update_or_create_fnhe(nh, fl4->daddr, new_gw,
> >  						0, false,
> 
> nh is assigned value that is never used. Mainline patch removes the
> assignment (but variable has different type).
> 
> 4.19 should delete the assignment, too.

Ah, good catch, I'll merge this in, thanks.

greg k-h
