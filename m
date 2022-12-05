Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A65F6432BF
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiLET3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiLET2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:28:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5311327CFE
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E45AC6131A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04564C433C1;
        Mon,  5 Dec 2022 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268320;
        bh=/6DMGXY9EomA1dt5qHgxcdohcaUpMHPAa2tJlcMoShk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfLncwAGrf7VJKdM6ndAhwGEag0m5++VA38NxR6poacjFEtgj3CriN8MpW0ys1ZZc
         1OAnlrs7LSFt/L+Mi7Lv8TbufRTl+2NDw6uhB8kscbqMaOYatrt0/fvP0JAcOrFgOj
         068DYqmVvpc3XvKv0HWDzK6gIEJL1W2bA4BPFyiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 058/124] net: wwan: iosm: fix incorrect skb length
Date:   Mon,  5 Dec 2022 20:09:24 +0100
Message-Id: <20221205190810.070735927@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit c34ca4f32c24bf748493b49085e43cd714cf8357 ]

skb passed to network layer contains incorrect length.

In mux aggregation protocol, the datagram block received
from device contains block signature, packet & datagram
header. The right skb len to be calculated by subracting
datagram pad len from datagram length.

Whereas in mux lite protocol, the skb contains single
datagram so skb len is calculated by subtracting the
packet offset from datagram header.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index 738420bd14af..d6b166fc5c0e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -365,7 +365,8 @@ static void ipc_mux_dl_cmd_decode(struct iosm_mux *ipc_mux, struct sk_buff *skb)
 /* Pass the DL packet to the netif layer. */
 static int ipc_mux_net_receive(struct iosm_mux *ipc_mux, int if_id,
 			       struct iosm_wwan *wwan, u32 offset,
-			       u8 service_class, struct sk_buff *skb)
+			       u8 service_class, struct sk_buff *skb,
+			       u32 pkt_len)
 {
 	struct sk_buff *dest_skb = skb_clone(skb, GFP_ATOMIC);
 
@@ -373,7 +374,7 @@ static int ipc_mux_net_receive(struct iosm_mux *ipc_mux, int if_id,
 		return -ENOMEM;
 
 	skb_pull(dest_skb, offset);
-	skb_set_tail_pointer(dest_skb, dest_skb->len);
+	skb_trim(dest_skb, pkt_len);
 	/* Pass the packet to the netif layer. */
 	dest_skb->priority = service_class;
 
@@ -429,7 +430,7 @@ static void ipc_mux_dl_fcth_decode(struct iosm_mux *ipc_mux,
 static void ipc_mux_dl_adgh_decode(struct iosm_mux *ipc_mux,
 				   struct sk_buff *skb)
 {
-	u32 pad_len, packet_offset;
+	u32 pad_len, packet_offset, adgh_len;
 	struct iosm_wwan *wwan;
 	struct mux_adgh *adgh;
 	u8 *block = skb->data;
@@ -470,10 +471,12 @@ static void ipc_mux_dl_adgh_decode(struct iosm_mux *ipc_mux,
 	packet_offset = sizeof(*adgh) + pad_len;
 
 	if_id += ipc_mux->wwan_q_offset;
+	adgh_len = le16_to_cpu(adgh->length);
 
 	/* Pass the packet to the netif layer */
 	rc = ipc_mux_net_receive(ipc_mux, if_id, wwan, packet_offset,
-				 adgh->service_class, skb);
+				 adgh->service_class, skb,
+				 adgh_len - packet_offset);
 	if (rc) {
 		dev_err(ipc_mux->dev, "mux adgh decoding error");
 		return;
@@ -547,7 +550,7 @@ static int mux_dl_process_dg(struct iosm_mux *ipc_mux, struct mux_adbh *adbh,
 			     int if_id, int nr_of_dg)
 {
 	u32 dl_head_pad_len = ipc_mux->session[if_id].dl_head_pad_len;
-	u32 packet_offset, i, rc;
+	u32 packet_offset, i, rc, dg_len;
 
 	for (i = 0; i < nr_of_dg; i++, dg++) {
 		if (le32_to_cpu(dg->datagram_index)
@@ -562,11 +565,12 @@ static int mux_dl_process_dg(struct iosm_mux *ipc_mux, struct mux_adbh *adbh,
 			packet_offset =
 				le32_to_cpu(dg->datagram_index) +
 				dl_head_pad_len;
+			dg_len = le16_to_cpu(dg->datagram_length);
 			/* Pass the packet to the netif layer. */
 			rc = ipc_mux_net_receive(ipc_mux, if_id, ipc_mux->wwan,
 						 packet_offset,
-						 dg->service_class,
-						 skb);
+						 dg->service_class, skb,
+						 dg_len - dl_head_pad_len);
 			if (rc)
 				goto dg_error;
 		}
-- 
2.35.1



