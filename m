Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C4B22EFBA
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbgG0OSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731295AbgG0OSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:18:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A832070A;
        Mon, 27 Jul 2020 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859526;
        bh=3Hmqgwr1tD2S0HFwH63ITNi5sClWaaetAgCJAU9oYEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTxmH8IY08BHkin1ail3yhaQ8pLAv0ugmP7DjBaUmnriW2Se3RKkive78w1ASuFzZ
         Rai4kvyk4eIpqA7uvHdfpXl9cURM8aroI1nXUBiJMy2pB+f582Uu2AVbjh2GDo5GLD
         zNhJvxrEUGEBlK9AoRouOcPBT7qGRKpiIh1c5L1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 133/138] ASoC: qcom: Drop HAS_DMA dependency to fix link failure
Date:   Mon, 27 Jul 2020 16:05:28 +0200
Message-Id: <20200727134932.063931415@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit b6aa06de7757667bac88997a8807b143b8436035 upstream.

When building on allyesconfig kernel for a NO_DMA=y platform (e.g.
Sun-3), CONFIG_SND_SOC_QCOM_COMMON=y, but CONFIG_SND_SOC_QDSP6_AFE=n,
leading to a link failure:

    sound/soc/qcom/common.o: In function `qcom_snd_parse_of':
    common.c:(.text+0x2e2): undefined reference to `q6afe_is_rx_port'

While SND_SOC_QDSP6 depends on HAS_DMA, SND_SOC_MSM8996 and SND_SOC_SDM845
don't, so the following warning is seen:

    WARNING: unmet direct dependencies detected for SND_SOC_QDSP6
      Depends on [n]: SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && QCOM_APR [=y] && HAS_DMA [=n]
      Selected by [y]:
      - SND_SOC_MSM8996 [=y] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && QCOM_APR [=y]
      - SND_SOC_SDM845 [=y] && SOUND [=y] && !UML && SND [=y] && SND_SOC [=y] && QCOM_APR [=y] && CROS_EC [=y] && I2C [=y] && SOUNDWIRE [=y]

Until recently, this warning was harmless (from a compile-testing
point-of-view), but the new user of q6afe_is_rx_port() turned this into
a hard failure.

As the QDSP6 driver itself builds fine if NO_DMA=y, and it depends on
QCOM_APR (which in turns depends on ARCH_QCOM || COMPILE_TEST), it is
safe to increase compile testing coverage.  Hence fix the link failure
by dropping the HAS_DMA dependency of SND_SOC_QDSP6.

Fixes: a2120089251f1fe2 ("ASoC: qcom: common: set correct directions for dailinks")
Fixes: 6b1687bf76ef84cb ("ASoC: qcom: add sdm845 sound card support")
Fixes: a6f933f63f2ffdb2 ("ASoC: qcom: apq8096: Add db820c machine driver")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20200629122443.21736-1-geert@linux-m68k.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/qcom/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/qcom/Kconfig
+++ b/sound/soc/qcom/Kconfig
@@ -72,7 +72,7 @@ config SND_SOC_QDSP6_ASM_DAI
 
 config SND_SOC_QDSP6
 	tristate "SoC ALSA audio driver for QDSP6"
-	depends on QCOM_APR && HAS_DMA
+	depends on QCOM_APR
 	select SND_SOC_QDSP6_COMMON
 	select SND_SOC_QDSP6_CORE
 	select SND_SOC_QDSP6_AFE


