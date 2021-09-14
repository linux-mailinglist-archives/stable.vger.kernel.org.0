Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BC240AD69
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 14:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhINMUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 08:20:25 -0400
Received: from comms.puri.sm ([159.203.221.185]:45054 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232606AbhINMUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 08:20:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id C305DDFA69;
        Tue, 14 Sep 2021 05:18:36 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NiOnI3NDwrju; Tue, 14 Sep 2021 05:18:36 -0700 (PDT)
From:   Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
To:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, kernel@puri.sm,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] power: supply: max17042_battery: Prevent int underflow in set_soc_threshold
Date:   Tue, 14 Sep 2021 14:18:06 +0200
Message-Id: <20210914121806.1301131-2-sebastian.krzyszkowiak@puri.sm>
In-Reply-To: <20210914121806.1301131-1-sebastian.krzyszkowiak@puri.sm>
References: <20210914121806.1301131-1-sebastian.krzyszkowiak@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

max17042_set_soc_threshold gets called with offset set to 1, which means
that minimum threshold value would underflow once SOC got down to 0,
causing invalid alerts from the gauge.

Fixes: e5f3872d2044 ("max17042: Add support for signalling change in SOC")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
---
v2: added commit description
---
 drivers/power/supply/max17042_battery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index da78ffe6a3ec..189c1979bc7b 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -857,7 +857,8 @@ static void max17042_set_soc_threshold(struct max17042_chip *chip, u16 off)
 	regmap_read(map, MAX17042_RepSOC, &soc);
 	soc >>= 8;
 	soc_tr = (soc + off) << 8;
-	soc_tr |= (soc - off);
+	if (off < soc)
+		soc_tr |= soc - off;
 	regmap_write(map, MAX17042_SALRT_Th, soc_tr);
 }
 
-- 
2.33.0

