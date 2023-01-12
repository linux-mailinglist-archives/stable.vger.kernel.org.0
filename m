Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A1766754E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbjALOUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjALOTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DAB53728
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:11:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5CFEFCE1E71
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18990C433EF;
        Thu, 12 Jan 2023 14:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532680;
        bh=KWbypAibzVAGEhqZTljc3d/eK7Wu9lIMQwxlQBI9Xbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1PyNzGM6/ggVeQZ244B5Ak9kYVGY4urMCchm61PxBeBa4tZVX9BpUk7bmDlgc4jX
         L9t7gY0YyqQWejQP/vLHYcAM3Aw35/6WFz82npLlj5FbqJz9M91Fv/OUy9vvuNJls+
         D8/MHi7K/oaxoEAm5Y29r67l4xFKb28cyxImT5Cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/783] hsr: Synchronize sending frames to have always incremented outgoing seq nr.
Date:   Thu, 12 Jan 2023 14:48:46 +0100
Message-Id: <20230112135534.079964635@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 06afd2c31d338fa762548580c1bf088703dd1e03 ]

Sending frames via the hsr (master) device requires a sequence number
which is tracked in hsr_priv::sequence_nr and protected by
hsr_priv::seqnr_lock. Each time a new frame is sent, it will obtain a
new id and then send it via the slave devices.
Each time a packet is sent (via hsr_forward_do()) the sequence number is
checked via hsr_register_frame_out() to ensure that a frame is not
handled twice. This make sense for the receiving side to ensure that the
frame is not injected into the stack twice after it has been received
from both slave ports.

There is no locking to cover the sending path which means the following
scenario is possible:

  CPU0				CPU1
  hsr_dev_xmit(skb1)		hsr_dev_xmit(skb2)
   fill_frame_info()             fill_frame_info()
    hsr_fill_frame_info()         hsr_fill_frame_info()
     handle_std_frame()            handle_std_frame()
      skb1's sequence_nr = 1
                                    skb2's sequence_nr = 2
   hsr_forward_do()              hsr_forward_do()

                                   hsr_register_frame_out(, 2)  // okay, send)

    hsr_register_frame_out(, 1) // stop, lower seq duplicate

Both skbs (or their struct hsr_frame_info) received an unique id.
However since skb2 was sent before skb1, the higher sequence number was
recorded in hsr_register_frame_out() and the late arriving skb1 was
dropped and never sent.

This scenario has been observed in a three node HSR setup, with node1 +
node2 having ping and iperf running in parallel. From time to time ping
reported a missing packet. Based on tracing that missing ping packet did
not leave the system.

It might be possible (didn't check) to drop the sequence number check on
the sending side. But if the higher sequence number leaves on wire
before the lower does and the destination receives them in that order
and it will drop the packet with the lower sequence number and never
inject into the stack.
Therefore it seems the only way is to lock the whole path from obtaining
the sequence number and sending via dev_queue_xmit() and assuming the
packets leave on wire in the same order (and don't get reordered by the
NIC).

Cover the whole path for the master interface from obtaining the ID
until after it has been forwarded via hsr_forward_skb() to ensure the
skbs are sent to the NIC in the order of the assigned sequence numbers.

Fixes: f421436a591d3 ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c  | 12 +++++++-----
 net/hsr/hsr_forward.c |  3 +--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 037ad39564a4..84e6ef4f3525 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -219,7 +219,9 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		skb->dev = master->dev;
 		skb_reset_mac_header(skb);
 		skb_reset_mac_len(skb);
+		spin_lock_bh(&hsr->seqnr_lock);
 		hsr_forward_skb(skb, master);
+		spin_unlock_bh(&hsr->seqnr_lock);
 	} else {
 		atomic_long_inc(&dev->tx_dropped);
 		dev_kfree_skb_any(skb);
@@ -306,7 +308,6 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 		hsr_stag->sequence_nr = htons(hsr->sequence_nr);
 		hsr->sequence_nr++;
 	}
-	spin_unlock_bh(&hsr->seqnr_lock);
 
 	hsr_stag->HSR_TLV_type = type;
 	/* TODO: Why 12 in HSRv0? */
@@ -317,11 +318,13 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
 
-	if (skb_put_padto(skb, ETH_ZLEN))
+	if (skb_put_padto(skb, ETH_ZLEN)) {
+		spin_unlock_bh(&hsr->seqnr_lock);
 		return;
+	}
 
 	hsr_forward_skb(skb, master);
-
+	spin_unlock_bh(&hsr->seqnr_lock);
 	return;
 }
 
@@ -360,9 +363,8 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 		return;
 	}
 
-	spin_unlock_bh(&hsr->seqnr_lock);
-
 	hsr_forward_skb(skb, master);
+	spin_unlock_bh(&hsr->seqnr_lock);
 }
 
 /* Announce (supervision frame) timer function
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 142bed7f1fea..aec48e670fb6 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -446,10 +446,9 @@ static void handle_std_frame(struct sk_buff *skb,
 		frame->is_from_san = true;
 	} else {
 		/* Sequence nr for the master node */
-		spin_lock_bh(&hsr->seqnr_lock);
+		lockdep_assert_held(&hsr->seqnr_lock);
 		frame->sequence_nr = hsr->sequence_nr;
 		hsr->sequence_nr++;
-		spin_unlock_bh(&hsr->seqnr_lock);
 	}
 }
 
-- 
2.35.1



