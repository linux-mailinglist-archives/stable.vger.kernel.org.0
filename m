Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD8C594870
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355355AbiHOXz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354773AbiHOXuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:50:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D0015858B;
        Mon, 15 Aug 2022 13:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BC95CE130B;
        Mon, 15 Aug 2022 20:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48F5C433C1;
        Mon, 15 Aug 2022 20:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594554;
        bh=tM4SDSdgsL1BoKw3VU2X2UxP5u4uYpyQPMV0hmBuJvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0POnYk1xFtVQ/IfU2aeTMogB2dhiZewBqnH7SrZ2GsNkS21x2s60Et0F6XrAXrxdA
         5CE62JTJNoglLP3xsDOYcO8LhDCBPniW57TDUuW55eWwsmV9UayekhZfwW5J0ypQ3F
         wQ1jKWd8W7484pa1HjvR27PWdM1swA3FOVCkW53c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0477/1157] mt76: mt7921: do not update pm states in case of error
Date:   Mon, 15 Aug 2022 19:57:13 +0200
Message-Id: <20220815180458.705456051@linuxfoundation.org>
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



