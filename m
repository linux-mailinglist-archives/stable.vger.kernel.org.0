Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B4667548
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbjALOT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbjALOTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C779658D0D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:11:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79FAAB81E6A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86121C433EF;
        Thu, 12 Jan 2023 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532674;
        bh=GDtEZkhACsU9At0ggvC9vkTaBeIvaEmc8xMYTSnQGFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXRL5JC9tFm0TRy1bMDdynvorRzai+nkpuYcZV+fETm0a94kQPvvhPKOvX5Gy6BL+
         NzXEgsgREOUj6Tc4yRYUIPv7okLEyqgB7gjocSYk4uMvYmfmVy69J2YxLVRxJKRrRc
         LRPs2QgC7VO66FCt/jnXETthzgIoStlBgJYSJ8B0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        George McCollister <george.mccollister@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/783] net: hsr: generate supervision frame without HSR/PRP tag
Date:   Thu, 12 Jan 2023 14:48:44 +0100
Message-Id: <20230112135533.988603402@linuxfoundation.org>
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

From: George McCollister <george.mccollister@gmail.com>

[ Upstream commit 78be9217c4014cebac4d549cc2db1f2886d5a8fb ]

For a switch to offload insertion of HSR/PRP tags, frames must not be
sent to the CPU facing switch port with a tag. Generate supervision frames
(eth type ETH_P_PRP) without HSR v1 (ETH_P_HSR)/PRP tag and rely on
create_tagged_frame which inserts it later. This will allow skipping the
tag insertion for all outgoing frames in the future which is required for
HSR v1/PRP tag insertions to be offloaded.

