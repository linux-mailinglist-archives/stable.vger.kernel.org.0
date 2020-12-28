Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62DA2E41ED
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404636AbgL1PO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438164AbgL1OGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEC9F20731;
        Mon, 28 Dec 2020 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164378;
        bh=GupfwFL5yEdxBwnR6c/CMKU4bl3wnHCOEcGxNo179u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWG5E3CFB5EivMP6t5nwEr7bKfn0jhdGfu+1mGvnVxmzvR3mwrxqjdi8dC5pfoM7C
         wgp/P6Cdg9ptqq1Ny815pZjO7pmGDzUrYIojSlzTF/9bkrQKGgizzblZlLLykkMMsV
         HtEOQBccWyiIOIaumeGy9O15MfEReqWNdLe4cKzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/717] mfd: htc-i2cpld: Add the missed i2c_put_adapter() in htcpld_register_chip_i2c()
Date:   Mon, 28 Dec 2020 13:42:38 +0100
Message-Id: <20201228125028.622081874@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 9a463284706c5217872c3cadaca863d47129bd95 ]

htcpld_register_chip_i2c() misses to call i2c_put_adapter() in an error
path. Add the missed function call to fix it.

Fixes: 6048a3dd2371 ("mfd: Add HTCPLD driver")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/htc-i2cpld.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index 247f9849e54ae..417b0355d904d 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -346,6 +346,7 @@ static int htcpld_register_chip_i2c(
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
 		dev_warn(dev, "i2c adapter %d non-functional\n",
 			 pdata->i2c_adapter_id);
+		i2c_put_adapter(adapter);
 		return -EINVAL;
 	}
 
@@ -360,6 +361,7 @@ static int htcpld_register_chip_i2c(
 		/* I2C device registration failed, contineu with the next */
 		dev_warn(dev, "Unable to add I2C device for 0x%x\n",
 			 plat_chip_data->addr);
+		i2c_put_adapter(adapter);
 		return PTR_ERR(client);
 	}
 
-- 
2.27.0



