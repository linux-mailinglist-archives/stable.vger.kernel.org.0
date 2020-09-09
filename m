Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D000926273E
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 08:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgIIGhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 02:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgIIGhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 02:37:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F413220936;
        Wed,  9 Sep 2020 06:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599633427;
        bh=V9NR7nDo2UszOuOP8RDVwdq8XRt9ah6sdjjX5rYls7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NlwPLZIgF1GL/oHuvSsxzRQI0AHkOimDqAW5+k22UOG/xweMctkbOEjtlJerTdkMZ
         t7nWuGmH0TygNx0gEVDvPGkfelGdhfgyJj6D4DmjYBwl4SSwYM+nWNfCfj20ufMDSw
         2/hAVYXQkW5uztKEQYJ7Hsvg0AF7CJJ4Nf8TeDCU=
Date:   Wed, 9 Sep 2020 08:37:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Hyunsoon Kim <h10.kim@samsung.com>
Subject: Re: [PATCH 5.4 086/129] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
Message-ID: <20200909063718.GA311356@kroah.com>
References: <20200908152229.689878733@linuxfoundation.org>
 <20200908152234.000867723@linuxfoundation.org>
 <70529b6c-7b00-d760-c0c0-42f0ea5784f3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70529b6c-7b00-d760-c0c0-42f0ea5784f3@solarflare.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 10:35:22PM +0100, Edward Cree wrote:
> On 08/09/2020 16:25, Greg Kroah-Hartman wrote:
> > From: Alexander Lobakin <alobakin@dlink.ru>
> >
> > commit 6570bc79c0dfff0f228b7afd2de720fb4e84d61d upstream.
> >
> > Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
> > skbs") made use of listified skb processing for the users of
> > napi_gro_frags().
> > The same technique can be used in a way more common napi_gro_receive()
> > to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers
> > including gro_cells and mac80211 users.
> > This slightly changes the return value in cases where skb is being
> > dropped by the core stack, but it seems to have no impact on related
> > drivers' functionality.
> > gro_normal_batch is left untouched as it's very individual for every
> > single system configuration and might be tuned in manual order to
> > achieve an optimal performance.
> >
> > Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> > Acked-by: Edward Cree <ecree@solarflare.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Hyunsoon Kim <h10.kim@samsung.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> I'm not quite sure why this is stable material(it's a performance
>  enhancement, rather than a fix).  But if you do want to take it,
>  make sure you've also got
> c80794323e82 ("net: Fix packet reordering caused by GRO and listified RX cooperation")
> b167191e2a85 ("net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling")
>  in your tree, particularly the latter as without it this commit
>  triggers a severe regression in iwlwifi.

Hm, that feels bad, I'll go drop this for now.

Hyunsoon was the one who asked for this, so I will let them defend the
request.  I thought they were asking for this because it was a bug fix,
but if it is a performance issue, that's fine as long as it doesn't also
cause problems :)

Hyunsoon, should all of these be taken, and if so, what exactly is the
performance increase here?

thanks,

greg k-h
