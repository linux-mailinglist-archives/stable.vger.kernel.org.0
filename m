Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EEB4BE48D
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351201AbiBUJnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:43:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351186AbiBUJmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:42:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F1B3E0EF;
        Mon, 21 Feb 2022 01:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93D93CE0E90;
        Mon, 21 Feb 2022 09:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FD9C340EB;
        Mon, 21 Feb 2022 09:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435064;
        bh=bFy7XXY2ACITulTCUKRC7dk/O8gBIpyeMZ3F7CKr/7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2sbK57hD1MNKO96n15UxRyR1WhJHbHaNxUOXFqeT4Os2ni6F7GaDDvl+pRPX+rCW
         CTeoVZ2MB88d0UpTf++XX4j0aHWTT/4GM3wCTOYdKorlQu5ABox0AOrgIvIHoGCpOc
         z4Se9oKHcUFqVMKda3PiQs0Xe/MTBqmk8EJcTzS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Braha <julianbraha@gmail.com>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 031/227] ASoC: mediatek: fix unmet dependency on GPIOLIB for SND_SOC_DMIC
Date:   Mon, 21 Feb 2022 09:47:30 +0100
Message-Id: <20220221084935.883998737@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 579b2c8f72d974f27d85bbd53846f34675ee3b01 ]

When SND_SOC_MT8195_MT6359_RT1011_RT5682 is selected,
and GPIOLIB is not selected,
Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for SND_SOC_DMIC
  Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && GPIOLIB [=n]
  Selected by [y]:
  - SND_SOC_MT8195_MT6359_RT1011_RT5682 [=y] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && I2C [=y] && SND_SOC_MT8195 [=y] && MTK_PMIC_WRAP [=y]

This is because SND_SOC_MT8195_MT6359_RT1011_RT5682
selects SND_SOC_DMIC without selecting or depending on
GPIOLIB, depsite SND_SOC_DMIC depending on GPIOLIB.

This unmet dependency bug was detected by Kismet,
a static analysis tool for Kconfig. Please advise
if this is not the appropriate solution.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20220117050324.68371-1-julianbraha@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/Kconfig b/sound/soc/mediatek/Kconfig
index 3b1ddea26a9ef..76f191ec7bf84 100644
--- a/sound/soc/mediatek/Kconfig
+++ b/sound/soc/mediatek/Kconfig
@@ -215,7 +215,7 @@ config SND_SOC_MT8195_MT6359_RT1019_RT5682
 
 config SND_SOC_MT8195_MT6359_RT1011_RT5682
 	tristate "ASoC Audio driver for MT8195 with MT6359 RT1011 RT5682 codec"
-	depends on I2C
+	depends on I2C && GPIOLIB
 	depends on SND_SOC_MT8195 && MTK_PMIC_WRAP
 	select SND_SOC_MT6359
 	select SND_SOC_RT1011
-- 
2.34.1



