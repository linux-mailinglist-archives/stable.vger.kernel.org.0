Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94884F32BC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242732AbiDEJiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236480AbiDEJDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:03:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5D711C06;
        Tue,  5 Apr 2022 01:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6902B81C15;
        Tue,  5 Apr 2022 08:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1F4C385A0;
        Tue,  5 Apr 2022 08:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148882;
        bh=mPVrZdRJ9e3MIMaNoTtfRmSysmhMmo05jO1t2TBd+Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWapMY3HxprYp+Q/91gZyl/qfS9vOAEDZCXUk3KwXyWiQfFlchso8uv+a7RgZwHSo
         eLn7NhFJmapHghcT6lezybzrH9ocw3LLFUp8v1lIdP3y2C4T0d6Zb3R9D2pCsTDI96
         uTzoZBkEVgIlpI2x6uZQU4xABXFziY2dYIytgG/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        MeiChia Chiu <meichia.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0467/1017] mt76: mt7915: fix the nss setting in bitrates
Date:   Tue,  5 Apr 2022 09:23:00 +0200
Message-Id: <20220405070408.160948329@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: MeiChia Chiu <meichia.chiu@mediatek.com>

[ Upstream commit c41d2a075206fcbdc89695b874a6ac06160b4f1a ]

without this change, the fixed MCS only supports 1 Nss.

Fixes: 70fd1333cd32f ("mt76: mt7915: rework .set_bitrate_mask() to support more options")
Reviewed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: MeiChia Chiu <meichia.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index ef8b0d0a05ef..21fbe7a6141f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2124,9 +2124,12 @@ mt7915_mcu_add_rate_ctrl_fixed(struct mt7915_dev *dev,
 			phy.sgi |= gi << (i << (_he));				\
 			phy.he_ltf |= mask->control[band].he_ltf << (i << (_he));\
 		}								\
-		for (i = 0; i < ARRAY_SIZE(mask->control[band]._mcs); i++) 	\
-			nrates += hweight16(mask->control[band]._mcs[i]);  	\
-		phy.mcs = ffs(mask->control[band]._mcs[0]) - 1;			\
+		for (i = 0; i < ARRAY_SIZE(mask->control[band]._mcs); i++) {	\
+			if (!mask->control[band]._mcs[i])			\
+				continue;					\
+			nrates += hweight16(mask->control[band]._mcs[i]);	\
+			phy.mcs = ffs(mask->control[band]._mcs[i]) - 1;		\
+		}								\
 	} while (0)
 
 	if (sta->he_cap.has_he) {
-- 
2.34.1



