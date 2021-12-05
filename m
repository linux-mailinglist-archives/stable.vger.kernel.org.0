Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DB4468B46
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhLEOAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 09:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbhLEOAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 09:00:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB5FC061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 05:56:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61F02B80E3A
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18EDC341C5;
        Sun,  5 Dec 2021 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638712599;
        bh=gWenVF5FlbdNpiTr6peOxWhdUvvc8GJ2Yncvcih9O10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TOekkIFI9zNng+fPWjQW/+HLu5JE+tV0TZOT5tTI80VWTgm9tMWpVsjaybKECrg96
         fVBrdXHuld7AE26kgNnXqAlwu5bUvM8Yz4nafi2Qr5XtbSt6ZiOkkag1O2Xtr+1VKe
         rA5rG/D3vioz9gkkMqz1iwhshp5LY+8dH03FRbMk=
Date:   Sun, 5 Dec 2021 14:56:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     msizanoen1 <msizanoen@qtmlabs.xyz>
Cc:     stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [Backport 5.4] [PATCH] ipv6: fix memory leak in
 fib6_rule_suppress
Message-ID: <YazFFOHtSpe9pcqc@kroah.com>
References: <61acc094.1c69fb81.ec369.9847SMTPIN_ADDED_MISSING@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61acc094.1c69fb81.ec369.9847SMTPIN_ADDED_MISSING@mx.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 01:48:32PM +0100, msizanoen1 wrote:
> commit cdef485217d30382f3bf6448c54b4401648fe3f1 upstream.
> 
> The kernel leaks memory when a `fib` rule is present in IPv6 nftables
> firewall rules and a suppress_prefix rule is present in the IPv6 routing
> rules (used by certain tools such as wg-quick). In such scenarios, every
> incoming packet will leak an allocation in `ip6_dst_cache` slab cache.
> 
> After some hours of `bpftrace`-ing and source code reading, I tracked
> down the issue to ca7a03c41753 ("ipv6: do not free rt if
> FIB_LOOKUP_NOREF is set on suppress rule").
> 
> The problem with that change is that the generic `args->flags` always have
> `FIB_LOOKUP_NOREF` set[1][2] but the IPv6-specific flag
> `RT6_LOOKUP_F_DST_NOREF` might not be, leading to `fib6_rule_suppress` not
> decreasing the refcount when needed.
> 
> How to reproduce:
>  - Add the following nftables rule to a prerouting chain:
>      meta nfproto ipv6 fib saddr . mark . iif oif missing drop
>    This can be done with:
>      sudo nft create table inet test
>      sudo nft create chain inet test test_chain '{ type filter hook prerouting priority filter + 10; policy accept; }'
>      sudo nft add rule inet test test_chain meta nfproto ipv6 fib saddr . mark . iif oif missing drop
>  - Run:
>      sudo ip -6 rule add table main suppress_prefixlength 0
>  - Watch `sudo slabtop -o | grep ip6_dst_cache` to see memory usage increase
>    with every incoming ipv6 packet.
> 
> This patch exposes the protocol-specific flags to the protocol
> specific `suppress` function, and check the protocol-specific `flags`
> argument for RT6_LOOKUP_F_DST_NOREF instead of the generic
> FIB_LOOKUP_NOREF when decreasing the refcount, like this.
> 
> [1]: https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L71
> [2]: https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L99
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215105
> Fixes: ca7a03c41753 ("ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> This is a backport of the patch to the 5.4 LTS kernels.

Wonderful, now queued up, thanks!

greg k-h
