Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFF969CC76
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjBTNkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBTNke (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:40:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3A01C313
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:40:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AADE60EA0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DAAC433D2;
        Mon, 20 Feb 2023 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900432;
        bh=60ilLB1wq8MB7L0xESGxj7SbM21GwdZSii4aoIgbJH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArfGG3+AGOy35FLquhhizI+AeQA44bbKfELSmITrM24RR8WRLX7lynJaSDllUb5qU
         1qKnkFA3FCX37cpGcQURg0ERaeu5w8U8mBUYSK5DlNczb3m6QKE99X5HhvxuhW1v3n
         gIRANK+BQLR2h5QCfTE3h1GYpokaF2IdjGl1jJUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Eelco Chaudron <echaudro@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/89] net: openvswitch: fix flow memory leak in ovs_flow_cmd_new
Date:   Mon, 20 Feb 2023 14:35:06 +0100
Message-Id: <20230220133553.345563561@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 0c598aed445eb45b0ee7ba405f7ece99ee349c30 ]

Syzkaller reports a memory leak of new_flow in ovs_flow_cmd_new() as it is
not freed when an allocation of a key fails.

BUG: memory leak
unreferenced object 0xffff888116668000 (size 632):
  comm "syz-executor231", pid 1090, jiffies 4294844701 (age 18.871s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000defa3494>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
    [<00000000defa3494>] ovs_flow_alloc+0x19/0x180 net/openvswitch/flow_table.c:77
    [<00000000c67d8873>] ovs_flow_cmd_new+0x1de/0xd40 net/openvswitch/datapath.c:957
    [<0000000010a539a8>] genl_family_rcv_msg_doit+0x22d/0x330 net/netlink/genetlink.c:739
    [<00000000dff3302d>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
    [<00000000dff3302d>] genl_rcv_msg+0x328/0x590 net/netlink/genetlink.c:800
    [<000000000286dd87>] netlink_rcv_skb+0x153/0x430 net/netlink/af_netlink.c:2515
    [<0000000061fed410>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
    [<000000009dc0f111>] netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
    [<000000009dc0f111>] netlink_unicast+0x545/0x7f0 net/netlink/af_netlink.c:1339
    [<000000004a5ee816>] netlink_sendmsg+0x8e7/0xde0 net/netlink/af_netlink.c:1934
    [<00000000482b476f>] sock_sendmsg_nosec net/socket.c:651 [inline]
    [<00000000482b476f>] sock_sendmsg+0x152/0x190 net/socket.c:671
    [<00000000698574ba>] ____sys_sendmsg+0x70a/0x870 net/socket.c:2356
    [<00000000d28d9e11>] ___sys_sendmsg+0xf3/0x170 net/socket.c:2410
    [<0000000083ba9120>] __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
    [<00000000c00628f8>] do_syscall_64+0x30/0x40 arch/x86/entry/common.c:46
    [<000000004abfdcf4>] entry_SYSCALL_64_after_hwframe+0x61/0xc6

To fix this the patch rearranges the goto labels to reflect the order of
object allocations and adds appropriate goto statements on the error
paths.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 68bb10101e6b ("openvswitch: Fix flow lookup to use unmasked key")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230201210218.361970-1-pchelkin@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index fbc575247268..0551915519d9 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -934,14 +934,14 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	key = kzalloc(sizeof(*key), GFP_KERNEL);
 	if (!key) {
 		error = -ENOMEM;
-		goto err_kfree_key;
+		goto err_kfree_flow;
 	}
 
 	ovs_match_init(&match, key, false, &mask);
 	error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
 				  a[OVS_FLOW_ATTR_MASK], log);
 	if (error)
-		goto err_kfree_flow;
+		goto err_kfree_key;
 
 	ovs_flow_mask_key(&new_flow->key, key, true, &mask);
 
@@ -949,14 +949,14 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
 				       key, log);
 	if (error)
-		goto err_kfree_flow;
+		goto err_kfree_key;
 
 	/* Validate actions. */
 	error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
 				     &new_flow->key, &acts, log);
 	if (error) {
 		OVS_NLERR(log, "Flow actions may not be safe on all matching packets.");
-		goto err_kfree_flow;
+		goto err_kfree_key;
 	}
 
 	reply = ovs_flow_cmd_alloc_info(acts, &new_flow->id, info, false,
@@ -1056,10 +1056,10 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	kfree_skb(reply);
 err_kfree_acts:
 	ovs_nla_free_flow_actions(acts);
-err_kfree_flow:
-	ovs_flow_free(new_flow, false);
 err_kfree_key:
 	kfree(key);
+err_kfree_flow:
+	ovs_flow_free(new_flow, false);
 error:
 	return error;
 }
-- 
2.39.0



