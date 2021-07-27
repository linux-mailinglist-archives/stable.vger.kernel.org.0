Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639043D7667
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbhG0N17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236973AbhG0NUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D34C161A8C;
        Tue, 27 Jul 2021 13:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392018;
        bh=clXpkkKYs0rFca8LLDbeSbQ7rs6gT7Z2YGaHBpBxeRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrbL2d0R6xsLqrXAGA/llhFB5fsUfNf2GXWuhkhYCiUHgjSy8fFKmj1QNgYcKTKic
         cjV8FLmrP5qBDy24TuT6CjAFyDJI5xsY7ee7v+jcuRA//Zu817v+8DsYLVGMVvoJbS
         0nrM0gD1ga5R/lSZUYz6SLB76oofAPLl3GBeYoVpobEXrJ/oDzHq93XSdEU2nfTp9x
         dNOy72F5L3lRX+f8szEoBSm0EyFYMJqYKBTTfmD+Jq5Pu4HdvXPsYq/NtWMa3xvNp8
         +2vd6DjfytqlvZi5u0Zq//azxKa5lKjGuKCpXYBfSaC7JvVIYP8AjZmcHxJkFgl+fo
         bHgKxhYviCZng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Russell <bkylerussell@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 2/6] ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits
Date:   Tue, 27 Jul 2021 09:20:11 -0400
Message-Id: <20210727132015.835651-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132015.835651-1-sashal@kernel.org>
References: <20210727132015.835651-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Russell <bkylerussell@gmail.com>

[ Upstream commit 9cf76a72af6ab81030dea6481b1d7bdd814fbdaf ]

These are backwards from Table 7-71 of the TLV320AIC3100 spec [1].

This was broken in 12eb4d66ba2e when BCLK_MASTER and WCLK_MASTER
were converted from 0x08 and 0x04 to BIT(2) and BIT(3), respectively.

-#define AIC31XX_BCLK_MASTER		0x08
-#define AIC31XX_WCLK_MASTER		0x04
+#define AIC31XX_BCLK_MASTER		BIT(2)
+#define AIC31XX_WCLK_MASTER		BIT(3)

Probably just a typo since the defines were not listed in bit order.

[1] https://www.ti.com/lit/gpn/tlv320aic3100

Signed-off-by: Kyle Russell <bkylerussell@gmail.com>
Link: https://lore.kernel.org/r/20210622010941.241386-1-bkylerussell@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic31xx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic31xx.h b/sound/soc/codecs/tlv320aic31xx.h
index 0b587585b38b..6071de5fca57 100644
--- a/sound/soc/codecs/tlv320aic31xx.h
+++ b/sound/soc/codecs/tlv320aic31xx.h
@@ -147,8 +147,8 @@ struct aic31xx_pdata {
 #define AIC31XX_WORD_LEN_24BITS		0x02
 #define AIC31XX_WORD_LEN_32BITS		0x03
 #define AIC31XX_IFACE1_MASTER_MASK	GENMASK(3, 2)
-#define AIC31XX_BCLK_MASTER		BIT(2)
-#define AIC31XX_WCLK_MASTER		BIT(3)
+#define AIC31XX_BCLK_MASTER		BIT(3)
+#define AIC31XX_WCLK_MASTER		BIT(2)
 
 /* AIC31XX_DATA_OFFSET */
 #define AIC31XX_DATA_OFFSET_MASK	GENMASK(7, 0)
-- 
2.30.2

