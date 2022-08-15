Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09DA59414B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240692AbiHOVJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347956AbiHOVHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D681F52DCC;
        Mon, 15 Aug 2022 12:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83D65B810C6;
        Mon, 15 Aug 2022 19:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C43C433C1;
        Mon, 15 Aug 2022 19:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591021;
        bh=ZUY3aye9XfntD/W1LptzNAeuGwjfjNeNEbwzMypK0Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUUFeIiuOYFmH46F8h2OuKFsF0+J6Y522Uv5GyRXgyUD18/Uk07lx8DvnpJ43qFpp
         tdcjyas4TjBY0YERYxXR1wJ13Q0Itqw+Uk4nEcc/lxeZARWC12gBaW351+xZGLfFoR
         Emp8j6k0TbAErqBh1asNZqJd8TSV130XTk+Q4kWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0447/1095] mt76: mt7921: enlarge maximum VHT MPDU length to 11454
Date:   Mon, 15 Aug 2022 19:57:26 +0200
Message-Id: <20220815180448.121058796@linuxfoundation.org>
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

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 31f3248a75932b111bc90c66b1f6c7d89eedca8e ]

Enlarge maximum MPDU length to 11454 that both mt7921/mt7922 can support.
After this fixing, we can get better performance.

Fixes: 5c14a5f944b9 ("mt76: mt7921: introduce mt7921e support")
Tested-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 2fb2a6295c06..37453e1c136f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -291,7 +291,7 @@ int mt7921_register_device(struct mt7921_dev *dev)
 			IEEE80211_HT_CAP_LDPC_CODING |
 			IEEE80211_HT_CAP_MAX_AMSDU;
 	dev->mphy.sband_5g.sband.vht_cap.cap |=
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 |
+			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
 			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK |
 			IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
 			IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE |
-- 
2.35.1



