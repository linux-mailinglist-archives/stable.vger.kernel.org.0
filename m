Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2462C0830
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbgKWMqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:46:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbgKWMqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:46:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D485320732;
        Mon, 23 Nov 2020 12:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135580;
        bh=hexWN8t9OWoJF/djr6mOixR9wKRlPWg6Mhv5UdRqB5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0Q0tZ5V/OA1ms0R0IAVRNTWMmB0njcyL6kWzwgb4uS/JEdZhETmR4mmsFRHW/XVH
         f0fNqfyLdI/v9HzlmzebW9htOCWdcpgrdrIzIQrKKobRraGE2sI1TD8SYxAT78hB2X
         cwgb3qsyIXHuEVA7+JabSC3qA/zY8BRYt8zcWdec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 120/252] RDMA/pvrdma: Fix missing kfree() in pvrdma_register_device()
Date:   Mon, 23 Nov 2020 13:21:10 +0100
Message-Id: <20201123121841.384623325@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit d035c3f6cdb8e5d5a17adcbb79d7453417a6077d ]

Fix missing kfree in pvrdma_register_device() when failure from
ib_device_set_netdev().

Fixes: 4b38da75e089 ("RDMA/drivers: Convert easy drivers to use ib_device_set_netdev()")
Link: https://lore.kernel.org/r/20201111032202.17925-1-miaoqinglang@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 780fd2dfc07eb..10e67283b9db7 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -266,7 +266,7 @@ static int pvrdma_register_device(struct pvrdma_dev *dev)
 	}
 	ret = ib_device_set_netdev(&dev->ib_dev, dev->netdev, 1);
 	if (ret)
-		return ret;
+		goto err_srq_free;
 	spin_lock_init(&dev->srq_tbl_lock);
 	rdma_set_device_sysfs_group(&dev->ib_dev, &pvrdma_attr_group);
 
-- 
2.27.0



