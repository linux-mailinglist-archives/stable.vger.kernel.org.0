Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B79594409
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351612AbiHOWwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351867AbiHOWtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:49:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2EA136779;
        Mon, 15 Aug 2022 12:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E00F5B8114A;
        Mon, 15 Aug 2022 19:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A4DC433D6;
        Mon, 15 Aug 2022 19:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593224;
        bh=PsZshobPurGVYu4Uh9WAkoFpIzsC+Nh4RYI6CN0A+XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4eAIkb48VaHhkKA3e981eykRqCWlMqDWRAfifIxln7X0/i9y9npB8zYggIILDh6f
         avup/LZlMd07/lmgOY5DmPt4syxvohdMzEH9KiZ5VLGsyan+FRTcnmy8ITjJ7c8igv
         oUcgwes7GuETjtq4+A7GmOfOmnovVxy4f6pAVPWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0914/1095] ASoC: mchp-spdifrx: disable end of block interrupt on failures
Date:   Mon, 15 Aug 2022 20:05:13 +0200
Message-Id: <20220815180507.099580115@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 768ac4f12ca0fda935f58eb8c5120e9d795bc6e3 ]

Disable end of block interrupt in case of wait for completion timeout
or errors to undo previously enable operation (done in
mchp_spdifrx_isr_blockend_en()). Otherwise we can end up with an
unbalanced reference counter for this interrupt.

Fixes: ef265c55c1ac ("ASoC: mchp-spdifrx: add driver for SPDIF RX")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220727090814.2446111-2-claudiu.beznea@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index 5fc968483f2c..a7baa0385ec5 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -288,15 +288,17 @@ static void mchp_spdifrx_isr_blockend_en(struct mchp_spdifrx_dev *dev)
 	spin_unlock_irqrestore(&dev->blockend_lock, flags);
 }
 
-/* called from atomic context only */
+/* called from atomic/non-atomic context */
 static void mchp_spdifrx_isr_blockend_dis(struct mchp_spdifrx_dev *dev)
 {
-	spin_lock(&dev->blockend_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->blockend_lock, flags);
 	dev->blockend_refcount--;
 	/* don't enable BLOCKEND interrupt if it's already enabled */
 	if (dev->blockend_refcount == 0)
 		regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_BLOCKEND);
-	spin_unlock(&dev->blockend_lock);
+	spin_unlock_irqrestore(&dev->blockend_lock, flags);
 }
 
 static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
@@ -575,6 +577,7 @@ static int mchp_spdifrx_subcode_ch_get(struct mchp_spdifrx_dev *dev,
 	if (ret <= 0) {
 		dev_dbg(dev->dev, "user data for channel %d timeout\n",
 			channel);
+		mchp_spdifrx_isr_blockend_dis(dev);
 		return ret;
 	}
 
-- 
2.35.1



