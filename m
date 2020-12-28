Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12B72E3DA6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441557AbgL1OSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441555AbgL1OSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8702E206D4;
        Mon, 28 Dec 2020 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165053;
        bh=l1UVjRlRXRpIr+flxh9z8kPHSEj4cArfqJkZGqgGFqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5DeMo5jfvXiM39pqAdVnRjef3/yVKw1QvvQ894m0HabteyXgla1F5oUW7OIUNMsy
         7/4lUpkAGVoLHU58A2+dNJRFBy5gZp5eYBpvG3HpFrat5GKnaObPfbod3ZboB82ZbU
         GFC1Pz/g1KdAUL6SDlbAYT4N7BlT5c2JBdWvySPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/717] slimbus: qcom: fix potential NULL dereference in qcom_slim_prg_slew()
Date:   Mon, 28 Dec 2020 13:46:32 +0100
Message-Id: <20201228125039.876542262@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 428bb001143cf5bfb65aa4ae90d4ebc95f82d007 ]

platform_get_resource_byname() may fail and in this case a NULL
dereference will occur.

Fix it to use devm_platform_ioremap_resource_byname() instead of calling
platform_get_resource_byname() and devm_ioremap().

This is detected by Coccinelle semantic patch.

@@
expression pdev, res, n, t, e, e1, e2;
@@

res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t,
n);
+ if (!res)
+   return -EINVAL;
... when != res == NULL
e = devm_ioremap(e1, res->start, e2);

Fixes: ad7fcbc308b0 ("slimbus: qcom: Add Qualcomm Slimbus controller driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1607392473-20610-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ctrl.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/slimbus/qcom-ctrl.c b/drivers/slimbus/qcom-ctrl.c
index 4aad2566f52d2..f04b961b96cd4 100644
--- a/drivers/slimbus/qcom-ctrl.c
+++ b/drivers/slimbus/qcom-ctrl.c
@@ -472,15 +472,10 @@ static void qcom_slim_rxwq(struct work_struct *work)
 static void qcom_slim_prg_slew(struct platform_device *pdev,
 				struct qcom_slim_ctrl *ctrl)
 {
-	struct resource	*slew_mem;
-
 	if (!ctrl->slew_reg) {
 		/* SLEW RATE register for this SLIMbus */
-		slew_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-				"slew");
-		ctrl->slew_reg = devm_ioremap(&pdev->dev, slew_mem->start,
-				resource_size(slew_mem));
-		if (!ctrl->slew_reg)
+		ctrl->slew_reg = devm_platform_ioremap_resource_byname(pdev, "slew");
+		if (IS_ERR(ctrl->slew_reg))
 			return;
 	}
 
-- 
2.27.0



