Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449691FDB81
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgFRBMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgFRBMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6834F21D7E;
        Thu, 18 Jun 2020 01:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442740;
        bh=zrR7EWqR9FOZ7/8Tm7ym4wywgV/bCyV61N5vb0zUF8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdI2tio0REoMspEDeuHToM4Z9G8qWoXEXZGhf8Gw/0ueSXC4MiP1lkg/Nog0kv1C4
         YRtuGMv/+QRGPgutmedSeQxJq/nvmxAQ8fOzcROuCxG1p4MP2xGPthd4UHDx8ZsxVC
         4SfBnXrJ24LUPF4nMnzwf7zyilDLSQGpWz0ZKag4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 194/388] ASoC: ux500: mop500: Fix some refcounted resources issues
Date:   Wed, 17 Jun 2020 21:04:51 -0400
Message-Id: <20200618010805.600873-194-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4e8748fcaeec073e3ba794871ce86c545e4f961f ]

There are 2 issues here:
   - if one of the 'of_parse_phandle' fails, calling 'mop500_of_node_put()'
     is a no-op because the 'mop500_dai_links' structure has not been
     initialized yet, so the referenced are not decremented
   - The reference stored in 'mop500_dai_links[i].codecs' is refcounted
     only once in the probe and must be decremented only once.

Fixes: 39013bd60e79 ("ASoC: Ux500: Dispose of device nodes correctly")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20200512100705.246349-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/mop500.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 2873e8e6f02b..cdae1190b930 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -63,10 +63,11 @@ static void mop500_of_node_put(void)
 {
 	int i;
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < 2; i++)
 		of_node_put(mop500_dai_links[i].cpus->of_node);
-		of_node_put(mop500_dai_links[i].codecs->of_node);
-	}
+
+	/* Both links use the same codec, which is refcounted only once */
+	of_node_put(mop500_dai_links[0].codecs->of_node);
 }
 
 static int mop500_of_probe(struct platform_device *pdev,
@@ -81,7 +82,9 @@ static int mop500_of_probe(struct platform_device *pdev,
 
 	if (!(msp_np[0] && msp_np[1] && codec_np)) {
 		dev_err(&pdev->dev, "Phandle missing or invalid\n");
-		mop500_of_node_put();
+		for (i = 0; i < 2; i++)
+			of_node_put(msp_np[i]);
+		of_node_put(codec_np);
 		return -EINVAL;
 	}
 
-- 
2.25.1

