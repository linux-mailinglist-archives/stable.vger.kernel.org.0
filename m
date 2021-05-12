Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC3C37CA06
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbhELQYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240648AbhELQSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1258061462;
        Wed, 12 May 2021 15:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834298;
        bh=fU/4kerB8Rqj+WMxsvLlAsgQQomxfRsmta0+ohO1Heg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXVskKPvqLYPKlQE1Dhwgp40QJPQXb6/zZ/FuqV2qd0u7QlqgthOzi/I3au7sC80C
         q/9dAubEOBguUX/0IgmYOQrRPJU30qUTzSVf2fV7rBIq17C/U5Uipu37G4qy4Hpyh8
         wagFiNztDRnOpkjZgggvBwqC+SiDjJ4bKKeBwXf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 489/601] i2c: img-scb: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:49:26 +0200
Message-Id: <20210512144843.949650114@linuxfoundation.org>
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

[ Upstream commit 223125e37af8a641ea4a09747a6a52172fc4b903 ]

The PM reference count is not expected to be incremented on
return in functions img_i2c_xfer and img_i2c_init.

However, pm_runtime_get_sync will increment the PM reference
count even failed. Forgetting to putting operation will result
in a reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: 93222bd9b966 ("i2c: img-scb: Add runtime PM")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-img-scb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-img-scb.c b/drivers/i2c/busses/i2c-img-scb.c
index 98a89301ed2a..8e987945ed45 100644
--- a/drivers/i2c/busses/i2c-img-scb.c
+++ b/drivers/i2c/busses/i2c-img-scb.c
@@ -1057,7 +1057,7 @@ static int img_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			atomic = true;
 	}
 
-	ret = pm_runtime_get_sync(adap->dev.parent);
+	ret = pm_runtime_resume_and_get(adap->dev.parent);
 	if (ret < 0)
 		return ret;
 
@@ -1158,7 +1158,7 @@ static int img_i2c_init(struct img_i2c *i2c)
 	u32 rev;
 	int ret;
 
-	ret = pm_runtime_get_sync(i2c->adap.dev.parent);
+	ret = pm_runtime_resume_and_get(i2c->adap.dev.parent);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



