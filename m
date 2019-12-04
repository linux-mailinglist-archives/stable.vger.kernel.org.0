Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339DF1132B8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbfLDSLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:11:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731403AbfLDSLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:11:12 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F3920863;
        Wed,  4 Dec 2019 18:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483072;
        bh=zei5XXSiJlVh0aRUkaleW2khLyQEpR2YizO3Ith2k/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7PCSDGZCEdMDxIPPB6C9fpUiqZYgW+xK9KBMEXzSop1dxwn2wqrxfdCzMlhGyJpQ
         VOeYgDbWJzxKvBjkORM3f/9lHQoLOZZjaqUsmiHhIBEC5ziiReAb4SVEY3F2cN5Krg
         7GVvDsJNr/0D8sxYsb/yKOaLJc7MniyrK2SBlFQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xingyu Chen <xingyu.chen@amlogic.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 009/125] watchdog: meson: Fix the wrong value of left time
Date:   Wed,  4 Dec 2019 18:55:14 +0100
Message-Id: <20191204175313.361413674@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xingyu Chen <xingyu.chen@amlogic.com>

[ Upstream commit 2c77734642d52448aca673e889b39f981110828b ]

The left time value is wrong when we get it by sysfs. The left time value
should be equal to preset timeout value minus elapsed time value. According
to the Meson-GXB/GXL datasheets which can be found at [0], the timeout value
is saved to BIT[0-15] of the WATCHDOG_TCNT, and elapsed time value is saved
to BIT[16-31] of the WATCHDOG_TCNT.

[0]: http://linux-meson.com

Fixes: 683fa50f0e18 ("watchdog: Add Meson GXBB Watchdog Driver")
Signed-off-by: Xingyu Chen <xingyu.chen@amlogic.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/meson_gxbb_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/meson_gxbb_wdt.c b/drivers/watchdog/meson_gxbb_wdt.c
index 44d180a2c5e57..58e06f059e673 100644
--- a/drivers/watchdog/meson_gxbb_wdt.c
+++ b/drivers/watchdog/meson_gxbb_wdt.c
@@ -137,8 +137,8 @@ static unsigned int meson_gxbb_wdt_get_timeleft(struct watchdog_device *wdt_dev)
 
 	reg = readl(data->reg_base + GXBB_WDT_TCNT_REG);
 
-	return ((reg >> GXBB_WDT_TCNT_CNT_SHIFT) -
-		(reg & GXBB_WDT_TCNT_SETUP_MASK)) / 1000;
+	return ((reg & GXBB_WDT_TCNT_SETUP_MASK) -
+		(reg >> GXBB_WDT_TCNT_CNT_SHIFT)) / 1000;
 }
 
 static const struct watchdog_ops meson_gxbb_wdt_ops = {
-- 
2.20.1



