Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F6353FB7
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbhDEJNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239586AbhDEJNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3658A60FE4;
        Mon,  5 Apr 2021 09:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614026;
        bh=4Ut61lDWJAoqX/WQaP0TgR5xOjT3ncSKo4DY06Z/niY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFDYbk9lmv6Yi6ph2B4RLygZ3lpwP2Hkrx+T4vreetsp0KMrxF69fNyHwm7T5NnHr
         N43LVfG1q5doOsFJ08GE/rHipIOo4QHAldl9WCaSNdYurtGNN9jceuLtwT7ef//lVa
         pCQBU5KYm1qP1wTR42qzpWX7i7mZ3FddhV3Ad6E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo-Feng Fan <vincent_fann@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 056/152] rtw88: coex: 8821c: correct antenna switch function
Date:   Mon,  5 Apr 2021 10:53:25 +0200
Message-Id: <20210405085036.093661985@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo-Feng Fan <vincent_fann@realtek.com>

[ Upstream commit adba838af159914eb98fcd55bfd3a89c9a7d41a8 ]

This patch fixes a defect that uses incorrect function to access
registers. Use 8 and 32 bit access function to access 8 and 32 bit long
data respectively.

Signed-off-by: Guo-Feng Fan <vincent_fann@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210202055012.8296-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index fbfd85439d1f..88fb49486ee0 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -719,8 +719,8 @@ static void rtw8821c_coex_cfg_ant_switch(struct rtw_dev *rtwdev, u8 ctrl_type,
 			regval = (!polarity_inverse ? 0x1 : 0x2);
 		}
 
-		rtw_write8_mask(rtwdev, REG_RFE_CTRL8, BIT_MASK_R_RFE_SEL_15,
-				regval);
+		rtw_write32_mask(rtwdev, REG_RFE_CTRL8, BIT_MASK_R_RFE_SEL_15,
+				 regval);
 		break;
 	case COEX_SWITCH_CTRL_BY_PTA:
 		rtw_write32_clr(rtwdev, REG_LED_CFG, BIT_DPDT_SEL_EN);
@@ -730,8 +730,8 @@ static void rtw8821c_coex_cfg_ant_switch(struct rtw_dev *rtwdev, u8 ctrl_type,
 				PTA_CTRL_PIN);
 
 		regval = (!polarity_inverse ? 0x2 : 0x1);
-		rtw_write8_mask(rtwdev, REG_RFE_CTRL8, BIT_MASK_R_RFE_SEL_15,
-				regval);
+		rtw_write32_mask(rtwdev, REG_RFE_CTRL8, BIT_MASK_R_RFE_SEL_15,
+				 regval);
 		break;
 	case COEX_SWITCH_CTRL_BY_ANTDIV:
 		rtw_write32_clr(rtwdev, REG_LED_CFG, BIT_DPDT_SEL_EN);
@@ -757,11 +757,11 @@ static void rtw8821c_coex_cfg_ant_switch(struct rtw_dev *rtwdev, u8 ctrl_type,
 	}
 
 	if (ctrl_type == COEX_SWITCH_CTRL_BY_BT) {
-		rtw_write32_clr(rtwdev, REG_CTRL_TYPE, BIT_CTRL_TYPE1);
-		rtw_write32_clr(rtwdev, REG_CTRL_TYPE, BIT_CTRL_TYPE2);
+		rtw_write8_clr(rtwdev, REG_CTRL_TYPE, BIT_CTRL_TYPE1);
+		rtw_write8_clr(rtwdev, REG_CTRL_TYPE, BIT_CTRL_TYPE2);
 	} else {
-		rtw_write32_set(rtwdev, REG_CTRL_TYPE, BIT_CTRL_TYPE1);
-		rtw_write32_set(rtwdev, REG_CTRL_TYPE, BIT_CTRL_TYPE2);
+		rtw_write8_set(rtwdev, REG_CTRL_TYPE, BIT_CTRL_TYPE1);
+		rtw_write8_set(rtwdev, REG_CTRL_TYPE, BIT_CTRL_TYPE2);
 	}
 }
 
-- 
2.30.1



