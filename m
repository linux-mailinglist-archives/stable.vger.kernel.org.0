Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BD1FA0E8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfKMBxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:53:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbfKMBxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94DB32245C;
        Wed, 13 Nov 2019 01:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610014;
        bh=ZMIpm2eGoF1gz+prN8Rj5RSMJQK+YlymFSmMKKZXimg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1qUoaXMmn2gGh81d06JuSEIal686YXWxsT7dj6D3TT+9gqHiW+QKT5Bs7Qlu4oaO
         ZFSpPUTrDSCVkvCPGGpmMgtPFhrHHOBMmBgUJX4nQYB/YTffRpsogDwSYdG3kSOrQj
         R2xTSAP5FqYNpsmA1sH5WHo24ilUFqQQbi+TB/sE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 118/209] i2c: tegra: use core to detect 'no zero length' quirk
Date:   Tue, 12 Nov 2019 20:48:54 -0500
Message-Id: <20191113015025.9685-118-sashal@kernel.org>
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

[ Upstream commit c96c0f2683804b710531e7b754dcd02b5ded6d4a ]

And don't reimplement in the driver.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index ef13b6ce9d8de..47d196c026ba6 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -684,9 +684,6 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 
 	tegra_i2c_flush_fifos(i2c_dev);
 
-	if (msg->len == 0)
-		return -EINVAL;
-
 	i2c_dev->msg_buf = msg->buf;
 	i2c_dev->msg_buf_remaining = msg->len;
 	i2c_dev->msg_err = I2C_ERR_NONE;
@@ -831,6 +828,7 @@ static const struct i2c_algorithm tegra_i2c_algo = {
 
 /* payload size is only 12 bit */
 static const struct i2c_adapter_quirks tegra_i2c_quirks = {
+	.flags = I2C_AQ_NO_ZERO_LEN,
 	.max_read_len = 4096,
 	.max_write_len = 4096 - 12,
 };
-- 
2.20.1

