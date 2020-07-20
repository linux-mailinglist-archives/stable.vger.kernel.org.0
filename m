Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8722270C1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgGTVjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728319AbgGTVjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:39:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7FA22BEF;
        Mon, 20 Jul 2020 21:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281142;
        bh=404mlOwBRprthN1mkVirySgS0S2bS+wvcYx3rW8zKHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQ0Dtml6WfhLeFuXNAnGm5zeV5hV1m+9I/Z/Ma+8STeaIBrYeunqQ5gx7IHZh5z/G
         j/CxXKFPK70KPrsJI6cZ9A6h+STNKrXx9x2SxjIta+YYUzTtNilNDQ0/6hpe97qOa+
         /81e5+BdHzRKtQhgT7m59BVYIzD7Es/iVzJ2u7MM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 09/19] hwmon: (aspeed-pwm-tacho) Avoid possible buffer overflow
Date:   Mon, 20 Jul 2020 17:38:40 -0400
Message-Id: <20200720213851.407715-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213851.407715-1-sashal@kernel.org>
References: <20200720213851.407715-1-sashal@kernel.org>
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
index 5e449eac788a1..a43fa730a513b 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -880,6 +880,8 @@ static int aspeed_create_fan(struct device *dev,
 	ret = of_property_read_u32(child, "reg", &pwm_port);
 	if (ret)
 		return ret;
+	if (pwm_port >= ARRAY_SIZE(pwm_port_params))
+		return -EINVAL;
 	aspeed_create_pwm_port(priv, (u8)pwm_port);
 
 	ret = of_property_count_u8_elems(child, "cooling-levels");
-- 
2.25.1

