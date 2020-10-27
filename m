Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3212A29BF62
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793753AbgJ0PIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793470AbgJ0PGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DFE21707;
        Tue, 27 Oct 2020 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811183;
        bh=Qj0yDVdUi0H6D/jVOZWgAw0JgAFzmIciiHVmpsfv7To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isFaUDDkt1hR6qJ3jdR0er7kONbpJbRiKgZ2nL8O1dfqiUope6CgH9BAVmH3mXe6F
         067+YxU1ZkNotY3nw+OvnsKDQBr9SHDc1VG05rD5X72BoDt2VdxUCMY3e/SqT6MlnO
         BTdQw4n5gW836Ma3BMmEGi5AS3kl2I5q8SjwglE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 402/633] i3c: master: Fix error return in cdns_i3c_master_probe()
Date:   Tue, 27 Oct 2020 14:52:25 +0100
Message-Id: <20201027135541.575435971@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit abea14bfdebbe9bd02f2ad24a1f3a878ed21c8f0 ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0.

Fixes: 603f2bee2c54 ("i3c: master: Add driver for Cadence IP")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-i3c/20200911033350.23904-1-jingxiangfeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/i3c-master-cdns.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/i3c-master-cdns.c b/drivers/i3c/master/i3c-master-cdns.c
index 3fee8bd7fe20b..3f2226928fe05 100644
--- a/drivers/i3c/master/i3c-master-cdns.c
+++ b/drivers/i3c/master/i3c-master-cdns.c
@@ -1635,8 +1635,10 @@ static int cdns_i3c_master_probe(struct platform_device *pdev)
 	master->ibi.slots = devm_kcalloc(&pdev->dev, master->ibi.num_slots,
 					 sizeof(*master->ibi.slots),
 					 GFP_KERNEL);
-	if (!master->ibi.slots)
+	if (!master->ibi.slots) {
+		ret = -ENOMEM;
 		goto err_disable_sysclk;
+	}
 
 	writel(IBIR_THR(1), master->regs + CMD_IBI_THR_CTRL);
 	writel(MST_INT_IBIR_THR, master->regs + MST_IER);
-- 
2.25.1



