Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F396655083
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 13:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiLWMl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 07:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbiLWMlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 07:41:31 -0500
X-Greylist: delayed 406 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 04:41:15 PST
Received: from factor-ts.ru (mail.factor-ts.ru [194.154.76.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBE41A20A
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 04:41:14 -0800 (PST)
Received: from localhost.localdomain (unknown [89.23.32.60])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by factor-ts.ru (Postfix) with ESMTPSA id 04A795EF1301;
        Fri, 23 Dec 2022 15:34:25 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=factor-ts.ru; s=555;
        t=1671798865; bh=tvkVsmXkci+t3wRMmCHYk05tm7ynOvn0hkJ2htiODu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kXesS9lHBv25n9KxVjUdUwCFXsWzmzF+5wIj+u42gyFpyTIDrPxotsAu4moWRvDt8
         2HHoVqtkifmcwR7JrIvPI9U7SxUyXFgCd/96Efm6y8tM61oUkDsugfSDnDQRIKu3Ue
         um93ilI+gvV4k4fnjBWgGPa9r1KxFXNWdqqIzoZE=
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
Subject: [PATCH 5.10 1/2] wifi: rtlwifi: remove always-true condition pointed out by GCC 12
Date:   Fri, 23 Dec 2022 15:34:15 +0300
Message-Id: <20221223123416.71557-2-semverchenko@factor-ts.ru>
In-Reply-To: <20221223123416.71557-1-semverchenko@factor-ts.ru>
References: <20221223123416.71557-1-semverchenko@factor-ts.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MailScanner-ID: 04A795EF1301.AFCB4
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

From: Jakub Kicinski <kuba@kernel.org>

commit ee3db469dd317e82f57b13aa3bc61be5cb60c2b4 upstream

The .value is a two-dim array, not a pointer.

struct iqk_matrix_regs {
	bool iqk_done;
        long value[1][IQK_MATRIX_REG_NUM];
};

Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Semyon Verchenko <semverchenko@factor-ts.ru>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index e34d33e73e52..d8a57e96a92f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2385,10 +2385,7 @@ void rtl92d_phy_reload_iqk_setting(struct ieee80211_hw *hw, u8 channel)
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Just Read IQK Matrix reg for channel:%d....\n",
 				channel);
-			if ((rtlphy->iqk_matrix[indexforchannel].
-			     value[0] != NULL)
-				/*&&(regea4 != 0) */)
-				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
 					rtlphy->iqk_matrix[
 					indexforchannel].value,	0,
 					(rtlphy->iqk_matrix[
-- 
2.38.1

