Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843004CF5B7
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbiCGJag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238505AbiCGJ3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C201A394;
        Mon,  7 Mar 2022 01:27:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECD00B810BF;
        Mon,  7 Mar 2022 09:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A01C340E9;
        Mon,  7 Mar 2022 09:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645250;
        bh=BY9Ruxi67wd8m2eQOnaUyRhsnnq5NaqeJk5fab+ldGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVWGhKYqJijVrd5EWIm+Oax5ELRHe/FhrtwHgfh7F4b6Y6N4etdbu/8gfbRNc8QeV
         NWlpu/lUqS9Uj3dNyj/+/DjPtPel+0EhlzmHOEZUAQogJo84dnNfvNeuxzuq3ePZyq
         dSXVk28Ezpr/GYMCvuFngbkk2mKkMpKRRnPDIgZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Nicolas Escande <nico.escande@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 34/64] mac80211: fix forwarded mesh frames AC & queue selection
Date:   Mon,  7 Mar 2022 10:19:07 +0100
Message-Id: <20220307091640.114466092@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
@@ -2852,13 +2852,13 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
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


