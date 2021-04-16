Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF98361D87
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbhDPJdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239848AbhDPJdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 05:33:15 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333EBC061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:32:50 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id g38so29382432ybi.12
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6A39D/ltNLVXHQXp0YgBWaQxSJiY9LOUgjRGwkD57t8=;
        b=DA8waUM6qCQA5DPh7UeUBhbFq6bFkFVpGLMXw/VQ58nd4mnkkTt/6E26EQ+FRyw7tK
         gIuwlIAdriYLCSGGPwGkD8aFEJDHx9aeuHIqGk+wD6NIAaBV8+UdOBFNVMi8wd1Svw/p
         NIdRV2kkhJ4URrmsCSYaCdvBpAWIz5HvztLg0UTQ3ywlJXu5ePkYzytwPFYTq9yFT2vJ
         PtcqHN0QtCP3rvsv8nhcQTuirkrvkb42t3JLttFa8nU7USwaF3xZFI1Kv3Vyq2HVsHbo
         tf1FuLK8rz8i6xbQSoQpr10sKdtBsnasRcAJTGHm3a41R8IWNtKbeoQvWIObyeRHGV5P
         KxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6A39D/ltNLVXHQXp0YgBWaQxSJiY9LOUgjRGwkD57t8=;
        b=I4n1qiI3tFVNii5V+RYOuU2r3Br94ueHyDdG1HlRtZgmeaZSyTQC437puBHDPgD7ry
         JPBD7D9QOalig5pUMJFgmd6PhYilzLCf2t8CpzVB6aqNmVYoRUzqzDNSbNzievpECFWg
         7VbWJKkUKwN2151LLD+w87IHOR1K9Frzm5lQYXHSwrJbfdOuYYdV7QzGRa6T+JkqgBYy
         NTY/ZyKirrGXdsm38wApSmQ1aBQag2M9DJErdiEYKAfwDyr7NxauMuWS8LVkfFinMt15
         kSdCjn5hysK0+lKGIzdsSpAdqw8IliNx0z1jN8RR5QhjBwdwQcqtTxvdbmFFQ4lIlfmF
         NSgw==
X-Gm-Message-State: AOAM530FpOVOiKq2gAHWfoOvuKYX/pQrJ3ddLJhG3ALYdO5l98ZNnXeF
        c6Bo7vHS+ljc/yEd/mSbP6YjT8nSoLU7NWs6bjcI1Q==
X-Google-Smtp-Source: ABdhPJws8UG08R8jGCP9HpSOImNdmD8qTd6g1nE0DrNelMfE0fogrOdpyy+pZncaaZB5t1pjBNqlVn8V9qD4RpFxwoM=
X-Received: by 2002:a25:cf08:: with SMTP id f8mr11601203ybg.132.1618565569092;
 Fri, 16 Apr 2021 02:32:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144414.464797272@linuxfoundation.org> <20210415144414.998180483@linuxfoundation.org>
 <7c0e6a19291e32eaa2e5d31d8d90f4c500392666.camel@redhat.com>
In-Reply-To: <7c0e6a19291e32eaa2e5d31d8d90f4c500392666.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 16 Apr 2021 11:32:37 +0200
Message-ID: <CANn89i+uktnBRcKXY8+uFZ0S3KJEgBhJUjOafs-3UH5f6++wQw@mail.gmail.com>
Subject: Re: [PATCH 4.14 16/68] net: ensure mac header is set in virtio_net_hdr_to_skb()
To:     Balazs Nemeth <bnemeth@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 10:49 AM Balazs Nemeth <bnemeth@redhat.com> wrote:
>
> On Thu, 2021-04-15 at 16:46 +0200, Greg Kroah-Hartman wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > commit 61431a5907fc36d0738e9a547c7e1556349a03e9 upstream.
> >
> > Commit 924a9bc362a5 ("net: check if protocol extracted by
> > virtio_net_hdr_set_proto is correct")
> > added a call to dev_parse_header_protocol() but mac_header is not yet
> > set.
> >
> > This means that eth_hdr() reads complete garbage, and syzbot
> > complained about it [1]
> >
> > This patch resets mac_header earlier, to get more coverage about this
> > change.
> >
> > Audit of virtio_net_hdr_to_skb() callers shows that this change
> > should be safe.
> >
> > [1]
> >
> > BUG: KASAN: use-after-free in eth_header_parse_protocol+0xdc/0xe0
> > net/ethernet/eth.c:282
> > Read of size 2 at addr ffff888017a6200b by task syz-executor313/8409
> >
> > CPU: 1 PID: 8409 Comm: syz-executor313 Not tainted 5.12.0-rc2-
> > syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:79 [inline]
> >  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
> >  print_address_description.constprop.0.cold+0x5b/0x2f8
> > mm/kasan/report.c:232
> >  __kasan_report mm/kasan/report.c:399 [inline]
> >  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
> >  eth_header_parse_protocol+0xdc/0xe0 net/ethernet/eth.c:282
> >  dev_parse_header_protocol include/linux/netdevice.h:3177 [inline]
> >  virtio_net_hdr_to_skb.constprop.0+0x99d/0xcd0
> > include/linux/virtio_net.h:83
> >  packet_snd net/packet/af_packet.c:2994 [inline]
> >  packet_sendmsg+0x2325/0x52b0 net/packet/af_packet.c:3031
> >  sock_sendmsg_nosec net/socket.c:654 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:674
> >  sock_no_sendpage+0xf3/0x130 net/core/sock.c:2860
> >  kernel_sendpage.part.0+0x1ab/0x350 net/socket.c:3631
> >  kernel_sendpage net/socket.c:3628 [inline]
> >  sock_sendpage+0xe5/0x140 net/socket.c:947
> >  pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
> >  splice_from_pipe_feed fs/splice.c:418 [inline]
> >  __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
> >  splice_from_pipe fs/splice.c:597 [inline]
> >  generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
> >  do_splice_from fs/splice.c:767 [inline]
> >  do_splice+0xb7e/0x1940 fs/splice.c:1079
> >  __do_splice+0x134/0x250 fs/splice.c:1144
> >  __do_sys_splice fs/splice.c:1350 [inline]
> >  __se_sys_splice fs/splice.c:1332 [inline]
> >  __x64_sys_splice+0x198/0x250 fs/splice.c:1332
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >
> > Fixes: 924a9bc362a5 ("net: check if protocol extracted by
> > virtio_net_hdr_set_proto is correct")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Balazs Nemeth <bnemeth@redhat.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  include/linux/virtio_net.h |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > --- a/include/linux/virtio_net.h
> > +++ b/include/linux/virtio_net.h
> > @@ -62,6 +62,8 @@ static inline int virtio_net_hdr_to_skb(
> >                         return -EINVAL;
> >         }
> >
> > +       skb_reset_mac_header(skb);
> > +
> >         if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> >                 u16 start = __virtio16_to_cpu(little_endian, hdr-
> > >csum_start);
> >                 u16 off = __virtio16_to_cpu(little_endian, hdr-
> > >csum_offset);
> >
> >
>
> Hi,
>
> Since the call to dev_parse_header_protocol is only made for gso
> packets where skb->protocol is not set, we could move
> skb_reset_mac_header down closer to that call. Is there another reason
> to reset mac_header earlier (and affect handling of other packets as
> well)? In any case, thanks for spotting this!
>

The answer to your question was in the changelog

"This patch resets mac_header earlier, to get more coverage about this change."

We want to detect if such a reset is going to hurt in general, not
only for GSO packets.
