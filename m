Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C1F1F2BE7
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgFHXSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730623AbgFHXSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E2532086A;
        Mon,  8 Jun 2020 23:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658302;
        bh=LpxpxJ35oFWhuM87IgD9IRxSyxS+069w7P+E9CDeK6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAuYSR+uO5U0EiLS42w6u1n6RktmRfZa6o/JzhlkuQ9FjJ7+cDT9RXeoOTy8UxIyg
         fhw2J5G+jpbmyz1hsCEZmszVnUnAqCwPZcH2Zu9a2bciJ0uertQNVXPNHx3crmZbt0
         fkf5kGjFme78dUPLUsmnpsxjefUvLnN2MvtSyrp4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 305/606] gpu/drm: Ingenic: Fix opaque pointer casted to wrong type
Date:   Mon,  8 Jun 2020 19:07:10 -0400
Message-Id: <20200608231211.3363633-305-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8f5077370a52..e9900e078d51 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
@@ -474,7 +474,7 @@ static int ingenic_drm_encoder_atomic_check(struct drm_encoder *encoder,
 
 static irqreturn_t ingenic_drm_irq_handler(int irq, void *arg)
 {
-	struct ingenic_drm *priv = arg;
+	struct ingenic_drm *priv = drm_device_get_priv(arg);
 	unsigned int state;
 
 	regmap_read(priv->map, JZ_REG_LCD_STATE, &state);
-- 
2.25.1

