Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B3637CA0B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbhELQYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240695AbhELQSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C1FB61D7E;
        Wed, 12 May 2021 15:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834310;
        bh=WSzZu37Dyy65c1OEzd1qgBONYfWbfihQe1G2L3kBRDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxjulJkLvHA9OnHhk2kpw+0FZmfCmZ8vO+VwhCb+ualE3yzjIeZ6yUnrKqtKSHa6I
         khQlnaCA0yfcFOIMfPNWtrdHjm0BOWrVgDdXCkAtX+T+73Ig6ytd+ZvesaWYZrylg4
         k+7fJmQxVJJ+mAprdAEku4rzgvALhcc6ULn3CUB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 494/601] i2c: stm32f7: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:49:31 +0200
Message-Id: <20210512144844.111878067@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 2c662660ce2bd3b09dae21a9a9ac9395e1e6c00b ]

The PM reference count is not expected to be incremented on
return in these stm32f7_i2c_xx serious functions.

However, pm_runtime_get_sync will increment the PM reference
count even failed. Forgetting to putting operation will result
in a reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: ea6dd25deeb5 ("i2c: stm32f7: add PM_SLEEP suspend/resume support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-stm32f7.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index 473fbe144b7e..8e2c65f91a67 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1652,7 +1652,7 @@ static int stm32f7_i2c_xfer(struct i2c_adapter *i2c_adap,
 	i2c_dev->msg_id = 0;
 	f7_msg->smbus = false;
 
-	ret = pm_runtime_get_sync(i2c_dev->dev);
+	ret = pm_runtime_resume_and_get(i2c_dev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -1698,7 +1698,7 @@ static int stm32f7_i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 	f7_msg->read_write = read_write;
 	f7_msg->smbus = true;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
@@ -1799,7 +1799,7 @@ static int stm32f7_i2c_reg_slave(struct i2c_client *slave)
 	if (ret)
 		return ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
@@ -1880,7 +1880,7 @@ static int stm32f7_i2c_unreg_slave(struct i2c_client *slave)
 
 	WARN_ON(!i2c_dev->slave[id]);
 
-	ret = pm_runtime_get_sync(i2c_dev->dev);
+	ret = pm_runtime_resume_and_get(i2c_dev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -2277,7 +2277,7 @@ static int stm32f7_i2c_regs_backup(struct stm32f7_i2c_dev *i2c_dev)
 	int ret;
 	struct stm32f7_i2c_regs *backup_regs = &i2c_dev->backup_regs;
 
-	ret = pm_runtime_get_sync(i2c_dev->dev);
+	ret = pm_runtime_resume_and_get(i2c_dev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -2299,7 +2299,7 @@ static int stm32f7_i2c_regs_restore(struct stm32f7_i2c_dev *i2c_dev)
 	int ret;
 	struct stm32f7_i2c_regs *backup_regs = &i2c_dev->backup_regs;
 
-	ret = pm_runtime_get_sync(i2c_dev->dev);
+	ret = pm_runtime_resume_and_get(i2c_dev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



