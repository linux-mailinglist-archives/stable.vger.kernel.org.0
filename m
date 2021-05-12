Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B220537C5C8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhELPnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhELPiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:38:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41CDE61C66;
        Wed, 12 May 2021 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832814;
        bh=nQlHBUX5/jCp0UAoG7yPgYiMvTxBOCk5/kHY3pxDLPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6zWfWQZyYrUrHCw2L5X9+RfTWD/WZuqBg6eBz+vX0oQBZU30q/UEd7Hss7oKhNUx
         IS9UvKPTolz2VGjaemJMZZxqc7NfS2/6rdnsRdRB+3yvMbjnV+zF44BH23Ra1tZeFQ
         amw+Q7AQ+pYFdACR5T+/73GVV5NOpK5g3Dmt7Fxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/530] i2c: sprd: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:49:03 +0200
Message-Id: <20210512144833.994744964@linuxfoundation.org>
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

[ Upstream commit 3a4f326463117cee3adcb72999ca34a9aaafda93 ]

The PM reference count is not expected to be incremented on
return in sprd_i2c_master_xfer() and sprd_i2c_remove().

However, pm_runtime_get_sync will increment the PM reference
count even failed. Forgetting to putting operation will result
in a reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: 8b9ec0719834 ("i2c: Add Spreadtrum I2C controller driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-sprd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sprd.c b/drivers/i2c/busses/i2c-sprd.c
index 2917fecf6c80..8ead7e021008 100644
--- a/drivers/i2c/busses/i2c-sprd.c
+++ b/drivers/i2c/busses/i2c-sprd.c
@@ -290,7 +290,7 @@ static int sprd_i2c_master_xfer(struct i2c_adapter *i2c_adap,
 	struct sprd_i2c *i2c_dev = i2c_adap->algo_data;
 	int im, ret;
 
-	ret = pm_runtime_get_sync(i2c_dev->dev);
+	ret = pm_runtime_resume_and_get(i2c_dev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -576,7 +576,7 @@ static int sprd_i2c_remove(struct platform_device *pdev)
 	struct sprd_i2c *i2c_dev = platform_get_drvdata(pdev);
 	int ret;
 
-	ret = pm_runtime_get_sync(i2c_dev->dev);
+	ret = pm_runtime_resume_and_get(i2c_dev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



