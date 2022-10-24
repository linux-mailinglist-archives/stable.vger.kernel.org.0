Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F560AB63
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbiJXNva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbiJXNu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:50:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66906B8C06;
        Mon, 24 Oct 2022 05:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86C586134C;
        Mon, 24 Oct 2022 12:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C90C433D7;
        Mon, 24 Oct 2022 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615285;
        bh=SrYQzjFgyqzLDKvy/umOLdWyR5WDunXFkbkDlhj7OM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztXJdRDaMlhdpR33a3jmIDXHIYNICvBx26tqArsXartHcFMGkbUrm4tU6LlFMAmHj
         luz/ivBz6KALGusjxggY++nB9PMhoCoVao4M13fDhIi6Et/k5wvsmOsnkSrUzDOHDV
         w5HosRVSd5AvgMXGxn659ttOzYRs4VkexKnnYp3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/530] xfrm: Reinject transport-mode packets through workqueue
Date:   Mon, 24 Oct 2022 13:28:55 +0200
Message-Id: <20221024113053.694262648@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 4f4920669d21e1060b7243e5118dc3b71ced1276 ]

The following warning is displayed when the tcp6-multi-diffip11 stress
test case of the LTP test suite is tested:

watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [ns-tcpserver:48198]
CPU: 0 PID: 48198 Comm: ns-tcpserver Kdump: loaded Not tainted 6.0.0-rc6+ #39
Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : des3_ede_encrypt+0x27c/0x460 [libdes]
lr : 0x3f
sp : ffff80000ceaa1b0
x29: ffff80000ceaa1b0 x28: ffff0000df056100 x27: ffff0000e51e5280
x26: ffff80004df75030 x25: ffff0000e51e4600 x24: 000000000000003b
x23: 0000000000802080 x22: 000000000000003d x21: 0000000000000038
x20: 0000000080000020 x19: 000000000000000a x18: 0000000000000033
x17: ffff0000e51e4780 x16: ffff80004e2d1448 x15: ffff80004e2d1248
x14: ffff0000e51e4680 x13: ffff80004e2d1348 x12: ffff80004e2d1548
x11: ffff80004e2d1848 x10: ffff80004e2d1648 x9 : ffff80004e2d1748
x8 : ffff80004e2d1948 x7 : 000000000bcaf83d x6 : 000000000000001b
x5 : ffff80004e2d1048 x4 : 00000000761bf3bf x3 : 000000007f1dd0a3
x2 : ffff0000e51e4780 x1 : ffff0000e3b9a2f8 x0 : 00000000db44e872
Call trace:
 des3_ede_encrypt+0x27c/0x460 [libdes]
 crypto_des3_ede_encrypt+0x1c/0x30 [des_generic]
 crypto_cbc_encrypt+0x148/0x190
 crypto_skcipher_encrypt+0x2c/0x40
 crypto_authenc_encrypt+0xc8/0xfc [authenc]
 crypto_aead_encrypt+0x2c/0x40
 echainiv_encrypt+0x144/0x1a0 [echainiv]
 crypto_aead_encrypt+0x2c/0x40
 esp6_output_tail+0x1c8/0x5d0 [esp6]
 esp6_output+0x120/0x278 [esp6]
 xfrm_output_one+0x458/0x4ec
 xfrm_output_resume+0x6c/0x1f0
 xfrm_output+0xac/0x4ac
 __xfrm6_output+0x130/0x270
 xfrm6_output+0x60/0xec
 ip6_xmit+0x2ec/0x5bc
 inet6_csk_xmit+0xbc/0x10c
 __tcp_transmit_skb+0x460/0x8c0
 tcp_write_xmit+0x348/0x890
 __tcp_push_pending_frames+0x44/0x110
 tcp_rcv_established+0x3c8/0x720
 tcp_v6_do_rcv+0xdc/0x4a0
 tcp_v6_rcv+0xc24/0xcb0
 ip6_protocol_deliver_rcu+0xf0/0x574
 ip6_input_finish+0x48/0x7c
 ip6_input+0x48/0xc0
 ip6_rcv_finish+0x80/0x9c
 xfrm_trans_reinject+0xb0/0xf4
 tasklet_action_common.constprop.0+0xf8/0x134
 tasklet_action+0x30/0x3c
 __do_softirq+0x128/0x368
 do_softirq+0xb4/0xc0
 __local_bh_enable_ip+0xb0/0xb4
 put_cpu_fpsimd_context+0x40/0x70
 kernel_neon_end+0x20/0x40
 sha1_base_do_update.constprop.0.isra.0+0x11c/0x140 [sha1_ce]
 sha1_ce_finup+0x94/0x110 [sha1_ce]
 crypto_shash_finup+0x34/0xc0
 hmac_finup+0x48/0xe0
 crypto_shash_finup+0x34/0xc0
 shash_digest_unaligned+0x74/0x90
 crypto_shash_digest+0x4c/0x9c
 shash_ahash_digest+0xc8/0xf0
 shash_async_digest+0x28/0x34
 crypto_ahash_digest+0x48/0xcc
 crypto_authenc_genicv+0x88/0xcc [authenc]
 crypto_authenc_encrypt+0xd8/0xfc [authenc]
 crypto_aead_encrypt+0x2c/0x40
 echainiv_encrypt+0x144/0x1a0 [echainiv]
 crypto_aead_encrypt+0x2c/0x40
 esp6_output_tail+0x1c8/0x5d0 [esp6]
 esp6_output+0x120/0x278 [esp6]
 xfrm_output_one+0x458/0x4ec
 xfrm_output_resume+0x6c/0x1f0
 xfrm_output+0xac/0x4ac
 __xfrm6_output+0x130/0x270
 xfrm6_output+0x60/0xec
 ip6_xmit+0x2ec/0x5bc
 inet6_csk_xmit+0xbc/0x10c
 __tcp_transmit_skb+0x460/0x8c0
 tcp_write_xmit+0x348/0x890
 __tcp_push_pending_frames+0x44/0x110
 tcp_push+0xb4/0x14c
 tcp_sendmsg_locked+0x71c/0xb64
 tcp_sendmsg+0x40/0x6c
 inet6_sendmsg+0x4c/0x80
 sock_sendmsg+0x5c/0x6c
 __sys_sendto+0x128/0x15c
 __arm64_sys_sendto+0x30/0x40
 invoke_syscall+0x50/0x120
 el0_svc_common.constprop.0+0x170/0x194
 do_el0_svc+0x38/0x4c
 el0_svc+0x28/0xe0
 el0t_64_sync_handler+0xbc/0x13c
 el0t_64_sync+0x180/0x184

