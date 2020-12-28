Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210AD2E65D9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389663AbgL1QFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389569AbgL1N10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:27:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E1AE206ED;
        Mon, 28 Dec 2020 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162030;
        bh=qkRseBJl7SByPdHgqiMBf708T2Qvanoo5HpUnPtWgMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDLJ9WHKXS1x7lgloCJbj3bFF87nib79f+LljkKlAo8+2aed7T5aua2xU01h5rS+F
         OWeWJRweNAmY+rAC18aOZTJtJWD8HMvZYI/EtwtKe/j533N+mV2eUmPj2TcUUA8mPx
         w6v5yBIL79v7Z+5DGFoXLgNA2DcOFUvG7TLCGlPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 165/346] cw1200: fix missing destroy_workqueue() on error in cw1200_init_common
Date:   Mon, 28 Dec 2020 13:48:04 +0100
Message-Id: <20201228124927.768078443@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 7ec8a926188eb8e7a3cbaca43ec44f2d7146d71b ]

Add the missing destroy_workqueue() before return from
cw1200_init_common in the error handling case.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201119070842.1011-1-miaoqinglang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c
index c1608f0bf6d01..0c5a15e2b8f97 100644
--- a/drivers/net/wireless/st/cw1200/main.c
+++ b/drivers/net/wireless/st/cw1200/main.c
@@ -384,6 +384,7 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 				    CW1200_LINK_ID_MAX,
 				    cw1200_skb_dtor,
 				    priv)) {
+		destroy_workqueue(priv->workqueue);
 		ieee80211_free_hw(hw);
 		return NULL;
 	}
@@ -395,6 +396,7 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 			for (; i > 0; i--)
 				cw1200_queue_deinit(&priv->tx_queue[i - 1]);
 			cw1200_queue_stats_deinit(&priv->tx_queue_stats);
+			destroy_workqueue(priv->workqueue);
 			ieee80211_free_hw(hw);
 			return NULL;
 		}
-- 
2.27.0



