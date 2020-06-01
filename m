Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED5B1EAD83
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgFASIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgFASIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:08:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668CC20872;
        Mon,  1 Jun 2020 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034932;
        bh=X4x75h3oHXMkeOrIher/65hlTtP64x+5i4tluufMDaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZYQ8oZQalgh2U6M1t6hF2SZ+Zo5FlY4kH16QBxAE021wxfTwxww5HiGXj4LwYnG9
         nW69+K4gUyqC7mgkQbHl0lj5d30gmm0mBwMn8XASQmd0tfMzR2Afme62SWh8Cu4kLM
         7/NDLhlLeOasAZ4FeyRPjmKbvFBK9FK1pN3lp3AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/142] gpu/drm: Ingenic: Fix opaque pointer casted to wrong type
Date:   Mon,  1 Jun 2020 19:53:56 +0200
Message-Id: <20200601174046.115405710@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit abf56fadf0e208abfb13ad1ac0094416058da0ad ]

The opaque pointer passed to the IRQ handler is a pointer to the
drm_device, not a pointer to our ingenic_drm structure.

It still worked, because our ingenic_drm structure contains the
drm_device as its first field, so the pointer received had the same
value, but this was not semantically correct.

Cc: stable@vger.kernel.org # v5.3
Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20200516215057.392609-5-paul@crapouillou.net
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ingenic/ingenic-drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
index 9e95f6fd5406..376fca6ca9f4 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
@@ -467,7 +467,7 @@ static int ingenic_drm_encoder_atomic_check(struct drm_encoder *encoder,
 
 static irqreturn_t ingenic_drm_irq_handler(int irq, void *arg)
 {
-	struct ingenic_drm *priv = arg;
+	struct ingenic_drm *priv = drm_device_get_priv(arg);
 	unsigned int state;
 
 	regmap_read(priv->map, JZ_REG_LCD_STATE, &state);
-- 
2.25.1



