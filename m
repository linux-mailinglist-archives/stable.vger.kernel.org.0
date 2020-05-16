Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EEC1D645B
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 23:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgEPVvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 May 2020 17:51:42 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:46860 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgEPVvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 May 2020 17:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1589665872; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qffdGDv3DgtfzooGKPawMUzSJPFPf7ZHHFvRxoHINpg=;
        b=OHFD6DUXNlYjXNKC6RI3DWsZnTlbGbayGdsGH/IYtQw1ElthnULEcHPG33W5ll/6Apam1d
        Cu+6aOiPk6W5veB0eMplQAwtw45H3KkiSZm4GshlzIQXts9t75nEZxkBFWH3M9i7LLHcXz
        wYY6YEpmnpvdUpaQ4HjaG0biVnQr6Gs=
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     od@zcrc.me, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH 05/12] gpu/drm: Ingenic: Fix opaque pointer casted to wrong type
Date:   Sat, 16 May 2020 23:50:50 +0200
Message-Id: <20200516215057.392609-5-paul@crapouillou.net>
In-Reply-To: <20200516215057.392609-1-paul@crapouillou.net>
References: <20200516215057.392609-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The opaque pointer passed to the IRQ handler is a pointer to the
drm_device, not a pointer to our ingenic_drm structure.

It still worked, because our ingenic_drm structure contains the
drm_device as its first field, so the pointer received had the same
value, but this was not semantically correct.

Cc: stable@vger.kernel.org # v5.3
Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/ingenic/ingenic-drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
index 0c472382a08b..97244462599b 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
@@ -476,7 +476,7 @@ static int ingenic_drm_encoder_atomic_check(struct drm_encoder *encoder,
 
 static irqreturn_t ingenic_drm_irq_handler(int irq, void *arg)
 {
-	struct ingenic_drm *priv = arg;
+	struct ingenic_drm *priv = drm_device_get_priv(arg);
 	unsigned int state;
 
 	regmap_read(priv->map, JZ_REG_LCD_STATE, &state);
-- 
2.26.2

