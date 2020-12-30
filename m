Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036642E7947
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgL3NEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:04:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgL3NEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE64A2226A;
        Wed, 30 Dec 2020 13:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333404;
        bh=28q/yNFrBweLKIPH/r6/kqkxmdVWeYWc9WRZ5w203jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMvuKys6WUK/XCVZkuzXhDTv39ebHgNCK6899O6BY2vGDxWMNqQM61ZKq5aNghdqc
         fUPD+64CdbGfsCFsp70R+e5YphmFnF8zceq8tbgF0glHDR92X1nCalbqup4WIVHmyI
         dRGqRoRYrHTh3lPhKegKPiHCKXrBPWlhSc2IAVJ1x+7rbFzp37WTC6J7fYrlbfrig1
         UM/uKeNkPFzZMmDaqyeVcdB58T2nQrbXdudN6BKHuogdZAW4dUx1EQqMNHqkODOKK/
         xuAWzhcUf+P0iLqdZ+CeQHq0BTAEMOELawj4JiF2w1+dCSYDtcAxx+LXjPI+Y5MApL
         qj5wo9P6rqs2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-i3c@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 07/31] i3c master: fix missing destroy_workqueue() on error in i3c_master_register
Date:   Wed, 30 Dec 2020 08:02:49 -0500
Message-Id: <20201230130314.3636961-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 59165d16c699182b86b5c65181013f1fd88feb62 ]

Add the missing destroy_workqueue() before return from
i3c_master_register in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-i3c/20201028091543.136167-1-miaoqinglang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 1c6b78ad5ade4..b61bf53ec07af 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2537,7 +2537,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 
 	ret = i3c_master_bus_init(master);
 	if (ret)
-		goto err_put_dev;
+		goto err_destroy_wq;
 
 	ret = device_add(&master->dev);
 	if (ret)
@@ -2568,6 +2568,9 @@ int i3c_master_register(struct i3c_master_controller *master,
 err_cleanup_bus:
 	i3c_master_bus_cleanup(master);
 
+err_destroy_wq:
+	destroy_workqueue(master->wq);
+
 err_put_dev:
 	put_device(&master->dev);
 
-- 
2.27.0

