Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07B8451DF1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346832AbhKPAed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233731AbhKOTXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EBFC633B4;
        Mon, 15 Nov 2021 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002201;
        bh=RdOplR5AugF+eTUgdrMUIknooNqDt6t07r9snoXRdpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4cDiS9I0UaJcdPjYXe7drsVBGueD1wmS3tQQyUmC2hSCnHd28O8WnH07if16SDDJ
         4eByvDhbJVxM9kN0cWU5byig7LBtaeXRdJ6Q/T4s7lyr9Gv06qa2nMw/viixrj2/g+
         kv7ohsDZeWXKqGk29AlSqd2YjGF1JucPztoEqj/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 476/917] mt76: mt7915: fix hwmon temp sensor mem use-after-free
Date:   Mon, 15 Nov 2021 17:59:31 +0100
Message-Id: <20211115165444.913149583@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 0ae3ff5684514d72357240f1033a7494c51f93ed ]

Without this change, garbage is seen in the hwmon name and sensors output
for mt7915 is garbled. It appears that the hwmon logic does not make a
copy of the incoming string, but instead just copies a char* and expects
it to never go away.

Fixes: 33fe9c639c13 ("mt76: mt7915: add thermal sensor device support")
Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 4798d6344305d..b171027e0cfa8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -130,9 +130,12 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 	struct wiphy *wiphy = phy->mt76->hw->wiphy;
 	struct thermal_cooling_device *cdev;
 	struct device *hwmon;
+	const char *name;
 
-	cdev = thermal_cooling_device_register(wiphy_name(wiphy), phy,
-					       &mt7915_thermal_ops);
+	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7915_%s",
+			      wiphy_name(wiphy));
+
+	cdev = thermal_cooling_device_register(name, phy, &mt7915_thermal_ops);
 	if (!IS_ERR(cdev)) {
 		if (sysfs_create_link(&wiphy->dev.kobj, &cdev->device.kobj,
 				      "cooling_device") < 0)
@@ -144,8 +147,7 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 	if (!IS_REACHABLE(CONFIG_HWMON))
 		return 0;
 
-	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev,
-						       wiphy_name(wiphy), phy,
+	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy,
 						       mt7915_hwmon_groups);
 	if (IS_ERR(hwmon))
 		return PTR_ERR(hwmon);
-- 
2.33.0