Get softirq info by bcc tool:
./softirqs -NT 10
Tracing soft irq event time... Hit Ctrl-C to end.

15:34:34
SOFTIRQ          TOTAL_nsecs
block                 158990
timer               20030920
sched               46577080
net_rx             676746820
tasklet           9906067650

15:34:45
SOFTIRQ          TOTAL_nsecs
block                  86100
sched               38849790
net_rx             676532470
timer             1163848790
tasklet           9409019620

15:34:55
SOFTIRQ          TOTAL_nsecs
sched               58078450
net_rx             475156720
timer              533832410
tasklet           9431333300

The tasklet software interrupt takes too much time. Therefore, the
xfrm_trans_reinject executor is changed from tasklet to workqueue. Add add
spin lock to protect the queue. This reduces the processing flow of the
tcp_sendmsg function in this scenario.

Fixes: acf568ee859f0 ("xfrm: Reinject transport-mode packets through tasklet")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 5f34bc378fdc..3d8668d62e63 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -24,7 +24,8 @@
 #include "xfrm_inout.h"
 
 struct xfrm_trans_tasklet {
-	struct tasklet_struct tasklet;
+	struct work_struct work;
+	spinlock_t queue_lock;
 	struct sk_buff_head queue;
 };
 
@@ -760,18 +761,22 @@ int xfrm_input_resume(struct sk_buff *skb, int nexthdr)
 }
 EXPORT_SYMBOL(xfrm_input_resume);
 
-static void xfrm_trans_reinject(struct tasklet_struct *t)
+static void xfrm_trans_reinject(struct work_struct *work)
 {
-	struct xfrm_trans_tasklet *trans = from_tasklet(trans, t, tasklet);
+	struct xfrm_trans_tasklet *trans = container_of(work, struct xfrm_trans_tasklet, work);
 	struct sk_buff_head queue;
 	struct sk_buff *skb;
 
 	__skb_queue_head_init(&queue);
+	spin_lock_bh(&trans->queue_lock);
 	skb_queue_splice_init(&trans->queue, &queue);
+	spin_unlock_bh(&trans->queue_lock);
 
+	local_bh_disable();
 	while ((skb = __skb_dequeue(&queue)))
 		XFRM_TRANS_SKB_CB(skb)->finish(XFRM_TRANS_SKB_CB(skb)->net,
 					       NULL, skb);
+	local_bh_enable();
 }
 
 int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
@@ -789,8 +794,10 @@ int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
 
 	XFRM_TRANS_SKB_CB(skb)->finish = finish;
 	XFRM_TRANS_SKB_CB(skb)->net = net;
+	spin_lock_bh(&trans->queue_lock);
 	__skb_queue_tail(&trans->queue, skb);
-	tasklet_schedule(&trans->tasklet);
+	spin_unlock_bh(&trans->queue_lock);
+	schedule_work(&trans->work);
 	return 0;
 }
 EXPORT_SYMBOL(xfrm_trans_queue_net);
@@ -817,7 +824,8 @@ void __init xfrm_input_init(void)
 		struct xfrm_trans_tasklet *trans;
 
 		trans = &per_cpu(xfrm_trans_tasklet, i);
+		spin_lock_init(&trans->queue_lock);
 		__skb_queue_head_init(&trans->queue);
-		tasklet_setup(&trans->tasklet, xfrm_trans_reinject);
+		INIT_WORK(&trans->work, xfrm_trans_reinject);
 	}
 }
-- 
2.35.1



