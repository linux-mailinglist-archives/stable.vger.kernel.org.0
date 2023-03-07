Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0CE6AEB68
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjCGRoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjCGRnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:43:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD40A02A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:39:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA97B6151B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A10CC4339C;
        Tue,  7 Mar 2023 17:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210778;
        bh=1w0m0SFyncH70yz1WAs1FuTe22z+P3k22RSUixRn6jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wunato7Po9Pzq1uJA2f5xdbhUZTORGzNxbPqhJZPTZs7mqBHRu/hqMkXST2wdwcvd
         1me5yKJ8dpAlUW3nIVo30YWerqu32P0pWpgEuvuROtboyrlHCP7Fk4zo0idpOQMwWp
         CHdDObShEjX/ZWyhOVMVmZqyx8TpjklI2lO8/OD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0650/1001] wifi: rtw89: fix assignation of TX BD RAM table
Date:   Tue,  7 Mar 2023 17:57:02 +0100
Message-Id: <20230307170049.799689377@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 7f495de6ae7d31f098970fb45a038c9f69b1bf75 ]

TX BD's RAM table describes how HW allocates usable buffer section
for each TX channel at fetch time. The total RAM size for TX BD is
chip-dependent. For 8852BE, it has only half size (32) for TX channels
of single band. Original table arrange total size (64) for dual band.
It will overflow on 8852BE circuit and cause section conflicts between
different TX channels.

So, we do the changes below.
* add another table for single band chip and export both kind of tables
* point to the expected one in rtw89_pci_info by chip

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230113090632.60957-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c       | 15 ++++++++++++++-
 drivers/net/wireless/realtek/rtw89/pci.h       | 15 +++++++++------
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c |  1 +
 5 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 1c4500ba777c6..0ea734c81b4f0 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -1384,7 +1384,7 @@ static int rtw89_pci_ops_tx_write(struct rtw89_dev *rtwdev, struct rtw89_core_tx
 	return 0;
 }
 
