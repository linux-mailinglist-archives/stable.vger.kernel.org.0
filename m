Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D495740E441
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243906AbhIPQ4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346407AbhIPQyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:54:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCDBA613CD;
        Thu, 16 Sep 2021 16:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809821;
        bh=PkHgKvoyfPY4SUoPcVWWAVmKs/676bv9UplHgoqlefg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvAdVXzEVW5sAMKs+dons7cC3es01R2IKNS5u9nQBhGV4AiZjpPwjHoCmYGXhUP8a
         P0ZDU2yjC3yW5qC+MwI6IWBozwON1GHvlkgOvHToRhehw3grRBO/pff7rq0YNsnZjL
         w5BC8um3UC5eAEkqoaNlHd6lwOT2+5Z8t5OXUaeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chin-Yen Lee <timlee@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 296/380] rtw88: use read_poll_timeout instead of fixed sleep
Date:   Thu, 16 Sep 2021 18:00:53 +0200
Message-Id: <20210916155814.129903489@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 02a55c0009a55b204e1e5c17295431f0a9e7d3b6 ]

In current wow flow, driver calls rtw_wow_fw_start and sleep for 100ms,
to wait firmware finish preliminary work and then update the value of
WOWLAN_WAKE_REASON register to zero. But later firmware will start wow
function with power-saving mode, in which mode the value of
WOWLAN_WAKE_REASON register is 0xea. So driver may get 0xea value and
return fail. We use read_poll_timeout instead to check the value to avoid
this issue.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210728014335.8785-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/wow.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/wow.c b/drivers/net/wireless/realtek/rtw88/wow.c
index fc9544f4e5e4..bdccfa70dddc 100644
--- a/drivers/net/wireless/realtek/rtw88/wow.c
+++ b/drivers/net/wireless/realtek/rtw88/wow.c
@@ -283,15 +283,26 @@ static void rtw_wow_rx_dma_start(struct rtw_dev *rtwdev)
 
 static int rtw_wow_check_fw_status(struct rtw_dev *rtwdev, bool wow_enable)
 {
-	/* wait 100ms for wow firmware to finish work */
-	msleep(100);
+	int ret;
+	u8 check;
+	u32 check_dis;
 
 	if (wow_enable) {
-		if (rtw_read8(rtwdev, REG_WOWLAN_WAKE_REASON))
+		ret = read_poll_timeout(rtw_read8, check, !check, 1000,
+					100000, true, rtwdev,
+					REG_WOWLAN_WAKE_REASON);
+		if (ret)
 			goto wow_fail;
 	} else {
-		if (rtw_read32_mask(rtwdev, REG_FE1IMR, BIT_FS_RXDONE) ||
-		    rtw_read32_mask(rtwdev, REG_RXPKT_NUM, BIT_RW_RELEASE))
+		ret = read_poll_timeout(rtw_read32_mask, check_dis,
+					!check_dis, 1000, 100000, true, rtwdev,
+					REG_FE1IMR, BIT_FS_RXDONE);
+		if (ret)
+			goto wow_fail;
+		ret = read_poll_timeout(rtw_read32_mask, check_dis,
+					!check_dis, 1000, 100000, false, rtwdev,
+					REG_RXPKT_NUM, BIT_RW_RELEASE);
+		if (ret)
 			goto wow_fail;
 	}
 
-- 
2.30.2



