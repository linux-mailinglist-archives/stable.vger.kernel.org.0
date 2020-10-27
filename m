Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA40529B912
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802178AbgJ0Ppz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798582AbgJ0P25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7237222C8;
        Tue, 27 Oct 2020 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812535;
        bh=UWr4wPpyxu7N3R5jCcmk+38FTMkchOt8V9CBURqwrXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmcZUbk8iz9c8Mta51UYDzQi1bFMKgOx/jRj1nR76w/86cKeLUvsmIZn6F08VBp4H
         j4FAaYgXSItyw8SSuG9Jok38oikPJWay5h9y1HPgz7pu97HaiUtGW5goJfv6SAZStc
         Tl+2cQ3wd9igTckhAMHmqpCfemat6Xo6FnI4wz1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 212/757] rtw88: dont treat NULL pointer as an array
Date:   Tue, 27 Oct 2020 14:47:42 +0100
Message-Id: <20201027135500.561319970@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 22b726cbdd09d9891ede8aa122a950d2d0ae5e09 ]

I'm not a standards expert, but this really looks to be undefined
behavior, when chip->dig_cck may be NULL. (And, we're trying to do a
NULL check a few lines down, because some chip variants will use NULL.)

Fixes: fc637a860a82 ("rtw88: 8723d: Set IG register for CCK rate")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200821211716.1631556-1-briannorris@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 8d93f31597469..9687b376d221b 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -147,12 +147,13 @@ void rtw_phy_dig_write(struct rtw_dev *rtwdev, u8 igi)
 {
 	struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_hal *hal = &rtwdev->hal;
-	const struct rtw_hw_reg *dig_cck = &chip->dig_cck[0];
 	u32 addr, mask;
 	u8 path;
 
-	if (dig_cck)
+	if (chip->dig_cck) {
+		const struct rtw_hw_reg *dig_cck = &chip->dig_cck[0];
 		rtw_write32_mask(rtwdev, dig_cck->addr, dig_cck->mask, igi >> 1);
+	}
 
 	for (path = 0; path < hal->rf_path_num; path++) {
 		addr = chip->dig[path].addr;
-- 
2.25.1



