Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0B68FCDF
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfHPH7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 03:59:01 -0400
Received: from mail.heine.tech ([195.201.24.99]:37344 "EHLO mail.heine.tech"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfHPH7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 03:59:01 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 03:59:00 EDT
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: michael@nosthoff.rocks)
        by mail.heine.tech (Postcow) with ESMTPSA id 624EA1814A1;
        Fri, 16 Aug 2019 09:37:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heine.so; s=dkim;
        t=1565941067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LoEZ6U0CLaUCuEgq+DdJEavhnFNLMhxnereXFUUd7+w=;
        b=ADHJBtUvJpCVa2gkdsCEqh2PXmwgnxP6s3ZS48eyGUo0fVHKJOD+X3RwtgwVUKmrQQMfeS
        svonZ+ZteWHG3bDBeAWLbLaWxRibglt/JTQlFVV/RefWPkezSVYf7wXUkdLj3R4+AlmdAN
        zfuwIHZ0iF8/SawqEmc9oHO/kT/ikIg=
From:   Michael Nosthoff <committed@heine.so>
To:     linux-pm@vger.kernel.org
Cc:     Michael Nosthoff <committed@heine.so>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2] power: supply: sbs-battery: use correct flags field
Date:   Fri, 16 Aug 2019 09:37:42 +0200
Message-Id: <20190816073742.26866-1-committed@heine.so>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

the type flag is stored in the chip->flags field not in the
client->flags field. This currently leads to never using the ti
specific health function as client->flags doesn't use that bit.
So it's always falling back to the general one.

Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume
MANUFACTURER_DATA formats")

Signed-off-by: Michael Nosthoff <committed@heine.so>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Cc: <stable@vger.kernel.org>
---
Changes since v1:
* Changed comment according to Brian's suggestions
* Added Fixes tag
* Added reviewed and cc stable

 drivers/power/supply/sbs-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sbs-battery.c
index 048d205d7074..2e86cc1e0e35 100644
--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -620,7 +620,7 @@ static int sbs_get_property(struct power_supply *psy,
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
 	case POWER_SUPPLY_PROP_HEALTH:
-		if (client->flags & SBS_FLAGS_TI_BQ20Z75)
+		if (chip->flags & SBS_FLAGS_TI_BQ20Z75)
 			ret = sbs_get_ti_battery_presence_and_health(client,
 								     psp, val);
 		else
-- 
2.20.1

