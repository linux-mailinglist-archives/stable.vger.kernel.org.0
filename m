Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC09206599
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388535AbgFWUGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388529AbgFWUGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B909D2064B;
        Tue, 23 Jun 2020 20:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942811;
        bh=i363s9QRyTKTSVSOlnPSLPjzoa/9HJSEe3IN1zyhEaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8ZGFir0YT5iAALoJsYpuyViTCh8Pw8OK/OszLgq4p79wUKbMhV3hY5coNr2o3M8I
         64bPwZRq+RRoMwvz6jewGIv/nE8LX3WqQbPszSD4CC4khgAw6PigcZtXC8bv4QYkZ3
         S7XCLlaYVVc0iBGYhesdre5yNqscvGP0ULWz+KfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 145/477] gpio: mlxbf2: fix return value check in mlxbf2_gpio_get_lock_res()
Date:   Tue, 23 Jun 2020 21:52:22 +0200
Message-Id: <20200623195414.452886129@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 66d8ad67aab3bc6f55e7de81565cd0d4875bd851 ]

In case of error, the function devm_ioremap() returns NULL pointer not
ERR_PTR(). The IS_ERR() test in the return value check should be
replaced with NULL test.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20200427110829.154785-1-weiyongjun1@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mlxbf2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index da570e63589d0..cc0dd8593a4ba 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -110,8 +110,8 @@ static int mlxbf2_gpio_get_lock_res(struct platform_device *pdev)
 	}
 
 	yu_arm_gpio_lock_param.io = devm_ioremap(dev, res->start, size);
-	if (IS_ERR(yu_arm_gpio_lock_param.io))
-		ret = PTR_ERR(yu_arm_gpio_lock_param.io);
+	if (!yu_arm_gpio_lock_param.io)
+		ret = -ENOMEM;
 
 exit:
 	mutex_unlock(yu_arm_gpio_lock_param.lock);
-- 
2.25.1



