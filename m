Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC53106E75
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbfKVLDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731457AbfKVLDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D4F7207FC;
        Fri, 22 Nov 2019 11:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420628;
        bh=tWMoYBDBxFN95d0VknL5vepaomjR5eoKtzCaE7yb/NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6646ryqChr7X07+fyEuQpYq2hbaRe7+9Ev7Ol3HLY/oyQWYPC/Hh2xrjUd3KaIqC
         ahW5WQH+rJQF4SdsA0qK+sG46QfwMmf0G3Ss4Yx6K8jWlf3TEvgZxVZDYFAdPJqPm3
         W5kLaG8N/EsEwsiSXChRsbwjT3Hh559OFWSD0Q5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andy Gross <andy.gross@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/220] i2c: qup: use core to detect no zero length quirk
Date:   Fri, 22 Nov 2019 11:28:13 +0100
Message-Id: <20191122100922.027888422@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



