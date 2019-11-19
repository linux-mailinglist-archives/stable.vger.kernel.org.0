Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315511018A0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbfKSF0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfKSF0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DB9621783;
        Tue, 19 Nov 2019 05:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141209;
        bh=FX7PqBezq7lvQhWb99e8xtKPgxkz9s7iKOplU6OafSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaeZef4E1wkcvzU6MU98JI6m/cnoRd0711uI8uZ9+lt5F1KQUoytXYGQwi+4YWeT/
         TagCYYj/MN2dFiKXCXmTDU631nipRdS65e6MFq13vRpHHmtgXJiBt0kA7DncKaAhgP
         HIk+YhDgvpJZlkYeo/L9efpWV00z8+uW9/io6lNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/422] ath10k: skip resetting rx filter for WCN3990
Date:   Tue, 19 Nov 2019 06:14:12 +0100
Message-Id: <20191119051403.352761634@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 58da3b42307061b71f2dcce2bd1185d578a3aa53 ]

WCN3990 has the MAC_PCU_ADDR1 configured properly
and hence it will not send spurious ack frames
during boot up.

Hence the reset_rx_filter workaround is not needed
for WCN3990. Add a hw_param to indicate if hardware rx
filter reset is needed and skip the reset_rx_filter for
WCN3990.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 17 ++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h   |  5 +++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2791ef2fd716c..436eac342b622 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -91,6 +91,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.rx_ring_fill_level = HTT_RX_RING_FILL_LEVEL,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA988X_HW_2_0_VERSION,
@@ -124,6 +125,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -157,6 +159,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -189,6 +192,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -221,6 +225,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -253,6 +258,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -288,6 +294,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -326,6 +333,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -369,6 +377,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -411,6 +420,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -443,6 +453,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -477,6 +488,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -516,6 +528,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = false,
 		.shadow_reg_support = false,
 		.rri_on_ddr = false,
+		.hw_filter_reset_required = true,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -540,6 +553,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.per_ce_irq = true,
 		.shadow_reg_support = true,
 		.rri_on_ddr = true,
+		.hw_filter_reset_required = false,
 	},
 };
 
@@ -2406,7 +2420,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	 * possible to implicitly make it correct by creating a dummy vdev and
 	 * then deleting it.
 	 */
-	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
+	if (ar->hw_params.hw_filter_reset_required &&
+	    mode == ATH10K_FIRMWARE_MODE_NORMAL) {
 		status = ath10k_core_reset_rx_filter(ar);
 		if (status) {
 			ath10k_err(ar,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 977f79ebb4fd5..fac58c3c576a2 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -589,6 +589,11 @@ struct ath10k_hw_params {
 
 	/* Number of bytes to be the offset for each FFT sample */
 	int spectral_bin_offset;
+
+	/* targets which require hw filter reset during boot up,
+	 * to avoid it sending spurious acks.
+	 */
+	bool hw_filter_reset_required;
 };
 
 struct htt_rx_desc;
-- 
2.20.1



