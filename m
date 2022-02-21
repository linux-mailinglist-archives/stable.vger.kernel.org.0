Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2894BE3BD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346767AbiBUI6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:58:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346351AbiBUI55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:57:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803E0255B1;
        Mon, 21 Feb 2022 00:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66FA7B80EB9;
        Mon, 21 Feb 2022 08:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820F5C340E9;
        Mon, 21 Feb 2022 08:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433630;
        bh=52wpOtA34kfSB8zmha79zlMZ/yJp064EQe8NNLcjG9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf17PvUOhU1dY+9JFQ7EiOkglfVyADyWcZ+cyS6Ft8crfTSjAc0DdPnCuiHLCjGeo
         +6jawwrFRFGkeXJGud/GFHZlDn9F1MtbInJuUej8D4X6NGGX5LCxQrhLo7MKXK021k
         fYaE7eX1oS63aSbhPPkZrhu7Fbw2Hjsd6McN8K94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/45] net: ieee802154: at86rf230: Stop leaking skbs
Date:   Mon, 21 Feb 2022 09:48:58 +0100
Message-Id: <20220221084910.702771660@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
References: <20220221084910.454824160@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit e5ce576d45bf72fd0e3dc37eff897bfcc488f6a9 ]

Upon error the ieee802154_xmit_complete() helper is not called. Only
ieee802154_wake_queue() is called manually. In the Tx case we then leak
the skb structure.

Free the skb structure upon error before returning when appropriate.

As the 'is_tx = 0' cannot be moved in the complete handler because of a
possible race between the delay in switching to STATE_RX_AACK_ON and a
new interrupt, we introduce an intermediate 'was_tx' boolean just for
this purpose.

There is no Fixes tag applying here, many changes have been made on this
area and the issue kind of always existed.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20220125121426.848337-4-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/at86rf230.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 5c48bdb6f6787..c2667c71a0cd1 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -108,6 +108,7 @@ struct at86rf230_local {
 	unsigned long cal_timeout;
 	bool is_tx;
 	bool is_tx_from_off;
+	bool was_tx;
 	u8 tx_retry;
 	struct sk_buff *tx_skb;
 	struct at86rf230_state_change tx;
@@ -351,7 +352,11 @@ at86rf230_async_error_recover_complete(void *context)
 	if (ctx->free)
 		kfree(ctx);
 
-	ieee802154_wake_queue(lp->hw);
+	if (lp->was_tx) {
+		lp->was_tx = 0;
+		dev_kfree_skb_any(lp->tx_skb);
+		ieee802154_wake_queue(lp->hw);
+	}
 }
 
 static void
@@ -360,7 +365,11 @@ at86rf230_async_error_recover(void *context)
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
 
-	lp->is_tx = 0;
+	if (lp->is_tx) {
+		lp->was_tx = 1;
+		lp->is_tx = 0;
+	}
+
 	at86rf230_async_state_change(lp, ctx, STATE_RX_AACK_ON,
 				     at86rf230_async_error_recover_complete);
 }
-- 
2.34.1



