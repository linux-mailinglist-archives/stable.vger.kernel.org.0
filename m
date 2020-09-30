Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1815A27E102
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 08:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgI3G0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 02:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3G0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 02:26:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD462071E;
        Wed, 30 Sep 2020 06:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601447175;
        bh=LMD7ZZ5QRigPjlsqESKBR3K6snhZb4kCxr4TukKJr0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qjNVyuHlmYeEDZQZJaR7IP46BLtPZy81Dqrw5nUVugeAaPyZAwrk9pJg/Zd4X+HhO
         koPJXDnXMXvzAW0rWje5MdXeExkddYZRKcT+/OY26uPuX8st2wjW+9P7Wdix897tte
         HN4RmZiQtWwe7EU3H+6ETLsAs7wNEe/0s9y2AFRM=
Date:   Wed, 30 Sep 2020 08:26:17 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Vishnu Rangayyan <vrangayyan@apple.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Forgue <andrewf@apple.com>
Subject: Re: vsock fix for 5.4 stable
Message-ID: <20200930062617.GA1472926@kroah.com>
References: <4871038a-6ab7-4c44-875c-2d04012de34a@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4871038a-6ab7-4c44-875c-2d04012de34a@apple.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 01:53:58PM -0700, Vishnu Rangayyan wrote:
> Hi,
> 
> Can we have this backport applied to 5.4 stable, its more of a required fix
> than an enhancement.
> 
> commit df12eb6d6cd920ab2f0e0a43cd6e1c23a05cea91 upstream
> 
> The call has a minor api change in 5.4 vs higher, only the pkt arg is
> required.
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c
> b/net/vmw_vsock/virtio_transport_common.c
> index d9f0c9c5425a..2f696124bab6 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1153,6 +1153,7 @@ void virtio_transport_recv_pkt(struct virtio_transport
> *t,
>  		virtio_transport_free_pkt(pkt);
>  		break;
>  	default:
> +		(void)virtio_transport_reset_no_sock(pkt);
>  		virtio_transport_free_pkt(pkt);
>  		break;
>  	}
> -- 

Please cc: netdev and the developers who wrote/reviewed a patch when
asking for it to be submitted to stable, so that they can comment on it.

Can you resend it and do that?

thanks,

greg k-h
