Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1030F2E1221
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgLWCTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbgLWCTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C06E52313F;
        Wed, 23 Dec 2020 02:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689915;
        bh=b6cgy4nxUBBV3LxGk89o8QHFcm84B1/gituP4rGZFoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKl5uUqQ98qVKqPcmmWzN6v2jGwCdHeRGBNb3ckNtOR9nQA9hvNumw9ezUF0jLJTz
         cILaB/QPPbLY7B3eRyM88iyidpkdjllTTc8TFQ3aRxw/U1rMOg2bjJTXegR1dT/i2i
         Rj7ZaXWMfGs9I62NtcMtFXEvkXCu88Lv6iFNUNxE7sDxfG4eHdIXcvyy/YlUmd3vvL
         jnRYuL0yW86SUo6LeYOdk7DrKLb5/mfIWkMbyBnI00/Lu9pNsldjew9RQkpzLtvc+y
         lF8um6gEHxbcGed2hjX0R4GTl7dxwm68BAI1gUhT0X2WjL+VQMd1sOVzvDL+y7/HjR
         XtGIXWnX4Ca4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 016/130] staging: ks7010: fix missing destroy_workqueue() on error in ks7010_sdio_probe
Date:   Tue, 22 Dec 2020 21:16:19 -0500
Message-Id: <20201223021813.2791612-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index 4b379542ecd50..bd864f9ce37ac 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -1028,10 +1028,12 @@ static int ks7010_sdio_probe(struct sdio_func *func,
 
 	ret = register_netdev(priv->net_dev);
 	if (ret)
-		goto err_free_netdev;
+		goto err_destroy_wq;
 
 	return 0;
 
+ err_destroy_wq:
+	destroy_workqueue(priv->wq);
  err_free_netdev:
 	free_netdev(netdev);
  err_release_irq:
-- 
2.27.0

