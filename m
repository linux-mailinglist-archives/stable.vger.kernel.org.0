Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C324A5A28
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 11:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbiBAKh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 05:37:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35874 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbiBAKh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 05:37:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A3BCB82D3C;
        Tue,  1 Feb 2022 10:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C638C340EB;
        Tue,  1 Feb 2022 10:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643711876;
        bh=nKxNaUeQErOIc7FxwwtPqOK2b0nKk8hQDKK4nb9Z714=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZvIQWR7cyO8y5+xGyW2wrbS0C2HzJRb+Q1BSyYuaI7fhltrKGYAR6AkQetgsDfMfe
         OO0G0t8CMsIKs1fsqHn61UEn26xSQyvWz7STa6QsmHl2tS8ulqQvo5Y8DleQ5bUd8E
         pyI2hLpyxgAz2iTlM2pnTxwk54RCeNNSovqEuvyY=
Date:   Tue, 1 Feb 2022 11:37:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 089/100] net: cpsw: Properly initialise struct
 page_pool_params
Message-ID: <YfkNgUDVl2mLsL6d@kroah.com>
References: <20220131105220.424085452@linuxfoundation.org>
 <20220131105223.452077670@linuxfoundation.org>
 <20220131201909.GA16820@COLIN-DESKTOP1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220131201909.GA16820@COLIN-DESKTOP1.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 12:19:09PM -0800, Colin Foster wrote:
> On Mon, Jan 31, 2022 at 11:56:50AM +0100, Greg Kroah-Hartman wrote:
> > From: Toke Høiland-Jørgensen <toke@redhat.com>
> > 
> > [ Upstream commit c63003e3d99761afb280add3b30de1cf30fa522b ]
> > 
> > The cpsw driver didn't properly initialise the struct page_pool_params
> > before calling page_pool_create(), which leads to crashes after the struct
> > has been expanded with new parameters.
> > 
> > The second Fixes tag below is where the buggy code was introduced, but
> > because the code was moved around this patch will only apply on top of the
> > commit in the first Fixes tag.
> > 
> > Fixes: c5013ac1dd0e ("net: ethernet: ti: cpsw: move set of common functions in cpsw_priv")
> > Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")
> 
> In 5.4 every parameter is individually initialized, so there really
> isn't a "bug" necessarily. Only at commit e68bc75691cc does it actually
> start not initializing every parameter.
> 
> https://elixir.bootlin.com/linux/v5.4.175/source/drivers/net/ethernet/ti/cpsw.c#L558
> 
> I'm not familiar with the process of backporting fixes to stable yet. Is
> there any benefit in this cleanup for 5.4 or is it fine to leave it?

Let's be safe and leave it.

thanks,

greg k-h
