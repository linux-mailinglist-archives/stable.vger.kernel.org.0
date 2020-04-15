Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFE81AA0A2
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369414AbgDOM3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409112AbgDOLoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:44:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7546B2166E;
        Wed, 15 Apr 2020 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951093;
        bh=u+ZK0QjmPA3ERKqb6bXhhJqFb/fnt7rrc/MvdpraFAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oo9IKAIj7YjvrQ/YJBjSYGICIe3eUdehQE6qDhKgdxYkG/pYztjBYRHXD7LB98yYr
         JrrHERsEsPoMuOR3HCaO0FLdwWhAcrIJsluyBGlZ+ZVOXUU0FNYXi5NaTxvlEUzIys
         4RiMNfZz+B/jxOkVmOFBfrUwWB2peZYNiUQ8EwLs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        "Andrew F . Davis" <afd@ti.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/84] power: supply: bq27xxx_battery: Silence deferred-probe error
Date:   Wed, 15 Apr 2020 07:43:26 -0400
Message-Id: <20200415114442.14166-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 583b53ece0b0268c542a1eafadb62e3d4b0aab8c ]

The driver fails to probe with -EPROBE_DEFER if battery's power supply
(charger driver) isn't ready yet and this results in a bit noisy error
message in KMSG during kernel's boot up. Let's silence the harmless
error message.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Andrew F. Davis <afd@ti.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 195c18c2f426e..664e50103eaaf 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1885,7 +1885,10 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 
 	di->bat = power_supply_register_no_ws(di->dev, psy_desc, &psy_cfg);
 	if (IS_ERR(di->bat)) {
-		dev_err(di->dev, "failed to register battery\n");
+		if (PTR_ERR(di->bat) == -EPROBE_DEFER)
+			dev_dbg(di->dev, "failed to register battery, deferring probe\n");
+		else
+			dev_err(di->dev, "failed to register battery\n");
 		return PTR_ERR(di->bat);
 	}
 
-- 
2.20.1

