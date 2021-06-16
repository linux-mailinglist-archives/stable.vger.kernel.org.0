Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17753A9E4D
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 16:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhFPO7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 10:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233747AbhFPO7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 10:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D0EF610CA;
        Wed, 16 Jun 2021 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623855415;
        bh=PqTEV+Y3Omq+th8DSxU8DPmQr8Af0ZwBW0+urUPYV08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x4r6f6t9j/vQ6snaJmuTLN6jy4SMMZ+1etChFKUYh5kjup5+uk9/sBKXcHLGuZgQq
         nyn1QjWZuwt1N/ky+iu2Ptj7G5u8W0JypTLR4XD9Y1VMKn1YdPwp0WT7R96XCVsHTE
         Z86QIIObBy4H/iPJLU8t/9Z2CQ3488nrzOSsBSg0=
Date:   Wed, 16 Jun 2021 16:56:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Message-ID: <YMoRNZYXoykO7mk0@kroah.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com>
 <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 12:16:52PM +0300, Amit Klein wrote:
> Here is the patch (minus headers, description, etc. - I believe these
> can be copied as is from the 5.x patch, but not sure about the
> rules...). It can be applied to 4.14.236. If this is OK, I can move on
> to 4.9 and 4.4.
> 
> 
>  net/ipv4/route.c | 41 ++++++++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 78d6bc61a1d8..022a2b748da3 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -70,6 +70,7 @@
>  #include <linux/types.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/memblock.h>
>  #include <linux/string.h>
>  #include <linux/socket.h>
>  #include <linux/sockios.h>
> @@ -485,8 +486,10 @@ static void ipv4_confirm_neigh(const struct
> dst_entry *dst, const void *daddr)
>      __ipv4_confirm_neigh(dev, *(__force u32 *)pkey);
>  }
> 
> -#define IP_IDENTS_SZ 2048u
> -
> +/* Hash tables of size 2048..262144 depending on RAM size.
> + * Each bucket uses 8 bytes.
> + */
> +static u32 ip_idents_mask __read_mostly;
>  static atomic_t *ip_idents __read_mostly;
>  static u32 *ip_tstamps __read_mostly;
> 
> @@ -496,12 +499,16 @@ static u32 *ip_tstamps __read_mostly;
>   */
>  u32 ip_idents_reserve(u32 hash, int segs)
>  {
> -    u32 *p_tstamp = ip_tstamps + hash % IP_IDENTS_SZ;
> -    atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
> -    u32 old = ACCESS_ONCE(*p_tstamp);
> -    u32 now = (u32)jiffies;
> +    u32 bucket, old, now = (u32)jiffies;
> +    atomic_t *p_id;
> +    u32 *p_tstamp;

Your patch is corrupted and couldn't be applied if I wanted to :(

