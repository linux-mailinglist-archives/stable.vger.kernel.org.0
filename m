Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC8F498D85
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345620AbiAXTcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51726 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352660AbiAXTay (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:30:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB43AB8121C;
        Mon, 24 Jan 2022 19:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E19C340E5;
        Mon, 24 Jan 2022 19:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052652;
        bh=hoGmMt6X0klq0+u7iW/1fCYXghyAHMkMKI5zDTPe7y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4wFWjprk37/1bRS6h5UUsFD5/h6dOkI8SZ00dbOt5DilrJpkDOx/tVovUjvxqNuY
         wFEosXJQH83FlrtM+eohreAn1/1QjTbY+LyjFfAAdcmACGPbvxvm76avDCzNjsKFkn
         uVHZrCs3IvHZa5BGF7oCZSiTkt+tdYskR107tzUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/320] ASoC: uniphier: drop selecting non-existing SND_SOC_UNIPHIER_AIO_DMA
Date:   Mon, 24 Jan 2022 19:41:53 +0100
Message-Id: <20220124183958.062009050@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 49f893253ab43566e34332a969324531fea463f6 ]

Commit f37fe2f9987b ("ASoC: uniphier: add support for UniPhier AIO common
driver") adds configs SND_SOC_UNIPHIER_{LD11,PXS2}, which select the
non-existing config SND_SOC_UNIPHIER_AIO_DMA.

Hence, ./scripts/checkkconfigsymbols.py warns:

  SND_SOC_UNIPHIER_AIO_DMA
  Referencing files: sound/soc/uniphier/Kconfig

Probably, there is actually no further config intended to be selected
here. So, just drop selecting the non-existing config.

Fixes: f37fe2f9987b ("ASoC: uniphier: add support for UniPhier AIO common driver")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20211125095158.8394-2-lukas.bulwahn@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/uniphier/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/uniphier/Kconfig b/sound/soc/uniphier/Kconfig
index aa3592ee1358b..ddfa6424c656b 100644
--- a/sound/soc/uniphier/Kconfig
+++ b/sound/soc/uniphier/Kconfig
@@ -23,7 +23,6 @@ config SND_SOC_UNIPHIER_LD11
 	tristate "UniPhier LD11/LD20 Device Driver"
 	depends on SND_SOC_UNIPHIER
 	select SND_SOC_UNIPHIER_AIO
-	select SND_SOC_UNIPHIER_AIO_DMA
 	help
 	  This adds ASoC driver for Socionext UniPhier LD11/LD20
 	  input and output that can be used with other codecs.
@@ -34,7 +33,6 @@ config SND_SOC_UNIPHIER_PXS2
 	tristate "UniPhier PXs2 Device Driver"
 	depends on SND_SOC_UNIPHIER
 	select SND_SOC_UNIPHIER_AIO
-	select SND_SOC_UNIPHIER_AIO_DMA
 	help
 	  This adds ASoC driver for Socionext UniPhier PXs2
 	  input and output that can be used with other codecs.
-- 
2.34.1



