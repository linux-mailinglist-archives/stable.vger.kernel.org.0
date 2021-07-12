Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F3E3C535E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352340AbhGLHyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350273AbhGLHus (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2250A619B0;
        Mon, 12 Jul 2021 07:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075852;
        bh=8Pyhlzta0R1oh33oTbZE03B1+QL5sIRA3vAjLadz5OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgDg4x25ULsmKQfQ76DAqDt3ZGQHIA/OEAAgCD8TGB9AgrpBwYclZQzrh8uliwFxl
         JhrYPwboN0gofUnyYMTwi36hPkUETqXMCfV4ISCTZQojMmUSYpFIbkduxN7l+PoLJW
         cTp6bRWbtlK01YARb+yRiSzwQiDmVdAN352yU2n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 393/800] drm/bridge: anx7625: Fix power on delay
Date:   Mon, 12 Jul 2021 08:06:56 +0200
Message-Id: <20210712061008.998929106@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 1fcf24fb07e254ca69001ab14adc8cf567127c44 ]

>From anx7625 spec, the delay between powering on power supplies and gpio
should be larger than 10ms.

Fixes: 6c744983004e ("drm/bridge: anx7625: disable regulators when power off")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210428115116.931328-1-hsinyi@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 23283ba0c4f9..b4e349ca38fe 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -893,7 +893,7 @@ static void anx7625_power_on(struct anx7625_data *ctx)
 		usleep_range(2000, 2100);
 	}
 
-	usleep_range(4000, 4100);
+	usleep_range(11000, 12000);
 
 	/* Power on pin enable */
 	gpiod_set_value(ctx->pdata.gpio_p_on, 1);
-- 
2.30.2



