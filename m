Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32761655084
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 13:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbiLWMl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 07:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236401AbiLWMlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 07:41:31 -0500
Received: from factor-ts.ru (mail.factor-ts.ru [194.154.76.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDF23B419
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 04:41:14 -0800 (PST)
Received: from localhost.localdomain (unknown [89.23.32.60])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by factor-ts.ru (Postfix) with ESMTPSA id 29B645EF1319;
        Fri, 23 Dec 2022 15:34:26 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=factor-ts.ru; s=555;
        t=1671798866; bh=a0RwqdTbWjf1b0gaYHGDT6knqvCVKW14bBvv1WhGNos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CcKddo/fOm0FwchdLmT6zckhlWnwOS0eiIa8khNK2HXjcr7TkhINYl9eEnDpMkaiQ
         Q8PvkqFMlhI768NoDeZBlxQ2v3gw9xXrf5aE6c+4k2ds15LSESyC5vXGDSXVomTUws
         PehJaq+Ie4Lfiwf85yIb07LClrJRHNys+Cy5WkF4=
From:   Semyon Verchenko <semverchenko@factor-ts.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Semyon Verchenko <semverchenko@factor-ts.ru>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 2/2] wifi: rtlwifi: 8192de: correct checking of IQK reload
Date:   Fri, 23 Dec 2022 15:34:16 +0300
Message-Id: <20221223123416.71557-3-semverchenko@factor-ts.ru>
In-Reply-To: <20221223123416.71557-1-semverchenko@factor-ts.ru>
References: <20221223123416.71557-1-semverchenko@factor-ts.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MailScanner-ID: 29B645EF1319.A0E3F
X-MailScanner: Found to be clean
X-MailScanner-From: semverchenko@factor-ts.ru
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

commit 93fbc1ebd978cf408ef5765e9c1630fce9a8621b upstream

Since IQK could spend time, we make a cache of IQK result matrix that looks
like iqk_matrix[channel_idx].val[x][y], and we can reload the matrix if we
have made a cache. To determine a cache is made, we check
iqk_matrix[channel_idx].val[0][0].

The initial commit 7274a8c22980 ("rtlwifi: rtl8192de: Merge phy routines")
make a mistake that checks incorrect iqk_matrix[channel_idx].val[0] that
is always true, and this mistake is found by commit ee3db469dd31
("wifi: rtlwifi: remove always-true condition pointed out by GCC 12"), so
I recall the vendor driver to find fix and apply the correctness.

Fixes: 7274a8c22980 ("rtlwifi: rtl8192de: Merge phy routines")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Semyon Verchenko <semverchenko@factor-ts.ru>
Link: https://lore.kernel.org/r/20220801113345.42016-1-pkshih@realtek.com
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index d8a57e96a92f..d3027f8fbd38 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2385,11 +2385,10 @@ void rtl92d_phy_reload_iqk_setting(struct ieee80211_hw *hw, u8 channel)
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Just Read IQK Matrix reg for channel:%d....\n",
 				channel);
-			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
-					rtlphy->iqk_matrix[
-					indexforchannel].value,	0,
-					(rtlphy->iqk_matrix[
-					indexforchannel].value[0][2] == 0));
+			if (rtlphy->iqk_matrix[indexforchannel].value[0][0] != 0)
+				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+					rtlphy->iqk_matrix[indexforchannel].value, 0,
+					rtlphy->iqk_matrix[indexforchannel].value[0][2] == 0);
 			if (IS_92D_SINGLEPHY(rtlhal->version)) {
 				if ((rtlphy->iqk_matrix[
 					indexforchannel].value[0][4] != 0)
-- 
2.38.1

