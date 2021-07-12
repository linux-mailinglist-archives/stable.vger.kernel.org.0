Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF683C4D55
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbhGLHMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244160AbhGLHK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 286A2613CC;
        Mon, 12 Jul 2021 07:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073606;
        bh=sUDcBnWAoNpaVZalSL2yTvcf7M8ILQVPIhuBIBrn36w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neIExjNobQNRuI7+aMikCIlkEVT6X3tRGm4Es88cI6Esna3cHm5MQP/IF0fGwk2fw
         GK7IPvxcq7iyx6gWvEqme4VhZ6Vs5xvJw+Efvrl3MNzdP6UipK0jjeOeOlQubF2mw7
         X8LUL248/Ia4ABxGJ9u0D7BHj8g6yxQiOBFb1lfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        =?UTF-8?q?V=C3=A1clav=20Kubern=C3=A1t?= <kubernat@cesnet.cz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 296/700] hwmon: (max31790) Fix fan speed reporting for fan7..12
Date:   Mon, 12 Jul 2021 08:06:19 +0200
Message-Id: <20210712061007.792827210@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit cbbf244f0515af3472084f22b6213121b4a63835 ]

Fans 7..12 do not have their own set of configuration registers.
So far the code ignored that and read beyond the end of the configuration
register range to get the tachometer period. This resulted in more or less
random fan speed values for those fans.

The datasheet is quite vague when it comes to defining the tachometer
period for fans 7..12. Experiments confirm that the period is the same
for both fans associated with a given set of configuration registers.

Fixes: 54187ff9d766 ("hwmon: (max31790) Convert to use new hwmon registration API")
Fixes: 195a4b4298a7 ("hwmon: Driver for Maxim MAX31790")
Cc: Jan Kundrát <jan.kundrat@cesnet.cz>
Reviewed-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Cc: Václav Kubernát <kubernat@cesnet.cz>
Reviewed-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210526154022.3223012-2-linux@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max31790.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/max31790.c b/drivers/hwmon/max31790.c
index 76aa96f5b984..67677c437768 100644
--- a/drivers/hwmon/max31790.c
+++ b/drivers/hwmon/max31790.c
@@ -171,7 +171,7 @@ static int max31790_read_fan(struct device *dev, u32 attr, int channel,
 
 	switch (attr) {
 	case hwmon_fan_input:
-		sr = get_tach_period(data->fan_dynamics[channel]);
+		sr = get_tach_period(data->fan_dynamics[channel % NR_CHANNEL]);
 		rpm = RPM_FROM_REG(data->tach[channel], sr);
 		*val = rpm;
 		return 0;
-- 
2.30.2



