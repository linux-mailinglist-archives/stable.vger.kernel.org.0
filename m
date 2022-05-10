Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD93652181A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243370AbiEJNdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243392AbiEJNao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:30:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A968222B38D;
        Tue, 10 May 2022 06:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EE96B81B32;
        Tue, 10 May 2022 13:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A071C385A6;
        Tue, 10 May 2022 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188892;
        bh=gdUdKjW7XpBqC98ng8uSCII3uv6RmKTxh7z3nkYusHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kf2OqDRi1ZyNtutywswqP3Y4TRXStAVrVhgq+YppDBvAEXoLL/ZQTvTVV1+kPItgu
         hEdFbhxnN+JCxrM3KEBFzfWm6lRBfBEWVhpoohx699aMgu1bBCxU6bUA5fXp6UiAm3
         sX3KlqCF6nw/dlg4pJp/YBXtuYdg8nQOJwNEN0P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 65/88] firewire: core: extend card->lock in fw_core_handle_bus_reset
Date:   Tue, 10 May 2022 15:07:50 +0200
Message-Id: <20220510130735.627286891@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

commit a7ecbe92b9243edbe94772f6f2c854e4142a3345 upstream.

card->local_node and card->bm_retries are both always accessed under
card->lock.
fw_core_handle_bus_reset has a check whose condition depends on
card->local_node and whose body writes to card->bm_retries.
Both of these accesses are not under card->lock. Move the lock acquiring
of card->lock to before this check such that these accesses do happen
when card->lock is held.
fw_destroy_nodes is called inside the check.
Since fw_destroy_nodes already acquires card->lock inside its function
body, move this out to the callsites of fw_destroy_nodes.
Also add a comment to indicate which locking is necessary when calling
fw_destroy_nodes.

Cc: <stable@vger.kernel.org>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20220409041243.603210-4-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/core-card.c     |    3 +++
 drivers/firewire/core-topology.c |    9 +++------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -681,6 +681,7 @@ EXPORT_SYMBOL_GPL(fw_card_release);
 void fw_core_remove_card(struct fw_card *card)
 {
 	struct fw_card_driver dummy_driver = dummy_driver_template;
+	unsigned long flags;
 
 	card->driver->update_phy_reg(card, 4,
 				     PHY_LINK_ACTIVE | PHY_CONTENDER, 0);
@@ -695,7 +696,9 @@ void fw_core_remove_card(struct fw_card
 	dummy_driver.stop_iso		= card->driver->stop_iso;
 	card->driver = &dummy_driver;
 
+	spin_lock_irqsave(&card->lock, flags);
 	fw_destroy_nodes(card);
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	/* Wait for all users, especially device workqueue jobs, to finish. */
 	fw_card_put(card);
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -386,16 +386,13 @@ static void report_found_node(struct fw_
 	card->bm_retries = 0;
 }
 
+/* Must be called with card->lock held */
 void fw_destroy_nodes(struct fw_card *card)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&card->lock, flags);
 	card->color++;
 	if (card->local_node != NULL)
 		for_each_fw_node(card, card->local_node, report_lost_node);
 	card->local_node = NULL;
-	spin_unlock_irqrestore(&card->lock, flags);
 }
 
 static void move_tree(struct fw_node *node0, struct fw_node *node1, int port)
@@ -521,6 +518,8 @@ void fw_core_handle_bus_reset(struct fw_
 	struct fw_node *local_node;
 	unsigned long flags;
 
+	spin_lock_irqsave(&card->lock, flags);
+
 	/*
 	 * If the selfID buffer is not the immediate successor of the
 	 * previously processed one, we cannot reliably compare the
@@ -532,8 +531,6 @@ void fw_core_handle_bus_reset(struct fw_
 		card->bm_retries = 0;
 	}
 
-	spin_lock_irqsave(&card->lock, flags);
-
 	card->broadcast_channel_allocated = card->broadcast_channel_auto_allocated;
 	card->node_id = node_id;
 	/*


