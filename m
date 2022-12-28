Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89921657D56
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiL1Pmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiL1PmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3578617045
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:42:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C73436154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD8CC433D2;
        Wed, 28 Dec 2022 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242122;
        bh=5V9D/yePDhYw4ca0MNLRKL0nFPjL0FyosZNzrKHH7QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNMjdjKrBEiMT49au5at2hOh33kDBoMmZAFJwBoBc9zcW//rNz0EJ5h1JxqPLTsXz
         FMmC3AKzc5tanQphV8WVUCtapogvBTvjGQ6R9m6jgPoW72yKwqEYWACLirxpVF1WCY
         N68c2X4Ur/xGDWNrfqO6s165fHy6nnndzvdllJFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Golle <daniel@makrotopia.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 565/731] pwm: mediatek: always use bus clock for PWM on MT7622
Date:   Wed, 28 Dec 2022 15:41:12 +0100
Message-Id: <20221228144312.937785806@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit aa3c668f2f98856af96e13f44da6ca4f26f0b98c ]

According to MT7622 Reference Manual for Development Board v1.0 the PWM
unit found in the MT7622 SoC also comes with the PWM_CK_26M_SEL register
at offset 0x210 just like other modern MediaTek ARM64 SoCs.
And also MT7622 sets that register to 0x00000001 on reset which is
described as 'Select 26M fix CLK as BCLK' in the datasheet.
Hence set has_ck_26m_sel to true also for MT7622 which results in the
driver writing 0 to the PWM_CK_26M_SEL register which is described as
'Select bus CLK as BCLK'.

Fixes: 0c0ead76235db0 ("pwm: mediatek: Always use bus clock")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/Y1iF2slvSblf6bYK@makrotopia.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-mediatek.c b/drivers/pwm/pwm-mediatek.c
index 0d4dd80e9f07..f8f9a7489129 100644
--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -275,7 +275,7 @@ static const struct pwm_mediatek_of_data mt2712_pwm_data = {
 static const struct pwm_mediatek_of_data mt7622_pwm_data = {
 	.num_pwms = 6,
 	.pwm45_fixup = false,
-	.has_ck_26m_sel = false,
+	.has_ck_26m_sel = true,
 };
 
 static const struct pwm_mediatek_of_data mt7623_pwm_data = {
-- 
2.35.1



