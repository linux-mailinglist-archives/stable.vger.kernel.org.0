Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0955036E77F
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 11:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhD2JCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 05:02:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233188AbhD2JCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 05:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619686914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQOF619k4uT4LXlOihlAZEz2vekNUOeGvs7MqvhRVBQ=;
        b=QHPGzNp/FqgM3i3Yzcr9wssKNzc7Chq6woD+Z9utb9SnRgVq2lAwuSxSRHwXvSIljaNLf0
        QSRFhRoaa+NtsCGmAAnP0d9KA33zzerADkuJDCvjIxWKGLbBnqspsRl6nLtuqeXX5OIB0M
        M5nhVByF0QH81EVG/CIGQs4W0TTRICY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-IAF3hkB6Oxi3-4hxcjAccA-1; Thu, 29 Apr 2021 05:01:49 -0400
X-MC-Unique: IAF3hkB6Oxi3-4hxcjAccA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06AEB8049CC;
        Thu, 29 Apr 2021 09:01:48 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-113-199.ams2.redhat.com [10.36.113.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67B9D101E663;
        Thu, 29 Apr 2021 09:01:46 +0000 (UTC)
Message-ID: <a4c76679564036a03127d451e29fee03984be59a.camel@redhat.com>
Subject: Re: [PATCH 4.14 16/68] net: ensure mac header is set in
 virtio_net_hdr_to_skb()
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Date:   Thu, 29 Apr 2021 11:01:45 +0200
In-Reply-To: <CANn89i+uktnBRcKXY8+uFZ0S3KJEgBhJUjOafs-3UH5f6++wQw@mail.gmail.com>
References: <20210415144414.464797272@linuxfoundation.org>
         <20210415144414.998180483@linuxfoundation.org>
         <7c0e6a19291e32eaa2e5d31d8d90f4c500392666.camel@redhat.com>
         <CANn89i+uktnBRcKXY8+uFZ0S3KJEgBhJUjOafs-3UH5f6++wQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-04-16 at 11:32 +0200, Eric Dumazet wrote:
> On Fri, Apr 16, 2021 at 10:49 AM Balazs Nemeth <bnemeth@redhat.com>
> wrote:
> > 
> > On Thu, 2021-04-15 at 16:46 +0200, Greg Kroah-Hartman wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > > 
> > > commit 61431a5907fc36d0738e9a547c7e1556349a03e9 upstream.
> > > 
> > > Commit 924a9bc362a5 ("net: check if protocol extracted by
> > > virtio_net_hdr_set_proto is correct")
> > > added a call to dev_parse_header_protocol() but mac_header is not
> > > yet
> > > set.
> > > 
> > > This means that eth_hdr() reads complete garbage, and syzbot
> > > complained about it [1]
> > > 
> > > This patch resets mac_header earlier, to get more coverage about
> > > this
> > > change.
> > > 
> > > Audit of virtio_net_hdr_to_skb() callers shows that this change
> > > should be safe.
> > > 
> > > [1]
> > > 
> > > BUG: KASAN: use-after-free in eth_header_parse_protocol+0xdc/0xe0
> > > net/ethernet/eth.c:282
> > > Read of size 2 at addr ffff888017a6200b by task syz-
> > > executor313/8409
> > > 
> > > CPU: 1 PID: 8409 Comm: syz-executor313 Not tainted 5.12.0-rc2-
> > > syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > > BIOS Google 01/01/2011
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:79 [inline]
> > >  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
> > >  print_address_description.constprop.0.cold+0x5b/0x2f8
> > > mm/kasan/report.c:232
> > >  __kasan_report mm/kasan/report.c:399 [inline]
> > >  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
> > >  eth_header_parse_protocol+0xdc/0xe0 net/ethernet/eth.c:282
> > >  dev_parse_header_protocol include/linux/netdevice.h:3177 [inline]
> > >  virtio_net_hdr_to_skb.constprop.0+0x99d/0xcd0
> > > include/linux/virtio_net.h:83
> > >  packet_snd net/packet/af_packet.c:2994 [inline]
> > >  packet_sendmsg+0x2325/0x52b0 net/packet/af_packet.c:3031
> > >  sock_sendmsg_nosec net/socket.c:654 [inline]
> > >  sock_sendmsg+0xcf/0x120 net/socket.c:674
> > >  sock_no_sendpage+0xf3/0x130 net/core/sock.c:2860
> > >  kernel_sendpage.part.0+0x1ab/0x350 net/socket.c:3631
> > >  kernel_sendpage net/socket.c:3628 [inline]
> > >  sock_sendpage+0xe5/0x140 net/socket.c:947
> > >  pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
> > >  splice_from_pipe_feed fs/splice.c:418 [inline]
> > >  __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
> > >  splice_from_pipe fs/splice.c:597 [inline]
> > >  generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
> > >  do_splice_from fs/splice.c:767 [inline]
> > >  do_splice+0xb7e/0x1940 fs/splice.c:1079
> > >  __do_splice+0x134/0x250 fs/splice.c:1144
> > >  __do_sys_splice fs/splice.c:1350 [inline]
> > >  __se_sys_splice fs/splice.c:1332 [inline]
> > >  __x64_sys_splice+0x198/0x250 fs/splice.c:1332
> > >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> > > 
> > > Fixes: 924a9bc362a5 ("net: check if protocol extracted by
> > > virtio_net_hdr_set_proto is correct")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Balazs Nemeth <bnemeth@redhat.com>
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  include/linux/virtio_net.h |    2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > --- a/include/linux/virtio_net.h
> > > +++ b/include/linux/virtio_net.h
> > > @@ -62,6 +62,8 @@ static inline int virtio_net_hdr_to_skb(
> > >                         return -EINVAL;
> > >         }
> > > 
> > > +       skb_reset_mac_header(skb);
> > > +
> > >         if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> > >                 u16 start = __virtio16_to_cpu(little_endian, hdr-
> > > > csum_start);
> > >                 u16 off = __virtio16_to_cpu(little_endian, hdr-
> > > > csum_offset);
> > > 
> > > 
> > 
> > Hi,
> > 
> > Since the call to dev_parse_header_protocol is only made for gso
> > packets where skb->protocol is not set, we could move
> > skb_reset_mac_header down closer to that call. Is there another
> > reason
> > to reset mac_header earlier (and affect handling of other packets as
> > well)? In any case, thanks for spotting this!
> > 
> 
> The answer to your question was in the changelog
> 
> "This patch resets mac_header earlier, to get more coverage about this
> change."
> 
> We want to detect if such a reset is going to hurt in general, not
> only for GSO packets.
> 


Acked-by: Balazs Nemeth <bnemeth@redhat.com>

I can't spot any issues caused by resetting the mac header early on.

Thanks!

