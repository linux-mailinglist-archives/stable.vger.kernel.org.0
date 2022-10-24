Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3770A60AB43
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiJXNrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiJXNqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F6452808;
        Mon, 24 Oct 2022 05:40:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A651612B9;
        Mon, 24 Oct 2022 12:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BED9C433D6;
        Mon, 24 Oct 2022 12:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615177;
        bh=A7BlILwg72M1EmbA1f/X+SRvG6p9eP2j0ab0qNOaeAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmWysIoGES3QlQ8HAaQe/hLOOY3DZTsBhRhTXc3BLG2Z2v29vbZP8mlm5UOpc8TCI
         DHazDQZ47mIHU99FPWHjHLggNzeWrGEXj2h7pYGlt95ijXhSSsC8MvuEtXmcCVg4Qb
         MQcCzJ1OFUxkwmRBdLCp6Pbe4vehqZMn7Gn9x4NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/530] wifi: rtlwifi: 8192de: correct checking of IQK reload
Date:   Mon, 24 Oct 2022 13:28:15 +0200
Message-Id: <20221024113051.900839576@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 93fbc1ebd978cf408ef5765e9c1630fce9a8621b ]

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
Link: https://lore.kernel.org/r/20220801113345.42016-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 743e38a1aa51..4d153bd62c53 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2386,11 +2386,10 @@ void rtl92d_phy_reload_iqk_setting(struct ieee80211_hw *hw, u8 channel)
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
2.35.1



