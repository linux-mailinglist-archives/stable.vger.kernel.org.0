Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3AF6AE914
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjCGRUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjCGRU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:20:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A227F8F523
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:15:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3940F61507
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E58C433EF;
        Tue,  7 Mar 2023 17:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209346;
        bh=fONHSEAlLOrS1Xc1Au/IJvgYRT/LIXGvYwCNt01SwxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvmSIgB/jdQk4GqkUFgmcruacih78+ZHNcYop1y9vy7Z7Bar5um/Qn8sXU0iy7/D1
         8RBRUxdRonSHbSwLJVKnDfUH9HJ/cZN501C5QR86pbd71n7dnm7DlqtD4PRZkLO+wJ
         p/xkTjM5hxb8L/b/zQ5m710DVb/1PA3iWBVb5PRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0157/1001] wifi: rtw89: 8852c: rfk: correct DACK setting
Date:   Tue,  7 Mar 2023 17:48:49 +0100
Message-Id: <20230307170028.867195140@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit b2bab7b14098dcf5d405fa8c76b2c3f6ce9184f9 ]

After filling calibration parameters, set BIT(0) to enable the hardware
circuit, but original set incorrect bit that affects a little TX
performance.

Fixes: 76599a8d0b7d ("rtw89: 8852c: rfk: add DACK")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221209020940.9573-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
index 60cd676fe22c9..f5b0b57f33207 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
@@ -337,7 +337,7 @@ static void _dack_reload_by_path(struct rtw89_dev *rtwdev,
 		(dack->dadck_d[path][index] << 14);
 	addr = 0xc210 + offset;
 	rtw89_phy_write32(rtwdev, addr, val32);
-	rtw89_phy_write32_set(rtwdev, addr, BIT(1));
+	rtw89_phy_write32_set(rtwdev, addr, BIT(0));
 }
 
 static void _dack_reload(struct rtw89_dev *rtwdev, enum rtw89_rf_path path)
-- 
2.39.2



