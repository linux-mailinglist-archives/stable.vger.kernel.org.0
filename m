Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF260B291
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiJXQuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbiJXQrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:47:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DB21ABA0A;
        Mon, 24 Oct 2022 08:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A872B81974;
        Mon, 24 Oct 2022 12:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D809C433C1;
        Mon, 24 Oct 2022 12:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615237;
        bh=kISgAwFe1gvG/v0nyJd99veHt8R86cBwD2RsH6xpSuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQpuN+ywwcpa/FqMfT+20/EufYJMQpiYw0BYoGdzq2c8r9rX7NZU/ga0zsccukpAb
         e4eauR36/KqV9lLNJfiIibBhMi3qGAIp+GsJ93KeyBMjQcfsYNEZ8ouaFHspNhYwc1
         dt+8Ia5hyaAK/O5vrzJL/a3IruWTzuAqCdSCuDKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/530] wifi: mt76: mt7615: add mt7615_mutex_acquire/release in mt7615_sta_set_decap_offload
Date:   Mon, 24 Oct 2022 13:28:39 +0200
Message-Id: <20221024113052.939971756@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 765c69d477a44c088e5d19e7758dfa4db418e3ba ]

Similar to mt7921 driver, introduce mt7615_mutex_acquire/release in
mt7615_sta_set_decap_offload in order to avoid sending mcu commands
while the device is in low-power state.

Fixes: d4b98c63d7a77 ("mt76: mt7615: add support for rx decapsulation offload")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 7c52a4d85cea..8f1338dae211 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -1186,12 +1186,16 @@ static void mt7615_sta_set_decap_offload(struct ieee80211_hw *hw,
 	struct mt7615_dev *dev = mt7615_hw_dev(hw);
 	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
 
+	mt7615_mutex_acquire(dev);
+
 	if (enabled)
 		set_bit(MT_WCID_FLAG_HDR_TRANS, &msta->wcid.flags);
 	else
 		clear_bit(MT_WCID_FLAG_HDR_TRANS, &msta->wcid.flags);
 
 	mt7615_mcu_set_sta_decap_offload(dev, vif, sta);
+
+	mt7615_mutex_release(dev);
 }
 
 #ifdef CONFIG_PM
-- 
2.35.1