HSR v0 supervision frames always contain tag information so insertion of
the tag can't be offloaded. IEC 62439-3 Ed.2.0 (HSR v1) specifically
notes that this was changed since v0 to allow offloading.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d5c7652eb16f ("hsr: Disable netpoll.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c  | 39 +++++++--------------------------------
 net/hsr/hsr_forward.c |  8 +++++++-
 2 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index fec1b014c0a2..7449c3c95317 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -232,7 +232,7 @@ static const struct header_ops hsr_header_ops = {
 	.parse	 = eth_header_parse,
 };
 
-static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
+static struct sk_buff *hsr_init_skb(struct hsr_port *master)
 {
 	struct hsr_priv *hsr = master->hsr;
 	struct sk_buff *skb;
@@ -244,8 +244,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
 	 * being, for PRP it is a trailer and for HSR it is a
 	 * header
 	 */
-	skb = dev_alloc_skb(sizeof(struct hsr_tag) +
-			    sizeof(struct hsr_sup_tag) +
+	skb = dev_alloc_skb(sizeof(struct hsr_sup_tag) +
 			    sizeof(struct hsr_sup_payload) + hlen + tlen);
 
 	if (!skb)
@@ -253,10 +252,9 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
 
 	skb_reserve(skb, hlen);
 	skb->dev = master->dev;
-	skb->protocol = htons(proto);
 	skb->priority = TC_PRIO_CONTROL;
 
-	if (dev_hard_header(skb, skb->dev, proto,
+	if (dev_hard_header(skb, skb->dev, ETH_P_PRP,
 			    hsr->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
@@ -278,12 +276,10 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 {
 	struct hsr_priv *hsr = master->hsr;
 	__u8 type = HSR_TLV_LIFE_CHECK;
-	struct hsr_tag *hsr_tag = NULL;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_sup_tag *hsr_stag;
 	unsigned long irqflags;
 	struct sk_buff *skb;
-	u16 proto;
 
 	*interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
 	if (hsr->announce_count < 3 && hsr->prot_version == 0) {
@@ -292,23 +288,12 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 		hsr->announce_count++;
 	}
 
-	if (!hsr->prot_version)
-		proto = ETH_P_PRP;
-	else
-		proto = ETH_P_HSR;
-
-	skb = hsr_init_skb(master, proto);
+	skb = hsr_init_skb(master);
 	if (!skb) {
 		WARN_ONCE(1, "HSR: Could not send supervision frame\n");
 		return;
 	}
 
-	if (hsr->prot_version > 0) {
-		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
-		hsr_tag->encap_proto = htons(ETH_P_PRP);
-		set_hsr_tag_LSDU_size(hsr_tag, HSR_V1_SUP_LSDUSIZE);
-	}
-
 	hsr_stag = skb_put(skb, sizeof(struct hsr_sup_tag));
 	set_hsr_stag_path(hsr_stag, (hsr->prot_version ? 0x0 : 0xf));
 	set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
@@ -318,8 +303,6 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	if (hsr->prot_version > 0) {
 		hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
 		hsr->sup_sequence_nr++;
-		hsr_tag->sequence_nr = htons(hsr->sequence_nr);
-		hsr->sequence_nr++;
 	} else {
 		hsr_stag->sequence_nr = htons(hsr->sequence_nr);
 		hsr->sequence_nr++;
@@ -335,7 +318,7 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
 
-	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
+	if (skb_put_padto(skb, ETH_ZLEN))
 		return;
 
 	hsr_forward_skb(skb, master);
@@ -351,10 +334,8 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	struct hsr_sup_tag *hsr_stag;
 	unsigned long irqflags;
 	struct sk_buff *skb;
-	struct prp_rct *rct;
-	u8 *tail;
 
-	skb = hsr_init_skb(master, ETH_P_PRP);
+	skb = hsr_init_skb(master);
 	if (!skb) {
 		WARN_ONCE(1, "PRP: Could not send supervision frame\n");
 		return;
@@ -376,17 +357,11 @@ static void send_prp_supervision_frame(struct hsr_port *master,
 	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
 
-	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN)) {
+	if (skb_put_padto(skb, ETH_ZLEN)) {
 		spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
 		return;
 	}
 
-	tail = skb_tail_pointer(skb) - HSR_HLEN;
-	rct = (struct prp_rct *)tail;
-	rct->PRP_suffix = htons(ETH_P_PRP);
-	set_prp_LSDU_size(rct, HSR_V1_SUP_LSDUSIZE);
-	rct->sequence_nr = htons(hsr->sequence_nr);
-	hsr->sequence_nr++;
 	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
 
 	hsr_forward_skb(skb, master);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 90b0ed16552b..15653d3bb6ac 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -186,6 +186,7 @@ static struct sk_buff *prp_fill_rct(struct sk_buff *skb,
 	set_prp_LSDU_size(trailer, lsdu_size);
 	trailer->sequence_nr = htons(frame->sequence_nr);
 	trailer->PRP_suffix = htons(ETH_P_PRP);
+	skb->protocol = eth_hdr(skb)->h_proto;
 
 	return skb;
 }
@@ -226,6 +227,7 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
 	hsr_ethhdr->hsr_tag.encap_proto = hsr_ethhdr->ethhdr.h_proto;
 	hsr_ethhdr->ethhdr.h_proto = htons(proto_version ?
 			ETH_P_HSR : ETH_P_PRP);
+	skb->protocol = hsr_ethhdr->ethhdr.h_proto;
 
 	return skb;
 }
@@ -455,7 +457,11 @@ static void handle_std_frame(struct sk_buff *skb,
 int hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
 			struct hsr_frame_info *frame)
 {
-	if (proto == htons(ETH_P_PRP) ||
+	struct hsr_port *port = frame->port_rcv;
+	struct hsr_priv *hsr = port->hsr;
+
+	/* HSRv0 supervisory frames double as a tag so treat them as tagged. */
+	if ((!hsr->prot_version && proto == htons(ETH_P_PRP)) ||
 	    proto == htons(ETH_P_HSR)) {
 		/* Check if skb contains hsr_ethhdr */
 		if (skb->mac_len < sizeof(struct hsr_ethhdr))
-- 
2.35.1



