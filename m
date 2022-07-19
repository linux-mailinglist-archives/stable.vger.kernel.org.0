Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8C457A3F0
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 18:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbiGSQIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 12:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiGSQIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 12:08:17 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A526100;
        Tue, 19 Jul 2022 09:08:15 -0700 (PDT)
Date:   Tue, 19 Jul 2022 18:08:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658246893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2dKGb2E0QqGRFRRVheII+rSbPJ0hXbaOlCSA1PSfg+U=;
        b=cve2S4HeQ/TSgVWGZYhXhdE7rxyvQc5FR0Fr/wb1d2+S0pwCvucY96wEVfLhbvoNuUo3Lv
        K6OZ5IQPoPGAJVi6FBxXUDimcgEF74r2uJ+CK90KZ4knT2VY9P9YwDMrTq3g+5/W6/snGj
        /n9CCSYkYSyZnJDAYUBJijNJKDkhw/PeGhGeDR65THVXUpnuAZYvxj99N0Anj43P9M80F0
        3ZC7LNUwZzoEUx/HdNObqwEXerGnyHkBXozxmw5BZTggiG9Txlq1dI6WollIPzINMeY9eF
        4X/V69em3M2dWebcEbmnn8ISFbJH1YnRBzCmw0CvwyFrmHfFEQJNHfy3TwlhLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658246893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2dKGb2E0QqGRFRRVheII+rSbPJ0hXbaOlCSA1PSfg+U=;
        b=OsI0gAG0EdwPQvH7yE3DMSMqWY9YjLLBMaFKqdNtNDMaj9qz5X7gVAIU15DR6EAg1PAg12
        euWjsdBUXR5XAPCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Antonio Quartulli <a@unstable.cc>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15] batman-adv: Use netif_rx_any_context() any.
Message-ID: <YtbW7Ca3t4/3qB7k@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts the stable commit
   e65d78b12fbc0 ("batman-adv: Use netif_rx().")

The commit message says:

| Since commit
|    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
|
| the function netif_rx() can be used in preemptible/thread context as
| well as in interrupt context.

This commit (baebdf48c3600) has not been backported to the 5.15 stable
series and therefore, the commit which builds upon it, must not be
backported either.

Revert the backport and use netif_rx_any_context() again.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 11f6ef657d822..17687848daec5 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -443,7 +443,7 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 	batadv_add_counter(bat_priv, BATADV_CNT_RX_BYTES,
 			   skb->len + ETH_HLEN);
 
-	netif_rx(skb);
+	netif_rx_any_context(skb);
 out:
 	batadv_hardif_put(primary_if);
 }
-- 
2.36.1

