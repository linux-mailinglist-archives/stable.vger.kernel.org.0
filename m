Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A363594A1F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355451AbiHOX4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355304AbiHOXvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:51:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C92891D1A;
        Mon, 15 Aug 2022 13:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 095796069F;
        Mon, 15 Aug 2022 20:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C064C433D6;
        Mon, 15 Aug 2022 20:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594587;
        bh=UiwS0woC9t2O9OGl5uIZCvA0IgPGyEzpElFJIVaIBUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1nAOoezASS226ihH4SN0jfdsOdyUk9VRV8UYeALoo+lSU9Hd5JLC7SLZSsRTiObZ
         3amKQsTclMIdxeYjhnyo/Zp1qAm+ui4b418OotBaSmKdLsD622TSMc8ZV8mlQqe5U3
         plN+NcCsV4cWhttA42JKXDqeiKO7alBOAPLnmv0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0478/1157] mt76: mt7921s: fix possible sdio deadlock in command fail
Date:   Mon, 15 Aug 2022 19:57:14 +0200
Message-Id: <20220815180458.747796390@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 364718c94ac2ea4e51958ac0aa15c9092c785a3a ]

Move sdio_release_host() to final resource handing

Fixes: b12deb5e86fa ("mt76: mt7921s: fix mt7921s_mcu_[fw|drv]_pmctrl")
Reported-by: YN Chen <YN.Chen@mediatek.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c
index 54a5c712a3c3..c572a3107b8b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c
@@ -136,8 +136,8 @@ int mt7921s_mcu_fw_pmctrl(struct mt7921_dev *dev)
 	struct sdio_func *func = dev->mt76.sdio.func;
 	struct mt76_phy *mphy = &dev->mt76.phy;
 	struct mt76_connac_pm *pm = &dev->pm;
-	int err = 0;
 	u32 status;
+	int err;
 
 	sdio_claim_host(func);
 
@@ -148,7 +148,7 @@ int mt7921s_mcu_fw_pmctrl(struct mt7921_dev *dev)
 					 2000, 1000000);
 		if (err < 0) {
 			dev_err(dev->mt76.dev, "mailbox ACK not cleared\n");
-			goto err;
+			goto out;
 		}
 	}
 
@@ -156,18 +156,18 @@ int mt7921s_mcu_fw_pmctrl(struct mt7921_dev *dev)
 
 	err = readx_poll_timeout(mt76s_read_pcr, &dev->mt76, status,
 				 !(status & WHLPCR_IS_DRIVER_OWN), 2000, 1000000);
+out:
 	sdio_release_host(func);
 
-err:
 	if (err < 0) {
 		dev_err(dev->mt76.dev, "firmware own failed\n");
 		clear_bit(MT76_STATE_PM, &mphy->state);
-		err = -EIO;
+		return -EIO;
 	}
 
 	pm->stats.last_doze_event = jiffies;
 	pm->stats.awake_time += pm->stats.last_doze_event -
 				pm->stats.last_wake_event;
 
-	return err;
+	return 0;
 }
-- 
2.35.1



