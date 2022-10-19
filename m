Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DDE604874
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiJSN4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiJSNyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB3C1DB8B6;
        Wed, 19 Oct 2022 06:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEDD0B8238C;
        Wed, 19 Oct 2022 08:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D81EC4347C;
        Wed, 19 Oct 2022 08:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169437;
        bh=1xY5XAr/WSrFdgBgCftPjgXpxV3yIuGvvgk5dYMelJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6gAChRV4r5396VsDpu48o1vWzEe0Btxy1kM2seku/f4F5gUX68pfTQEprwIiZ8Ea
         jIGZ/5vlV0Djn1mMzJWec+tH7A/uR3b1h9KWfxVjixHcR8URO2Scixhk/wMUC6RC+E
         ucg5fIv8IddqPXPtBKKGm3ey7LG5POF4aVpX5Lp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 277/862] wifi: mt76: mt7921u: fix race issue between reset and suspend/resume
Date:   Wed, 19 Oct 2022 10:26:04 +0200
Message-Id: <20221019083302.268615421@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 86f15d043ba7f13211d5c3e41961c3381fb12880 ]

It is unexpected that the reset work is running simultaneously with
the suspend or resume context and it is possible that reset work is still
running even after mt7921 is suspended if we don't fix the race issue.

Thus, the suspend procedure should be waiting until the reset is completed
at the beginning and ignore the subsequent the reset requests.

In case there is an error that happens during either suspend or resume
handler, we will schedule a reset task to recover the error before
returning the error code to ensure we can immediately fix the error there.

Fixes: df3e4143ba8a ("mt76: mt7921u: add suspend/resume support")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/usb.c   | 28 ++++++++++++++++---
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index dd3b8884e162..613d5cefffc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -300,11 +300,15 @@ static void mt7921u_disconnect(struct usb_interface *usb_intf)
 static int mt7921u_suspend(struct usb_interface *intf, pm_message_t state)
 {
 	struct mt7921_dev *dev = usb_get_intfdata(intf);
+	struct mt76_connac_pm *pm = &dev->pm;
 	int err;
 
+	pm->suspended = true;
+	flush_work(&dev->reset_work);
+
 	err = mt76_connac_mcu_set_hif_suspend(&dev->mt76, true);
 	if (err)
-		return err;
+		goto failed;
 
 	mt76u_stop_rx(&dev->mt76);
 	mt76u_stop_tx(&dev->mt76);
@@ -312,11 +316,20 @@ static int mt7921u_suspend(struct usb_interface *intf, pm_message_t state)
 	set_bit(MT76_STATE_SUSPEND, &dev->mphy.state);
 
 	return 0;
+
+failed:
+	pm->suspended = false;
+
+	if (err < 0)
+		mt7921_reset(&dev->mt76);
+
+	return err;
 }
 
 static int mt7921u_resume(struct usb_interface *intf)
 {
 	struct mt7921_dev *dev = usb_get_intfdata(intf);
+	struct mt76_connac_pm *pm = &dev->pm;
 	bool reinit = true;
 	int err, i;
 
@@ -338,16 +351,23 @@ static int mt7921u_resume(struct usb_interface *intf)
 	if (reinit || mt7921_dma_need_reinit(dev)) {
 		err = mt7921u_dma_init(dev, true);
 		if (err)
-			return err;
+			goto failed;
 	}
 
 	clear_bit(MT76_STATE_SUSPEND, &dev->mphy.state);
 
 	err = mt76u_resume_rx(&dev->mt76);
 	if (err < 0)
-		return err;
+		goto failed;
+
+	err = mt76_connac_mcu_set_hif_suspend(&dev->mt76, false);
+failed:
+	pm->suspended = false;
+
+	if (err < 0)
+		mt7921_reset(&dev->mt76);
 
-	return mt76_connac_mcu_set_hif_suspend(&dev->mt76, false);
+	return err;
 }
 #endif /* CONFIG_PM */
 
-- 
2.35.1



