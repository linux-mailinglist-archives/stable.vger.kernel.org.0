Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9CC4F2748
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiDEIEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbiDEH76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6750DAE76;
        Tue,  5 Apr 2022 00:56:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 048706167D;
        Tue,  5 Apr 2022 07:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1191CC340EE;
        Tue,  5 Apr 2022 07:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145402;
        bh=ZAPcMDiTjmKI6SgKNlTMxy9T9vOo7cofZpuRfDPZIkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJL79sPqjrA/aGo9hXzqqZwD6yLRVNf2JpX+CsOv7AUo/CTAAQ6AD6p4rdixfV6KU
         zZx6fBQZzGnAtI9VZZfg9WLbNt5JPp6IJrwRBlHARga6gdOyJG63hH6L+S7jcL5TLT
         dgU52oJb90f6JIAvU++egQhLJPf1rXZlRiGy0O2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Rhodes <drhodes@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0393/1126] ASoC: cs35l41: Fix GPIO2 configuration
Date:   Tue,  5 Apr 2022 09:19:00 +0200
Message-Id: <20220405070419.163411570@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: David Rhodes <drhodes@opensource.cirrus.com>

[ Upstream commit 03a7895ee701e873c88c06bdb830ff40adb2be73 ]

Fix GPIO2 polarity and direction configuration

Fixes: fe1024d50477b ("ASoC: cs35l41: Combine adjacent register writes")
Signed-off-by: David Rhodes <drhodes@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220303173059.269657-2-tanureal@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs35l41.c b/sound/soc/codecs/cs35l41.c
index 77a017694645..90c91b00288b 100644
--- a/sound/soc/codecs/cs35l41.c
+++ b/sound/soc/codecs/cs35l41.c
@@ -1035,8 +1035,8 @@ static int cs35l41_irq_gpio_config(struct cs35l41_private *cs35l41)
 
 	regmap_update_bits(cs35l41->regmap, CS35L41_GPIO2_CTRL1,
 			   CS35L41_GPIO_POL_MASK | CS35L41_GPIO_DIR_MASK,
-			   irq_gpio_cfg1->irq_pol_inv << CS35L41_GPIO_POL_SHIFT |
-			   !irq_gpio_cfg1->irq_out_en << CS35L41_GPIO_DIR_SHIFT);
+			   irq_gpio_cfg2->irq_pol_inv << CS35L41_GPIO_POL_SHIFT |
+			   !irq_gpio_cfg2->irq_out_en << CS35L41_GPIO_DIR_SHIFT);
 
 	regmap_update_bits(cs35l41->regmap, CS35L41_GPIO_PAD_CONTROL,
 			   CS35L41_GPIO1_CTRL_MASK | CS35L41_GPIO2_CTRL_MASK,
-- 
2.34.1



