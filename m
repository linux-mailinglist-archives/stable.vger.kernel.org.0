Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274BC205D60
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbgFWUMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388980AbgFWUMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:12:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0390820707;
        Tue, 23 Jun 2020 20:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943154;
        bh=6PVMyRZV9NWRJQbMiCEigj0ikYYgTAmzulYY+YnTpQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7zMi3huEP9Ncaqp1NRezwtGbKklBAdqfI3tJVfc4lx7FooZKDzY1UaO05t8OOOyk
         IJp5kOnRvRfHQ9lUbpn/v5WJTsvt0JOeaH5yU7WLGU9Yvci7+QAHQHlGGcbUAHX3rP
         a0YAtrEiLht+t8dMFVNM+zvbCM0MGdnKqUEFzC3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 281/477] scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes
Date:   Tue, 23 Jun 2020 21:54:38 +0200
Message-Id: <20200623195420.853620979@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 22617e21633142dd2b81541cb3b95d6fb59aa85f ]

Fix unwinding of pm_runtime changes when bailing out of driver probe due to
a failure and also on removal of driver.

Link: https://lore.kernel.org/r/20200526100340.15032-1-vigneshr@ti.com
Fixes: 6979e56cec97 ("scsi: ufs: Add driver for TI wrapper for Cadence UFS IP")
Reported-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ti-j721e-ufs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
index 5216d228cdd9a..46bb905b4d6a9 100644
--- a/drivers/scsi/ufs/ti-j721e-ufs.c
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -32,14 +32,14 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(dev);
-		return ret;
+		goto disable_pm;
 	}
 
 	/* Select MPHY refclk frequency */
 	clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(dev, "Cannot claim MPHY clock.\n");
-		return PTR_ERR(clk);
+		goto clk_err;
 	}
 	clk_rate = clk_get_rate(clk);
 	if (clk_rate == 26000000)
@@ -54,16 +54,23 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 				   dev);
 	if (ret) {
 		dev_err(dev, "failed to populate child nodes %d\n", ret);
-		pm_runtime_put_sync(dev);
+		goto clk_err;
 	}
 
 	return ret;
+
+clk_err:
+	pm_runtime_put_sync(dev);
+disable_pm:
+	pm_runtime_disable(dev);
+	return ret;
 }
 
 static int ti_j721e_ufs_remove(struct platform_device *pdev)
 {
 	of_platform_depopulate(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	return 0;
 }
-- 
2.25.1



