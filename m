Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98752E144C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgLWCXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgLWCXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4B632333B;
        Wed, 23 Dec 2020 02:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690182;
        bh=kwr7vOqLTHit+B0tLX6e2t6x/SRPTCIFmBpxO580gAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crCliLiKg8k/+408wHv5HFjB99HlyEEAvHQB7Dq6TJV2dLleHzpVO4+bxKF1KqYHu
         I76rkBhe4YUzfI6r+29rQxCajddQPrHEVMQ1ojHSso69x0qA1j1nbQuQ3lcoYlTugu
         ZCItLHqvNMp6/geDKyAOr7gEfsyN4loZWm0CnK1cJhbqjeJSTbdgB//ySHc3vBM0TF
         ksvPN4QOuq59i35UBhf/3hhFKSzGwmWJdyaNhu+A/kfbQaFMeqH0D3ibYWeldyG6HD
         H0VdIrjVM3tUGkM0kgpgit6OpMGTIaaCNGnMdMjw2hSZ/GXZVHlAlf4PWUjm7kuAzI
         R/+ZAN1gU2WGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.14 07/66] staging: ks7010: fix missing destroy_workqueue() on error in ks7010_sdio_probe
Date:   Tue, 22 Dec 2020 21:21:53 -0500
Message-Id: <20201223022253.2793452-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit d1e7550ad081fa5e9260f636dd51e1c496e0fd5f ]

Add the missing destroy_workqueue() before return from
ks7010_sdio_probe in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201028091552.136445-1-miaoqinglang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ks7010/ks7010_sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index 8cfdff198334b..46d26423d3935 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -952,10 +952,12 @@ static int ks7010_sdio_probe(struct sdio_func *func,
 
 	ret = register_netdev(priv->net_dev);
 	if (ret)
-		goto err_free_netdev;
+		goto err_destroy_wq;
 
 	return 0;
 
+ err_destroy_wq:
+	destroy_workqueue(priv->wq);
  err_free_netdev:
 	free_netdev(priv->net_dev);
 	card->priv = NULL;
-- 
2.27.0

