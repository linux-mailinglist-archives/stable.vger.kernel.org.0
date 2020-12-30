Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E0F2E797B
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgL3NKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:53804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgL3NE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BE452222A;
        Wed, 30 Dec 2020 13:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333448;
        bh=RfDIi+ld6PVLeo0NMQXjKVHQtzypeNuRJnbtIICYHuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/g1K0/7tHIrBFTFA3+hB44D/5NYSzIQrka/vuFmgyRtlwXEV/osOJFyjF0K89Z4W
         tk+dPGGa2Kd1qBiAkiXnK+6DEUJPSbtO3ESs61kswFq91XuRCnU+yddGNS2WRIk51X
         IiG9xSQXdr43iES14StBJsySpyjZ8a/tDCWMfkU3JfgDxq1P0mDclNehwXcqkuGirH
         Kb79Bfgb5qeFPjSTXO67hKmjG/Wm/YIBNKw9c2kuHbd1lecWzgzcbMfhQ12PnER8NI
         mDsx+ndk8H3MyRPHnfR3KPEj7dcViiNXGO38vHZgTMoJEt9sdNS4vmoKPT8YnFwUDS
         eTcG3H1WVefEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-i3c@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 07/17] i3c master: fix missing destroy_workqueue() on error in i3c_master_register
Date:   Wed, 30 Dec 2020 08:03:47 -0500
Message-Id: <20201230130357.3637261-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130357.3637261-1-sashal@kernel.org>
References: <20201230130357.3637261-1-sashal@kernel.org>
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
index 6cc71c90f85ea..19337aed9f235 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2492,7 +2492,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 
 	ret = i3c_master_bus_init(master);
 	if (ret)
-		goto err_put_dev;
+		goto err_destroy_wq;
 
 	ret = device_add(&master->dev);
 	if (ret)
@@ -2523,6 +2523,9 @@ int i3c_master_register(struct i3c_master_controller *master,
 err_cleanup_bus:
 	i3c_master_bus_cleanup(master);
 
+err_destroy_wq:
+	destroy_workqueue(master->wq);
+
 err_put_dev:
 	put_device(&master->dev);
 
-- 
2.27.0

