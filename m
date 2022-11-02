Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8026157D2
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiKBCji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKBCje (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:39:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1814611441
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:39:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6633CCE1F17
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E70C433D7;
        Wed,  2 Nov 2022 02:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356770;
        bh=Dnor4adkufRk++lfcAtgS5yKuVG7nGEmHiyDDMIs/1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CDnZeDnZ9kykN+qbP9UnnWFqLC9lK2Q838Oo/NRYOLioP9RnVt82Z1t0bTx+VaC9
         rs0qy0Gc2EySMghiZHZRDk5UHxGOZ41P+3M+9vb2d/TX281Bnc9O5IC5tRNHXwgY1E
         +6qMtQ+o8M/XKlcsFUef6OpRawEeam6qJ8vF5aLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.0 056/240] mac802154: Fix LQI recording
Date:   Wed,  2 Nov 2022 03:30:31 +0100
Message-Id: <20221102022112.666990490@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 5a5c4e06fd03b595542d5590f2bc05a6b7fc5c2b upstream.

Back in 2014, the LQI was saved in the skb control buffer (skb->cb, or
mac_cb(skb)) without any actual reset of this area prior to its use.

As part of a useful rework of the use of this region, 32edc40ae65c
("ieee802154: change _cb handling slightly") introduced mac_cb_init() to
basically memset the cb field to 0. In particular, this new function got
called at the beginning of mac802154_parse_frame_start(), right before
the location where the buffer got actually filled.

What went through unnoticed however, is the fact that the very first
helper called by device drivers in the receive path already used this
area to save the LQI value for later extraction. Resetting the cb field
"so late" led to systematically zeroing the LQI.

If we consider the reset of the cb field needed, we can make it as soon
as we get an skb from a device driver, right before storing the LQI,
as is the very first time we need to write something there.

Cc: stable@vger.kernel.org
Fixes: 32edc40ae65c ("ieee802154: change _cb handling slightly")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20221020142535.1038885-1-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/rx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -132,7 +132,7 @@ static int
 ieee802154_parse_frame_start(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 {
 	int hlen;
-	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
+	struct ieee802154_mac_cb *cb = mac_cb(skb);
 
 	skb_reset_mac_header(skb);
 
@@ -294,8 +294,9 @@ void
 ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
+	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
 
-	mac_cb(skb)->lqi = lqi;
+	cb->lqi = lqi;
 	skb->pkt_type = IEEE802154_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);


