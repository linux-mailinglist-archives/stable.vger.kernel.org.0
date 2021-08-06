Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1DA3E2557
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243773AbhHFITn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244040AbhHFISZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AF116120D;
        Fri,  6 Aug 2021 08:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237889;
        bh=bUScK7HYt7P6cLu4rd9N47IJvD80SgTtLcUsmsVepaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pM8qLmMjiUTj+POqhy5M6Ccj6eI6XWyevzzEMKtijRqSsZ03Wg8HgdDsvJbIpCtsY
         QUHbMMUYDZMSFQdo5NR3VMkANvHnfL3azy7M4Gym5FnLgbadL3thRtZaA47rg6T/w2
         P+wr/1zLoHnTGP2X9Bp+7XRRzzF6cujioi5bAl78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Russell <bkylerussell@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/23] ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits
Date:   Fri,  6 Aug 2021 10:16:39 +0200
Message-Id: <20210806081112.366176848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cb024955c978..73c5f6c8ed69 100644
--- a/sound/soc/codecs/tlv320aic31xx.h
+++ b/sound/soc/codecs/tlv320aic31xx.h
@@ -151,8 +151,8 @@ struct aic31xx_pdata {
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



