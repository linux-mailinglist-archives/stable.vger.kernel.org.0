Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C224E72C
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 13:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfFULeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 07:34:02 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:48414 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfFULeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 07:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3FBFeMMQbHDljCo0ysZt4E1/LLDovdIwQ1oyGOMfxow=; b=jr2yPJFjv8wsFKWBZQ1VqKv4b
        r6VdXmrj7q6VoPktD+/CgPd2w9HVxnPFyH+OF06FZhZd5chqZWLEMbj0z5JTVRYz2/my8YoYBuP2r
        tX6/gLSEEuiECdfOxv+JGyJJwUA7bMmSzRKEZ8W36anj5eZJH8dRl3EfO9QX2mbXY95xU=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1heHnq-0002PW-H8; Fri, 21 Jun 2019 11:33:58 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 4305A440046; Fri, 21 Jun 2019 12:33:57 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ASoC: core: Adapt for debugfs API change
Date:   Fri, 21 Jun 2019 12:33:56 +0100
Message-Id: <20190621113357.8264-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Back in ff9fb72bc07705c (debugfs: return error values, not NULL) the
debugfs APIs were changed to return error pointers rather than NULL
pointers on error, breaking the error checking in ASoC. Update the
code to use IS_ERR() and log the codes that are returned as part of
the error messages.

Fixes: ff9fb72bc07705c (debugfs: return error values, not NULL)
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/soc-core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index c510da2d4af6..6d5c09493f4b 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -165,9 +165,10 @@ static void soc_init_component_debugfs(struct snd_soc_component *component)
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
 
@@ -219,18 +220,21 @@ static void soc_init_card_debugfs(struct snd_soc_card *card)
 
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
-- 
2.20.1

