Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF3255E4AB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346470AbiF1NcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 09:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346481AbiF1Nbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 09:31:36 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F283425F4
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 06:31:10 -0700 (PDT)
X-QQ-mid: bizesmtp78t1656423060trmfx83z
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 28 Jun 2022 21:30:57 +0800 (CST)
X-QQ-SSF: 01400000002000G0S000B00A0000000
X-QQ-FEAT: zCqO8hPdPe7z4KFAQ2d/MgTLxnUx5zs48XI+5lOMBR/3ecyAbEqg7rDeyhyQS
        71wY5Ql/Ee4gWGv8+i42FfBLRjYaIa2Bmrp86AFCRcdQ4kOl3QwiiUZfObwBPr8yVwaDikj
        U6h+iw6Tt/nt+gxiQhRzjRQIvRlFTUyGYHM52g8VeZBBg1B5lR5Ts8YU9mGatG8q9NSyEH3
        oE4X9G1ZYMYUPE/fq+YkxeuFJia9WAzJSr7Z1nawwYo1J4RFey+CPr03PlSrgvOytYh/D66
        9f9Pf0ovgMFzg4BcTRO8E8om+nTfBzVhCuxA/UrzZqH6wZnwjEFWyHsTb6ALtG1zG2kqAkF
        Ji8NUAdHFvSNWF6Ehkm2icY1TD0SWn2MAVKgeFIQEyX6vk/QySv9Zp+Y9nn6A==
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     stable@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo-Feng Fan <vincent_fann@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH 5.10 2/3] commit b789e3fe7047 ("rtw88: 8821c: support RFE type4 wifi NIC")
Date:   Tue, 28 Jun 2022 21:30:45 +0800
Message-Id: <20220628133046.2474-2-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220628133046.2474-1-tangmeng@uniontech.com>
References: <20220628133046.2474-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign10
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo-Feng Fan <vincent_fann@realtek.com>

RFE type4 is a new NIC which has one RF antenna shares with BT.
RFE type4 HW is the same as RFE type2 but attaching antenna to
aux antenna connector.

RFE type2 attach antenna to main antenna connector.
Load the same parameter as RFE type2 when initializing NIC.

Signed-off-by: Guo-Feng Fan <vincent_fann@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210922023637.9357-1-pkshih@realtek.com
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 4514c4e8ee58..9c8fbc96f536 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -300,7 +300,8 @@ static void rtw8821c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
 	if (channel <= 14) {
 		if (rtwdev->efuse.rfe_option == 0)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_WLG);
-		else if (rtwdev->efuse.rfe_option == 2)
+		else if (rtwdev->efuse.rfe_option == 2 ||
+			 rtwdev->efuse.rfe_option == 4)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_BTG);
 		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTDBG, BIT(6), 0x1);
 		rtw_write_rf(rtwdev, RF_PATH_A, 0x64, 0xf, 0xf);
@@ -737,6 +738,15 @@ static void rtw8821c_coex_cfg_ant_switch(struct rtw_dev *rtwdev, u8 ctrl_type,
 	if (switch_status == coex_dm->cur_switch_status)
 		return;
 
+	if (coex_rfe->wlg_at_btg) {
+		ctrl_type = COEX_SWITCH_CTRL_BY_BBSW;
+
+		if (coex_rfe->ant_switch_polarity)
+			pos_type = COEX_SWITCH_TO_WLA;
+		else
+			pos_type = COEX_SWITCH_TO_WLG_BT;
+	}
+
 	coex_dm->cur_switch_status = switch_status;
 
 	if (coex_rfe->ant_switch_diversity &&
@@ -1457,6 +1467,7 @@ static const struct rtw_intf_phy_para_table phy_para_table_8821c = {
 static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8821c, 0, 0),
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
-- 
2.20.1



