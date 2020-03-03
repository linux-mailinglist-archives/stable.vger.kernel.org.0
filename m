Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C09177ADE
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 16:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgCCPq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 10:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgCCPq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 10:46:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865AB20863;
        Tue,  3 Mar 2020 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583250419;
        bh=fAQdGJUTHfenkFjY5EY4IkekGQXc8jAE7JffWrzy3Bw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UTSJj1dBJ3EXiiMRXOwXIMu/JnjlAGKG874nqk/ykA8f77OSM478hjpP0sbUT9QpU
         kUqOPgyThTJEyJlpnRmqfNMpsk849tkcvUrDl/2R6vmK7peaA0oqoqmvOTz4lFTN8i
         dUGuF46DJXNrKTkEJgCsK9QBRn5bhVnzMktttEr0=
Date:   Tue, 3 Mar 2020 16:46:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tommi Rantala <tommi.t.rantala@nokia.com>
Cc:     stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14] tuntap: correctly set SOCKWQ_ASYNC_NOSPACE
Message-ID: <20200303154656.GD372992@kroah.com>
References: <20200228084216.15816-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228084216.15816-1-tommi.t.rantala@nokia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 10:42:16AM +0200, Tommi Rantala wrote:
> From: Jason Wang <jasowang@redhat.com>
> 
> [ Upstream commit 2f3ab6221e4c87960347d65c7cab9bd917d1f637 ]
> 
> When link is down, writes to the device might fail with
> -EIO. Userspace needs an indication when the status is resolved.  As a
> fix, tun_net_open() attempts to wake up writers - but that is only
> effective if SOCKWQ_ASYNC_NOSPACE has been set in the past. This is
> not the case of vhost_net which only poll for EPOLLOUT after it meets
> errors during sendmsg().
> 
> This patch fixes this by making sure SOCKWQ_ASYNC_NOSPACE is set when
> socket is not writable or device is down to guarantee EPOLLOUT will be
> raised in either tun_chr_poll() or tun_sock_write_space() after device
> is up.
> 
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 1bd4978a88ac2 ("tun: honor IFF_UP in tun_get_user()")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
> ---
>  drivers/net/tun.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)

Thanks for the backport, now queued up to 4.9.y and 4.14.y.

greg k-h
