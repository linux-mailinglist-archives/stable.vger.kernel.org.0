Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394EE417372
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344809AbhIXM4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344830AbhIXMyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA2626137F;
        Fri, 24 Sep 2021 12:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487839;
        bh=gPIh2XjepXMz/qIZHLg+oQgDWalZeTjqIcKW8W6FABg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/ohDWk0yVfXIP2J7edfCgnAKAQZUMWpqxy8mnOwgs1TwCnHKSbWGHVIJ6kYuPR3Z
         ccGlC+ERFNplYntx8lEJW/MeOIjDxdGX2WwWf5iPk2GprCEnkhwyGr/UXJe4riBA/D
         B04XFGv0t0gLVR2WWaIpdnon40UbSJdg78r4ZKUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/50] thermal/core: Fix thermal_cooling_device_register() prototype
Date:   Fri, 24 Sep 2021 14:44:19 +0200
Message-Id: <20210924124333.257612059@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fb83610762dd5927212aa62a468dd3b756b57a88 ]

There are two pairs of declarations for thermal_cooling_device_register()
and thermal_of_cooling_device_register(), and only one set was changed
in a recent patch, so the other one now causes a compile-time warning:

drivers/net/wireless/mediatek/mt76/mt7915/init.c: In function 'mt7915_thermal_init':
drivers/net/wireless/mediatek/mt76/mt7915/init.c:134:48: error: passing argument 1 of 'thermal_cooling_device_register' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
  134 |         cdev = thermal_cooling_device_register(wiphy_name(wiphy), phy,
      |                                                ^~~~~~~~~~~~~~~~~
In file included from drivers/net/wireless/mediatek/mt76/mt7915/init.c:7:
include/linux/thermal.h:407:39: note: expected 'char *' but argument is of type 'const char *'
  407 | thermal_cooling_device_register(char *type, void *devdata,
      |                                 ~~~~~~^~~~

Change the dummy helper functions to have the same arguments as the
normal version.

Fixes: f991de53a8ab ("thermal: make device_register's type argument const")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210722090717.1116748-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/thermal.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index e45659c75920..a41378bdf27c 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -501,12 +501,13 @@ static inline void thermal_zone_device_update(struct thermal_zone_device *tz,
 static inline void thermal_zone_set_trips(struct thermal_zone_device *tz)
 { }
 static inline struct thermal_cooling_device *
-thermal_cooling_device_register(char *type, void *devdata,
+thermal_cooling_device_register(const char *type, void *devdata,
 	const struct thermal_cooling_device_ops *ops)
 { return ERR_PTR(-ENODEV); }
 static inline struct thermal_cooling_device *
 thermal_of_cooling_device_register(struct device_node *np,
-	char *type, void *devdata, const struct thermal_cooling_device_ops *ops)
+	const char *type, void *devdata,
+	const struct thermal_cooling_device_ops *ops)
 { return ERR_PTR(-ENODEV); }
 static inline struct thermal_cooling_device *
 devm_thermal_of_cooling_device_register(struct device *dev,
-- 
2.33.0



