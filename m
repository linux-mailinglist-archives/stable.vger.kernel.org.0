Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351B32E6701
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732486AbgL1NOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732475AbgL1NOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8580D22582;
        Mon, 28 Dec 2020 13:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161224;
        bh=oroVu+Y/v0hARBDWPaa3/W+x6u0CoNwNdkAg8smfTfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FY1+uTDEto9OmPrkbEJhjB/72xG67sHtgFSQL89j1FlLjrucp9YJTLDsz+6tHVFVM
         5abImIrB5plH5PC2ccIwhA0+fF83cid/OaETdnZwCb4gWRU5ZKcW+RGvts8QxRcVvt
         FJp3ywjKPH9eOjwvdHgHTHGg4Kl42GL7GKYv/ThM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 104/242] drivers: soc: ti: knav_qmss_queue: Fix error return code in knav_queue_probe
Date:   Mon, 28 Dec 2020 13:48:29 +0100
Message-Id: <20201228124909.813022784@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 4cba398f37f868f515ff12868418dc28574853a1 ]

Fix to return the error code from of_get_child_by_name() instaed of 0
in knav_queue_probe().

Fixes: 41f93af900a20d1a0a ("soc: ti: add Keystone Navigator QMSS driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index eef79cd5a7238..25baf13d6dfd2 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1787,9 +1787,10 @@ static int knav_queue_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	regions =  of_get_child_by_name(node, "descriptor-regions");
+	regions = of_get_child_by_name(node, "descriptor-regions");
 	if (!regions) {
 		dev_err(dev, "descriptor-regions not specified\n");
+		ret = -ENODEV;
 		goto err;
 	}
 	ret = knav_queue_setup_regions(kdev, regions);
-- 
2.27.0



