Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952076579B9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiL1PEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiL1PEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:04:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784D2633B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 154D361547
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272AAC433EF;
        Wed, 28 Dec 2022 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239838;
        bh=BS47w7g9828pTnJC7/ndOiPdTvG8y/saiS21fElgk00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFhxSee8HGFlCXdBz7MirjSHvz3t4NwtyhXzqzvXrYho897DziJENTQ3dP+fWtvuz
         b4Y5o8pGfPzl+VSJOVxwVH02gfLNT7AuxO4DKkyKups3ku3hUByP6CW1087aTw4Lju
         TgVHqZL5zkt5eszSX3Tx88dabbp8Nh6EOqklS/o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/731] hsr: Disable netpoll.
Date:   Wed, 28 Dec 2022 15:36:23 +0100
Message-Id: <20221228144304.574212322@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit d5c7652eb16fa203d82546e0285136d7b321ffa9 ]

The hsr device is a software device. Its
net_device_ops::ndo_start_xmit() routine will process the packet and
then pass the resulting skb to dev_queue_xmit().
During processing, hsr acquires a lock with spin_lock_bh()
(hsr_add_node()) which needs to be promoted to the _irq() suffix in
order to avoid a potential deadlock.
Then there are the warnings in dev_queue_xmit() (due to
local_bh_disable() with disabled interrupts) left.

Instead trying to address those (there is qdisc and…) for netpoll sake,
just disable netpoll on hsr.

Disable netpoll on hsr and replace the _irqsave() locking with _bh().

Fixes: f421436a591d3 ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c  | 14 ++++++--------
 net/hsr/hsr_forward.c |  5 ++---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index a1045c3d71b4..c44c6747a0bf 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -278,7 +278,6 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	__u8 type = HSR_TLV_LIFE_CHECK;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_sup_tag *hsr_stag;
-	unsigned long irqflags;
 	struct sk_buff *skb;
 
 	*interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
@@ -299,7 +298,7 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
 
 	/* From HSRv1 on we have separate supervision sequence numbers. */
-	spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
+	spin_lock_bh(&hsr->seqnr_lock);
 	if (hsr->prot_version > 0) {
 		hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
 		hsr->sup_sequence_nr++;
@@ -307,7 +306,7 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 		hsr_stag->sequence_nr = htons(hsr->sequence_nr);
 		hsr->sequence_nr++;
 	}
-	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
+	spin_unlock_bh(&hsr->seqnr_lock);
 
 	hsr_stag->HSR_TLV_type = type;
 	/* TODO: Why 12 in HSRv0? */
@@ -332,7 +331,6 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	struct hsr_priv *hsr = master->hsr;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_sup_tag *hsr_stag;
-	unsigned long irqflags;
 	struct sk_buff *skb;
 
 	skb = hsr_init_skb(master);
@@ -347,7 +345,7 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	set_hsr_stag_HSR_ver(hsr_stag, (hsr->prot_version ? 1 : 0));
 
 	/* From HSRv1 on we have separate supervision sequence numbers. */
-	spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
+	spin_lock_bh(&hsr->seqnr_lock);
 	hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
 	hsr->sup_sequence_nr++;
 	hsr_stag->HSR_TLV_type = PRP_TLV_LIFE_CHECK_DD;
@@ -358,11 +356,11 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
 
 	if (skb_put_padto(skb, ETH_ZLEN)) {
-		spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
+		spin_unlock_bh(&hsr->seqnr_lock);
 		return;
 	}
 
-	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
+	spin_unlock_bh(&hsr->seqnr_lock);
 
 	hsr_forward_skb(skb, master);
 }
@@ -444,7 +442,7 @@ void hsr_dev_setup(struct net_device *dev)
 	dev->header_ops = &hsr_header_ops;
 	dev->netdev_ops = &hsr_device_ops;
 	SET_NETDEV_DEVTYPE(dev, &hsr_type);
-	dev->priv_flags |= IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
 
 	dev->needs_free_netdev = true;
 
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index daf6abbadeb9..c8bcbd990f59 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -458,7 +458,6 @@ static void handle_std_frame(struct sk_buff *skb,
 {
 	struct hsr_port *port = frame->port_rcv;
 	struct hsr_priv *hsr = port->hsr;
-	unsigned long irqflags;
 
 	frame->skb_hsr = NULL;
 	frame->skb_prp = NULL;
@@ -468,10 +467,10 @@ static void handle_std_frame(struct sk_buff *skb,
 		frame->is_from_san = true;
 	} else {
 		/* Sequence nr for the master node */
-		spin_lock_irqsave(&hsr->seqnr_lock, irqflags);
+		spin_lock_bh(&hsr->seqnr_lock);
 		frame->sequence_nr = hsr->sequence_nr;
 		hsr->sequence_nr++;
-		spin_unlock_irqrestore(&hsr->seqnr_lock, irqflags);
+		spin_unlock_bh(&hsr->seqnr_lock);
 	}
 }
 
-- 
2.35.1



