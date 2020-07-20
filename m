Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DE72270A3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGTViV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgGTViU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6341822CB2;
        Mon, 20 Jul 2020 21:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281100;
        bh=WuELeavyDRx8mw9ik3oLaPzKVsJbeveplcMAf2xPW3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWD8Q4RPtSA1SSO0wH53AKVRFCcYk51w/98+37yvF0QyL/5eDf4NdoAWM5q3lsxEB
         i1n7EmnEzqowJckzTSXE2+ubHK5y9uIbfQWgXeeOsElS38bXvUnKTmdguVOVvMtwNH
         Z3eftLpLYylemJZGXfzwp9in1C62TTRo/3apTn4k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 10/34] hwmon: (aspeed-pwm-tacho) Avoid possible buffer overflow
Date:   Mon, 20 Jul 2020 17:37:43 -0400
Message-Id: <20200720213807.407380-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213807.407380-1-sashal@kernel.org>
References: <20200720213807.407380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit bc4071aafcf4d0535ee423b69167696d6c03207d ]

aspeed_create_fan() reads a pwm_port value using of_property_read_u32().
If pwm_port will be more than ARRAY_SIZE(pwm_port_params), there will be
a buffer overflow in
aspeed_create_pwm_port()->aspeed_set_pwm_port_enable(). The patch fixes
the potential buffer overflow.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Link: https://lore.kernel.org/r/20200703111518.9644-1-novikov@ispras.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aspeed-pwm-tacho.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/aspeed-pwm-tacho.c b/drivers/hwmon/aspeed-pwm-tacho.c
index 40c489be62eaa..40f3139f1e028 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -851,6 +851,8 @@ static int aspeed_create_fan(struct device *dev,
 	ret = of_property_read_u32(child, "reg", &pwm_port);
 	if (ret)
 		return ret;
+	if (pwm_port >= ARRAY_SIZE(pwm_port_params))
+		return -EINVAL;
 	aspeed_create_pwm_port(priv, (u8)pwm_port);
 
 	ret = of_property_count_u8_elems(child, "cooling-levels");
-- 
2.25.1

