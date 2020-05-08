Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75381CAFBB
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgEHNTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbgEHMlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD9FE2495F;
        Fri,  8 May 2020 12:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941700;
        bh=kZSpbwMjiUsLOnPRALjdPtfQYqyoa/8Jo8EJQKpLap0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIL7MULCl5RUEMymy42okYpVXuCkLb2IcPy64LaIBIQvR87rhFZHID0DuyNiMw0lg
         aQP3R3j33Zdwl++lrFbyW92IOs3bKXaZP0wrAtF6EzhspAQ+QLmCtZCFLdIJMl0gu/
         RUsUHELnvuUVQ8rJvHkeRfbBt3EOwGdDndMPr+fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 136/312] ASoC: fsl_ssi: mark SACNT register volatile
Date:   Fri,  8 May 2020 14:32:07 +0200
Message-Id: <20200508123134.063717277@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

commit 3f1c241f0f5f90046258e6b8d4aeb6463ffdc08e upstream.

SACNT register should be marked volatile since
its WR and RD bits are cleared by SSI after
completing the relevant operation.
This unbreaks AC'97 register access.

Fixes: 05cf237972fe ("ASoC: fsl_ssi: Add driver suspend and resume to support MEGA Fast")

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Reviewed-by: Fabio Estevam <fabio.estevam@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/fsl_ssi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -146,6 +146,7 @@ static bool fsl_ssi_volatile_reg(struct
 	case CCSR_SSI_SRX1:
 	case CCSR_SSI_SISR:
 	case CCSR_SSI_SFCSR:
+	case CCSR_SSI_SACNT:
 	case CCSR_SSI_SACADD:
 	case CCSR_SSI_SACDAT:
 	case CCSR_SSI_SATAG:
@@ -239,8 +240,9 @@ struct fsl_ssi_private {
 	unsigned int baudclk_streams;
 	unsigned int bitclk_freq;
 
-	/*regcache for SFCSR*/
+	/* regcache for volatile regs */
 	u32 regcache_sfcsr;
+	u32 regcache_sacnt;
 
 	/* DMA params */
 	struct snd_dmaengine_dai_dma_data dma_params_tx;
@@ -1597,6 +1599,8 @@ static int fsl_ssi_suspend(struct device
 
 	regmap_read(regs, CCSR_SSI_SFCSR,
 			&ssi_private->regcache_sfcsr);
+	regmap_read(regs, CCSR_SSI_SACNT,
+			&ssi_private->regcache_sacnt);
 
 	regcache_cache_only(regs, true);
 	regcache_mark_dirty(regs);
@@ -1615,6 +1619,8 @@ static int fsl_ssi_resume(struct device
 			CCSR_SSI_SFCSR_RFWM1_MASK | CCSR_SSI_SFCSR_TFWM1_MASK |
 			CCSR_SSI_SFCSR_RFWM0_MASK | CCSR_SSI_SFCSR_TFWM0_MASK,
 			ssi_private->regcache_sfcsr);
+	regmap_write(regs, CCSR_SSI_SACNT,
+			ssi_private->regcache_sacnt);
 
 	return regcache_sync(regs);
 }


