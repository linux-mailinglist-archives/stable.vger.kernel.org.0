Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A6935C44F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 12:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbhDLKpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 06:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239062AbhDLKph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 06:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 374F36134F;
        Mon, 12 Apr 2021 10:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618224319;
        bh=/yFjMUiGPFNWMalqJeYQqR6ZQK8rTlZ0JOYyZI10Zdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uZy2CKXyxIM6LSMKsoGOrwjzJ/dzK4T3EygMvD1b5iY/Y9IS6+Iws23AYOEqSIrj6
         OdpJPAmBiJdx7juSCPSIRT56CER2Da7apU5bnf2PxfAHx9gY1c0uUPdOpivELFu2Mg
         eOOyS9JYEFqX0MDAtR5HdMr2QM1flv+b/ucccMOc=
Date:   Mon, 12 Apr 2021 12:45:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 055/188] virtio_net: Do not pull payload in skb->head
Message-ID: <YHQkvAOytk+rH+LB@kroah.com>
References: <20210412084013.643370347@linuxfoundation.org>
 <20210412084015.479443671@linuxfoundation.org>
 <20210412051010-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412051010-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 05:11:40AM -0400, Michael S. Tsirkin wrote:
> On Mon, Apr 12, 2021 at 10:39:29AM +0200, Greg Kroah-Hartman wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > commit 0f6925b3e8da0dbbb52447ca8a8b42b371aac7db upstream.
> > 
> > Xuan Zhuo reported that commit 3226b158e67c ("net: avoid 32 x truesize
> > under-estimation for tiny skbs") brought  a ~10% performance drop.
> > 
> > The reason for the performance drop was that GRO was forced
> > to chain sk_buff (using skb_shinfo(skb)->frag_list), which
> > uses more memory but also cause packet consumers to go over
> > a lot of overhead handling all the tiny skbs.
> > 
> > It turns out that virtio_net page_to_skb() has a wrong strategy :
> > It allocates skbs with GOOD_COPY_LEN (128) bytes in skb->head, then
> > copies 128 bytes from the page, before feeding the packet to GRO stack.
> > 
> > This was suboptimal before commit 3226b158e67c ("net: avoid 32 x truesize
> > under-estimation for tiny skbs") because GRO was using 2 frags per MSS,
> > meaning we were not packing MSS with 100% efficiency.
> > 
> > Fix is to pull only the ethernet header in page_to_skb()
> > 
> > Then, we change virtio_net_hdr_to_skb() to pull the missing
> > headers, instead of assuming they were already pulled by callers.
> > 
> > This fixes the performance regression, but could also allow virtio_net
> > to accept packets with more than 128bytes of headers.
> > 
> > Many thanks to Xuan Zhuo for his report, and his tests/help.
> > 
> > Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Link: https://www.spinics.net/lists/netdev/msg731397.html
> > Co-Developed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: virtualization@lists.linux-foundation.org
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> 
> Note that an issue related to this patch was recently reported.
> It's quite possible that the root cause is a bug elsewhere
> in the kernel, but it probably makes sense to defer the backport
> until we know more ...

Thanks, I'll go drop it from all 4 queues.  If you all find out that all
is good, and it should be added back, please let us at stable@vger know
about it.

thanks,

greg k-h
