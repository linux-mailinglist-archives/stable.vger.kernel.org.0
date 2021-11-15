Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185C3451389
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348379AbhKOTwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:52:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343635AbhKOTVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49C71635B9;
        Mon, 15 Nov 2021 18:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001804;
        bh=VD7Y+YYASiY5CD26HKei4DYez59qwv2bnxAwAi4+bTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0hPEFYiObgV6MKCfrDjYcJenM7YXJFj5io5phf5ypjDL5zgXI2U4b+lmgYIO9oS7
         F+SrWj1pkVgO10Cs6QGoUhiwVSzNtVhz1LQHpOAOMk/zfJ1Edw02tjA/YJz332sQ7g
         wtSQzYqmHgMt3dRg5T9X0dWowT5xg5srrBGL6UFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/917] drm/bridge: it66121: Initialize {device,vendor}_ids
Date:   Mon, 15 Nov 2021 17:57:02 +0100
Message-Id: <20211115165439.842198753@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 3a5f3d61de657bc1c2b53b77d065c5526f982e10 ]

These two arrays are populated with data read from the I2C device
through regmap_read(), and the data is then compared with hardcoded
vendor/product ID values of supported chips.

However, the return value of regmap_read() was never checked. This is
fine, as long as the two arrays are zero-initialized, so that we don't
compare the vendor/product IDs against whatever garbage is left on the
stack.

Address this issue by zero-initializing these two arrays.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Fixes: 988156dc2fc9 ("drm: bridge: add it66121 driver")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210827163956.27517-1-paul@crapouillou.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index 2f2a09adb4bc8..b130d01147c6c 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -889,7 +889,7 @@ unlock:
 static int it66121_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
-	u32 vendor_ids[2], device_ids[2], revision_id;
+	u32 revision_id, vendor_ids[2] = { 0 }, device_ids[2] = { 0 };
 	struct device_node *ep;
 	int ret;
 	struct it66121_ctx *ctx;
-- 
2.33.0



