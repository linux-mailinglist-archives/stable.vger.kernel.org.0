Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F5B246C13
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbgHQQJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388485AbgHQQI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:08:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EBDA22CAE;
        Mon, 17 Aug 2020 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680535;
        bh=p6srLh1mO7qTqUiHJN5XSOb7Rqkscs42yAAUQYlVUcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leH3YKXJwE4BzZkmuL56Re8kgWaFT289355CLHTQj2XyRtBPIoQU5J7wXxXxBJM5V
         LrL4tMte1qOVlfjjcTfd5o13v+Aub2M4O3zMXzjJ1zgLR0dKmSvYufljEaGVjHHAZW
         0EDA5gmqztJlnfREu797aUwvCKK3D0uKOrIbO00U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/270] rtw88: coex: only skip coex triggered by BT info
Date:   Mon, 17 Aug 2020 17:16:36 +0200
Message-Id: <20200817143805.505591723@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

[ Upstream commit 3f194bd4ca1cd9b8eef34d37d562279dbeb80319 ]

The coex mechanism used to skip upon the freeze flag is raised.
That will cause the coex mechanism being skipped unexpectedly.
Coex only wanted to keep the TDMA table from being changed by
BT side.

So, check the freeze and reason, if the coex reason is coming
from BT info, skip it, to make sure the coex triggered by Wifi
itself can work.

This is required for the AP mode, while the control flow is
different with STA mode. When starting an AP mode, the AP mode
needs to start working immedaitely after leaving IPS, and the
freeze flag could be raised. If the coex info is skipped, then
the AP mode will not set the antenna owner, leads to TX stuck.

Fixes: 4136214f7c46 ("rtw88: add BT co-existence support")
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200717064937.27966-5-yhchuang@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 3e95ad1989123..853ac1c2ed73c 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -1923,7 +1923,8 @@ static void rtw_coex_run_coex(struct rtw_dev *rtwdev, u8 reason)
 	if (coex_stat->wl_under_ips)
 		return;
 
-	if (coex->freeze && !coex_stat->bt_setup_link)
+	if (coex->freeze && coex_dm->reason == COEX_RSN_BTINFO &&
+	    !coex_stat->bt_setup_link)
 		return;
 
 	coex_stat->cnt_wl[COEX_CNT_WL_COEXRUN]++;
-- 
2.25.1



