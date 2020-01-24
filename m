Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AAE14818A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390768AbgAXLUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390751AbgAXLUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:20:50 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA04206D4;
        Fri, 24 Jan 2020 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864850;
        bh=KQwFnlFj/knXAB6kuN3/XLy7vseHLHLagofxE3P5t7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mK0aCDcn4fWc0mB6WkgBi1fH7rfXIPofXi11gi7cyaGzw00QMclI/BB7Dc8plpdsG
         7HaJttPrNmIshLHeUYhwJggijzd0XJFXuFo2N8ZtvWBbINZM1k6729KZYv/mzJJoqy
         at3PPUQIdu8LIQnxM6H4lSZV3gVUVApsQ96d6gJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Pavel Machek <pavel@ucw.cz>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 371/639] backlight: lm3630a: Return 0 on success in update_status functions
Date:   Fri, 24 Jan 2020 10:29:01 +0100
Message-Id: <20200124093133.515990747@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <masneyb@onstation.org>

[ Upstream commit d3f48ec0954c6aac736ab21c34a35d7554409112 ]

lm3630a_bank_a_update_status() and lm3630a_bank_b_update_status()
both return the brightness value if the brightness was successfully
updated. Writing to these attributes via sysfs would cause a 'Bad
address' error to be returned. These functions should return 0 on
success, so let's change it to correct that error.

Fixes: 28e64a68a2ef ("backlight: lm3630: apply chip revision")
Signed-off-by: Brian Masney <masneyb@onstation.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lm3630a_bl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index 2030a6b77a097..ef2553f452ca9 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -201,7 +201,7 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 				      LM3630A_LEDA_ENABLE, LM3630A_LEDA_ENABLE);
 	if (ret < 0)
 		goto out_i2c_err;
-	return bl->props.brightness;
+	return 0;
 
 out_i2c_err:
 	dev_err(pchip->dev, "i2c failed to access\n");
@@ -278,7 +278,7 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
 				      LM3630A_LEDB_ENABLE, LM3630A_LEDB_ENABLE);
 	if (ret < 0)
 		goto out_i2c_err;
-	return bl->props.brightness;
+	return 0;
 
 out_i2c_err:
 	dev_err(pchip->dev, "i2c failed to access REG_CTRL\n");
-- 
2.20.1



