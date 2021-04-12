Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FF535C0EC
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbhDLJSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:18:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239298AbhDLJMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 05:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618218750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9MX/q65ulilBbiEmH9SpX/hWPbm4em/YWE26ePKzMIY=;
        b=hxegpaqbRqTCbX4NxRDHe97SA+3DcrN8SBmPYACarJZcBfEHlBhDiO7glZ2x+z4pkJUGf3
        dUPOI3n6d0szOhYQrfyvI2k51eaDx4RGdoOFBfm2E/a8CgwrLw35us5blhGv4VOV5hZsoQ
        6Y3QWrTd6p35JVdYGAyW0M0cKHe+4N4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-U9iTrLTGOK6CUjmw91qwtg-1; Mon, 12 Apr 2021 05:12:28 -0400
X-MC-Unique: U9iTrLTGOK6CUjmw91qwtg-1
Received: by mail-wr1-f72.google.com with SMTP id v3so779598wrr.22
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 02:12:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9MX/q65ulilBbiEmH9SpX/hWPbm4em/YWE26ePKzMIY=;
        b=LU70QCmDXPWQSG/epA3g1QZkmS6Psbz4gYiNPXZuRHsceGzNuuKqzLI/qr8gHWCGA4
         Gnu+ksC2MI/N17cw9j30VPEWB5IToazF2yVASGQvKWclmDp/pMdWEHxGgVgZn5GGrGng
         kzL/N/j5cFaIJFCyQp8Q3SDRIOXf4trdBLhI83h913YMxvj01ynV5qgSCJUuvibOFsDZ
         linK+xvjGdA/sH+iO1v+KhetlreXkL1PDnAwrfq3t/vos9qbpRbQ2noQTZMovrVU2mTw
         iXMA1yihTuYz8lU8vHyWeFbldyA1dmy8Z3W29+0CORWLdUT2O8mCb/rmtscFOxJOkVyp
         yKEw==
X-Gm-Message-State: AOAM533aEL6iKCr7IQg87YaXP7UpHPlAc7yvSHUx0vf/pl1Dt+HSdhhW
        rSDM5nts6wXH6mxU/Yg2vFE2pWueysFbHztGL2PHQYEruJOf20A130pDvTL7mhbGmgE1jqOgcIc
        x/lKOpYOFcGnHkY16
X-Received: by 2002:a1c:c355:: with SMTP id t82mr8739027wmf.160.1618218747305;
        Mon, 12 Apr 2021 02:12:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytReoQtggqwIdF15Nw8+1JD7ZnJzHU1656q8IXOGUyc29YkyAmvn7gN5OjoJW6bjg/x6usvw==
X-Received: by 2002:a1c:c355:: with SMTP id t82mr8739013wmf.160.1618218747161;
        Mon, 12 Apr 2021 02:12:27 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id 24sm13711646wmg.19.2021.04.12.02.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 02:12:26 -0700 (PDT)
Date:   Mon, 12 Apr 2021 05:12:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 28/66] virtio_net: Do not pull payload in skb->head
Message-ID: <20210412051204-mutt-send-email-mst@kernel.org>
References: <20210412083958.129944265@linuxfoundation.org>
 <20210412083959.037627043@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412083959.037627043@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 10:40:34AM +0200, Greg Kroah-Hartman wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 0f6925b3e8da0dbbb52447ca8a8b42b371aac7db ]
> 
> Xuan Zhuo reported that commit 3226b158e67c ("net: avoid 32 x truesize
> under-estimation for tiny skbs") brought  a ~10% performance drop.
> 
> The reason for the performance drop was that GRO was forced
> to chain sk_buff (using skb_shinfo(skb)->frag_list), which
> uses more memory but also cause packet consumers to go over
> a lot of overhead handling all the tiny skbs.
> 
> It turns out that virtio_net page_to_skb() has a wrong strategy :
> It allocates skbs with GOOD_COPY_LEN (128) bytes in skb->head, then
> copies 128 bytes from the page, before feeding the packet to GRO stack.
> 
> This was suboptimal before commit 3226b158e67c ("net: avoid 32 x truesize
> under-estimation for tiny skbs") because GRO was using 2 frags per MSS,
> meaning we were not packing MSS with 100% efficiency.
> 
> Fix is to pull only the ethernet header in page_to_skb()
> 
> Then, we change virtio_net_hdr_to_skb() to pull the missing
> headers, instead of assuming they were already pulled by callers.
> 
> This fixes the performance regression, but could also allow virtio_net
> to accept packets with more than 128bytes of headers.
> 
> Many thanks to Xuan Zhuo for his report, and his tests/help.
> 
> Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
> Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Link: https://www.spinics.net/lists/netdev/msg731397.html
> Co-Developed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>




Note that an issue related to this patch was recently reported.
It's quite possible that the root cause is a bug elsewhere
in the kernel, but it probably makes sense to defer the backport
until we know more ...


> ---
>  drivers/net/virtio_net.c   | 10 +++++++---
>  include/linux/virtio_net.h | 14 +++++++++-----
>  2 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0b1c6a8906b9..06ddf009f833 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -413,9 +413,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	offset += hdr_padded_len;
>  	p += hdr_padded_len;
>  
> -	copy = len;
> -	if (copy > skb_tailroom(skb))
> -		copy = skb_tailroom(skb);
> +	/* Copy all frame if it fits skb->head, otherwise
> +	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
> +	 */
> +	if (len <= skb_tailroom(skb))
> +		copy = len;
> +	else
> +		copy = ETH_HLEN + metasize;
>  	skb_put_data(skb, p, copy);
>  
>  	if (metasize) {
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index a1829139ff4a..8f48264f5dab 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -65,14 +65,18 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>  	skb_reset_mac_header(skb);
>  
>  	if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> -		u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> -		u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> +		u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> +		u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> +		u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
> +
> +		if (!pskb_may_pull(skb, needed))
> +			return -EINVAL;
>  
>  		if (!skb_partial_csum_set(skb, start, off))
>  			return -EINVAL;
>  
>  		p_off = skb_transport_offset(skb) + thlen;
> -		if (p_off > skb_headlen(skb))
> +		if (!pskb_may_pull(skb, p_off))
>  			return -EINVAL;
>  	} else {
>  		/* gso packets without NEEDS_CSUM do not set transport_offset.
> @@ -102,14 +106,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>  			}
>  
>  			p_off = keys.control.thoff + thlen;
> -			if (p_off > skb_headlen(skb) ||
> +			if (!pskb_may_pull(skb, p_off) ||
>  			    keys.basic.ip_proto != ip_proto)
>  				return -EINVAL;
>  
>  			skb_set_transport_header(skb, keys.control.thoff);
>  		} else if (gso_type) {
>  			p_off = thlen;
> -			if (p_off > skb_headlen(skb))
> +			if (!pskb_may_pull(skb, p_off))
>  				return -EINVAL;
>  		}
>  	}
> -- 
> 2.30.2
> 
> 

