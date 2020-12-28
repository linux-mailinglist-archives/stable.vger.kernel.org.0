Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343A12E659C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390054AbgL1N3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390048AbgL1N3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6556D206ED;
        Mon, 28 Dec 2020 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162110;
        bh=mlTsnEcIZHlHnH1ZBt4xncgPjTJtWeF6V9bH9LIpUXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTLEozTB35o/BZ5QrVjKfpwbC+sKXxiw9TC6o4UMmwEaJa0/e4tQfD8JYtSa2FfKk
         YTuy6YBVks57bI50P+m5+u3iktNsc8bgq6hJTAIXOGeUupRqwSaLZr7+psukp7QGCX
         Cxe+MMFDsS8vZ7enkY7R1KMs3qokUXA52HTun2dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/346] spi: mxs: fix reference leak in mxs_spi_probe
Date:   Mon, 28 Dec 2020 13:47:50 +0100
Message-Id: <20201228124927.086950526@linuxfoundation.org>
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

[ Upstream commit 03fc41afaa6549baa2dab7a84e1afaf5cadb5b18 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in mxs_spi_probe, so we should fix it.

Fixes: b7969caf41a1d ("spi: mxs: implement runtime pm")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201106012421.95420-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mxs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mxs.c b/drivers/spi/spi-mxs.c
index 6ac95a2a21cef..4a7375ecb65ef 100644
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -605,6 +605,7 @@ static int mxs_spi_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(ssp->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(ssp->dev);
 		dev_err(ssp->dev, "runtime_get_sync failed\n");
 		goto out_pm_runtime_disable;
 	}
-- 
2.27.0



