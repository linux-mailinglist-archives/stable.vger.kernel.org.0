Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D437471594
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfGWJ7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:59:46 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:40695 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfGWJ7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:59:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 656AD5B9;
        Tue, 23 Jul 2019 05:59:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 05:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0Mr7Jm
        PBn9kqGY1nKUgz/W6bP+e/lTC27cexjtC1Qvw=; b=jQZ2xIBrRFtsCD6R3aE4E4
        ITAaNdgAYL5amLOQf7V6QOu9sU839Kd6ac4D2uT4jFZdEpeu8N3Oacxd8vDuY18m
        /HECh+p0Mm6C7o+4I05m3a2dNJE/aGoV8Ran8b4LqAASvI84XcSl55uIX4FmsNkz
        ohmltWzP/WTMTMnaXdhyRXwnzhUyIkL8ZHeIyz9zj1w+ooddK7m98dYykSTl7uoz
        HuKWXUpxBZEH9OMdh15gXqYJ3XthL8Be96u+0wCtr4IFe2RMS1NSKP5XBNg0pLIQ
        n8x4BLFyVy60Th35khX9JYHyC9YQPXCrAy/EfPp2zUD+aOUjYfxQ5Sp5Yb4lCyTQ
        ==
X-ME-Sender: <xms:kNo2XV6MgvsKtPzeMwuSoW-ImU1CtFfHYHtIwPCShai9pNxRPA5_kQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:kNo2XQYwzBdBHkx2tbbZSjHmXktCvf0RXbmWV5YvTrJCWnJzrIgAHw>
    <xmx:kNo2XSyXilwcRUTCbGuAXPiJRh2_1G8Wv5yAICbQnkE86A78yIW9SA>
    <xmx:kNo2XVQNVJbXLtkyfGwt_U1GYI_EmoBUE-ux5yJrCo38TGNsHvlB1w>
    <xmx:kdo2XV-XBC9Uf9usBtNKUx0f7JRwbKiEFCZEhWYX0vj4YJiXixu8SA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 832E2380079;
        Tue, 23 Jul 2019 05:59:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ASoC: core: Adapt for debugfs API change" failed to apply to 4.14-stable tree
To:     broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 11:59:35 +0200
Message-ID: <15638759757593@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c2c928c93173f220955030e8440517b87ec7df92 Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Jun 2019 12:33:56 +0100
Subject: [PATCH] ASoC: core: Adapt for debugfs API change

Back in ff9fb72bc07705c (debugfs: return error values, not NULL) the
debugfs APIs were changed to return error pointers rather than NULL
pointers on error, breaking the error checking in ASoC. Update the
code to use IS_ERR() and log the codes that are returned as part of
the error messages.

Fixes: ff9fb72bc07705c (debugfs: return error values, not NULL)
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 9138fcb15cd3..6aeba0d66ec5 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -158,9 +158,10 @@ static void soc_init_component_debugfs(struct snd_soc_component *component)
 				component->card->debugfs_card_root);
 	}
 
-	if (!component->debugfs_root) {
+	if (IS_ERR(component->debugfs_root)) {
 		dev_warn(component->dev,
-			"ASoC: Failed to create component debugfs directory\n");
+			"ASoC: Failed to create component debugfs directory: %ld\n",
+			PTR_ERR(component->debugfs_root));
 		return;
 	}
 
@@ -212,18 +213,21 @@ static void soc_init_card_debugfs(struct snd_soc_card *card)
 
 	card->debugfs_card_root = debugfs_create_dir(card->name,
 						     snd_soc_debugfs_root);
-	if (!card->debugfs_card_root) {
+	if (IS_ERR(card->debugfs_card_root)) {
 		dev_warn(card->dev,
-			 "ASoC: Failed to create card debugfs directory\n");
+			 "ASoC: Failed to create card debugfs directory: %ld\n",
+			 PTR_ERR(card->debugfs_card_root));
+		card->debugfs_card_root = NULL;
 		return;
 	}
 
 	card->debugfs_pop_time = debugfs_create_u32("dapm_pop_time", 0644,
 						    card->debugfs_card_root,
 						    &card->pop_time);
-	if (!card->debugfs_pop_time)
+	if (IS_ERR(card->debugfs_pop_time))
 		dev_warn(card->dev,
-			 "ASoC: Failed to create pop time debugfs file\n");
+			 "ASoC: Failed to create pop time debugfs file: %ld\n",
+			 PTR_ERR(card->debugfs_pop_time));
 }
 
 static void soc_cleanup_card_debugfs(struct snd_soc_card *card)

