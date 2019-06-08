Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D94A39EF8
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfFHLxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727949AbfFHLky (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 388FF214C6;
        Sat,  8 Jun 2019 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994054;
        bh=TSRcLFrlpO2JyXfmGJburXdZEkncU+WobgydvtGgduo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2BI3QjeBS3u+iyXQKXw4MqkCz/dvVz6cD417TNoEs2T7bjX7XHOO/dn7LrqAp2Ow
         0MWDRpS222Q65doKKa18j17DLJmYc/PoPzWFeAOr03D07Gb6n1dRRjUX2XOeCIohM8
         97rTb503GAlgBXfHWM7zMuibTzxJA91aTOaEI2y4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vadim Pasternak <vadimp@mellanox.com>,
        Wolfram Sang <wsa@the-dreams.de>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 40/70] i2c: mlxcpld: Fix wrong initialization order in probe
Date:   Sat,  8 Jun 2019 07:39:19 -0400
Message-Id: <20190608113950.8033-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit 13067ef73f337336e3149f5bb9f3fd05fe7f87a0 ]

Fix wrong order in probing routine initialization - field `base_addr'
is used before it's initialized. Move assignment of 'priv->base_addr`
to the beginning, prior the call to mlxcpld_i2c_read_comm().
Wrong order caused the first read of capability register to be executed
at wrong offset 0x0 instead of 0x2000. By chance it was a "good
garbage" at 0x0 offset.

Fixes: 313ce648b5a4 ("i2c: mlxcpld: Add support for extended transaction length for i2c-mlxcpld")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxcpld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mlxcpld.c b/drivers/i2c/busses/i2c-mlxcpld.c
index 745ed43a22d6..2fd717d8dd30 100644
--- a/drivers/i2c/busses/i2c-mlxcpld.c
+++ b/drivers/i2c/busses/i2c-mlxcpld.c
@@ -503,6 +503,7 @@ static int mlxcpld_i2c_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, priv);
 
 	priv->dev = &pdev->dev;
+	priv->base_addr = MLXPLAT_CPLD_LPC_I2C_BASE_ADDR;
 
 	/* Register with i2c layer */
 	mlxcpld_i2c_adapter.timeout = usecs_to_jiffies(MLXCPLD_I2C_XFER_TO);
@@ -518,7 +519,6 @@ static int mlxcpld_i2c_probe(struct platform_device *pdev)
 		mlxcpld_i2c_adapter.nr = pdev->id;
 	priv->adap = mlxcpld_i2c_adapter;
 	priv->adap.dev.parent = &pdev->dev;
-	priv->base_addr = MLXPLAT_CPLD_LPC_I2C_BASE_ADDR;
 	i2c_set_adapdata(&priv->adap, priv);
 
 	err = i2c_add_numbered_adapter(&priv->adap);
-- 
2.20.1

