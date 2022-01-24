Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D486C499763
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448591AbiAXVNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58932 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiAXVIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D21DDB80FA3;
        Mon, 24 Jan 2022 21:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F258BC340E5;
        Mon, 24 Jan 2022 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058528;
        bh=YjrVxM7CLUaCdnPq3WETDJ47sLozfT7aDhMUijcqU08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfOE1GmC2M/18GoO9qbgk/J6bJ0TRAbpDZP21DCaXRU/65dBiBJ5bRefVlEHaAO4P
         W1fm+qyPwMfA59Mc98+UIxwohTEWeObqOM653cZEhfigaS7AhHTtxCusWZLQE9Or1r
         QJlLrElDsZSlK1Qe2TdJUnhSA3FmCs9+mTf4aEkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0318/1039] mt76: mt7921: fix possible resume failure
Date:   Mon, 24 Jan 2022 19:35:07 +0100
Message-Id: <20220124184135.983197973@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 5375001bb4ce22801bf3bb566cc3e67d2d3a5dc0 ]

Fix the possible resume failure due to mt76_connac_mcu_set_hif_suspend
timeout.

That is because clearing the flag pm->suspended too early opened up a race
window, where mt7921_poll_tx/rx scheduled a ps_work to put the device in
doze mode, that is unexpected for the device is being resumed from the
suspend state and would make the remaining MCU comamnds in resume handler
failed to execute.

Fixes: ffa1bf97425b ("mt76: mt7921: introduce PM support")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index c29dde23d4ab1..40186e6cd865e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -313,7 +313,6 @@ static int mt7921_pci_resume(struct pci_dev *pdev)
 	struct mt76_connac_pm *pm = &dev->pm;
 	int i, err;
 
-	pm->suspended = false;
 	err = pci_set_power_state(pdev, PCI_D0);
 	if (err)
 		return err;
@@ -351,7 +350,13 @@ static int mt7921_pci_resume(struct pci_dev *pdev)
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(&dev->mt76, false);
 
-	return mt76_connac_mcu_set_hif_suspend(mdev, false);
+	err = mt76_connac_mcu_set_hif_suspend(mdev, false);
+	if (err)
+		return err;
+
+	pm->suspended = false;
+
+	return err;
 }
 #endif /* CONFIG_PM */
 
-- 
2.34.1



