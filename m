Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEDA2E3760
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgL1Mys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbgL1Myh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:54:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B5D12242A;
        Mon, 28 Dec 2020 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160036;
        bh=XAuZMLSZNQM37Gph0XBD4GiduJ20pZCWKiUeZx7WuyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ao9W+jIviy62t0DRtGv5Nqlp4Zx+BxtM23iPPoZSz7cI6ugECJxcVwypa+3Am7Ij
         eWRvCUdU3mqUX3VdyUuoOcjjBzb6/hCG+MPyajrPpJkmWiLnPXNq5WVDYOyxwmAaxZ
         jq9cWBsZOZZIbYV/HeCauGF/Ivc+fWtHJH+3QUOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 051/132] soc: ti: knav_qmss: fix reference leak in knav_queue_probe
Date:   Mon, 28 Dec 2020 13:48:55 +0100
Message-Id: <20201228124848.904602260@linuxfoundation.org>
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
index 8c03a80b482dd..3a3bc8ef532a7 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1717,6 +1717,7 @@ static int knav_queue_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
 		dev_err(dev, "Failed to enable QMSS\n");
 		return ret;
 	}
-- 
2.27.0



