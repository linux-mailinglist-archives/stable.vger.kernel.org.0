Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0545035C0EB
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbhDLJSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:18:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237922AbhDLJMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 05:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618218707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z4CGSPG8tOPRpMOFt0W6LolJTlNS23GsEDS81NNit60=;
        b=BEEkikuboSBT2qQO0qrQ71dsjSn0/Fs2yfunnxCR+SxPBQHiHa8AQViQ7SKQZs/EU4dHaq
        B4DX31DkXMkCGyib41ymVEaJINGcyDYiD9YbJHpMt96sEj51V5csW4fHVKM9XGTM5hHW76
        fT5rVjkVgaMYVYWU+2I4jK3RMp2wKvg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-q-K5qdtqOXW-kQFLu13vPg-1; Mon, 12 Apr 2021 05:11:45 -0400
X-MC-Unique: q-K5qdtqOXW-kQFLu13vPg-1
Received: by mail-wr1-f70.google.com with SMTP id f3so5738997wrt.14
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 02:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z4CGSPG8tOPRpMOFt0W6LolJTlNS23GsEDS81NNit60=;
        b=IQyZ/B8Bhe2d8OeuJehhTeV/3wrloBY/3c9pCcZmevsBgPUvItUha0n+JnNFegBL+l
         qKnP86awRNP05xoY2k90mWnKf17F36KJrND6y4B6EP5fYoiKDRhDsdRsjLXRV+6JCyY6
         nd2D0rvPiEmlylPpIRuHGJwohkcRqnv7wWJPWDRo/14PnZkf74Ai8lXhmpHi8rq/ndIV
         qOjPvpkIV74D+hvsLKE5JNEbhf12lA3DM+Wib6KU7DzgBRkVSjmAuXwsN1obM/weCK0E
         ftaWUhrtGG8MiNxOkY0J8FR4iQhwqjrBwxBKS1JwWDCr+pbEy207Gf+LWg5h9eBZBKOk
         oV3A==
X-Gm-Message-State: AOAM531rw8z/bxCXlVRkfuyi6qrxXZE5+OmafC+98zKWdCJYOvpTjpdj
        fRiWSb0sfsw+P0Bc+ZWmTOd6F48aPHwwE9o1mMjvU/YN0pCHa2mXFPdQZe9YHQ+PE67R4EZo/BH
        NeHe57Xcf1wwXlId3
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr5212615wrt.132.1618218703975;
        Mon, 12 Apr 2021 02:11:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbpV1As7D9dyJG1976JRdBrYE4HjVYKZIQxqsW0bAy1gaSfmpLSNvIIk81JI1cpg3MnYPDbw==
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr5212601wrt.132.1618218703837;
        Mon, 12 Apr 2021 02:11:43 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id q186sm14842311wma.21.2021.04.12.02.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 02:11:42 -0700 (PDT)
Date:   Mon, 12 Apr 2021 05:11:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 055/188] virtio_net: Do not pull payload in skb->head
Message-ID: <20210412051010-mutt-send-email-mst@kernel.org>
References: <20210412084013.643370347@linuxfoundation.org>
 <20210412084015.479443671@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412084015.479443671@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 10:39:29AM +0200, Greg Kroah-Hartman wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> commit 0f6925b3e8da0dbbb52447ca8a8b42b371aac7db upstream.
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
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



Note that an issue related to this patch was recently reported.
It's quite possible that the root cause is a bug elsewhere
in the kernel, but it probably makes sense to defer the backport
until we know more ...


> ---
>  drivers/net/virtio_net.c   |   10 +++++++---
>  include/linux/virtio_net.h |   14 +++++++++-----
>  2 files changed, 16 insertions(+), 8 deletions(-)
> 
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -406,9 +406,13 @@ static struct sk_buff *page_to_skb(struc
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
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -65,14 +65,18 @@ static inline int virtio_net_hdr_to_skb(
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
> @@ -102,14 +106,14 @@ retry:
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
> 

