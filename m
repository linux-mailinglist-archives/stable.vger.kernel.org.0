Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017A1579E7B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242547AbiGSNBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242629AbiGSM7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CBD9B55C;
        Tue, 19 Jul 2022 05:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D54CCE1BCF;
        Tue, 19 Jul 2022 12:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253F4C341CB;
        Tue, 19 Jul 2022 12:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233440;
        bh=3sXG+VTt4xWZvQsDFeqcthLuMkGVH+7fXqtk7X35lCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mb0yolcGQBkSr9A/gYgf/h52+n5vVbERcKlhhVD5AZCH/VP42sEAZWanlHCTwyHNh
         jWG40tbKp/b/OoKyTo5iUuchaIHobmXwI4qONYtYY/DD3nHLaPk1jkECcBWMvxXvuO
         NLFjghiQ3T13uBisHgR/+tuCtJwKxAYquqagnq9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 087/231] vlan: fix memory leak in vlan_newlink()
Date:   Tue, 19 Jul 2022 13:52:52 +0200
Message-Id: <20220719114722.113428923@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 72a0b329114b1caa8e69dfa7cdad1dd3c69b8602 ]

Blamed commit added back a bug I fixed in commit 9bbd917e0bec
("vlan: fix memory leak in vlan_dev_set_egress_priority")

If a memory allocation fails in vlan_changelink() after other allocations
succeeded, we need to call vlan_dev_free_egress_priority()
to free all allocated memory because after a failed ->newlink()
we do not call any methods like ndo_uninit() or dev->priv_destructor().

In following example, if the allocation for last element 2000:2001 fails,
we need to free eight prior allocations:

ip link add link dummy0 dummy0.100 type vlan id 100 \
	egress-qos-map 1:2 2:3 3:4 4:5 5:6 6:7 7:8 8:9 2000:2001

syzbot report was:

BUG: memory leak
unreferenced object 0xffff888117bd1060 (size 32):
comm "syz-executor408", pid 3759, jiffies 4294956555 (age 34.090s)
hex dump (first 32 bytes):
09 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<ffffffff83fc60ad>] kmalloc include/linux/slab.h:600 [inline]
[<ffffffff83fc60ad>] vlan_dev_set_egress_priority+0xed/0x170 net/8021q/vlan_dev.c:193
[<ffffffff83fc6628>] vlan_changelink+0x178/0x1d0 net/8021q/vlan_netlink.c:128
[<ffffffff83fc67c8>] vlan_newlink+0x148/0x260 net/8021q/vlan_netlink.c:185
[<ffffffff838b1278>] rtnl_newlink_create net/core/rtnetlink.c:3363 [inline]
[<ffffffff838b1278>] __rtnl_newlink+0xa58/0xdc0 net/core/rtnetlink.c:3580
[<ffffffff838b1629>] rtnl_newlink+0x49/0x70 net/core/rtnetlink.c:3593
[<ffffffff838ac66c>] rtnetlink_rcv_msg+0x21c/0x5c0 net/core/rtnetlink.c:6089
[<ffffffff839f9c37>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2501
[<ffffffff839f8da7>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
[<ffffffff839f8da7>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
[<ffffffff839f9266>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
[<ffffffff8384dbf6>] sock_sendmsg_nosec net/socket.c:714 [inline]
[<ffffffff8384dbf6>] sock_sendmsg+0x56/0x80 net/socket.c:734
[<ffffffff8384e15c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2488
[<ffffffff838523cb>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2542
[<ffffffff838525b8>] __sys_sendmsg net/socket.c:2571 [inline]
[<ffffffff838525b8>] __do_sys_sendmsg net/socket.c:2580 [inline]
[<ffffffff838525b8>] __se_sys_sendmsg net/socket.c:2578 [inline]
[<ffffffff838525b8>] __x64_sys_sendmsg+0x78/0xf0 net/socket.c:2578
[<ffffffff845ad8d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<ffffffff845ad8d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
[<ffffffff8460006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 37aa50c539bc ("vlan: introduce vlan_dev_free_egress_priority")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_netlink.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 53b1955b027f..214532173536 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -182,10 +182,14 @@ static int vlan_newlink(struct net *src_net, struct net_device *dev,
 	else if (dev->mtu > max_mtu)
 		return -EINVAL;
 
+	/* Note: If this initial vlan_changelink() fails, we need
+	 * to call vlan_dev_free_egress_priority() to free memory.
+	 */
 	err = vlan_changelink(dev, tb, data, extack);
-	if (err)
-		return err;
-	err = register_vlan_dev(dev, extack);
+
+	if (!err)
+		err = register_vlan_dev(dev, extack);
+
 	if (err)
 		vlan_dev_free_egress_priority(dev);
 	return err;
-- 
2.35.1



