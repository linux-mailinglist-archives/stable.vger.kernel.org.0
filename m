Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2812E6743
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbgL1NMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731950AbgL1NME (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:12:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A7922582;
        Mon, 28 Dec 2020 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161109;
        bh=bc6GbhACSBu4w9iM3shQkXEetJ5QtseSPAXOKqeFWoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFGsVkBl3S1UhFcYSFbOglo28eWsjqZOzP2XfR3WT3aKe7PxOPJt35vv9pX2Vo+2K
         xQ/gX3AHFyA0RU/Ov8lrX2ZnflxopNxyGfVU9p2JK06jwyhjze9KzBNXu3ga9nnuBy
         zwMeUbJApCrRFGxsRN14IrDB9p/tyQTkFO+AVDpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/242] soc: ti: knav_qmss: fix reference leak in knav_queue_probe
Date:   Mon, 28 Dec 2020 13:48:27 +0100
Message-Id: <20201228124909.714366547@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit ec8684847d8062496c4619bc3fcff31c19d56847 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in knav_queue_probe, so we should fix it.

Fixes: 41f93af900a20 ("soc: ti: add Keystone Navigator QMSS driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 9879ca5f8c5f5..eef79cd5a7238 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1719,6 +1719,7 @@ static int knav_queue_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
 		dev_err(dev, "Failed to enable QMSS\n");
 		return ret;
 	}
-- 
2.27.0



