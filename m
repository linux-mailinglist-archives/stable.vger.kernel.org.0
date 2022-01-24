Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9345D4999BD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455995AbiAXVhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388845AbiAXVM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF8CC02B5F2;
        Mon, 24 Jan 2022 12:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D17F66136F;
        Mon, 24 Jan 2022 20:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D2BC340E7;
        Mon, 24 Jan 2022 20:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054975;
        bh=+cHD1sv0DCBEaOmQQwWTkSRUl1GaWxvlAts901+cBS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IW6/BbboiNzapHlf4piCYmk0uKAMZ1ELA20KXlNqdKBrNSI5pfaemjzUoiiX7Nt17
         qS0980VA/22p281eeDhMJOO/wSWoA7p7enL7YQFYrcpKFPorqXWpHfuLvz2HY0nh4x
         B5TqliJyyHLQnAMknApmQrByg6lbOHHKsp0Fae1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 5.10 563/563] ath10k: Fix the MTU size on QCA9377 SDIO
Date:   Mon, 24 Jan 2022 19:45:28 +0100
Message-Id: <20220124184043.924007897@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

commit 09b8cd69edcf2be04a781e1781e98e52a775c9ad upstream.

On an imx6dl-pico-pi board with a QCA9377 SDIO chip, simply trying to
connect via ssh to another machine causes:

[   55.824159] ath10k_sdio mmc1:0001:1: failed to transmit packet, dropping: -12
[   55.832169] ath10k_sdio mmc1:0001:1: failed to submit frame: -12
[   55.838529] ath10k_sdio mmc1:0001:1: failed to push frame: -12
[   55.905863] ath10k_sdio mmc1:0001:1: failed to transmit packet, dropping: -12
[   55.913650] ath10k_sdio mmc1:0001:1: failed to submit frame: -12
[   55.919887] ath10k_sdio mmc1:0001:1: failed to push frame: -12

, leading to an ssh connection failure.

One user inspected the size of frames on Wireshark and reported
the followig:

"I was able to narrow the issue down to the mtu. If I set the mtu for
the wlan0 device to 1486 instead of 1500, the issue does not happen.

The size of frames that I see on Wireshark is exactly 1500 after
setting it to 1486."

Clearing the HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE avoids the problem and
the ssh command works successfully after that.

Introduce a 'credit_size_workaround' field to ath10k_hw_params for
the QCA9377 SDIO, so that the HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE
is not set in this case.

Tested with QCA9377 SDIO with firmware WLAN.TF.1.1.1-00061-QCATFSWPZ-1.

Fixes: 2f918ea98606 ("ath10k: enable alt data of TX path for sdio")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20211124131047.713756-1-festevam@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/core.c |   19 ++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h   |    3 +++
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -89,6 +89,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = true,
 	},
 	{
@@ -123,6 +124,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = true,
 	},
 	{
@@ -158,6 +160,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -187,6 +190,7 @@ static const struct ath10k_hw_params ath
 		.num_wds_entries = 0x20,
 		.uart_pin_workaround = true,
 		.tx_stats_over_pktlog = false,
+		.credit_size_workaround = false,
 		.bmi_large_size_download = true,
 		.supports_peer_stats_info = true,
 	},
@@ -222,6 +226,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -256,6 +261,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -290,6 +296,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -327,6 +334,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = true,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 		.supports_peer_stats_info = true,
 	},
@@ -368,6 +376,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -415,6 +424,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -459,6 +469,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -493,6 +504,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -529,6 +541,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = true,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -557,6 +570,7 @@ static const struct ath10k_hw_params ath
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.uart_pin_workaround = true,
+		.credit_size_workaround = true,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -597,6 +611,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -624,6 +639,7 @@ static const struct ath10k_hw_params ath
 		.rri_on_ddr = true,
 		.hw_filter_reset_required = false,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 };
@@ -697,6 +713,7 @@ static void ath10k_send_suspend_complete
 
 static int ath10k_init_sdio(struct ath10k *ar, enum ath10k_firmware_mode mode)
 {
+	bool mtu_workaround = ar->hw_params.credit_size_workaround;
 	int ret;
 	u32 param = 0;
 
@@ -714,7 +731,7 @@ static int ath10k_init_sdio(struct ath10
 
 	param |= HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET;
 
-	if (mode == ATH10K_FIRMWARE_MODE_NORMAL)
+	if (mode == ATH10K_FIRMWARE_MODE_NORMAL && !mtu_workaround)
 		param |= HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
 	else
 		param &= ~HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -618,6 +618,9 @@ struct ath10k_hw_params {
 	 */
 	bool uart_pin_workaround;
 
+	/* Workaround for the credit size calculation */
+	bool credit_size_workaround;
+
 	/* tx stats support over pktlog */
 	bool tx_stats_over_pktlog;
 


