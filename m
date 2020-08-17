Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D677246F71
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388751AbgHQRrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388554AbgHQQNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8CC22B43;
        Mon, 17 Aug 2020 16:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680803;
        bh=kuynjF7Ogyf5SCgAhHKGjEUVqGvyDfBFxRNKHrCkplc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqmTqVSeb+O3M6T8L54nNWQde46Pm6wdM2wQDA+ezeb1i759crgzuefLEDb/smLC0
         e12P8Nwiu0iN0PFF29afVjcUdBiWd5OxS7SoalV04b7O6MeMzq0wSP0S65Y2kRtKez
         QOqL+fDWHzW1dU8LLn+GnzcHmVKdh04h88TnQXmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/168] drm/arm: fix unintentional integer overflow on left shift
Date:   Mon, 17 Aug 2020 17:16:33 +0200
Message-Id: <20200817143736.842080392@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 5f368ddea6fec519bdb93b5368f6a844b6ea27a6 ]

Shifting the integer value 1 is evaluated using 32-bit arithmetic
and then used in an expression that expects a long value leads to
a potential integer overflow. Fix this by using the BIT macro to
perform the shift to avoid the overflow.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: ad49f8602fe8 ("drm/arm: Add support for Mali Display Processors")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200618100400.11464-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_planes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index 29409a65d8647..a347b27405d88 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -446,7 +446,7 @@ int malidp_de_planes_init(struct drm_device *drm)
 	const struct malidp_hw_regmap *map = &malidp->dev->hw->map;
 	struct malidp_plane *plane = NULL;
 	enum drm_plane_type plane_type;
-	unsigned long crtcs = 1 << drm->mode_config.num_crtc;
+	unsigned long crtcs = BIT(drm->mode_config.num_crtc);
 	unsigned long flags = DRM_MODE_ROTATE_0 | DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_180 |
 			      DRM_MODE_ROTATE_270 | DRM_MODE_REFLECT_X | DRM_MODE_REFLECT_Y;
 	u32 *formats;
-- 
2.25.1



