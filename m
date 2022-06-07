Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A1541AD9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380366AbiFGVjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380521AbiFGViO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:38:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2DE23146E;
        Tue,  7 Jun 2022 12:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9BD0B822C0;
        Tue,  7 Jun 2022 19:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454E1C385A2;
        Tue,  7 Jun 2022 19:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628714;
        bh=Ia8YhthTXwo6lCDBIdkcLlJtmZlqWo/5RO+MA5OekTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHbetf2SgL18cj1HMeyEr2V+WMW80yVoRLdODGYPb00yLwLYz8rrAh2w0ogBc5Hk5
         rYCG9+EehQVZMG6JALNwZ1rKbJw3D1m9tew/xCdGUjQO18BxchfMkIoIOnU49i9uG/
         LxLi2rT591qZV9Utuk4j0U0jaNaWp+WHXqJCH5h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 430/879] mt76: mt7921: honor pm user configuration in mt7921_sniffer_interface_iter
Date:   Tue,  7 Jun 2022 18:59:08 +0200
Message-Id: <20220607165015.350066658@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 47eea8ad62a1203ce20b365f7feba23fef62a487 ]

Honor runtime-pm user configuration in mt7921_sniffer_interface_iter
routine if we do not have a monitor interface.

Fixes: 1f12fa34e5dc5 ("mt76: mt7921: don't enable beacon filter when IEEE80211_CONF_CHANGE_MONITOR is set")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index fdaf2451bc1d..11472aaf1440 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -489,8 +489,8 @@ mt7921_sniffer_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	bool monitor = !!(hw->conf.flags & IEEE80211_CONF_MONITOR);
 
 	mt7921_mcu_set_sniffer(dev, vif, monitor);
-	pm->enable = !monitor;
-	pm->ds_enable = !monitor;
+	pm->enable = pm->enable_user && !monitor;
+	pm->ds_enable = pm->ds_enable_user && !monitor;
 
 	mt76_connac_mcu_set_deep_sleep(&dev->mt76, pm->ds_enable);
 
-- 
2.35.1



