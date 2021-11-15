Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FC04526AA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbhKPCJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238106AbhKORym (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:54:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62A2A632BA;
        Mon, 15 Nov 2021 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997582;
        bh=E+r5NNwQiYIPCJrf9wG4ImreUwNweOvmKgyW6t1Z/sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+0N4PJqVKhT0i3m8ugNpxgH+zV4FbAwq7zvNYODxKf+lj17h535vR/TDe2d1ndlx
         d/rg3b5sFDzxYLAQzlVaGck0GUCw/FG55KyEPJup1PFYzmPbWh/pwmC5W/1XG0B1lI
         0oaR9eAZ88mmynk2aJUC+H4fEaggJpYtbRHOcgIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/575] rtw88: fix RX clock gate setting while fifo dump
Date:   Mon, 15 Nov 2021 17:58:45 +0100
Message-Id: <20211115165350.620916305@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit c5a8e90730a322f236731fc347dd3afa5db5550e ]

When fw fifo dumps, RX clock gating should be disabled to avoid
something unexpected. However, the register operation ran into
a mistake. So, we fix it.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210927111830.5354-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c  | 7 +++----
 drivers/net/wireless/realtek/rtw88/reg.h | 1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 0452630bcfacc..40bcfabd2d214 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1421,12 +1421,10 @@ static void rtw_fw_read_fifo_page(struct rtw_dev *rtwdev, u32 offset, u32 size,
 	u32 i;
 	u16 idx = 0;
 	u16 ctl;
-	u8 rcr;
 
-	rcr = rtw_read8(rtwdev, REG_RCR + 2);
 	ctl = rtw_read16(rtwdev, REG_PKTBUF_DBG_CTRL) & 0xf000;
 	/* disable rx clock gate */
-	rtw_write8(rtwdev, REG_RCR, rcr | BIT(3));
+	rtw_write32_set(rtwdev, REG_RCR, BIT_DISGCLK);
 
 	do {
 		rtw_write16(rtwdev, REG_PKTBUF_DBG_CTRL, start_pg | ctl);
@@ -1445,7 +1443,8 @@ static void rtw_fw_read_fifo_page(struct rtw_dev *rtwdev, u32 offset, u32 size,
 
 out:
 	rtw_write16(rtwdev, REG_PKTBUF_DBG_CTRL, ctl);
-	rtw_write8(rtwdev, REG_RCR + 2, rcr);
+	/* restore rx clock gate */
+	rtw_write32_clr(rtwdev, REG_RCR, BIT_DISGCLK);
 }
 
 static void rtw_fw_read_fifo(struct rtw_dev *rtwdev, enum rtw_fw_fifo_sel sel,
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index aca3dbdc2d5a5..9088bfb2a3157 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -400,6 +400,7 @@
 #define BIT_MFBEN		BIT(22)
 #define BIT_DISCHKPPDLLEN	BIT(21)
 #define BIT_PKTCTL_DLEN		BIT(20)
+#define BIT_DISGCLK		BIT(19)
 #define BIT_TIM_PARSER_EN	BIT(18)
 #define BIT_BC_MD_EN		BIT(17)
 #define BIT_UC_MD_EN		BIT(16)
-- 
2.33.0



