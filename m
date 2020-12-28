Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE792E63D0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406391AbgL1Pmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404808AbgL1NpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6859A206D4;
        Mon, 28 Dec 2020 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163096;
        bh=rWnUtGOoQnQMfh4NLsRhKVZMXguWtpqYAnpN39lDTxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpRohaVjvgzEzSeibGD8lm2bTW4FfOlBwQPYR0x1aAngjVAZ/7QgMizQrBSLPAQIE
         DN2y9x/CjYImJFkLic4eKFHtFoBvjLgHUW1cwlLQgF+tctRU2FGTDNmJ5pTCc7VXce
         7yhHiGUzBqe9KmcZ/ESdf2HC4QROsm/VoJbT/1IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/453] rsi: fix error return code in rsi_reset_card()
Date:   Mon, 28 Dec 2020 13:46:42 +0100
Message-Id: <20201228124945.189610933@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit fb21d14694bd46a538258d86498736490b3ba855 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 17ff2c794f39 ("rsi: reset device changes for 9116")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1605582454-39649-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 30 +++++++++++++-------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 4b9e406b84612..a296f4e0d324a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -733,24 +733,24 @@ static int rsi_reset_card(struct rsi_hw *adapter)
 		if (ret < 0)
 			goto fail;
 	} else {
-		if ((rsi_usb_master_reg_write(adapter,
-					      NWP_WWD_INTERRUPT_TIMER,
-					      NWP_WWD_INT_TIMER_CLKS,
-					      RSI_9116_REG_SIZE)) < 0) {
+		ret = rsi_usb_master_reg_write(adapter,
+					       NWP_WWD_INTERRUPT_TIMER,
+					       NWP_WWD_INT_TIMER_CLKS,
+					       RSI_9116_REG_SIZE);
+		if (ret < 0)
 			goto fail;
-		}
-		if ((rsi_usb_master_reg_write(adapter,
-					      NWP_WWD_SYSTEM_RESET_TIMER,
-					      NWP_WWD_SYS_RESET_TIMER_CLKS,
-					      RSI_9116_REG_SIZE)) < 0) {
+		ret = rsi_usb_master_reg_write(adapter,
+					       NWP_WWD_SYSTEM_RESET_TIMER,
+					       NWP_WWD_SYS_RESET_TIMER_CLKS,
+					       RSI_9116_REG_SIZE);
+		if (ret < 0)
 			goto fail;
-		}
-		if ((rsi_usb_master_reg_write(adapter,
-					      NWP_WWD_MODE_AND_RSTART,
-					      NWP_WWD_TIMER_DISABLE,
-					      RSI_9116_REG_SIZE)) < 0) {
+		ret = rsi_usb_master_reg_write(adapter,
+					       NWP_WWD_MODE_AND_RSTART,
+					       NWP_WWD_TIMER_DISABLE,
+					       RSI_9116_REG_SIZE);
+		if (ret < 0)
 			goto fail;
-		}
 	}
 
 	rsi_dbg(INFO_ZONE, "Reset card done\n");
-- 
2.27.0



