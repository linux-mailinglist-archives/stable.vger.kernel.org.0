Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0094D604244
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbiJSK5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiJSK4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:56:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A47D2CD5;
        Wed, 19 Oct 2022 03:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF064B824A8;
        Wed, 19 Oct 2022 09:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B83CC433D6;
        Wed, 19 Oct 2022 09:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170504;
        bh=xtM5s+f3529j7nQlyo4YPIfMABIDOHknGrVRtsueMpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDTwW+07U3G+7kEbANJmwQ5E8u1Bg6O5yL5UpcH1ZMjS3VjdVMivFdP4Y4lOsAAXr
         1b8QQm6WM9//uOpXhWjI52uyJN1vv4Wc4KhV5o10bLHP8oOkLfNzjtzdHRM2aVd/G3
         yf5qUo/Idnkp6F+ZkvM3EM+QoKTFZY00gznAjWHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 681/862] wifi: rtw88: phy: fix warning of possible buffer overflow
Date:   Wed, 19 Oct 2022 10:32:48 +0200
Message-Id: <20221019083320.063888989@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 86331c7e0cd819bf0c1d0dcf895e0c90b0aa9a6f ]

reported by smatch

phy.c:854 rtw_phy_linear_2_db() error: buffer overflow 'db_invert_table[i]'
8 <= 8 (assuming for loop doesn't break)

However, it seems to be a false alarm because we prevent it originally via
       if (linear >= db_invert_table[11][7])
               return 96; /* maximum 96 dB */

Still, we adjust the code to be more readable and avoid smatch warning.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220727065003.28340-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 8982e0c98dac..da1efec0aa85 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -816,23 +816,18 @@ static u8 rtw_phy_linear_2_db(u64 linear)
 	u8 j;
 	u32 dB;
 
-	if (linear >= db_invert_table[11][7])
-		return 96; /* maximum 96 dB */
-
 	for (i = 0; i < 12; i++) {
-		if (i <= 2 && (linear << FRAC_BITS) <= db_invert_table[i][7])
-			break;
-		else if (i > 2 && linear <= db_invert_table[i][7])
-			break;
+		for (j = 0; j < 8; j++) {
+			if (i <= 2 && (linear << FRAC_BITS) <= db_invert_table[i][j])
+				goto cnt;
+			else if (i > 2 && linear <= db_invert_table[i][j])
+				goto cnt;
+		}
 	}
 
-	for (j = 0; j < 8; j++) {
-		if (i <= 2 && (linear << FRAC_BITS) <= db_invert_table[i][j])
-			break;
-		else if (i > 2 && linear <= db_invert_table[i][j])
-			break;
-	}
+	return 96; /* maximum 96 dB */
 
+cnt:
 	if (j == 0 && i == 0)
 		goto end;
 
-- 
2.35.1



