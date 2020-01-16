Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6096613FEFE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732818AbgAPXje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389592AbgAPX2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 889AE20684;
        Thu, 16 Jan 2020 23:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217289;
        bh=Vv5RyghxI+e62Ubg8liNy/1QrWWU3ugVXiPsjGGf0Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJveuqFK6izK21HIIp6W8pBQqmNS8zdZ9sXrEJosvS9R6fMBofS5AF13qrXt+agIg
         Dbjk+Qaevw2jD7ivwXqSPkMK9StFzNjMMawP+vy07bTNHwCINq2kjk12wD5qPUrmJH
         Zga2LEOg8J4b3uCDYY4NfCXiKSy1s4k6PQ5jemQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 21/84] ASoC: stm32: spdifrx: fix inconsistent lock state
Date:   Fri, 17 Jan 2020 00:17:55 +0100
Message-Id: <20200116231716.172793007@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 2859b1784031b5709446af8f6039c467f136e67d upstream.

In current spdifrx driver locks may be requested as follows:
- request lock on iec capture control, when starting synchronization.
- request lock in interrupt context, when spdifrx stop is called
from IRQ handler.

Take lock with IRQs disabled, to avoid the possible deadlock.

Lockdep report:
[   74.278059] ================================
[   74.282306] WARNING: inconsistent lock state
[   74.290120] --------------------------------
...
[   74.314373]        CPU0
[   74.314377]        ----
[   74.314381]   lock(&(&spdifrx->lock)->rlock);
[   74.314396]   <Interrupt>
[   74.314400]     lock(&(&spdifrx->lock)->rlock);

Fixes: 03e4d5d56fa5 ("ASoC: stm32: Add SPDIFRX support")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Link: https://lore.kernel.org/r/20191204154333.7152-2-olivier.moysan@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_spdifrx.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -313,6 +313,7 @@ static void stm32_spdifrx_dma_ctrl_stop(
 static int stm32_spdifrx_start_sync(struct stm32_spdifrx_data *spdifrx)
 {
 	int cr, cr_mask, imr, ret;
+	unsigned long flags;
 
 	/* Enable IRQs */
 	imr = SPDIFRX_IMR_IFEIE | SPDIFRX_IMR_SYNCDIE | SPDIFRX_IMR_PERRIE;
@@ -320,7 +321,7 @@ static int stm32_spdifrx_start_sync(stru
 	if (ret)
 		return ret;
 
-	spin_lock(&spdifrx->lock);
+	spin_lock_irqsave(&spdifrx->lock, flags);
 
 	spdifrx->refcount++;
 
@@ -353,7 +354,7 @@ static int stm32_spdifrx_start_sync(stru
 				"Failed to start synchronization\n");
 	}
 
-	spin_unlock(&spdifrx->lock);
+	spin_unlock_irqrestore(&spdifrx->lock, flags);
 
 	return ret;
 }
@@ -361,11 +362,12 @@ static int stm32_spdifrx_start_sync(stru
 static void stm32_spdifrx_stop(struct stm32_spdifrx_data *spdifrx)
 {
 	int cr, cr_mask, reg;
+	unsigned long flags;
 
-	spin_lock(&spdifrx->lock);
+	spin_lock_irqsave(&spdifrx->lock, flags);
 
 	if (--spdifrx->refcount) {
-		spin_unlock(&spdifrx->lock);
+		spin_unlock_irqrestore(&spdifrx->lock, flags);
 		return;
 	}
 
@@ -384,7 +386,7 @@ static void stm32_spdifrx_stop(struct st
 	regmap_read(spdifrx->regmap, STM32_SPDIFRX_DR, &reg);
 	regmap_read(spdifrx->regmap, STM32_SPDIFRX_CSR, &reg);
 
-	spin_unlock(&spdifrx->lock);
+	spin_unlock_irqrestore(&spdifrx->lock, flags);
 }
 
 static int stm32_spdifrx_dma_ctrl_register(struct device *dev,


