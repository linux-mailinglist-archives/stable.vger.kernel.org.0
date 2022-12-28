Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA81657DE7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiL1PsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiL1Prw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DFD178AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDD82B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3487BC433EF;
        Wed, 28 Dec 2022 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242469;
        bh=mENYC5g2HqOxzqqvRtFT3mgeP8kUvIJdOJhIm/iwziE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRdLnbL1KBatp9+0Bba2nPK6LMgpWWmkbi91srEcUxfxi8t9CO54QPFagLrvwgAJL
         uKEtEuZqaj0wsy4J7jBYi45oZlD5JrZdKhOrVx2hh8M8rMd3EYBfQvFQ/PK8X2W0b0
         EdgbN7z6VzZATT03SxX3aJicQo+LS6R5ufa/WYqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0373/1146] wifi: rtw89: fix physts IE page check
Date:   Wed, 28 Dec 2022 15:31:52 +0100
Message-Id: <20221228144340.294370748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 9e2f177de1bfb7d891bf38140bda54831ecef30d ]

The index RTW89_PHYSTS_BITMAP_NUM is not a valid physts IE page.
So, fix the check condition.

Fixes: eb4e52b3f38d ("rtw89: fix incorrect channel info during scan")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221118042322.26794-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index 6a6bdc652e09..c894a2b614eb 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3139,7 +3139,7 @@ void rtw89_phy_env_monitor_track(struct rtw89_dev *rtwdev)
 
 static bool rtw89_physts_ie_page_valid(enum rtw89_phy_status_bitmap *ie_page)
 {
-	if (*ie_page > RTW89_PHYSTS_BITMAP_NUM ||
+	if (*ie_page >= RTW89_PHYSTS_BITMAP_NUM ||
 	    *ie_page == RTW89_RSVD_9)
 		return false;
 	else if (*ie_page > RTW89_RSVD_9)
-- 
2.35.1



