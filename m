Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E608415EE46
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389817AbgBNQD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389809AbgBNQD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 006A7222C2;
        Fri, 14 Feb 2020 16:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696238;
        bh=HnWhr6/KKXYznfesNXl5gOHM6wIdNTDv3KbNna8Ndxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcNEtOz9ZBb0EqlKjXMQy/d2ykxJDzEtTN8unPZ8bendSqzQ7y3e6cnVNgCRurDPV
         j6ip8FIUsp3vTUzlTAtTOHXg8wmIHSPa/+MgygF3N7+hcHoBZPvy+9QBWfe33ta32L
         D3WjHrsuZUezK01P1wGlvpNpteW+hm2Wt/oPtUbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Roullier <christophe.roullier@st.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-watchdog@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 097/459] drivers: watchdog: stm32_iwdg: set WDOG_HW_RUNNING at probe
Date:   Fri, 14 Feb 2020 10:55:47 -0500
Message-Id: <20200214160149.11681-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Roullier <christophe.roullier@st.com>

[ Upstream commit 85fdc63fe256b595f923a69848cd99972ff446d8 ]

If the watchdog hardware is already enabled during the boot process,
when the Linux watchdog driver loads, it should start/reset the watchdog
and tell the watchdog framework. As a result, ping can be generated from
the watchdog framework (if CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is set),
until the userspace watchdog daemon takes over control

Fixes:4332d113c66a ("watchdog: Add STM32 IWDG driver")

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20191122132246.8473-1-christophe.roullier@st.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/stm32_iwdg.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/watchdog/stm32_iwdg.c b/drivers/watchdog/stm32_iwdg.c
index a3a329011a06b..25188d6bbe152 100644
--- a/drivers/watchdog/stm32_iwdg.c
+++ b/drivers/watchdog/stm32_iwdg.c
@@ -262,6 +262,24 @@ static int stm32_iwdg_probe(struct platform_device *pdev)
 	watchdog_set_nowayout(wdd, WATCHDOG_NOWAYOUT);
 	watchdog_init_timeout(wdd, 0, dev);
 
+	/*
+	 * In case of CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is set
+	 * (Means U-Boot/bootloaders leaves the watchdog running)
+	 * When we get here we should make a decision to prevent
+	 * any side effects before user space daemon will take care of it.
+	 * The best option, taking into consideration that there is no
+	 * way to read values back from hardware, is to enforce watchdog
+	 * being run with deterministic values.
+	 */
+	if (IS_ENABLED(CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED)) {
+		ret = stm32_iwdg_start(wdd);
+		if (ret)
+			return ret;
+
+		/* Make sure the watchdog is serviced */
+		set_bit(WDOG_HW_RUNNING, &wdd->status);
+	}
+
 	ret = devm_watchdog_register_device(dev, wdd);
 	if (ret)
 		return ret;
-- 
2.20.1

