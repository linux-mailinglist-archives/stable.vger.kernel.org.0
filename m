Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B321B37CE52
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbhELRE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237845AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0025861E62;
        Wed, 12 May 2021 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835979;
        bh=hZWnAzRTgoMkcZpCZMtJj4pGVbRrv/fyZvi4D1X31cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ay90TzuOW1U2LKs9u4Ahq3OBnX3jZHk43ygGvPOEF7Jr04T7C4bAeOx4NM9UXTqXJ
         0UR+XjkDbX5Ma8r/4/eBO/g0qgxyPIe9zw6EwWFUvwkJrVyOV51G0a0gGqYoo549V7
         47TUsWPm93isQP+OWNzZVShEYEvabpzj50tk6xCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 560/677] i2c: omap: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:50:06 +0200
Message-Id: <20210512144856.000247036@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 780f629741257ed6c54bd3eb53b57f648eabf200 ]

The PM reference count is not expected to be incremented on
return in omap_i2c_probe() and omap_i2c_remove().

However, pm_runtime_get_sync will increment the PM reference
count even failed. Forgetting to putting operation will result
in a reference leak here. I Replace it with pm_runtime_resume_and_get
to keep usage counter balanced.

What's more, error path 'err_free_mem' seems not like a proper
name any more. So I change the name to err_disable_pm and move
pm_runtime_disable below, for pm_runtime of 'pdev->dev' should
be disabled when pm_runtime_resume_and_get fails.

Fixes: 3b0fb97c8dc4 ("I2C: OMAP: Handle error check for pm runtime")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-omap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 12ac4212aded..d4f6c6d60683 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1404,9 +1404,9 @@ omap_i2c_probe(struct platform_device *pdev)
 	pm_runtime_set_autosuspend_delay(omap->dev, OMAP_I2C_PM_TIMEOUT);
 	pm_runtime_use_autosuspend(omap->dev);
 
-	r = pm_runtime_get_sync(omap->dev);
+	r = pm_runtime_resume_and_get(omap->dev);
 	if (r < 0)
-		goto err_free_mem;
+		goto err_disable_pm;
 
 	/*
 	 * Read the Rev hi bit-[15:14] ie scheme this is 1 indicates ver2.
@@ -1513,8 +1513,8 @@ err_unuse_clocks:
 	omap_i2c_write_reg(omap, OMAP_I2C_CON_REG, 0);
 	pm_runtime_dont_use_autosuspend(omap->dev);
 	pm_runtime_put_sync(omap->dev);
+err_disable_pm:
 	pm_runtime_disable(&pdev->dev);
-err_free_mem:
 
 	return r;
 }
@@ -1525,7 +1525,7 @@ static int omap_i2c_remove(struct platform_device *pdev)
 	int ret;
 
 	i2c_del_adapter(&omap->adapter);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



