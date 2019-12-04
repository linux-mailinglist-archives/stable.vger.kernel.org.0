Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2FD11328F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbfLDSJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:09:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730544AbfLDSJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:09:26 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054CD20833;
        Wed,  4 Dec 2019 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482965;
        bh=45pYFyKcVPl9aq3G/+/M2pqNf9Ix+NuT7eye5i+f9yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZQls3f2KRrwg5xirkBQe4+g00YgmSfmoovTGmQLwQjDeSaoIKZF1S9eKePm3KrFY
         98Vj0MRdZHKqOVRwIhHKL/3MG9z8mVtqh72t/ER4XxRxGvMNSYw26IKLcWmVM/kX+2
         hsECOcyAaJm70dRtFcRwuThpjPhlPI7hDiIZ0mJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 206/209] ASoC: stm32: i2s: fix IRQ clearing
Date:   Wed,  4 Dec 2019 18:56:58 +0100
Message-Id: <20191204175337.669141996@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 8ba3c5215d69c09f5c39783ff3b78347769822ad upstream.

Because of regmap cache, interrupts may not be cleared
as expected.
Declare IFCR register as write only and make writings
to IFCR register unconditional.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_i2s.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -246,8 +246,8 @@ static irqreturn_t stm32_i2s_isr(int irq
 		return IRQ_NONE;
 	}
 
-	regmap_update_bits(i2s->regmap, STM32_I2S_IFCR_REG,
-			   I2S_IFCR_MASK, flags);
+	regmap_write_bits(i2s->regmap, STM32_I2S_IFCR_REG,
+			  I2S_IFCR_MASK, flags);
 
 	if (flags & I2S_SR_OVR) {
 		dev_dbg(&pdev->dev, "Overrun\n");
@@ -276,7 +276,6 @@ static bool stm32_i2s_readable_reg(struc
 	case STM32_I2S_CFG2_REG:
 	case STM32_I2S_IER_REG:
 	case STM32_I2S_SR_REG:
-	case STM32_I2S_IFCR_REG:
 	case STM32_I2S_TXDR_REG:
 	case STM32_I2S_RXDR_REG:
 	case STM32_I2S_CGFR_REG:
@@ -547,8 +546,8 @@ static int stm32_i2s_startup(struct snd_
 	i2s->refcount++;
 	spin_unlock(&i2s->lock_fd);
 
-	return regmap_update_bits(i2s->regmap, STM32_I2S_IFCR_REG,
-				  I2S_IFCR_MASK, I2S_IFCR_MASK);
+	return regmap_write_bits(i2s->regmap, STM32_I2S_IFCR_REG,
+				 I2S_IFCR_MASK, I2S_IFCR_MASK);
 }
 
 static int stm32_i2s_hw_params(struct snd_pcm_substream *substream,
@@ -603,8 +602,8 @@ static int stm32_i2s_trigger(struct snd_
 			return ret;
 		}
 
-		regmap_update_bits(i2s->regmap, STM32_I2S_IFCR_REG,
-				   I2S_IFCR_MASK, I2S_IFCR_MASK);
+		regmap_write_bits(i2s->regmap, STM32_I2S_IFCR_REG,
+				  I2S_IFCR_MASK, I2S_IFCR_MASK);
 
 		if (playback_flg) {
 			ier = I2S_IER_UDRIE;


