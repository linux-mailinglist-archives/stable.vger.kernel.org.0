Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEC137CE65
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240945AbhELRFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237867AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD69961E5E;
        Wed, 12 May 2021 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836002;
        bh=qcijQx95h+lRm0cz4YZ4JFo08J43H8yQ6iqo2AaYK0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URD4sp37fIXSdigC2mQudNi4OY2F14a0qeW4RVD+gfjko4GuFa/tbNPtr7l2fGnM0
         4vvaBuXGMrNna14K4TXM2snS2i3s8wBFXIQ1nAW72+A1d2bISpDOGDH3PgJoxE96SE
         duMsTjiIqor90cBNKxNebZxnH5ETyXgT3k3SWkUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 563/677] i2c: xiic: fix reference leak when pm_runtime_get_sync fails
Date:   Wed, 12 May 2021 16:50:09 +0200
Message-Id: <20210512144856.102595421@linuxfoundation.org>
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

[ Upstream commit a85c5c7a3aa8041777ff691400b4046e56149fd3 ]

The PM reference count is not expected to be incremented on
return in xiic_xfer and xiic_i2c_remove.

However, pm_runtime_get_sync will increment the PM reference
count even failed. Forgetting to putting operation will result
in a reference leak here.

Replace it with pm_runtime_resume_and_get to keep usage
counter balanced.

Fixes: 10b17004a74c ("i2c: xiic: Fix the clocking across bind unbind")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 087b2951942e..2a8568b97c14 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -706,7 +706,7 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	dev_dbg(adap->dev.parent, "%s entry SR: 0x%x\n", __func__,
 		xiic_getreg8(i2c, XIIC_SR_REG_OFFSET));
 
-	err = pm_runtime_get_sync(i2c->dev);
+	err = pm_runtime_resume_and_get(i2c->dev);
 	if (err < 0)
 		return err;
 
@@ -873,7 +873,7 @@ static int xiic_i2c_remove(struct platform_device *pdev)
 	/* remove adapter & data */
 	i2c_del_adapter(&i2c->adap);
 
-	ret = pm_runtime_get_sync(i2c->dev);
+	ret = pm_runtime_resume_and_get(i2c->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



