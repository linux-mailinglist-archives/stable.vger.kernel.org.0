Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2732FFEC82
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 14:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfKPN41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 08:56:27 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:44912 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbfKPN40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 08:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1573912585; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=XtMiD4L8Mgswux/la2nsChygCf/Wix4n1q7sgFMyzbs=;
        b=gor+OKjQzzT9o51Vg9CwAiSyZIAW9gc5B9ChfIeGHNp/vaNq8JdWn+sx0qr5k6Fi1mM8mN
        Ok/AMoyPDe1bbez6taaooAfOtn6gyZzARXz4zC+oNwO5uhIE+WkUr9mk8l48LJHBqebnue
        xyLGCMaZ+cz1ENwHYiwKKeOdKNwa0l4=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Sebastian Reichel <sre@kernel.org>,
        Artur Rojek <contact@artur-rojek.eu>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, od@zcrc.me,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH v3] power/supply: ingenic-battery: Don't change scale if there's only one
Date:   Sat, 16 Nov 2019 14:56:19 +0100
Message-Id: <20191116135619.9545-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ADC in the JZ4740 can work either in high-precision mode with a 2.5V
range, or in low-precision mode with a 7.5V range. The code in place in
this driver will select the proper scale according to the maximum
voltage of the battery.

The JZ4770 however only has one mode, with a 6.6V range. If only one
scale is available, there's no need to change it (and nothing to change
it to), and trying to do so will fail with -EINVAL.

Fixes: fb24ccfbe1e0 ("power: supply: add Ingenic JZ47xx battery driver.")

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
---

Notes:
    v2: Rebased on v5.4-rc7
    v3: Move code after check for max scale voltage

 drivers/power/supply/ingenic-battery.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/ingenic-battery.c b/drivers/power/supply/ingenic-battery.c
index 35816d4b3012..2748715c4c75 100644
--- a/drivers/power/supply/ingenic-battery.c
+++ b/drivers/power/supply/ingenic-battery.c
@@ -100,10 +100,17 @@ static int ingenic_battery_set_scale(struct ingenic_battery *bat)
 		return -EINVAL;
 	}
 
-	return iio_write_channel_attribute(bat->channel,
-					   scale_raw[best_idx],
-					   scale_raw[best_idx + 1],
-					   IIO_CHAN_INFO_SCALE);
+	/* Only set scale if there is more than one (fractional) entry */
+	if (scale_len > 2) {
+		ret = iio_write_channel_attribute(bat->channel,
+						  scale_raw[best_idx],
+						  scale_raw[best_idx + 1],
+						  IIO_CHAN_INFO_SCALE);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static enum power_supply_property ingenic_battery_properties[] = {
-- 
2.24.0

