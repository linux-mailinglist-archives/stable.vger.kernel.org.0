Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12AD9FA54A
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbfKMBxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbfKMBxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9F02245A;
        Wed, 13 Nov 2019 01:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610013;
        bh=tWMoYBDBxFN95d0VknL5vepaomjR5eoKtzCaE7yb/NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IO9op3sTdcQ8pHwZrBBSlRXH3zPUkk4OmwuEgyfT+LeKOpAv2JtfrkFZe/yJkBis6
         Wdn+Et5Ee3d83A0p6JGAgz5SUnRVBCX11Ym1cyeUDLyt3kGPSnnb7shcTX7JfNGGuO
         y4qeIMLq+QW6aXPSmh3c5fh2tNd+zoh6tue3qvzo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andy Gross <andy.gross@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 117/209] i2c: qup: use core to detect 'no zero length' quirk
Date:   Tue, 12 Nov 2019 20:48:53 -0500
Message-Id: <20191113015025.9685-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit de82bb431855580ad659bfed3e858bd9dd12efd0 ]

And don't reimplement in the driver.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qup.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index c86c3ae1318f2..e09cd0775ae91 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -1088,11 +1088,6 @@ static int qup_i2c_xfer(struct i2c_adapter *adap,
 	writel(I2C_MINI_CORE | I2C_N_VAL, qup->base + QUP_CONFIG);
 
 	for (idx = 0; idx < num; idx++) {
-		if (msgs[idx].len == 0) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		if (qup_i2c_poll_state_i2c_master(qup)) {
 			ret = -EIO;
 			goto out;
@@ -1520,9 +1515,6 @@ qup_i2c_determine_mode_v2(struct qup_i2c_dev *qup,
 
 	/* All i2c_msgs should be transferred using either dma or cpu */
 	for (idx = 0; idx < num; idx++) {
-		if (msgs[idx].len == 0)
-			return -EINVAL;
-
 		if (msgs[idx].flags & I2C_M_RD)
 			max_rx_len = max_t(unsigned int, max_rx_len,
 					   msgs[idx].len);
@@ -1636,9 +1628,14 @@ static const struct i2c_algorithm qup_i2c_algo_v2 = {
  * which limits the possible read to 256 (QUP_READ_LIMIT) bytes.
  */
 static const struct i2c_adapter_quirks qup_i2c_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN,
 	.max_read_len = QUP_READ_LIMIT,
 };
 
+static const struct i2c_adapter_quirks qup_i2c_quirks_v2 = {
+	.flags = I2C_AQ_NO_ZERO_LEN,
+};
+
 static void qup_i2c_enable_clocks(struct qup_i2c_dev *qup)
 {
 	clk_prepare_enable(qup->clk);
@@ -1701,6 +1698,7 @@ static int qup_i2c_probe(struct platform_device *pdev)
 		is_qup_v1 = true;
 	} else {
 		qup->adap.algo = &qup_i2c_algo_v2;
+		qup->adap.quirks = &qup_i2c_quirks_v2;
 		is_qup_v1 = false;
 		if (acpi_match_device(qup_i2c_acpi_match, qup->dev))
 			goto nodma;
-- 
2.20.1

