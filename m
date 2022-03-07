Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457044CF838
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbiCGJwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238894AbiCGJsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:48:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539786E341;
        Mon,  7 Mar 2022 01:42:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CEC861312;
        Mon,  7 Mar 2022 09:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89014C340F6;
        Mon,  7 Mar 2022 09:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646150;
        bh=6gcCmo2niaY1ICfThriAwiWMgJuKdrDVjhBfnsf86Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJrA5lWB+DEBy2TtmSMrYmAQ6rweIGVaeqhtaqDb0drh/MZDJZ7Y78YZl6EBxST6O
         7pD5sOdG9Bg2zSOvVpszpu9DbZK3qoI+U02tfiIy6idrIiLVLv+EmNz1U1H4VVcVn0
         Re2Gv09CubP+rV6rRgPC3T6ZlTl+Hf+10sAy6bJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 149/262] mac80211: fix EAPoL rekey fail in 802.3 rx path
Date:   Mon,  7 Mar 2022 10:18:13 +0100
Message-Id: <20220307091706.647053440@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

From: Deren Wu <deren.wu@mediatek.com>

commit 610d086d6df0b15c3732a7b4a5b0f1c3e1b84d4c upstream.

mac80211 set capability NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211
to upper layer by default. That means we should pass EAPoL packets through
nl80211 path only, and should not send the EAPoL skb to netdevice diretly.
At the meanwhile, wpa_supplicant would not register sock to listen EAPoL
skb on the netdevice.

However, there is no control_port_protocol handler in mac80211 for 802.3 RX
packets, mac80211 driver would pass up the EAPoL rekey frame to netdevice
and wpa_supplicant would be never interactive with this kind of packets,
if SUPPORTS_RX_DECAP_OFFLOAD is enabled. This causes STA always rekey fail
if EAPoL frame go through 802.3 path.

To avoid this problem, align the same process as 802.11 type to handle
this frame before put it into network stack.

This also addresses a potential security issue in 802.3 RX mode that was
previously fixed in commit a8c4d76a8dd4 ("mac80211: do not accept/forward
invalid EAPOL frames").

Cc: stable@vger.kernel.org # 5.12+
Fixes: 80a915ec4427 ("mac80211: add rx decapsulation offload support")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Link: https://lore.kernel.org/r/6889c9fced5859ebb088564035f84fd0fa792a49.1644680751.git.deren.wu@mediatek.com
[fix typos, update comment and add note about security issue]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2602,7 +2602,8 @@ static void ieee80211_deliver_skb_to_loc
 		 * address, so that the authenticator (e.g. hostapd) will see
 		 * the frame, but bridge won't forward it anywhere else. Note
 		 * that due to earlier filtering, the only other address can
-		 * be the PAE group address.
+		 * be the PAE group address, unless the hardware allowed them
+		 * through in 802.3 offloaded mode.
 		 */
 		if (unlikely(skb->protocol == sdata->control_port_protocol &&
 			     !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
@@ -4518,12 +4519,7 @@ static void ieee80211_rx_8023(struct iee
 
 	/* deliver to local stack */
 	skb->protocol = eth_type_trans(skb, fast_rx->dev);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	if (rx->list)
-		list_add_tail(&skb->list, rx->list);
-	else
-		netif_receive_skb(skb);
-
+	ieee80211_deliver_skb_to_local_stack(skb, rx);
 }
 
 static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,


