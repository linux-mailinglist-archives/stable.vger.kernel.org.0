Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF1871593
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGWJ7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:59:38 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56323 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbfGWJ7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:59:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B5A3F5B7;
        Tue, 23 Jul 2019 05:59:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 05:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A32vPr
        bFXQEvfHBUBxJ4uWni+nooXHF3jucCl+GDR0A=; b=ADWwRsiz4VJBB4Vmt7C8rX
        6g6P1cefNPg740piGho1DKwHLF9REQOe7OW5JAcLvSSALF/UksYtrSCpIl3Lx/L7
        Yoa+Hukuol/G8UGclJ/5w6KqA+wWLuGRiyaWgqRQ+W9RUuIPIVfvjKg4+KXoalpM
        Z0OSYVb+THY/WweF8BdnjSDNBsGTyKo7h5gNs4IrujgJMpqYI47e/wHF4F+d+xJK
        aaFd76102HRheHqi211fSv3C4zwO0JhmtaHRJQzlcU4mzhMKCVkw9OFzNAQtIig9
        quU3TS/CRrXB/a7l4InnNLzqAdL6yNe8wy4EW9cS95oL9LOxA0itdc7o4JR47itQ
        ==
X-ME-Sender: <xms:iNo2XQl_R83bSTK7RFqOrJnbFH3zaHDX8r28goTbBF9_FXX4bwKW6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:iNo2XaKpuX1uS011X_eM7-_Eb8ow5FpapkfrCIzhainx0wm-_XzUcg>
    <xmx:iNo2XY6wLPEg3GIma6Hlke6-JuxBj3H9u4q9MCR4KbH3by7ws8jw5A>
    <xmx:iNo2XS21QKNJB-IzKkGEEa9d_PT1uAG_WucS5gI8HE3HlpF5rWmn1g>
    <xmx:iNo2XVLv1jHNuZN6xIYTVj20rf9U2MsOuXF8gAtu3INYLKnPdxbjfg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCD31380083;
        Tue, 23 Jul 2019 05:59:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ASoC: core: Adapt for debugfs API change" failed to apply to 4.19-stable tree
To:     broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 11:59:34 +0200
Message-ID: <1563875974119164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

