Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAD836AD4A
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhDZHdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232298AbhDZHd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:33:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 782F161077;
        Mon, 26 Apr 2021 07:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422365;
        bh=4ha8hzvQewrAkYWKaJdNQ2KOkMlMHpc8eBqJkj1wlRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQLlQizy5JneRgp8Q5NUFTYcBrmVMjAgokR8+rUbMTVPl/ccn361/WMNK6vULHyai
         8VszEZidG7JegdEuD+03IDXOSpaIbmjm4BOpdp4Q6GuEYG7I5sskkLbXmqjIk+lSK6
         56WGvsuwxVCcpLjyaylMnUpl1pvbffWPEgam1iCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/37] ASoC: fsl_esai: Fix TDM slot setup for I2S mode
Date:   Mon, 26 Apr 2021 09:29:09 +0200
Message-Id: <20210426072817.532903014@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shiyan <shc_work@mail.ru>

[ Upstream commit e7a48c710defa0e0fef54d42b7d9e4ab596e2761 ]

When using the driver in I2S TDM mode, the fsl_esai_startup()
function rewrites the number of slots previously set by the
fsl_esai_set_dai_tdm_slot() function to 2.
To fix this, let's use the saved slot count value or, if TDM
is not used and the number of slots is not set, the driver will use
the default value (2), which is set by fsl_esai_probe().

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20210402081405.9892-1-shc_work@mail.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_esai.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index fa64cc2b1729..94bf497092b2 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -495,11 +495,13 @@ static int fsl_esai_startup(struct snd_pcm_substream *substream,
 				   ESAI_SAICR_SYNC, esai_priv->synchronous ?
 				   ESAI_SAICR_SYNC : 0);
 
-		/* Set a default slot number -- 2 */
+		/* Set slots count */
 		regmap_update_bits(esai_priv->regmap, REG_ESAI_TCCR,
-				   ESAI_xCCR_xDC_MASK, ESAI_xCCR_xDC(2));
+				   ESAI_xCCR_xDC_MASK,
+				   ESAI_xCCR_xDC(esai_priv->slots));
 		regmap_update_bits(esai_priv->regmap, REG_ESAI_RCCR,
-				   ESAI_xCCR_xDC_MASK, ESAI_xCCR_xDC(2));
+				   ESAI_xCCR_xDC_MASK,
+				   ESAI_xCCR_xDC(esai_priv->slots));
 	}
 
 	return 0;
-- 
2.30.2



