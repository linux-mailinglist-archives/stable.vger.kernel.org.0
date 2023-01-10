Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D67E664883
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbjAJSMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238965AbjAJSLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:11:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AF916483
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:09:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F08516186D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DDBC433EF;
        Tue, 10 Jan 2023 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374196;
        bh=EyFzlm1AF0BcmS4C0dEN0f2te3uirLZkZiddwNlgE3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zo9ufSz4Ko22iI+6vcB2XeQzLRlX7NUyRyj/Htia7p9GTtZMn+u+wkNanaQUQzeQw
         tESxb1FVjmKNYNT6K79hRsRpA8cNleLkgpww0BzxxVa5PgAiOhLHYw5WxqNcS6JDMr
         y/j6uB1b8QrMShTCsVCo4mr3wcfoMMzIwJNSd0VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 082/148] vxlan: Fix memory leaks in error path
Date:   Tue, 10 Jan 2023 19:03:06 +0100
Message-Id: <20230110180019.805593918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 06bf62944144a92d83dd14fd1378d2a288259561 ]

The memory allocated by vxlan_vnigroup_init() is not freed in the error
path, leading to memory leaks [1]. Fix by calling
vxlan_vnigroup_uninit() in the error path.

The leaks can be reproduced by annotating gro_cells_init() with
ALLOW_ERROR_INJECTION() and then running:

 # echo "100" > /sys/kernel/debug/fail_function/probability
 # echo "1" > /sys/kernel/debug/fail_function/times
 # echo "gro_cells_init" > /sys/kernel/debug/fail_function/inject
 # printf %#x -12 > /sys/kernel/debug/fail_function/gro_cells_init/retval
 # ip link add name vxlan0 type vxlan dstport 4789 external vnifilter
 RTNETLINK answers: Cannot allocate memory

[1]
unreferenced object 0xffff88810db84a00 (size 512):
  comm "ip", pid 330, jiffies 4295010045 (age 66.016s)
  hex dump (first 32 bytes):
    f8 d5 76 0e 81 88 ff ff 01 00 00 00 00 00 00 02  ..v.............
    03 00 04 00 48 00 00 00 00 00 00 01 04 00 01 00  ....H...........
  backtrace:
    [<ffffffff81a3097a>] kmalloc_trace+0x2a/0x60
    [<ffffffff82f049fc>] vxlan_vnigroup_init+0x4c/0x160
    [<ffffffff82ecd69e>] vxlan_init+0x1ae/0x280
    [<ffffffff836858ca>] register_netdevice+0x57a/0x16d0
    [<ffffffff82ef67b7>] __vxlan_dev_create+0x7c7/0xa50
    [<ffffffff82ef6ce6>] vxlan_newlink+0xd6/0x130
    [<ffffffff836d02ab>] __rtnl_newlink+0x112b/0x18a0
    [<ffffffff836d0a8c>] rtnl_newlink+0x6c/0xa0
    [<ffffffff836c0ddf>] rtnetlink_rcv_msg+0x43f/0xd40
    [<ffffffff83908ce0>] netlink_rcv_skb+0x170/0x440
    [<ffffffff839066af>] netlink_unicast+0x53f/0x810
    [<ffffffff839072d8>] netlink_sendmsg+0x958/0xe70
    [<ffffffff835c319f>] ____sys_sendmsg+0x78f/0xa90
    [<ffffffff835cd6da>] ___sys_sendmsg+0x13a/0x1e0
    [<ffffffff835cd94c>] __sys_sendmsg+0x11c/0x1f0
    [<ffffffff8424da78>] do_syscall_64+0x38/0x80
unreferenced object 0xffff88810e76d5f8 (size 192):
  comm "ip", pid 330, jiffies 4295010045 (age 66.016s)
  hex dump (first 32 bytes):
    04 00 00 00 00 00 00 00 db e1 4f e7 00 00 00 00  ..........O.....
    08 d6 76 0e 81 88 ff ff 08 d6 76 0e 81 88 ff ff  ..v.......v.....
  backtrace:
    [<ffffffff81a3162e>] __kmalloc_node+0x4e/0x90
    [<ffffffff81a0e166>] kvmalloc_node+0xa6/0x1f0
    [<ffffffff8276e1a3>] bucket_table_alloc.isra.0+0x83/0x460
    [<ffffffff8276f18b>] rhashtable_init+0x43b/0x7c0
    [<ffffffff82f04a1c>] vxlan_vnigroup_init+0x6c/0x160
    [<ffffffff82ecd69e>] vxlan_init+0x1ae/0x280
    [<ffffffff836858ca>] register_netdevice+0x57a/0x16d0
    [<ffffffff82ef67b7>] __vxlan_dev_create+0x7c7/0xa50
    [<ffffffff82ef6ce6>] vxlan_newlink+0xd6/0x130
    [<ffffffff836d02ab>] __rtnl_newlink+0x112b/0x18a0
    [<ffffffff836d0a8c>] rtnl_newlink+0x6c/0xa0
    [<ffffffff836c0ddf>] rtnetlink_rcv_msg+0x43f/0xd40
    [<ffffffff83908ce0>] netlink_rcv_skb+0x170/0x440
    [<ffffffff839066af>] netlink_unicast+0x53f/0x810
    [<ffffffff839072d8>] netlink_sendmsg+0x958/0xe70
    [<ffffffff835c319f>] ____sys_sendmsg+0x78f/0xa90

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index c3285242f74f..a03752ef544f 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2920,16 +2920,23 @@ static int vxlan_init(struct net_device *dev)
 		vxlan_vnigroup_init(vxlan);
 
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!dev->tstats)
-		return -ENOMEM;
+	if (!dev->tstats) {
+		err = -ENOMEM;
+		goto err_vnigroup_uninit;
+	}
 
 	err = gro_cells_init(&vxlan->gro_cells, dev);
-	if (err) {
-		free_percpu(dev->tstats);
-		return err;
-	}
+	if (err)
+		goto err_free_percpu;
 
 	return 0;
+
+err_free_percpu:
+	free_percpu(dev->tstats);
+err_vnigroup_uninit:
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
+		vxlan_vnigroup_uninit(vxlan);
+	return err;
 }
 
 static void vxlan_fdb_delete_default(struct vxlan_dev *vxlan, __be32 vni)
-- 
2.35.1



