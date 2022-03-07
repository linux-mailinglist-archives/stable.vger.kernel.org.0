Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE134CF703
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbiCGJoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbiCGJiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:38:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A5E61A36;
        Mon,  7 Mar 2022 01:32:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E7B0B810C2;
        Mon,  7 Mar 2022 09:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96542C340E9;
        Mon,  7 Mar 2022 09:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645536;
        bh=rkN/9pHcviQL+3Bw05GKlarMeOkPn7TNP2Y495EHTAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jh6RTBQUZIcE11lgX1QHvXUb5lJYi5UhnZvAifIPV6jYrQsSJ2wlzN57Z9Uk9bw87
         jwPNGHA2IQkoA2CRN8/6l/FLiU1kMByerkeaQr6HmMro1A+ZJs41FSR241cfs8Y07x
         +7eZx3jZkG9PcnodR6Q+ftV9Kn3i1HDpzJSegQ6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Nicolas Escande <nico.escande@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 060/105] mac80211: fix forwarded mesh frames AC & queue selection
Date:   Mon,  7 Mar 2022 10:19:03 +0100
Message-Id: <20220307091645.868637246@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Escande <nico.escande@gmail.com>

commit 859ae7018316daa4adbc496012dcbbb458d7e510 upstream.

There are two problems with the current code that have been highlighted
with the AQL feature that is now enbaled by default.

First problem is in ieee80211_rx_h_mesh_fwding(),
ieee80211_select_queue_80211() is used on received packets to choose
the sending AC queue of the forwarding packet although this function
should only be called on TX packet (it uses ieee80211_tx_info).
This ends with forwarded mesh packets been sent on unrelated random AC
queue. To fix that, AC queue can directly be infered from skb->priority
which has been extracted from QOS info (see ieee80211_parse_qos()).

Second problem is the value of queue_mapping set on forwarded mesh
frames via skb_set_queue_mapping() is not the AC of the packet but a
hardware queue index. This may or may not work depending on AC to HW
queue mapping which is driver specific.

Both of these issues lead to improper AC selection while forwarding
mesh packets but more importantly due to improper airtime accounting
(which is done on a per STA, per AC basis) caused traffic stall with
the introduction of AQL.

Fixes: cf44012810cc ("mac80211: fix unnecessary frame drops in mesh fwding")
Fixes: d3c1597b8d1b ("mac80211: fix forwarded mesh frame queue mapping")
Co-developed-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://lore.kernel.org/r/20220214173214.368862-1-nico.escande@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2910,13 +2910,13 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 	    ether_addr_equal(sdata->vif.addr, hdr->addr3))
 		return RX_CONTINUE;
 
-	ac = ieee80211_select_queue_80211(sdata, skb, hdr);
+	ac = ieee802_1d_to_ac[skb->priority];
 	q = sdata->vif.hw_queue[ac];
 	if (ieee80211_queue_stopped(&local->hw, q)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
 		return RX_DROP_MONITOR;
 	}
-	skb_set_queue_mapping(skb, q);
+	skb_set_queue_mapping(skb, ac);
 
 	if (!--mesh_hdr->ttl) {
 		if (!is_multicast_ether_addr(hdr->addr1))


