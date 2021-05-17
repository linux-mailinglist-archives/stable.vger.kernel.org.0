Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A029C383193
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbhEQOhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240906AbhEQOf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 831F46192F;
        Mon, 17 May 2021 14:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261034;
        bh=Z+su00VV6BzT4yB/RcshKmukqgCEF2W7XMrUIcaYdq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNsvtJ/7hNutUb8pYlILiav7I7w1+MAqNSjSNTkaHfFlWL9TLGoeFvGQwH7bpC53z
         8KLvkkTYG/K6O+l0JiKlM2W4jHPX1beWzDansos58efLmr7SoH8fWOQ/lFet8o254P
         pea7DFl/4OgAQk97RyPo0SJILQFohkwEHn6OGJ3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 294/363] hwmon: (ltc2992) Put fwnode in error case during ->probe()
Date:   Mon, 17 May 2021 16:02:40 +0200
Message-Id: <20210517140312.535276129@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 8370e5b093080c03cf89f7ebf0bef6984545429e ]

In each iteration fwnode_for_each_available_child_node() bumps a reference
counting of a loop variable followed by dropping in on a next iteration,

Since in error case the loop is broken, we have to drop a reference count
by ourselves. Do it for port_fwnode in error case during ->probe().

Fixes: b0bd407e94b0 ("hwmon: (ltc2992) Add support")
Cc: Alexandru Tachici <alexandru.tachici@analog.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210510100136.3303142-1-andy.shevchenko@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2992.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ltc2992.c b/drivers/hwmon/ltc2992.c
index 4382105bf142..2a4bed0ab226 100644
--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -900,11 +900,15 @@ static int ltc2992_parse_dt(struct ltc2992_state *st)
 
 	fwnode_for_each_available_child_node(fwnode, child) {
 		ret = fwnode_property_read_u32(child, "reg", &addr);
-		if (ret < 0)
+		if (ret < 0) {
+			fwnode_handle_put(child);
 			return ret;
+		}
 
-		if (addr > 1)
+		if (addr > 1) {
+			fwnode_handle_put(child);
 			return -EINVAL;
+		}
 
 		ret = fwnode_property_read_u32(child, "shunt-resistor-micro-ohms", &val);
 		if (!ret)
-- 
2.30.2



