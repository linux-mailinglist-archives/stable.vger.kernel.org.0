Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CE34539C8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbhKPTHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239755AbhKPTHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE2476321B;
        Tue, 16 Nov 2021 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637089489;
        bh=EjfK6ywtkTbYiXTxOr4yEkJELrvwgwMVwqnEQgNPO2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqEHdSkt9INv9sFbakw6AsNAz3ncErGskJRspBd/s9V1+OIt2FaZ/EVNzFERr5wPC
         QdwIji9HXkKT0trN5E6V1aJC/PpHW3L2E1oPFSViiVBeSONKngDd8zL3Gv6WGlvTpg
         hievjzjGACr286+JAFvA3E6bD77/v8EM4FPo8BjMjsBoeaQnZFaL4OvSWcyK65SdV6
         JWEcR0fK2zzyW4VTWNwjYJj7CzpwkgJ7RzihgbtNZHoMxN2qO3xOCKcrKCNQpnWtsP
         J++C9u3LEXYdnUpz9uFLKKeSMmjNRcGELMPhJ7iLUYjTZ/tkCOZJor11NxUKhbI0FU
         HP00DWZ019Xsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, jingoohan1@gmail.com,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/65] backlight: Propagate errors from get_brightness()
Date:   Tue, 16 Nov 2021 14:03:23 -0500
Message-Id: <20211116190443.2418144-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116190443.2418144-1-sashal@kernel.org>
References: <20211116190443.2418144-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 563edf85ce18a90dd0a7b39e279a691d937205f6 ]

backlight.h documents "struct backlight_ops->get_brightness()" to return
a negative errno on failure.

So far these errors have not been handled in the backlight core.
This leads to negative values being exposed through sysfs although only
positive values are documented to be reported.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/backlight.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 537fe1b376ad7..4658cfb75aa28 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -292,10 +292,13 @@ static ssize_t actual_brightness_show(struct device *dev,
 	struct backlight_device *bd = to_backlight_device(dev);
 
 	mutex_lock(&bd->ops_lock);
-	if (bd->ops && bd->ops->get_brightness)
-		rc = sprintf(buf, "%d\n", bd->ops->get_brightness(bd));
-	else
+	if (bd->ops && bd->ops->get_brightness) {
+		rc = bd->ops->get_brightness(bd);
+		if (rc >= 0)
+			rc = sprintf(buf, "%d\n", rc);
+	} else {
 		rc = sprintf(buf, "%d\n", bd->props.brightness);
+	}
 	mutex_unlock(&bd->ops_lock);
 
 	return rc;
@@ -381,9 +384,18 @@ ATTRIBUTE_GROUPS(bl_device);
 void backlight_force_update(struct backlight_device *bd,
 			    enum backlight_update_reason reason)
 {
+	int brightness;
+
 	mutex_lock(&bd->ops_lock);
-	if (bd->ops && bd->ops->get_brightness)
-		bd->props.brightness = bd->ops->get_brightness(bd);
+	if (bd->ops && bd->ops->get_brightness) {
+		brightness = bd->ops->get_brightness(bd);
+		if (brightness >= 0)
+			bd->props.brightness = brightness;
+		else
+			dev_err(&bd->dev,
+				"Could not update brightness from device: %pe\n",
+				ERR_PTR(brightness));
+	}
 	mutex_unlock(&bd->ops_lock);
 	backlight_generate_event(bd, reason);
 }
-- 
2.33.0

