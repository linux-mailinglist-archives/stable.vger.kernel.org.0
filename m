Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF76F6353D1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbiKWI6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236828AbiKWI6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:58:47 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D37FFA85
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:58:46 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id c14-20020a5ea80e000000b006d6e9b05e58so8930410ioa.23
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:58:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VnVueKTZoShuUXW7zwHhg0Gb9tesJnQcU/uJSiALPAA=;
        b=mHGwtiJuXJ+3gyVWJykHfhVfekjnWVIriczp4YfXncLTu2SupxZD40YA+S6DSBQ1UU
         UhcGfIzud5r0uLbNSPXTkj++gCKcyrDBVCaE/OoZheqZrt98Y1ght/CwNImKUCzdJHEJ
         xKeTNqrOYjph5GxJAGgmtFZIT4tWk+f+/4c9SpYcHzqiKI9DnGGYTNULWOImOG83Gp3t
         ZBsMgKvjDjbc0Jv56K1uPhJj8XoamU4EUhFhcNL02p6LZ9MrrvE6P5M918eBkK0bqUfS
         UwWbVofzkzpUKzNVsgQilUZ+tiOKicWIiV91EGzONtjzYh5t+hixKbXilBshAKNxBEIS
         Bapw==
X-Gm-Message-State: ANoB5plX4fHnFVPKXamdkrO5ZwA0tWrcv2UOv84akZtl1i24uoG3fIaW
        dDeAvSj2GV3DYFn+QHxv4Xi4ghU1c8xhIH3CAk6CoF+0e9N3
X-Google-Smtp-Source: AA0mqf6evUrN5h5EVPATBIZ0obUu4buZG/KATYMorRQ7hixUH3ww3U47LrFDRtmmNGg1D3cnlvQdpEn3YOGqPMf2wnzItsPExDEB
MIME-Version: 1.0
X-Received: by 2002:a92:874e:0:b0:2f9:32c2:a10a with SMTP id
 d14-20020a92874e000000b002f932c2a10amr3863147ilm.47.1669193925813; Wed, 23
 Nov 2022 00:58:45 -0800 (PST)
Date:   Wed, 23 Nov 2022 00:58:45 -0800
In-Reply-To: <20221123084548.847749891@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000026c4005ee1f7fcc@google.com>
Subject: Re: [PATCH 4.14 09/88] ipv6: addrlabel: fix infoleak when sending
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
> index f664871feca6..4e215cfb5fa9 100644
> --- a/net/ipv6/addrlabel.c
> +++ b/net/ipv6/addrlabel.c
> @@ -474,6 +474,7 @@ static void ip6addrlbl_putmsg(struct nlmsghdr *nlh,
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

