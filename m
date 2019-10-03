Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8597ECAB6A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389650AbfJCRVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389344AbfJCQRx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:17:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C6882133F;
        Thu,  3 Oct 2019 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119472;
        bh=Q/ywRCQArBh0m7zwjTfd1BsBMu4lEOlN3cPetuN71E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxE2H4r9b1U+MoiXx7wcUpKvIi4WolTVPQmzG4DcEYf+ml/VB1FLgsSg+wHk3Xffl
         IALZzr8rgExd9cVqH4CBIpN8X3UJ5HF/HCWUwrXLOH1B4Tkuk51mXg5pT1JmVxW3R+
         mH6B4gtgLEAQxOrVILh3sy+ftIxhSa6PPuRoOyyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/211] ASoC: sgtl5000: Fix charge pump source assignment
Date:   Thu,  3 Oct 2019 17:51:34 +0200
Message-Id: <20191003154453.706714725@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

[ Upstream commit b6319b061ba279577fd7030a9848fbd6a17151e3 ]

If VDDA != VDDIO and any of them is greater than 3.1V, charge pump
source can be assigned automatically [1].

[1] https://www.nxp.com/docs/en/data-sheet/SGTL5000.pdf

Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Igor Opaniuk <igor.opaniuk@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20190719100524.23300-7-oleksandr.suvorov@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sgtl5000.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index f9817029bffbb..18cddf1729a65 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1165,12 +1165,17 @@ static int sgtl5000_set_power_regs(struct snd_soc_component *component)
 					SGTL5000_INT_OSC_EN);
 		/* Enable VDDC charge pump */
 		ana_pwr |= SGTL5000_VDDC_CHRGPMP_POWERUP;
-	} else if (vddio >= 3100 && vdda >= 3100) {
+	} else {
 		ana_pwr &= ~SGTL5000_VDDC_CHRGPMP_POWERUP;
-		/* VDDC use VDDIO rail */
-		lreg_ctrl |= SGTL5000_VDDC_ASSN_OVRD;
-		lreg_ctrl |= SGTL5000_VDDC_MAN_ASSN_VDDIO <<
-			    SGTL5000_VDDC_MAN_ASSN_SHIFT;
+		/*
+		 * if vddio == vdda the source of charge pump should be
+		 * assigned manually to VDDIO
+		 */
+		if (vddio == vdda) {
+			lreg_ctrl |= SGTL5000_VDDC_ASSN_OVRD;
+			lreg_ctrl |= SGTL5000_VDDC_MAN_ASSN_VDDIO <<
+				    SGTL5000_VDDC_MAN_ASSN_SHIFT;
+		}
 	}
 
 	snd_soc_component_write(component, SGTL5000_CHIP_LINREG_CTRL, lreg_ctrl);
-- 
2.20.1



