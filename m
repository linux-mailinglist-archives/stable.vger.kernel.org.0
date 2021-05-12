Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062CE37C5C9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhELPnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231383AbhELPiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:38:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0108F61447;
        Wed, 12 May 2021 15:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832807;
        bh=stNhE00ZYP3qm9u/BggeMLPbWctUcAJiQGGVcCR5dX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dt/vF+2JrAjChRtW47PW2P3yNsrmWeaD83n/rKQ7T59aEYL2gp+IrQ4HIJtuVjVtP
         HWAanvB7JZtuKzukdHvuH00qUCHNVrk/5hnxEEz+RARN+7cp96kYxDFkVFFn00cWtr
         eTuCpEsXhWtqPZfSdyNJbQ+MbwEvE9u1zQIMcGs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 431/530] i2c: imx: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:49:01 +0200
Message-Id: <20210512144833.931768671@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 47ff617217ca6a13194fcb35c6c3a0c57c080693 ]

In i2c_imx_xfer() and i2c_imx_remove(), the pm reference count
is not expected to be incremented on return.

However, pm_runtime_get_sync will increment pm reference count
even failed. Forgetting to putting operation will result in a
reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: 3a5ee18d2a32 ("i2c: imx: implement master_xfer_atomic callback")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index e6f8d6e45a15..72af4b4d1318 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1036,7 +1036,7 @@ static int i2c_imx_xfer(struct i2c_adapter *adapter,
 	struct imx_i2c_struct *i2c_imx = i2c_get_adapdata(adapter);
 	int result;
 
-	result = pm_runtime_get_sync(i2c_imx->adapter.dev.parent);
+	result = pm_runtime_resume_and_get(i2c_imx->adapter.dev.parent);
 	if (result < 0)
 		return result;
 
@@ -1280,7 +1280,7 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
 	int irq, ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



