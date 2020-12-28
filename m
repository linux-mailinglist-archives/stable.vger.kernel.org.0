Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB06E2E659B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390031AbgL1N3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390025AbgL1N3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9810222472;
        Mon, 28 Dec 2020 13:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162101;
        bh=w1QfFPVY3eyH4O0jpxH3+yNdRxDsJVJ1DkoARXa8vGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgtG4iRAAmXehs3DBzjJcD7QLxGdgu1m04NDMlbBnUQuvhRM277p4rEfTpsJdQaCl
         yubsNmRSQqoUUOvYqnwRRawn24+BUZZGuVj58fWOCGoMk8uaosZmBl3P6bVxVxYIFX
         PIcl5s+FWDczGoRnBNkR6XmCvW62mV2kieCe7fAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/346] drivers: soc: ti: knav_qmss_queue: Fix error return code in knav_queue_probe
Date:   Mon, 28 Dec 2020 13:47:57 +0100
Message-Id: <20201228124927.426162867@linuxfoundation.org>
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
index ffd7046caa2ca..9f5ce52e6c161 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1867,9 +1867,10 @@ static int knav_queue_probe(struct platform_device *pdev)
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



