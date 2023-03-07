Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F506AEE2E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbjCGSKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCGSJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E74A2C12
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:04:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7DB66151D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4E4C4339C;
        Tue,  7 Mar 2023 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212247;
        bh=2YKSoMO+LOdmd6bfdP1j342fCHRATHLvztW+3FHeze0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jgVMZ5wGXfN1b33ZI13UKf4G5srVEJFEZ+muftrEtU8oE+zNj/h+k6o7PySJga3B
         2y3YXZHP7t3EBZBiip8hnntkQDqoGhCzLDkHLj8ITjvjyHaRfsfGevPkWdrHd57ocl
         fWmdAvYpNt4gadV4jH/hrkENUw5WfwzVo0C8U4so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/885] wifi: rtw89: 8852c: rfk: correct DPK settings
Date:   Tue,  7 Mar 2023 17:50:59 +0100
Message-Id: <20230307170007.266643911@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 21b5f159a2ee47d30f418559f6ece0088c80199f ]

Some DPK settings are wrong, and causes bad TX performance occasionally.
So, fix them by internal suggestions.

Fixes: da4cea16cb13 ("rtw89: 8852c: rfk: add DPK")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221209020940.9573-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/reg.h          | 2 ++
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c | 9 ++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index ca20bb024b407..0291aff940166 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -3374,6 +3374,8 @@
 #define RR_TXRSV_GAPK BIT(19)
 #define RR_BIAS 0x5e
 #define RR_BIAS_GAPK BIT(19)
+#define RR_TXAC 0x5f
+#define RR_TXAC_IQG GENMASK(3, 0)
 #define RR_BIASA 0x60
 #define RR_BIASA_TXG GENMASK(15, 12)
 #define RR_BIASA_TXA GENMASK(19, 16)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
index 6387c834a73da..98428f17814f5 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
@@ -1873,12 +1873,11 @@ static void _dpk_rf_setting(struct rtw89_dev *rtwdev, u8 gain,
 			       0x50101 | BIT(rtwdev->dbcc_en));
 		rtw89_write_rf(rtwdev, path, RR_MOD_V1, RR_MOD_MASK, RF_DPK);
 
-		if (dpk->bp[path][kidx].band == RTW89_BAND_6G && dpk->bp[path][kidx].ch >= 161) {
+		if (dpk->bp[path][kidx].band == RTW89_BAND_6G && dpk->bp[path][kidx].ch >= 161)
 			rtw89_write_rf(rtwdev, path, RR_IQGEN, RR_IQGEN_BIAS, 0x8);
-			rtw89_write_rf(rtwdev, path, RR_LOGEN, RR_LOGEN_RPT, 0xd);
-		} else {
-			rtw89_write_rf(rtwdev, path, RR_LOGEN, RR_LOGEN_RPT, 0xd);
-		}
+
+		rtw89_write_rf(rtwdev, path, RR_LOGEN, RR_LOGEN_RPT, 0xd);
+		rtw89_write_rf(rtwdev, path, RR_TXAC, RR_TXAC_IQG, 0x8);
 
 		rtw89_write_rf(rtwdev, path, RR_RXA2, RR_RXA2_ATT, 0x0);
 		rtw89_write_rf(rtwdev, path, RR_TXIQK, RR_TXIQK_ATT2, 0x3);
-- 
2.39.2



