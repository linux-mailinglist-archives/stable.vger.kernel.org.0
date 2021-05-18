Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E9F38808F
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 21:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351874AbhERTg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 15:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345403AbhERTg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 15:36:57 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28912C06175F
        for <stable@vger.kernel.org>; Tue, 18 May 2021 12:35:39 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id f9so14857944ybo.6
        for <stable@vger.kernel.org>; Tue, 18 May 2021 12:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zuttx+ccp2WJpeVo41ApR4QzlKZXH0hmSVWBq1ylj1s=;
        b=r01H/LXoxE+CT6mAOiH2s+UHWFMDnVq1591tvNy96n2aTtUTSY3h/VaXnqcxl/iLGD
         OwLEiDdAFdMyB2IoSx470QJd9JbJlJQlhcb83zioeUI6+1X1MbEN7p1QyH53aQul3fnM
         RtE4CAAi3aiTCGFrqdhkyb3b16kTduuxExSy2Tj3hx+as9nD/9AnYnsPtgGKHjzhgFEp
         IjpWVi124kLu0c3v1bYtx4u/DoGXAM/MElIJaKaNgPzr0yHVFNydcw/WRC2aw59RW52Y
         TcQWBe3uFU9byEVB6foASvYYAuD0lKmOeNxb7gfPcAFU4CkOELZHQOJXkPmUIiGK9QeD
         2WUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zuttx+ccp2WJpeVo41ApR4QzlKZXH0hmSVWBq1ylj1s=;
        b=eJzVg2iUUsTlASBi6clu7gcViOKAZp5s3iGb/63QUk6HfP0HP/5jYpwT3VfR4ELAL2
         Y3LQ/afb2/PCaNMzE7Cx+CKJ8at7hAH1sNPSexMl5nvxPzoxI/sPBpQS9jto47BVM0Ky
         ePp2iWHgklE1xAe02C32Ew6ifwdZi6z6jmc8HBYNcBP/54umejga0em/4bBkRizOdiZj
         /kimaxMso3FMY25JYDajB6lzDngxN21Fb0QkYtm41QgJofHbIVhzTcu4RzwkEyIp4/gZ
         zUNR1Kl9KdLODNjiDa6G5ak0Ks+O+Ms2JQMyxrlUSR75tFh19ZQBO66qZKED61MZ/Oll
         yg+Q==
X-Gm-Message-State: AOAM532zFAo0JRqRzriuSoxrP7ygV+7Boh4LPV43/6G+/UTEYi4dxchj
        RkkfC2JZO1DKzq3Jz3q/KMIMdtBx7bXszc0E5wg+Mw==
X-Google-Smtp-Source: ABdhPJwd6LPFInfHlB0MoYTGJBNYl6tOWlIcXNtchel3ebgFsJbwFmOPhHEI/49CuTvKdTxtoX37odJCBnGzIQH81F0=
X-Received: by 2002:a5b:711:: with SMTP id g17mr550659ybq.446.1621366537876;
 Tue, 18 May 2021 12:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210412084004.200986670@linuxfoundation.org> <20210412084005.653952525@linuxfoundation.org>
 <20210412051230-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210412051230-mutt-send-email-mst@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 May 2021 21:35:26 +0200
Message-ID: <CANn89iJ+5qFw+sPmxBqzxd6rp=3fnc8xkbup7SWWa_LxyhUUrg@mail.gmail.com>
Subject: Re: [PATCH 5.4 042/111] virtio_net: Do not pull payload in skb->head
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 11:12 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Apr 12, 2021 at 10:40:20AM +0200, Greg Kroah-Hartman wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > [ Upstream commit 0f6925b3e8da0dbbb52447ca8a8b42b371aac7db ]
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
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>
> Note that an issue related to this patch was recently reported.
> It's quite possible that the root cause is a bug elsewhere
> in the kernel, but it probably makes sense to defer the backport
> until we know more ...

I think the patch should be backported now, all issues have been sorted out ?

>
>
> > ---
> >  drivers/net/virtio_net.c   | 10 +++++++---
> >  include/linux/virtio_net.h | 14 +++++++++-----
> >  2 files changed, 16 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index b67460864b3c..d8ee001d8e8e 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -406,9 +406,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >       offset += hdr_padded_len;
> >       p += hdr_padded_len;
> >
> > -     copy = len;
> > -     if (copy > skb_tailroom(skb))
> > -             copy = skb_tailroom(skb);
> > +     /* Copy all frame if it fits skb->head, otherwise
> > +      * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
> > +      */
> > +     if (len <= skb_tailroom(skb))
> > +             copy = len;
> > +     else
> > +             copy = ETH_HLEN + metasize;
> >       skb_put_data(skb, p, copy);
> >
> >       if (metasize) {
> > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > index 98775d7fa696..b465f8f3e554 100644
> > --- a/include/linux/virtio_net.h
> > +++ b/include/linux/virtio_net.h
> > @@ -65,14 +65,18 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> >       skb_reset_mac_header(skb);
> >
> >       if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> > -             u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> > -             u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> > +             u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> > +             u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> > +             u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
> > +
> > +             if (!pskb_may_pull(skb, needed))
> > +                     return -EINVAL;
> >
> >               if (!skb_partial_csum_set(skb, start, off))
> >                       return -EINVAL;
> >
> >               p_off = skb_transport_offset(skb) + thlen;
> > -             if (p_off > skb_headlen(skb))
> > +             if (!pskb_may_pull(skb, p_off))
> >                       return -EINVAL;
> >       } else {
> >               /* gso packets without NEEDS_CSUM do not set transport_offset.
> > @@ -102,14 +106,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> >                       }
> >
> >                       p_off = keys.control.thoff + thlen;
> > -                     if (p_off > skb_headlen(skb) ||
> > +                     if (!pskb_may_pull(skb, p_off) ||
> >                           keys.basic.ip_proto != ip_proto)
> >                               return -EINVAL;
> >
> >                       skb_set_transport_header(skb, keys.control.thoff);
> >               } else if (gso_type) {
> >                       p_off = thlen;
> > -                     if (p_off > skb_headlen(skb))
> > +                     if (!pskb_may_pull(skb, p_off))
> >                               return -EINVAL;
> >               }
> >       }
> > --
> > 2.30.2
> >
> >
>
