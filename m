Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CFC2E6598
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390013AbgL1N24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390010AbgL1N2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC4AD22582;
        Mon, 28 Dec 2020 13:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162095;
        bh=X6kk+vmnDN51qBg7Y7eRVjGS7L2G8ywbtoWUCD0tlLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Negnh7ceerwd7jjoUHfYxH9kOPjWSXGDU8UowFSNIfwMfTpIM2r4TKIHG9wxhlhbr
         GUa3MUZCgvsJHcmAsebepCU9blbDNJNhSkbn/aHyhWtqmz/Wnq8f1s7J8aP3qJIl51
         MvGlBjNO9+eCD7jM7uDkXIT2Lo8Fe7AEz9SWE6+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/346] soc: ti: knav_qmss: fix reference leak in knav_queue_probe
Date:   Mon, 28 Dec 2020 13:47:55 +0100
Message-Id: <20201228124927.327854287@linuxfoundation.org>
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
index ef36acc0e7088..ffd7046caa2ca 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1799,6 +1799,7 @@ static int knav_queue_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
 		dev_err(dev, "Failed to enable QMSS\n");
 		return ret;
 	}
-- 
2.27.0



