Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15C349A38F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387037AbiAXX7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846417AbiAXXPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6ECC0604D4;
        Mon, 24 Jan 2022 13:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45C0CB81057;
        Mon, 24 Jan 2022 21:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B06C340E4;
        Mon, 24 Jan 2022 21:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059480;
        bh=s5IjFqMJ/dT0kIt8h9WrHQlrzu3r9T+bGFdI2o8kycU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faStgG3usJ/cAuKUTaCxnkhU0DChE5nEKJTr+TmFPi7QDGqs0jpdB5NavhR6aYywA
         uPZvHJlXTxMUDV64v4cCW8sZLoIyRwzSzyGAy3UP8Aye23iqBjGnCai0L9e7XS7PCr
         kTKZbWor4xBVieC93suXk0U2kyFqIZ/mTwegVmbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0630/1039] rtw89: dont kick off TX DMA if failed to write skb
Date:   Mon, 24 Jan 2022 19:40:19 +0100
Message-Id: <20220124184146.526481637@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit a58fdb7c843a37d6598204c6513961feefdadc6a ]

This is found by Smatch static checker warning:
	drivers/net/wireless/realtek/rtw89/mac80211.c:31 rtw89_ops_tx()
	error: uninitialized symbol 'qsel'.

The warning is because 'qsel' isn't filled by rtw89_core_tx_write() due to
failed to write. The way to fix it is to avoid kicking off TX DMA, so add
'return' to the failure case.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211201093816.13806-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 16dc6fb7dbb0b..e9d61e55e2d92 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -27,6 +27,7 @@ static void rtw89_ops_tx(struct ieee80211_hw *hw,
 	if (ret) {
 		rtw89_err(rtwdev, "failed to transmit skb: %d\n", ret);
 		ieee80211_free_txskb(hw, skb);
+		return;
 	}
 	rtw89_core_tx_kick_off(rtwdev, qsel);
 }
-- 
2.34.1



