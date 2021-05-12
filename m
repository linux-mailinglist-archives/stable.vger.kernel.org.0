Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E79A37C3D6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbhELPW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234689AbhELPUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 950C360FD9;
        Wed, 12 May 2021 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832109;
        bh=RUzs8sveTmYzQCIE7RnOZxqCzs+u8mJGuskzNLjrQsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHO2lkvlHyXHv1s+1s4jS7EQ07fHH/MN4sqhFYCvQqREVHHayKbpoEm8zYZ0SOebS
         qXEp/8Y7bSzkr3qZzaEnmOMRFglgTYnGZ+J3ayleKA6brdzahUFrV3TdqZg8G5v+j7
         1FNxK7iaoRoA7l3/FsPRo7teFjiLvATjl/c7WzU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tejas Patel <tejas.patel@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/530] firmware: xilinx: Fix dereferencing freed memory
Date:   Wed, 12 May 2021 16:43:41 +0200
Message-Id: <20210512144823.446878401@linuxfoundation.org>
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

From: Tejas Patel <tejas.patel@xilinx.com>

[ Upstream commit f1f21bece82c76a56a96988ec7d51ccc033d8949 ]

Fix smatch warning:
drivers/firmware/xilinx/zynqmp.c:1288 zynqmp_firmware_remove()
error: dereferencing freed memory 'feature_data'

Use hash_for_each_safe for safe removal of hash entry.

Fixes: acfdd18591ea ("firmware: xilinx: Use hash-table for api feature check")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tejas Patel <tejas.patel@xilinx.com>
Signed-off-by: Rajan Vaja <rajan.vaja@xilinx.com>
Link: https://lore.kernel.org/r/1612765883-22018-1-git-send-email-rajan.vaja@xilinx.com
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/xilinx/zynqmp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index fd95edeb702b..9e6504592646 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -2,7 +2,7 @@
 /*
  * Xilinx Zynq MPSoC Firmware layer
  *
- *  Copyright (C) 2014-2020 Xilinx, Inc.
+ *  Copyright (C) 2014-2021 Xilinx, Inc.
  *
  *  Michal Simek <michal.simek@xilinx.com>
  *  Davorin Mista <davorin.mista@aggios.com>
@@ -1280,12 +1280,13 @@ static int zynqmp_firmware_probe(struct platform_device *pdev)
 static int zynqmp_firmware_remove(struct platform_device *pdev)
 {
 	struct pm_api_feature_data *feature_data;
+	struct hlist_node *tmp;
 	int i;
 
 	mfd_remove_devices(&pdev->dev);
 	zynqmp_pm_api_debugfs_exit();
 
-	hash_for_each(pm_api_features_map, i, feature_data, hentry) {
+	hash_for_each_safe(pm_api_features_map, i, tmp, feature_data, hentry) {
 		hash_del(&feature_data->hentry);
 		kfree(feature_data);
 	}
-- 
2.30.2



