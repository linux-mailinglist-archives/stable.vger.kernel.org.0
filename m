Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9C0105B1B
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUU1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:27:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfKUU07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 15:26:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7216820643;
        Thu, 21 Nov 2019 20:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574368018;
        bh=C/VgH8BwEy1i023RhpUjVEPMpC/v8y+ViYx7+0Ra5wo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AT+rFE0mVw18OzGtBTNnaO1v8aUq3U+0wOMZnz+5S05vvrS5ntR4eaWkFRlwrxjyJ
         5Pe8PTTjzBww2l3oAWAevHU25p0faSGGa/NIHlILdve9DEr//LfnGMbnIFuoZR7BKh
         W6CXKEOeH9xFlwEFTogGOpmUIHKaAeVyEKu1DnMc=
Date:   Thu, 21 Nov 2019 21:26:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 241/422] net: socionext: Fix two
 sleep-in-atomic-context bugs in ave_rxfifo_reset()
Message-ID: <20191121202656.GA813044@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051414.641566074@linuxfoundation.org>
 <20191121202140.GA7573@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121202140.GA7573@duo.ucw.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 09:21:40PM +0100, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 0020f5c807ef67954d9210eea0ba17a6134cdf7d ]
> > 
> > The driver may sleep with holding a spinlock.
> > The function call paths (from bottom to top) in Linux-4.17 are:
> > 
> > [FUNC] usleep_range
> > drivers/net/ethernet/socionext/sni_ave.c, 892:
> > 	usleep_range in ave_rxfifo_reset
> > drivers/net/ethernet/socionext/sni_ave.c, 932:
> > 	ave_rxfifo_reset in ave_irq_handler
> > 
> > [FUNC] usleep_range
> > drivers/net/ethernet/socionext/sni_ave.c, 888:
> > 	usleep_range in ave_rxfifo_reset
> > drivers/net/ethernet/socionext/sni_ave.c, 932:
> > 	ave_rxfifo_reset in ave_irq_handler
> > 
> > To fix these bugs, usleep_range() is replaced with udelay().
> 
> I don't believe this is serious enough for -stable, but more
> importantly:

Sleeping in a spinlock is not allowed, yes, this is a bugfix worth of
stable, how could it not?

> > +++ b/drivers/net/ethernet/socionext/sni_ave.c
> > @@ -906,11 +906,11 @@ static void ave_rxfifo_reset(struct net_device *ndev)
> >  
> >  	/* assert reset */
> >  	writel(AVE_GRR_RXFFR, priv->base + AVE_GRR);
> > -	usleep_range(40, 50);
> > +	udelay(50);
> >  
> >  	/* negate reset */
> >  	writel(0, priv->base + AVE_GRR);
> > -	usleep_range(10, 20);
> > +	udelay(20);
> >
> 
> udelay(40) / udelay(10) should be enough here.

Maybe not, this way is safe, right?

greg k-h
