Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435422E659A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390023AbgL1N3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390018AbgL1N27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C34422583;
        Mon, 28 Dec 2020 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162098;
        bh=a8rweLZd5JsqRDzBlBAYE+KB21mQGLYdkiAT7oZFWyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCiiBKjmcbMQ7qF+wyzhAzAnhBnhDIR7xKRwWZiLRHWRzIoxr16VzG8KQXomWmfQQ
         wCYu203n30l1raOC73FSvEiI/ZlahSFMv+SkciFNWQuPKeDOirNRJ2aNxPsDkSbU8I
         eyd3+nx9kjiB/aE3reC5/9ttXSdxsiWWIOO6gSwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/346] soc: ti: Fix reference imbalance in knav_dma_probe
Date:   Mon, 28 Dec 2020 13:47:56 +0100
Message-Id: <20201228124927.376572468@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 224d7ddeeb767..eb2e87229c1da 100644
--- a/drivers/soc/ti/knav_dma.c
+++ b/drivers/soc/ti/knav_dma.c
@@ -759,8 +759,9 @@ static int knav_dma_probe(struct platform_device *pdev)
 	pm_runtime_enable(kdev->dev);
 	ret = pm_runtime_get_sync(kdev->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(kdev->dev);
 		dev_err(kdev->dev, "unable to enable pktdma, err %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	/* Initialise all packet dmas */
@@ -774,7 +775,8 @@ static int knav_dma_probe(struct platform_device *pdev)
 
 	if (list_empty(&kdev->list)) {
 		dev_err(dev, "no valid dma instance\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_put_sync;
 	}
 
 	debugfs_create_file("knav_dma", S_IFREG | S_IRUGO, NULL, NULL,
@@ -782,6 +784,13 @@ static int knav_dma_probe(struct platform_device *pdev)
 
 	device_ready = true;
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



