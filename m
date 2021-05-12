Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ABD37CE34
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbhELRDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232542AbhELQnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2166C61D48;
        Wed, 12 May 2021 16:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835974;
        bh=Sz9w2m3rG2JmL0SoYcKXy+7G7vWIenZoaa1Z7dv16r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygfu06X/7RvRyLtOvXswVZm1v16a5FNSMMIVjhTYWeUtbh7/HggwSSVvnHT0FuIpj
         VMymzvWtczE2mZx95XQj4tJVY2O6W9PpCz6AZm2xWGnxnOVEEe62invvgSApnxAZ1g
         4+qHaQiaTSffSsjbpx5wRRS4qnP8DWDrsBoJFZsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 558/677] i2c: imx-lpi2c: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:50:04 +0200
Message-Id: <20210512144855.929467880@linuxfoundation.org>
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

[ Upstream commit 278e5bbdb9a94fa063c0f9bcde2479d0b8042462 ]

The PM reference count is not expected to be incremented on
return in lpi2c_imx_master_enable.

However, pm_runtime_get_sync will increment the PM reference
count even failed. Forgetting to putting operation will result
in a reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: 13d6eb20fc79 ("i2c: imx-lpi2c: add runtime pm support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 9db6ccded5e9..8b9ba055c418 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -259,7 +259,7 @@ static int lpi2c_imx_master_enable(struct lpi2c_imx_struct *lpi2c_imx)
 	unsigned int temp;
 	int ret;
 
-	ret = pm_runtime_get_sync(lpi2c_imx->adapter.dev.parent);
+	ret = pm_runtime_resume_and_get(lpi2c_imx->adapter.dev.parent);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



