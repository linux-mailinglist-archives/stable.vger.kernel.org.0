Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409E5FCACF
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 17:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKNQfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 11:35:18 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:37374 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfKNQfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 11:35:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1573749314; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=2hOlbk6iAq+UU7QhjPD6XaltGVEyMEJe7yJQLIlOvew=;
        b=S0ZW2Hues0ig2tyT7NeZj8q1wLhYZ/X+RXFEzcthF1fpv/26gO0tH68SPpkz7sHt+AQ6O8
        BHXYKJfX3Ker3OxsEp58hDfGRjHXhsstPzIkWSMOptDoNWczciO+l+GKudjzwQj8EQnZ+x
        O5bugp3OAcvQBL4J/Ag3qbHGT4n4nf4=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Sebastian Reichel <sre@kernel.org>,
        Artur Rojek <contact@artur-rojek.eu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH v2] power/supply: ingenic-battery: Don't change scale if there's only one
Date:   Thu, 14 Nov 2019 17:35:00 +0100
Message-Id: <20191114163500.57384-1-paul@crapouillou.net>
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

 drivers/power/supply/ingenic-battery.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/power/supply/ingenic-battery.c b/drivers/power/supply/ingenic-battery.c
index 35816d4b3012..5a53057b4f64 100644
--- a/drivers/power/supply/ingenic-battery.c
+++ b/drivers/power/supply/ingenic-battery.c
@@ -80,6 +80,10 @@ static int ingenic_battery_set_scale(struct ingenic_battery *bat)
 	if (ret != IIO_AVAIL_LIST || scale_type != IIO_VAL_FRACTIONAL_LOG2)
 		return -EINVAL;
 
+	/* Only one (fractional) entry - nothing to change */
+	if (scale_len == 2)
+		return 0;
+
 	max_mV = bat->info.voltage_max_design_uv / 1000;
 
 	for (i = 0; i < scale_len; i += 2) {
-- 
2.24.0

