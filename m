Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD3945BCC8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244515AbhKXMc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344167AbhKXMag (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A82861359;
        Wed, 24 Nov 2021 12:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756340;
        bh=7+ik/QM0SSY9izOtJeZyh2oN/k0ZiB3xnzNA9pTuZIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lR0ZEDg/wGKV9dKLwfGeYQskcYeuW32TmoinUNEH+YBg599PlTITswnAhHxY0wPJ
         cySeBatQr3wsHaCa9PnZTcqstfgoGh4WowypKY5M50uAIDjSpnFaZeC7ZHXsWLinwI
         u+CdtOXlSW9uVCndQWOJMyU6GoNh0PAVUBYjo27Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wolfgang Wiedmeyer <wolfgit@wiedmeyer.de>,
        Henrik Grimler <henrik@grimler.se>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.14 052/251] power: supply: max17042_battery: use VFSOC for capacity when no rsns
Date:   Wed, 24 Nov 2021 12:54:54 +0100
Message-Id: <20211124115712.058714514@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henrik Grimler <henrik@grimler.se>

commit 223a3b82834f036a62aa831f67cbf1f1d644c6e2 upstream.

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
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17042_battery.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -303,7 +303,10 @@ static int max17042_get_property(struct
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
 


