Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C38A4983BE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiAXPpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiAXPpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:45:09 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D745C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 07:45:09 -0800 (PST)
Received: from localhost.localdomain (unknown [IPv6:2804:14c:485:4b69:915:5092:874a:4cf7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: festevam@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id ECF5180820;
        Mon, 24 Jan 2022 16:45:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1643039106;
        bh=F1h47D/HR82Abh6IQIkPW7EcLWLMIReVnX5YvIbH9yw=;
        h=From:To:Cc:Subject:Date:From;
        b=iLBsSo1NzToaNfGLc+ug8c5+V8cc0le8G62f0hZWkDQdkHKMpxbO4B6d/uf7vKK3r
         858OrVN0PUnd6QWEtv1GInyUINYGLI0hpnLeU4cr68O4/V/KONlHhgydwIGOAXVliJ
         waEcK9+ISRnig5KCDBs5trvcQ1lZApACoWVYUcc9qy8KMFOb7f07j0vnMAnNkopoEF
         hsm3a1qc/ycglX4bF/bM/Yo9d2ZS0pVJH/0z2GWehx4YC7SNCrPMkkJOZQPwgGk1y0
         g4Vr+M5LF95aI1qro5F97+mKWZMxcZm+tCNCjEMDjbvARG0hQnJ04ePpVWooM+kriu
         lhP2xYkLLerQQ==
From:   Fabio Estevam <festevam@denx.de>
To:     sashal@kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH stable-5.10] ath10k: Fix the MTU size on QCA9377 SDIO
Date:   Mon, 24 Jan 2022 12:44:54 -0300
Message-Id: <20220124154454.1349296-1-festevam@denx.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 09b8cd69edcf2be04a781e1781e98e52a775c9ad ]
    
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
---
Hi,

This is the resolution for the linux-stable 5.10 tree.
	
 drivers/net/wireless/ath/ath10k/core.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index d73ad60b571c..d0967bb1f387 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -89,6 +89,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = true,
 	},
 	{
@@ -123,6 +124,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = true,
 	},
 	{
@@ -158,6 +160,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -187,6 +190,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.num_wds_entries = 0x20,
 		.uart_pin_workaround = true,
 		.tx_stats_over_pktlog = false,
+		.credit_size_workaround = false,
 		.bmi_large_size_download = true,
 		.supports_peer_stats_info = true,
 	},
@@ -222,6 +226,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -256,6 +261,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -290,6 +296,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -327,6 +334,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = true,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 		.supports_peer_stats_info = true,
 	},
@@ -368,6 +376,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -415,6 +424,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -459,6 +469,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -493,6 +504,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -529,6 +541,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = true,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -557,6 +570,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.uart_pin_workaround = true,
+		.credit_size_workaround = true,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -597,6 +611,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = false,
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 	{
@@ -624,6 +639,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rri_on_ddr = true,
 		.hw_filter_reset_required = false,
 		.fw_diag_ce_download = false,
+		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 	},
 };
@@ -697,6 +713,7 @@ static void ath10k_send_suspend_complete(struct ath10k *ar)
 
 static int ath10k_init_sdio(struct ath10k *ar, enum ath10k_firmware_mode mode)
 {
+	bool mtu_workaround = ar->hw_params.credit_size_workaround;
 	int ret;
 	u32 param = 0;
 
@@ -714,7 +731,7 @@ static int ath10k_init_sdio(struct ath10k *ar, enum ath10k_firmware_mode mode)
 
 	param |= HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET;
 
-	if (mode == ATH10K_FIRMWARE_MODE_NORMAL)
+	if (mode == ATH10K_FIRMWARE_MODE_NORMAL && !mtu_workaround)
 		param |= HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
 	else
 		param &= ~HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
-- 
2.25.1

