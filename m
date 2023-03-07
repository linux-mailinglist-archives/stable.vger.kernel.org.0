Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147AF6AEE2D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjCGSKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjCGSJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37F5A3B42
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:04:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FA30B819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD5CC433D2;
        Tue,  7 Mar 2023 18:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212244;
        bh=jCRDyrOqSSYV9h9C9cXC43VRp+pQ1SJS4AyC4c+vCtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPLiLdPbfbUYB9akv4CybYmICG8+o9pXu0Oc4nbExSILInEfh+F23C1H6iB8zWWHU
         wyCT48zhFnmyqKxJVHWbE8Enc9dBGR2v7L1j+3fDJmqQ5jmRgy0IOOZVwFRjfVf7l+
         u6gxBwdcIQKP+ZMc6NI+W9MME06u+u5C4aIe9FXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/885] wifi: rtw89: 8852c: rfk: correct DACK setting
Date:   Tue,  7 Mar 2023 17:50:58 +0100
Message-Id: <20230307170007.227164612@linuxfoundation.org>
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
index 006c2cf931116..6387c834a73da 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
@@ -338,7 +338,7 @@ static void _dack_reload_by_path(struct rtw89_dev *rtwdev,
 		(dack->dadck_d[path][index] << 14);
 	addr = 0xc210 + offset;
 	rtw89_phy_write32(rtwdev, addr, val32);
-	rtw89_phy_write32_set(rtwdev, addr, BIT(1));
+	rtw89_phy_write32_set(rtwdev, addr, BIT(0));
 }
 
 static void _dack_reload(struct rtw89_dev *rtwdev, enum rtw89_rf_path path)
-- 
2.39.2



