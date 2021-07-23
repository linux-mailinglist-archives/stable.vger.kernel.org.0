Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F483D39F5
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 14:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhGWLbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 07:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234385AbhGWLbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 07:31:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 286F360EB4;
        Fri, 23 Jul 2021 12:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627042308;
        bh=Mr420c+MF+ArDJ6B2xtcg8/xFgLUpQJWxOrixZ2UYx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FXiQ//HQa+faPjeyCiT+3G9O0eL7X9z76PjcxDu1K7z+76ExLJh7aOebSYjTzZQGL
         oc37XqOMCrWGLOMr6gwQxf9UAliNQYAjYBh1iBs4NhymnxkR/s8f81Ew2St8TYpZNI
         f21AUG9lkV2x8XG9lUlBT78VzyaA2X0nLb6h2dRg=
Date:   Fri, 23 Jul 2021 14:11:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net, jishi@redhat.com
Subject: Re: [PATCH 4.19] net: ip_tunnel: fix mtu calculation for ETHER
 tunnel devices
Message-ID: <YPqyAW86HAnxxezf@kroah.com>
References: <1626967494217153@kroah.com>
 <20210723020031.343268-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723020031.343268-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 23, 2021 at 10:00:31AM +0800, Hangbin Liu wrote:
> commit 9992a078b1771da354ac1f9737e1e639b687caa2 upstream.
> 
> Commit 28e104d00281 ("net: ip_tunnel: fix mtu calculation") removed
> dev->hard_header_len subtraction when calculate MTU for tunnel devices
> as there is an overhead for device that has header_ops.
> 
> But there are ETHER tunnel devices, like gre_tap or erspan, which don't
> have header_ops but set dev->hard_header_len during setup. This makes
> pkts greater than (MTU - ETH_HLEN) could not be xmited. Fix it by
> subtracting the ETHER tunnel devices' dev->hard_header_len for MTU
> calculation.
> 
> Fixes: 28e104d00281 ("net: ip_tunnel: fix mtu calculation")
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/ipv4/ip_tunnel.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)

Applied, thanks.

greg k-h
