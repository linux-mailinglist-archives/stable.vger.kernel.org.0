Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F84635451
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbiKWJFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbiKWJFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:05:05 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4B8100B2A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:05:04 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id j20-20020a056e02219400b00300a22a7fe0so12531997ila.3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:05:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hOwaUP9SnaHg7GvHDtdq80VwQovF/jP7FuJHxUUIH1w=;
        b=3q2CSDE0IYGt5TnpYEa1vs0QB3mpq/T3K7159FF/VwF8nzDNC8OMwQ+qK5vQWWFQkH
         s0byjokIq6zpLI2wlaGJIHnjjsfHYpQWYzH8yYsFuv016MlQLrTKymA93tQSIS2cwEZJ
         7GzhNnzx3LYFL0p+ztugnDCuDltTZxpxuYuaWSQBw5pBynnPFFJz5NbEIlmT7z6wFMHg
         pGTcUi9z664707xolvKJ8jRc61GA1xXA8cfnL+7JAfzOO/VjSe7XnvNbbM+lOHaJ4f5u
         3HOPfnuAyNIpBzFrlOlNxN3Ep/2579wAaAG4a+4EEn9Ive7bQYTW5DbgRWYB6xbw/4Gj
         csKw==
X-Gm-Message-State: ANoB5pmKhQzhK/n6i6kF1svXVinaqIHhhyb8Ky8C7y0OM6IT6yG+ZxrS
        nHLgZAmYYk70ZaYFNuyMeWWG2xj1P0NB5cV1XNp92Najc3e8
X-Google-Smtp-Source: AA0mqf7SdlyZACq4cXIrmJqHAqNcAdRgWSbuK5H6M+yoJ1JAc2cVG1j8G8YLFXsab5Beg4+24GIvpt0zW9qBCvmAblAA6gaEz4CG
MIME-Version: 1.0
X-Received: by 2002:a5e:aa06:0:b0:6bc:614c:63c2 with SMTP id
 s6-20020a5eaa06000000b006bc614c63c2mr5330231ioe.21.1669194304118; Wed, 23 Nov
 2022 01:05:04 -0800 (PST)
Date:   Wed, 23 Nov 2022 01:05:04 -0800
In-Reply-To: <20221123084552.337303067@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008ee66405ee1f9570@google.com>
Subject: Re: [PATCH 4.19 012/114] ipv6: addrlabel: fix infoleak when sending
 struct ifaddrlblmsg to network
From:   syzbot <syzbot+@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org
Cc:     davem@davemloft.net, dsahern@kernel.org, glider@google.com,
        gregkh@linuxfoundation.org, patches@lists.linux.dev,
        sashal@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Alexander Potapenko <glider@google.com>
>
> [ Upstream commit c23fb2c82267638f9d206cb96bb93e1f93ad7828 ]
>
> When copying a `struct ifaddrlblmsg` to the network, __ifal_reserved
> remained uninitialized, resulting in a 1-byte infoleak:
>
>   BUG: KMSAN: kernel-network-infoleak in __netdev_start_xmit ./include/linux/netdevice.h:4841
>    __netdev_start_xmit ./include/linux/netdevice.h:4841
>    netdev_start_xmit ./include/linux/netdevice.h:4857
>    xmit_one net/core/dev.c:3590
>    dev_hard_start_xmit+0x1dc/0x800 net/core/dev.c:3606
>    __dev_queue_xmit+0x17e8/0x4350 net/core/dev.c:4256
>    dev_queue_xmit ./include/linux/netdevice.h:3009
>    __netlink_deliver_tap_skb net/netlink/af_netlink.c:307
>    __netlink_deliver_tap+0x728/0xad0 net/netlink/af_netlink.c:325
>    netlink_deliver_tap net/netlink/af_netlink.c:338
>    __netlink_sendskb net/netlink/af_netlink.c:1263
>    netlink_sendskb+0x1d9/0x200 net/netlink/af_netlink.c:1272
>    netlink_unicast+0x56d/0xf50 net/netlink/af_netlink.c:1360
>    nlmsg_unicast ./include/net/netlink.h:1061
>    rtnl_unicast+0x5a/0x80 net/core/rtnetlink.c:758
>    ip6addrlbl_get+0xfad/0x10f0 net/ipv6/addrlabel.c:628
>    rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
>   ...
>   Uninit was created at:
>    slab_post_alloc_hook+0x118/0xb00 mm/slab.h:742
>    slab_alloc_node mm/slub.c:3398
>    __kmem_cache_alloc_node+0x4f2/0x930 mm/slub.c:3437
>    __do_kmalloc_node mm/slab_common.c:954
>    __kmalloc_node_track_caller+0x117/0x3d0 mm/slab_common.c:975
>    kmalloc_reserve net/core/skbuff.c:437
>    __alloc_skb+0x27a/0xab0 net/core/skbuff.c:509
>    alloc_skb ./include/linux/skbuff.h:1267
>    nlmsg_new ./include/net/netlink.h:964
>    ip6addrlbl_get+0x490/0x10f0 net/ipv6/addrlabel.c:608
>    rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
>    netlink_rcv_skb+0x299/0x550 net/netlink/af_netlink.c:2540
>    rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6109
>    netlink_unicast_kernel net/netlink/af_netlink.c:1319
>    netlink_unicast+0x9ab/0xf50 net/netlink/af_netlink.c:1345
>    netlink_sendmsg+0xebc/0x10f0 net/netlink/af_netlink.c:1921
>   ...
>
> This patch ensures that the reserved field is always initialized.
>
> Reported-by: syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
> Fixes: 2a8cc6c89039 ("[IPV6] ADDRCONF: Support RFC3484 configurable address selection policy table.")
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ipv6/addrlabel.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
> index c7dc8b2de6c2..7fdd433b968e 100644
> --- a/net/ipv6/addrlabel.c
> +++ b/net/ipv6/addrlabel.c
> @@ -437,6 +437,7 @@ static void ip6addrlbl_putmsg(struct nlmsghdr *nlh,
>  {
>  	struct ifaddrlblmsg *ifal = nlmsg_data(nlh);
>  	ifal->ifal_family = AF_INET6;
> +	ifal->__ifal_reserved = 0;
>  	ifal->ifal_prefixlen = prefixlen;
>  	ifal->ifal_flags = 0;
>  	ifal->ifal_index = ifindex;
> -- 
> 2.35.1
>
>
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

