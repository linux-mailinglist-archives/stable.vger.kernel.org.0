Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B188C451F65
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355992AbhKPAis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344018AbhKOTXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B42A613AD;
        Mon, 15 Nov 2021 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002206;
        bh=Bwxs8RremgeeOxsIZo15403pKjyeqw5l+Chq6TMssdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPCzp2BjL32r8f3DBmJciLsMG/pdS8RfxHxjX1Lsjn/ND6DgWKiDmk/irJK4NlX5M
         FgPV+j+SFiAbDmTKJACtltnHbEf/jkt6HLGA/8QArdEb/aO+fImcRTHfnHSTxC9fhe
         Bw+zo0EwqtoIl5UfzJoI/f7Na0tL+Lt3FRXrGSOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/917] mt76: mt7615: fix hwmon temp sensor mem use-after-free
Date:   Mon, 15 Nov 2021 17:59:32 +0100
Message-Id: <20211115165444.945853976@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 0bb4e9187ea4a59dc6658a62978deda0c0dc4b28 ]

Without this change, garbage is seen in the hwmon name and sensors output
for mt7615 is garbled.

Fixes: 109e505ad944 ("mt76: mt7615: add thermal sensor device support")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 2f1ac644e018e..47f23ac905a3c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -49,12 +49,14 @@ int mt7615_thermal_init(struct mt7615_dev *dev)
 {
 	struct wiphy *wiphy = mt76_hw(dev)->wiphy;
 	struct device *hwmon;
+	const char *name;
 
 	if (!IS_REACHABLE(CONFIG_HWMON))
 		return 0;
 
-	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev,
-						       wiphy_name(wiphy), dev,
+	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7615_%s",
+			      wiphy_name(wiphy));
+	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, dev,
 						       mt7615_hwmon_groups);
 	if (IS_ERR(hwmon))
 		return PTR_ERR(hwmon);
-- 
2.33.0



