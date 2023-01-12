Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983C166754C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbjALOUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbjALOTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E7258F91
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F12B861F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D4DC433D2;
        Thu, 12 Jan 2023 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532677;
        bh=E1qAVEKRXwpAglb7bj9Kvw7bS40kXmTsSO5OeznVJJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2eY4PA4v4TfOqKXJjuW8P0iIYsclVNqpikp7myheKbJllivSKflpP96nWBwNfr4BJ
         NF+2KyktWKoA6BrL9qNi61eU8/Jy6E9Qi0l1JTyp7E4aOFgpLpE/QZzS9vy6wbiu+7
         8F3cncRBekjXNUd+pNbwqN/f3nzr+n05wkVXqPKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/783] hsr: Disable netpoll.
Date:   Thu, 12 Jan 2023 14:48:45 +0100
Message-Id: <20230112135534.036281623@linuxfoundation.org>
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
index 7449c3c95317..037ad39564a4 100644
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
@@ -443,7 +441,7 @@ void hsr_dev_setup(struct net_device *dev)
 	dev->header_ops = &hsr_header_ops;
 	dev->netdev_ops = &hsr_device_ops;
 	SET_NETDEV_DEVTYPE(dev, &hsr_type);
-	dev->priv_flags |= IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
 
 	dev->needs_free_netdev = true;
 
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 15653d3bb6ac..142bed7f1fea 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -437,7 +437,6 @@ static void handle_std_frame(struct sk_buff *skb,
 {
 	struct hsr_port *port = frame->port_rcv;
 	struct hsr_priv *hsr = port->hsr;
-	unsigned long irqflags;
 
 	frame->skb_hsr = NULL;
 	frame->skb_prp = NULL;
@@ -447,10 +446,10 @@ static void handle_std_frame(struct sk_buff *skb,
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



