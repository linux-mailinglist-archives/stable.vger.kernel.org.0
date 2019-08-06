Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D983CAA
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfHFVn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727766AbfHFVeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A000D217D9;
        Tue,  6 Aug 2019 21:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127276;
        bh=qMAinlzQ7+uEcv47sCj80Tt1am1WRdCpsOCm4BaZJ0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxKJE3y5+YrfIFQPuqAMZdB3WE8RyPjMYLOPbujAVqzAxrWCu61wGz4weOgoUisGU
         GpLJuXHDIWVUTws82JhRWFgURh7U+c6SGdGK+RD9BEOZfdFdok620c3iG3sqYrrcaW
         gOTeHGqMgyNvcCxRckGpTO/gzcbvJUacqcrJhkDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        stable@kernel.org, Ray Jui <ray.jui@broadcom.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 39/59] i2c: iproc: Fix i2c master read more than 63 bytes
Date:   Tue,  6 Aug 2019 17:32:59 -0400
Message-Id: <20190806213319.19203-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

[ Upstream commit fd01eecdf9591453177d7b06faaabef8c300114a ]

Use SMBUS_MASTER_DATA_READ.MASTER_RD_STATUS bit to check for RX
FIFO empty condition because SMBUS_MASTER_FIFO_CONTROL.MASTER_RX_PKT_COUNT
is not updated for read >= 64 bytes. This fixes the issue when trying to
read from the I2C slave more than 63 bytes.

Fixes: c24b8d574b7c ("i2c: iproc: Extend I2C read up to 255 bytes")
Cc: stable@kernel.org
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bcm-iproc.c b/drivers/i2c/busses/i2c-bcm-iproc.c
index a845b8decac8f..ad1681872e39d 100644
--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -403,16 +403,18 @@ static bool bcm_iproc_i2c_slave_isr(struct bcm_iproc_i2c_dev *iproc_i2c,
 static void bcm_iproc_i2c_read_valid_bytes(struct bcm_iproc_i2c_dev *iproc_i2c)
 {
 	struct i2c_msg *msg = iproc_i2c->msg;
+	uint32_t val;
 
 	/* Read valid data from RX FIFO */
 	while (iproc_i2c->rx_bytes < msg->len) {
-		if (!((iproc_i2c_rd_reg(iproc_i2c, M_FIFO_CTRL_OFFSET) >> M_FIFO_RX_CNT_SHIFT)
-		      & M_FIFO_RX_CNT_MASK))
+		val = iproc_i2c_rd_reg(iproc_i2c, M_RX_OFFSET);
+
+		/* rx fifo empty */
+		if (!((val >> M_RX_STATUS_SHIFT) & M_RX_STATUS_MASK))
 			break;
 
 		msg->buf[iproc_i2c->rx_bytes] =
-			(iproc_i2c_rd_reg(iproc_i2c, M_RX_OFFSET) >>
-			M_RX_DATA_SHIFT) & M_RX_DATA_MASK;
+			(val >> M_RX_DATA_SHIFT) & M_RX_DATA_MASK;
 		iproc_i2c->rx_bytes++;
 	}
 }
-- 
2.20.1

