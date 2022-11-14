Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CBF628006
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbiKNNDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiKNNDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AC928E0F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5E09B80EC0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF7FC433C1;
        Mon, 14 Nov 2022 13:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430976;
        bh=sun2Z1GG3xPPxE+oBoADHbJltqL/2m3iWLgXTzsuyy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdd0yL60PAvT3Z2tbhD71xkXIk9GOsiMoMUxOG/q/eHnyYPiu8iXzIZBTAShFce1D
         vz/L1SIJhvdzxJK/T+ADetVkX8OfGIVkSgBX2zOFMZOrzMBLtSRUAAhRhNRk7wudRI
         LE4MkIV10cQtJLWUdHAlwxpkqPthmZqhUYa20RC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 055/190] ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network
Date:   Mon, 14 Nov 2022 13:44:39 +0100
Message-Id: <20221114124501.172553909@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

[ Upstream commit c23fb2c82267638f9d206cb96bb93e1f93ad7828 ]

When copying a `struct ifaddrlblmsg` to the network, __ifal_reserved
remained uninitialized, resulting in a 1-byte infoleak:

  BUG: KMSAN: kernel-network-infoleak in __netdev_start_xmit ./include/linux/netdevice.h:4841
   __netdev_start_xmit ./include/linux/netdevice.h:4841
   netdev_start_xmit ./include/linux/netdevice.h:4857
   xmit_one net/core/dev.c:3590
   dev_hard_start_xmit+0x1dc/0x800 net/core/dev.c:3606
   __dev_queue_xmit+0x17e8/0x4350 net/core/dev.c:4256
   dev_queue_xmit ./include/linux/netdevice.h:3009
   __netlink_deliver_tap_skb net/netlink/af_netlink.c:307
   __netlink_deliver_tap+0x728/0xad0 net/netlink/af_netlink.c:325
   netlink_deliver_tap net/netlink/af_netlink.c:338
   __netlink_sendskb net/netlink/af_netlink.c:1263
   netlink_sendskb+0x1d9/0x200 net/netlink/af_netlink.c:1272
   netlink_unicast+0x56d/0xf50 net/netlink/af_netlink.c:1360
   nlmsg_unicast ./include/net/netlink.h:1061
   rtnl_unicast+0x5a/0x80 net/core/rtnetlink.c:758
   ip6addrlbl_get+0xfad/0x10f0 net/ipv6/addrlabel.c:628
   rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
  ...
  Uninit was created at:
   slab_post_alloc_hook+0x118/0xb00 mm/slab.h:742
   slab_alloc_node mm/slub.c:3398
   __kmem_cache_alloc_node+0x4f2/0x930 mm/slub.c:3437
   __do_kmalloc_node mm/slab_common.c:954
   __kmalloc_node_track_caller+0x117/0x3d0 mm/slab_common.c:975
   kmalloc_reserve net/core/skbuff.c:437
   __alloc_skb+0x27a/0xab0 net/core/skbuff.c:509
   alloc_skb ./include/linux/skbuff.h:1267
   nlmsg_new ./include/net/netlink.h:964
   ip6addrlbl_get+0x490/0x10f0 net/ipv6/addrlabel.c:608
   rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
   netlink_rcv_skb+0x299/0x550 net/netlink/af_netlink.c:2540
   rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6109
   netlink_unicast_kernel net/netlink/af_netlink.c:1319
   netlink_unicast+0x9ab/0xf50 net/netlink/af_netlink.c:1345
   netlink_sendmsg+0xebc/0x10f0 net/netlink/af_netlink.c:1921
  ...

This patch ensures that the reserved field is always initialized.

Reported-by: syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
Fixes: 2a8cc6c89039 ("[IPV6] ADDRCONF: Support RFC3484 configurable address selection policy table.")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrlabel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index 8a22486cf270..17ac45aa7194 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -437,6 +437,7 @@ static void ip6addrlbl_putmsg(struct nlmsghdr *nlh,
 {
 	struct ifaddrlblmsg *ifal = nlmsg_data(nlh);
 	ifal->ifal_family = AF_INET6;
+	ifal->__ifal_reserved = 0;
 	ifal->ifal_prefixlen = prefixlen;
 	ifal->ifal_flags = 0;
 	ifal->ifal_index = ifindex;
-- 
2.35.1



