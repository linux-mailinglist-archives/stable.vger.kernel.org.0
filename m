Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA862E3EDE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505023AbgL1Od2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505016AbgL1OdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB53A206D4;
        Mon, 28 Dec 2020 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165989;
        bh=fYHXfmQTtDL/AckUuon2v7KhLXw9bP39Bzlrnbi2oek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHZanPXLJR9ampzaabvCPKoF0IITl2fRz3uXeEsa1lB/OIdisqhd4k/UJ9EDkAl1z
         9O499xCHZeFxXd1EmfEf/mw2BksBrVNWvbL0ZXOk6inVSccBeYZPS0RrCpa5fiHR+l
         2/DDeVYvNT4qd6Moo9gylnFqukdvzhfl0ozHIfOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 052/132] soc: ti: Fix reference imbalance in knav_dma_probe
Date:   Mon, 28 Dec 2020 13:48:56 +0100
Message-Id: <20201228124848.952887186@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit b4fa73358c306d747a2200aec6f7acb97e5750e6 ]

The patch fix two reference leak.

  1) pm_runtime_get_sync will increment pm usage counter even it
     failed. Forgetting to call put operation will result in
     reference leak.

  2) The pm_runtime_enable will increase power disable depth. Thus
     a pairing decrement is needed on the error handling path to
     keep it balanced.

We fix it by: 1) adding call pm_runtime_put_noidle or
pm_runtime_put_sync in error handling. 2) adding pm_runtime_disable
in error handling, to keep usage counter and disable depth balanced.

Fixes: 88139ed030583 ("soc: ti: add Keystone Navigator DMA support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_dma.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/knav_dma.c b/drivers/soc/ti/knav_dma.c
index bc1b80ec6afe3..838b87adf48bb 100644
--- a/drivers/soc/ti/knav_dma.c
+++ b/drivers/soc/ti/knav_dma.c
@@ -752,8 +752,9 @@ static int knav_dma_probe(struct platform_device *pdev)
 	pm_runtime_enable(kdev->dev);
 	ret = pm_runtime_get_sync(kdev->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(kdev->dev);
 		dev_err(kdev->dev, "unable to enable pktdma, err %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	/* Initialise all packet dmas */
@@ -767,13 +768,21 @@ static int knav_dma_probe(struct platform_device *pdev)
 
 	if (list_empty(&kdev->list)) {
 		dev_err(dev, "no valid dma instance\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_put_sync;
 	}
 
 	debugfs_create_file("knav_dma", S_IFREG | S_IRUGO, NULL, NULL,
 			    &knav_dma_debug_ops);
 
 	return ret;
+
+err_put_sync:
+	pm_runtime_put_sync(kdev->dev);
+err_pm_disable:
+	pm_runtime_disable(kdev->dev);
+
+	return ret;
 }
 
 static int knav_dma_remove(struct platform_device *pdev)
-- 
2.27.0



