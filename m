Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3537241CBB6
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 20:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345758AbhI2SW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 14:22:58 -0400
Received: from h02mx15.reliablemail.org ([185.76.66.168]:42778 "EHLO
        h02mx15.reliablemail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343518AbhI2SW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 14:22:58 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2021 14:22:57 EDT
X-Halon-Out: 2fdeebfa-2151-11ec-930f-f5be715b97e5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=grimler.se;
        s=default; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JDCzG/NIZpsyCZN5FF/XKbBBvpMH6WE/le82sQnlqHg=; b=tevEXB9OJcHUm79hQldt/+qPOH
        wSgouYbV7OMTgVLCsCLnLdbbX+fzAsWVo7wgP7dRWARg2RRsmgwkQsNtRhwPJxCiKxr9xAOZsybT2
        +jJ2OsImryccVQSHJZ9JKFIaU9YI8YN5lR3by/afRJ0fMPrbxQYEDJNeckrk4N1DFION+DDZsy3p9
        lb56lW8UyEJxryTEtx8SXt0pNYHGnYKlHwCCyUY0CVYBNDIdd3AkHGf2/qIpnXS8uZt8U31tkYr22
        aKt/Y87uhVZ5aAgbe9FJmR9udqBiFKyGpp4fV2eDdLuPnKY+QJDGmhJDj18tDq9Q7zBUgntbFVyPR
        Giw0yJCg==;
From:   Henrik Grimler <henrik@grimler.se>
To:     sre@kernel.org, m.szyprowski@samsung.com,
        krzysztof.kozlowski@canonical.com, sebastian.krzyszkowiak@puri.sm,
        hdegoede@redhat.com, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht
Cc:     Henrik Grimler <henrik@grimler.se>, stable@vger.kernel.org,
        Wolfgang Wiedmeyer <wolfgit@wiedmeyer.de>
Subject: [PATCH v2 1/2] power: supply: max17042_battery: use VFSOC for capacity when no rsns
Date:   Wed, 29 Sep 2021 20:14:17 +0200
Message-Id: <20210929181418.4221-1-henrik@grimler.se>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpsrv07.misshosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - grimler.se
X-Get-Message-Sender-Via: cpsrv07.misshosting.com: authenticated_id: henrik@grimler.se
X-Authenticated-Sender: cpsrv07.misshosting.com: henrik@grimler.se
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Galaxy S3 (i9300/i9305), which has the max17047 fuel gauge and no
current sense resistor (rsns), the RepSOC register does not provide an
accurate state of charge value. The reported value is wrong, and does
not change over time. VFSOC however, which uses the voltage fuel gauge
to determine the state of charge, always shows an accurate value.

For devices without current sense, VFSOC is already used for the
soc-alert (0x0003 is written to MiscCFG register), so with this change
the source of the alert and the PROP_CAPACITY value match.

Fixes: 359ab9f5b154 ("power_supply: Add MAX17042 Fuel Gauge Driver")
Cc: <stable@vger.kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Suggested-by: Wolfgang Wiedmeyer <wolfgit@wiedmeyer.de>
Signed-off-by: Henrik Grimler <henrik@grimler.se>
---
Changes in v2:
Re-write commit message to highlight that VFSOC is already used for
alert, after Krzysztof's comments
---
 drivers/power/supply/max17042_battery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 8dffae76b6a3..5809ba997093 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -313,7 +313,10 @@ static int max17042_get_property(struct power_supply *psy,
 		val->intval = data * 625 / 8;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = regmap_read(map, MAX17042_RepSOC, &data);
+		if (chip->pdata->enable_current_sense)
+			ret = regmap_read(map, MAX17042_RepSOC, &data);
+		else
+			ret = regmap_read(map, MAX17042_VFSOC, &data);
 		if (ret < 0)
 			return ret;
 

base-commit: 5816b3e6577eaa676ceb00a848f0fd65fe2adc29
-- 
2.33.0

