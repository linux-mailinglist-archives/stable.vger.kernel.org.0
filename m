Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26A2452416
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354080AbhKPBgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242563AbhKOSiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 814E56326D;
        Mon, 15 Nov 2021 18:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999407;
        bh=i1k6L7tT9EcqRvVJFKd6oY6S/rehLbwXr9eN22urIzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMCsVGWMhrS6obFItxv4hGxRlwMh2OuqgZWiQrNBL2vcc0djLb7QJEBNoEGKnetV3
         obpq8rIxKEoPFyfqTn8k4vw9kCpVcY0Z8ywmaBRtQHnZObxzOMHTHstFFUcfp6reqg
         XuBz+IN2LoVdlsRPbjemOQX+KvbMoZWt47jpXy4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 253/849] rtw88: fix RX clock gate setting while fifo dump
Date:   Mon, 15 Nov 2021 17:55:36 +0100
Message-Id: <20211115165428.791127358@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index e6399519584bd..a384fc3a4f2b0 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1556,12 +1556,10 @@ static void rtw_fw_read_fifo_page(struct rtw_dev *rtwdev, u32 offset, u32 size,
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
@@ -1580,7 +1578,8 @@ static void rtw_fw_read_fifo_page(struct rtw_dev *rtwdev, u32 offset, u32 size,
 
 out:
 	rtw_write16(rtwdev, REG_PKTBUF_DBG_CTRL, ctl);
-	rtw_write8(rtwdev, REG_RCR + 2, rcr);
+	/* restore rx clock gate */
+	rtw_write32_clr(rtwdev, REG_RCR, BIT_DISGCLK);
 }
 
 static void rtw_fw_read_fifo(struct rtw_dev *rtwdev, enum rtw_fw_fifo_sel sel,
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index f5ce75095e904..c0fb1e446245f 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -406,6 +406,7 @@
 #define BIT_MFBEN		BIT(22)
 #define BIT_DISCHKPPDLLEN	BIT(21)
 #define BIT_PKTCTL_DLEN		BIT(20)
+#define BIT_DISGCLK		BIT(19)
 #define BIT_TIM_PARSER_EN	BIT(18)
 #define BIT_BC_MD_EN		BIT(17)
 #define BIT_UC_MD_EN		BIT(16)
-- 
2.33.0



