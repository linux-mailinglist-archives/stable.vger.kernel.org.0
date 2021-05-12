Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B47837C278
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhELPKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233338AbhELPId (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:08:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D136661963;
        Wed, 12 May 2021 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831721;
        bh=JFzLzekphzuNNpReAtBToAyJ215kB8BSeIfdgIL3hUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PV4xc4RbVYbQlI/Nx0sIkCWd93aNhc5LEjFIBJmFY8Y6e8w+lzCYs1/OtrwI1+7UI
         X6gdBMoRcTObRXZ3Z3P66tsc4Z1mbRbW82XnmaiMNyg8cAvlZ+Ye46xwJU2dLvcBgY
         7U39MMYfmL8ZBupL5N4nWQ/aNsNcnx9wbt25nang=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/244] i2c: imx-lpi2c: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:49:29 +0200
Message-Id: <20210512144749.333262515@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index c92b56485fa6..a0d045c1bc9e 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -265,7 +265,7 @@ static int lpi2c_imx_master_enable(struct lpi2c_imx_struct *lpi2c_imx)
 	unsigned int temp;
 	int ret;
 
-	ret = pm_runtime_get_sync(lpi2c_imx->adapter.dev.parent);
+	ret = pm_runtime_resume_and_get(lpi2c_imx->adapter.dev.parent);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



