Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6759D385
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242084AbiHWIMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242076AbiHWIKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DB3696F5;
        Tue, 23 Aug 2022 01:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61742611A8;
        Tue, 23 Aug 2022 08:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB65C433D6;
        Tue, 23 Aug 2022 08:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242052;
        bh=h3xjcasmKH79T4Xe1CGuqxknob4/8v+qLXk+cPNXymg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYRNaDX8qjXiFoN5DsLPZJz8f4FizKWSokAzBXomYZ0sgdNd/8oi16wl483kqV9Pr
         nJuJfIvcibeBAkymKNaQELkZdBZ2FNyM+83CU0r4jLP44yjMc9ZdB7WEJCYVXEQVhK
         oF442carRbgFkkpdl5XvnJxwa0Yd4Sgb8shsBNfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cezar Bulinaru <cbulinaru@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 051/365] net: tap: NULL pointer derefence in dev_parse_header_protocol when skb->dev is null
Date:   Tue, 23 Aug 2022 09:59:12 +0200
Message-Id: <20220823080120.322529519@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezar Bulinaru <cbulinaru@gmail.com>

commit 4f61f133f354853bc394ec7d6028adb9b02dd701 upstream.

Fixes a NULL pointer derefence bug triggered from tap driver.
When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
(in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
virtio_net_hdr_to_skb calls dev_parse_header_protocol which
needs skb->dev field to be valid.

The line that trigers the bug is in dev_parse_header_protocol
(dev is at offset 0x10 from skb and is stored in RAX register)
  if (!dev->header_ops || !dev->header_ops->parse_protocol)
  22e1:   mov    0x10(%rbx),%rax
  22e5:	  mov    0x230(%rax),%rax

Setting skb->dev before the call in tap.c fixes the issue.

BUG: kernel NULL pointer dereference, address: 0000000000000230
RIP: 0010:virtio_net_hdr_to_skb.constprop.0+0x335/0x410 [tap]
Code: c0 0f 85 b7 fd ff ff eb d4 41 39 c6 77 cf 29 c6 48 89 df 44 01 f6 e8 7a 79 83 c1 48 85 c0 0f 85 d9 fd ff ff eb b7 48 8b 43 10 <48> 8b 80 30 02 00 00 48 85 c0 74 55 48 8b 40 28 48 85 c0 74 4c 48
RSP: 0018:ffffc90005c27c38 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888298f25300 RCX: 0000000000000010
RDX: 0000000000000005 RSI: ffffc90005c27cb6 RDI: ffff888298f25300
RBP: ffffc90005c27c80 R08: 00000000ffffffea R09: 00000000000007e8
R10: ffff88858ec77458 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000014 R14: ffffc90005c27e08 R15: ffffc90005c27cb6
FS:  0000000000000000(0000) GS:ffff88858ec40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000230 CR3: 0000000281408006 CR4: 00000000003706e0
Call Trace:
 tap_get_user+0x3f1/0x540 [tap]
 tap_sendmsg+0x56/0x362 [tap]
 ? get_tx_bufs+0xc2/0x1e0 [vhost_net]
 handle_tx_copy+0x114/0x670 [vhost_net]
 handle_tx+0xb0/0xe0 [vhost_net]
 handle_tx_kick+0x15/0x20 [vhost_net]
 vhost_worker+0x7b/0xc0 [vhost]
 ? vhost_vring_call_reset+0x40/0x40 [vhost]
 kthread+0xfa/0x120
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30

Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tap.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -716,10 +716,20 @@ static ssize_t tap_get_user(struct tap_q
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_hdr(skb)->h_proto;
 
+	rcu_read_lock();
+	tap = rcu_dereference(q->tap);
+	if (!tap) {
+		kfree_skb(skb);
+		rcu_read_unlock();
+		return total_len;
+	}
+	skb->dev = tap->dev;
+
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
 					    tap_is_little_endian(q));
 		if (err) {
+			rcu_read_unlock();
 			drop_reason = SKB_DROP_REASON_DEV_HDR;
 			goto err_kfree;
 		}
@@ -732,8 +742,6 @@ static ssize_t tap_get_user(struct tap_q
 	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-	rcu_read_lock();
-	tap = rcu_dereference(q->tap);
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
 		skb_zcopy_init(skb, msg_control);
@@ -742,14 +750,8 @@ static ssize_t tap_get_user(struct tap_q
 		uarg->callback(NULL, uarg, false);
 	}
 
-	if (tap) {
-		skb->dev = tap->dev;
-		dev_queue_xmit(skb);
-	} else {
-		kfree_skb(skb);
-	}
+	dev_queue_xmit(skb);
 	rcu_read_unlock();
-
 	return total_len;
 
 err_kfree:


