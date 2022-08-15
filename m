Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB15940BD
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243106AbiHOVJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbiHOVHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095B22D1F0;
        Mon, 15 Aug 2022 12:16:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B934FB81106;
        Mon, 15 Aug 2022 19:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05348C433C1;
        Mon, 15 Aug 2022 19:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591011;
        bh=tM4SDSdgsL1BoKw3VU2X2UxP5u4uYpyQPMV0hmBuJvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FReGgXUZu2H0cRIMvzX6om+oIyiRk5/oWZC3m78BQK4UalR4ck87r4tx3Khi7lDKN
         SbXkDRejjqXWS4nsUPMGW/U0ekb44CrU7IEkNxnVOOjOD5E216Sd39J7L4dGuV7Avy
         cs/tLcx0IgnOq4XUIujcDzkJHqNI+pHYlxf2GBiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0444/1095] mt76: mt7921: do not update pm states in case of error
Date:   Mon, 15 Aug 2022 19:57:23 +0200
Message-Id: <20220815180448.008789243@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit f4a92547fb9818ff272e1e2f0c79cd6b0bc99ce8 ]

Do not update pm stats if mt7921e_mcu_fw_pmctrl routine returns an
error.

Fixes: 36873246f78a2 ("mt76: mt7921: add awake and doze time accounting")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
index 36669e5aeef3..a1ab5f878f81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
@@ -102,7 +102,7 @@ int mt7921e_mcu_fw_pmctrl(struct mt7921_dev *dev)
 {
 	struct mt76_phy *mphy = &dev->mt76.phy;
 	struct mt76_connac_pm *pm = &dev->pm;
-	int i, err = 0;
+	int i;
 
 	for (i = 0; i < MT7921_DRV_OWN_RETRY_COUNT; i++) {
 		mt76_wr(dev, MT_CONN_ON_LPCTL, PCIE_LPCR_HOST_SET_OWN);
@@ -114,12 +114,12 @@ int mt7921e_mcu_fw_pmctrl(struct mt7921_dev *dev)
 	if (i == MT7921_DRV_OWN_RETRY_COUNT) {
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



