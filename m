Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C9D374268
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbhEEQqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235766AbhEEQo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E41F61926;
        Wed,  5 May 2021 16:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232538;
        bh=yMMHeJwtOjSzzGJkzTq+5P1IroFA0qOOWeJTB7p5iqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OniYxozPZPpI48XA5CgtTsKWJEQ6Zj5RIk/r2x5oBqBDi/B28w662fT+p7WZNTw4e
         kSzFSpdxui28nUlcnXMA/hkprk9RSBqtQ4CpujyyX9exRUjmwChq/91l4c1/dleNc6
         6oZHcs/RRzj7D9yuSvBjzjm3138bLF+p/3rroryDemKRc8+vcn/YlWMQHLP6WlRcr0
         Z9MDe7aPGcoKLvA/mIORFWdGjSGYzNGBpbui7yRu+WMSmEup8jAkjfCP5wtDqti/jj
         V+pDtNQljYKM3p9rCLt+UEkheSL2zaH1FUXbJTxdFU9mXsNcU0cvz4t5HlWWxDknB4
         pOQJsjaZv1vbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Weihua <yeweihua4@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 058/104] i2c: imx: Fix PM reference leak in i2c_imx_reg_slave()
Date:   Wed,  5 May 2021 12:33:27 -0400
Message-Id: <20210505163413.3461611-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Weihua <yeweihua4@huawei.com>

[ Upstream commit c4b1fcc310e655fa8414696c38a84d36c00684c8 ]

pm_runtime_get_sync() will increment the PM reference count even on
failure. Forgetting to put the reference again will result in a leak.

Replace it with pm_runtime_resume_and_get() to keep the usage counter
balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Weihua <yeweihua4@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index a8e8af57e33f..56c5a9f8c138 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -763,7 +763,7 @@ static int i2c_imx_reg_slave(struct i2c_client *client)
 	i2c_imx->slave = client;
 
 	/* Resume */
-	ret = pm_runtime_get_sync(i2c_imx->adapter.dev.parent);
+	ret = pm_runtime_resume_and_get(i2c_imx->adapter.dev.parent);
 	if (ret < 0) {
 		dev_err(&i2c_imx->adapter.dev, "failed to resume i2c controller");
 		return ret;
-- 
2.30.2

