Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54AE37CE37
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbhELRDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232532AbhELQnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4401E61E54;
        Wed, 12 May 2021 16:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835969;
        bh=wHGr8/2MKJ9QkujvqJp8NVpSdB7CSZyNxCnj1lOrdvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpNgfUrvYXFzhTMmEg595M2vFY/uUZ1D2uKQy4Dqx3D9rtN/E0TR+ptqcV5SD/8tZ
         Beds5ne+eCWHElSP8WND5ysCYcG/FRcrbVJzRa3PP0x9VyWoUnJlA5ziZgbXgBeKa+
         xVvXwHwJEp84W0fdPShfMEi7/h8BCzGWgAyLUKOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 556/677] i2c: cadence: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:50:02 +0200
Message-Id: <20210512144855.855735279@linuxfoundation.org>
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

[ Upstream commit 23ceb8462dc6f4b4decdb5536a7e5fc477cdf0b6 ]

The PM reference count is not expected to be incremented on
return in functions cdns_i2c_master_xfer and cdns_reg_slave.

However, pm_runtime_get_sync will increment pm usage counter
even failed. Forgetting to putting operation will result in a
reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: 7fa32329ca03 ("i2c: cadence: Move to sensible power management")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index e4b7f2a951ad..e8eae8725900 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -789,7 +789,7 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	bool change_role = false;
 #endif
 
-	ret = pm_runtime_get_sync(id->dev);
+	ret = pm_runtime_resume_and_get(id->dev);
 	if (ret < 0)
 		return ret;
 
@@ -911,7 +911,7 @@ static int cdns_reg_slave(struct i2c_client *slave)
 	if (slave->flags & I2C_CLIENT_TEN)
 		return -EAFNOSUPPORT;
 
-	ret = pm_runtime_get_sync(id->dev);
+	ret = pm_runtime_resume_and_get(id->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



