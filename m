Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2045262AED
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 10:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgIIIua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 04:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbgIIIua (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 04:50:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C80A2218AC;
        Wed,  9 Sep 2020 08:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599641429;
        bh=3brvJRSqkSgs/2gqVdKI2of8iGbX+HzT97KJlz3luXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pXzO2ZOIUIkiJTzva5kMNDyZDu71A/X4nx147Zo3tMAhVckYbbK1mqZ6OJxf+dLUz
         K1pYBgu/8k1pS1by1NGNXZbS85P8vtqcHmjUTYn1BTi8e5zqwgNYqTF3TBgCPz3Cpr
         HQng+gm3VKPXaFsSTsvHHiJooaMH7HigMCjELsmU=
Date:   Wed, 9 Sep 2020 10:50:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?utf-8?B?6rmA7ZiE7Iic?= <h10.kim@samsung.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [PATCH 5.4 086/129] net: core: use listified Rx for
 GRO_NORMAL in napi_gro_receive()
Message-ID: <20200909085039.GA583189@kroah.com>
References: <20200909063718.GA311356@kroah.com>
 <20200908152229.689878733@linuxfoundation.org>
 <20200908152234.000867723@linuxfoundation.org>
 <70529b6c-7b00-d760-c0c0-42f0ea5784f3@solarflare.com>
 <CGME20200909063710epcas2p340688acd14fad9e0fe53a66d06fd14a7@epcms2p4>
 <20200909072101epcms2p457639b69a22434d140c01aeecd3ef46e@epcms2p4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200909072101epcms2p457639b69a22434d140c01aeecd3ef46e@epcms2p4>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 04:21:01PM +0900, 김현순 wrote:
> Dear Greg,
> 
>  
> 
> I didn't intent to gain performance from this patch. Indeed i requested this
> patch to resolve the bug we are experiencing.
> 
>  
> 
> Different from kernel 4.19, napi gro made additional data structure called
> rx_list, and for some reason, the list is always used after napi_gro_flush,
> which is intended to be created to flush all gro (both merged and non-merged)
> packets to network stack. Network packets received from network interface are
> passed to rx_list once, and the rx_list is later flushed to network stack.
> However, on the other hand, napi_gro_receive doesn't insert packet to rx_list.
> Instead, it flushes to network stack directly. This causes out of order because
> there might be some packets in rx_list (which has groups of packets that are
> not flushed to network stack yet). If the packet from the same stream remains
> in rx_list, and napi_gro_receive on next packet (from the same stream) is
> called, this posterior packet will arrive to network stack first, which causes
> out of order.
> 
>  
> 
> And two patches mentioned by Edward are already in the branch. The patch i am
> requesting is somewhat missing in android kernel, not sure the reason why.

Ah, you are right, this is odd.  Edward, those patches are already in
the 5.4.y tree, which makes this patch not being present odd.

I'll go add it back....

thanks,

greg k-h
