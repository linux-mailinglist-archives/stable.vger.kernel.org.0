Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408785B73A5
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiIMPJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbiIMPJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:09:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7932B76964;
        Tue, 13 Sep 2022 07:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFCEFB80F4B;
        Tue, 13 Sep 2022 14:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B876C433C1;
        Tue, 13 Sep 2022 14:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079486;
        bh=JYuxi9O3FdJnifusqhvtJkC+4XphOyrht8mntGp0LCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQKkMxMjFanNmmbspJfEYpuJnxKKa+tpRhqJofeuY1LBcJiK2URfieXqtbXLcTvPo
         hT5lNyxqxdm8Goye7WmrnII2Vo6sPktLfes6L/clXGFQOGs7VbFC4xm2Cl+3TQSJLK
         5YvOKzjTcXTs6dCJUfM+CrMZPwinsFD/As1cawII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.19 46/79] net: mac802154: Fix a condition in the receive path
Date:   Tue, 13 Sep 2022 16:07:04 +0200
Message-Id: <20220913140351.133713162@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit f0da47118c7e93cdbbc6fb403dd729a5f2c90ee3 upstream.

Upon reception, a packet must be categorized, either it's destination is
the host, or it is another host. A packet with no destination addressing
fields may be valid in two situations:
- the packet has no source field: only ACKs are built like that, we
  consider the host as the destination.
- the packet has a valid source field: it is directed to the PAN
  coordinator, as for know we don't have this information we consider we
  are not the PAN coordinator.

There was likely a copy/paste error made during a previous cleanup
because the if clause is now containing exactly the same condition as in
the switch case, which can never be true. In the past the destination
address was used in the switch and the source address was used in the
if, which matches what the spec says.

Cc: stable@vger.kernel.org
Fixes: ae531b9475f6 ("ieee802154: use ieee802154_addr instead of *_sa variants")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20220826142954.254853-1-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -52,7 +52,7 @@ ieee802154_subif_frame(struct ieee802154
 
 	switch (mac_cb(skb)->dest.mode) {
 	case IEEE802154_ADDR_NONE:
-		if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
+		if (hdr->source.mode != IEEE802154_ADDR_NONE)
 			/* FIXME: check if we are PAN coordinator */
 			skb->pkt_type = PACKET_OTHERHOST;
 		else


