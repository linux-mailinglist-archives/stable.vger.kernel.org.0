Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784932C0A05
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733207AbgKWMoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733202AbgKWMoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 726F520888;
        Mon, 23 Nov 2020 12:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135459;
        bh=/1e8oe+pJOVUZibf9pz42Q21CG+UPTu4fNXAMtOLdEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4U1uy0jX4CKheyWsiRobSdr6tVFSvdjUN/3zN/ODou8YhC6TL+cNnmIAyU9xUIs+
         BaHgrd3HID+hNLrqfuPq64BtNXS11wWFL5idL4b89WnWVh/hake0igYPw8SRX+sv/+
         qI1ECoH8cn3bO+ENHJHz+q+kG1I11h04QQQVlhco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 048/252] net: fec: Fix reference count leak in fec series ops
Date:   Mon, 23 Nov 2020 13:19:58 +0100
Message-Id: <20201123121837.905579687@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit da875fa5040b0f951cb4bf7efbf59f6dcff44d3c ]

pm_runtime_get_sync() will increment pm usage at first and it will
resume the device later. If runtime of the device has error or
device is in inaccessible state(or other error state), resume
operation will fail. If we do not call put operation to decrease
the reference, it will result in reference count leak. Moreover,
this device cannot enter the idle state and always stay busy or other
non-idle state later. So we fixed it by replacing it with
pm_runtime_resume_and_get.

Fixes: 8fff755e9f8d0 ("net: fec: Ensure clocks are enabled while using mdio bus")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1808,7 +1808,7 @@ static int fec_enet_mdio_read(struct mii
 	int ret = 0, frame_start, frame_addr, frame_op;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
@@ -1867,11 +1867,9 @@ static int fec_enet_mdio_write(struct mi
 	int ret, frame_start, frame_addr;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
-	else
-		ret = 0;
 
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
@@ -2276,7 +2274,7 @@ static void fec_enet_get_regs(struct net
 	u32 i, off;
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return;
 
@@ -2977,7 +2975,7 @@ fec_enet_open(struct net_device *ndev)
 	int ret;
 	bool reset_again;
 
-	ret = pm_runtime_get_sync(&fep->pdev->dev);
+	ret = pm_runtime_resume_and_get(&fep->pdev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -3771,7 +3769,7 @@ fec_drv_remove(struct platform_device *p
 	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
 


