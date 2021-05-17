Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BA33831B4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbhEQOkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241002AbhEQOhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FEC9613F4;
        Mon, 17 May 2021 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261060;
        bh=P0GQHDid5gNULmxh/7T9/eqqfcAIQflFAo5uX2BAX/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDKlHoMmABOdE7UZr9y8EX8FhcRyUuiiscgRRn3o/QmYuh5E584gvcdT9e0hJp9RQ
         xgHyzZNYM4E+uwLSojzlJS36dt2tSCOoWc1WbypUSLd6IRwpbKmqN+s5qTxJHavjOU
         5jfJkaA0Mjh23MdhmsqPYVpAgREl3Y7cPZE+ArzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Ye Weihua <yeweihua4@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 065/329] i2c: imx: Fix PM reference leak in i2c_imx_reg_slave()
Date:   Mon, 17 May 2021 15:59:36 +0200
Message-Id: <20210517140304.261965668@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8a694b2eebfd..d6b3fdf09b8f 100644
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



