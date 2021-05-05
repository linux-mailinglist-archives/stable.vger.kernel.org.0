Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC737414D
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbhEEQhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234786AbhEEQfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:35:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAACE613FC;
        Wed,  5 May 2021 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232376;
        bh=LOY+2umU38duiEhfLe5WxFGdlFE8datgP10oqSVAxp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Li5a6F50OMrt6XmZpXfQ0N/3Gx3gGi1ym9Il6UfMKXUE5i7DiVs03egEtIwQWBuBB
         7hSzYUN3LlQfqI/XAINAS1VelPqcJEXWhGUUcyGMEkmN2rtiOkfdBlq4PsoymZZbsD
         HdjIt9fLXYhxtLwF+cfEe7NstgUshMKGXnLEiBG7vx7xsYb8/lBROKvtZAgRxnKsOK
         61g8NTYWcW19Bd9hClClokFv5ZVYYPXoxsJOJvbRQ6YZrdV0x8+r7LbtkycPhI310M
         +s7V02aZDzf6qgLAtYGWKYakjpOf1Q6CLLj6aYpcZ+PRN4wEJUnKqnhQcRLrZyaTGP
         taLLZ9kvD/5xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Weihua <yeweihua4@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 065/116] i2c: imx: Fix PM reference leak in i2c_imx_reg_slave()
Date:   Wed,  5 May 2021 12:30:33 -0400
Message-Id: <20210505163125.3460440-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index b80fdc1f0092..5fd8201a14cd 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -801,7 +801,7 @@ static int i2c_imx_reg_slave(struct i2c_client *client)
 	i2c_imx->last_slave_event = I2C_SLAVE_STOP;
 
 	/* Resume */
-	ret = pm_runtime_get_sync(i2c_imx->adapter.dev.parent);
+	ret = pm_runtime_resume_and_get(i2c_imx->adapter.dev.parent);
 	if (ret < 0) {
 		dev_err(&i2c_imx->adapter.dev, "failed to resume i2c controller");
 		return ret;
-- 
2.30.2