-static const struct rtw89_pci_bd_ram bd_ram_table[RTW89_TXCH_NUM] = {
+const struct rtw89_pci_bd_ram rtw89_bd_ram_table_dual[RTW89_TXCH_NUM] = {
 	[RTW89_TXCH_ACH0] = {.start_idx = 0,  .max_num = 5, .min_num = 2},
 	[RTW89_TXCH_ACH1] = {.start_idx = 5,  .max_num = 5, .min_num = 2},
 	[RTW89_TXCH_ACH2] = {.start_idx = 10, .max_num = 5, .min_num = 2},
@@ -1399,11 +1399,24 @@ static const struct rtw89_pci_bd_ram bd_ram_table[RTW89_TXCH_NUM] = {
 	[RTW89_TXCH_CH11] = {.start_idx = 55, .max_num = 5, .min_num = 1},
 	[RTW89_TXCH_CH12] = {.start_idx = 60, .max_num = 4, .min_num = 1},
 };
+EXPORT_SYMBOL(rtw89_bd_ram_table_dual);
+
+const struct rtw89_pci_bd_ram rtw89_bd_ram_table_single[RTW89_TXCH_NUM] = {
+	[RTW89_TXCH_ACH0] = {.start_idx = 0,  .max_num = 5, .min_num = 2},
+	[RTW89_TXCH_ACH1] = {.start_idx = 5,  .max_num = 5, .min_num = 2},
+	[RTW89_TXCH_ACH2] = {.start_idx = 10, .max_num = 5, .min_num = 2},
+	[RTW89_TXCH_ACH3] = {.start_idx = 15, .max_num = 5, .min_num = 2},
+	[RTW89_TXCH_CH8]  = {.start_idx = 20, .max_num = 4, .min_num = 1},
+	[RTW89_TXCH_CH9]  = {.start_idx = 24, .max_num = 4, .min_num = 1},
+	[RTW89_TXCH_CH12] = {.start_idx = 28, .max_num = 4, .min_num = 1},
+};
+EXPORT_SYMBOL(rtw89_bd_ram_table_single);
 
 static void rtw89_pci_reset_trx_rings(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
+	const struct rtw89_pci_bd_ram *bd_ram_table = *info->bd_ram_table;
 	struct rtw89_pci_tx_ring *tx_ring;
 	struct rtw89_pci_rx_ring *rx_ring;
 	struct rtw89_pci_dma_ring *bd_ring;
diff --git a/drivers/net/wireless/realtek/rtw89/pci.h b/drivers/net/wireless/realtek/rtw89/pci.h
index 7d033501d4d95..1e19740db8c54 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -750,6 +750,12 @@ struct rtw89_pci_ch_dma_addr_set {
 	struct rtw89_pci_ch_dma_addr rx[RTW89_RXCH_NUM];
 };
 
+struct rtw89_pci_bd_ram {
+	u8 start_idx;
+	u8 max_num;
+	u8 min_num;
+};
+
 struct rtw89_pci_info {
 	enum mac_ax_bd_trunc_mode txbd_trunc_mode;
 	enum mac_ax_bd_trunc_mode rxbd_trunc_mode;
@@ -785,6 +791,7 @@ struct rtw89_pci_info {
 	u32 tx_dma_ch_mask;
 	const struct rtw89_pci_bd_idx_addr *bd_idx_addr_low_power;
 	const struct rtw89_pci_ch_dma_addr_set *dma_addr_set;
+	const struct rtw89_pci_bd_ram (*bd_ram_table)[RTW89_TXCH_NUM];
 
 	int (*ltr_set)(struct rtw89_dev *rtwdev, bool en);
 	u32 (*fill_txaddr_info)(struct rtw89_dev *rtwdev,
@@ -798,12 +805,6 @@ struct rtw89_pci_info {
 				struct rtw89_pci_isrs *isrs);
 };
 
-struct rtw89_pci_bd_ram {
-	u8 start_idx;
-	u8 max_num;
-	u8 min_num;
-};
-
 struct rtw89_pci_tx_data {
 	dma_addr_t dma;
 };
@@ -1057,6 +1058,8 @@ static inline bool rtw89_pci_ltr_is_err_reg_val(u32 val)
 extern const struct dev_pm_ops rtw89_pm_ops;
 extern const struct rtw89_pci_ch_dma_addr_set rtw89_pci_ch_dma_addr_set;
 extern const struct rtw89_pci_ch_dma_addr_set rtw89_pci_ch_dma_addr_set_v1;
+extern const struct rtw89_pci_bd_ram rtw89_bd_ram_table_dual[RTW89_TXCH_NUM];
+extern const struct rtw89_pci_bd_ram rtw89_bd_ram_table_single[RTW89_TXCH_NUM];
 
 struct pci_device_id;
 
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
index 0cd8c0c44d19d..d835a44a1d0d0 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
@@ -44,6 +44,7 @@ static const struct rtw89_pci_info rtw8852a_pci_info = {
 	.tx_dma_ch_mask		= 0,
 	.bd_idx_addr_low_power	= NULL,
 	.dma_addr_set		= &rtw89_pci_ch_dma_addr_set,
+	.bd_ram_table		= &rtw89_bd_ram_table_dual,
 
 	.ltr_set		= rtw89_pci_ltr_set,
 	.fill_txaddr_info	= rtw89_pci_fill_txaddr_info,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852be.c b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
index 0ef2ca8efeb0e..ecf39d2d9f81f 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
@@ -46,6 +46,7 @@ static const struct rtw89_pci_info rtw8852b_pci_info = {
 				  BIT(RTW89_TXCH_CH10) | BIT(RTW89_TXCH_CH11),
 	.bd_idx_addr_low_power	= NULL,
 	.dma_addr_set		= &rtw89_pci_ch_dma_addr_set,
+	.bd_ram_table		= &rtw89_bd_ram_table_single,
 
 	.ltr_set		= rtw89_pci_ltr_set,
 	.fill_txaddr_info	= rtw89_pci_fill_txaddr_info,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
index 35901f64d17de..80490a5437df6 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
@@ -53,6 +53,7 @@ static const struct rtw89_pci_info rtw8852c_pci_info = {
 	.tx_dma_ch_mask		= 0,
 	.bd_idx_addr_low_power	= &rtw8852c_bd_idx_addr_low_power,
 	.dma_addr_set		= &rtw89_pci_ch_dma_addr_set_v1,
+	.bd_ram_table		= &rtw89_bd_ram_table_dual,
 
 	.ltr_set		= rtw89_pci_ltr_set_v1,
 	.fill_txaddr_info	= rtw89_pci_fill_txaddr_info_v1,
-- 
2.39.2



