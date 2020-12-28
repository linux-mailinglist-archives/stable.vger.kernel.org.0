Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFDE2E4087
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501874AbgL1OR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440203AbgL1OR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBD222063A;
        Mon, 28 Dec 2020 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165030;
        bh=E0AtVvM9J6+qU1oA0xg0oXB1ALa+lGHAU7dIFhTwAk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABHfQBxbTTUrjs65STmm57NKf5DHn7iI9MtzkxLF8fKSUXVMJYMGxfKH1kO59q+ad
         UftyrJmsM75mDDYtyXt4zy7pKtgnTHk/CkEzPYrBQqnAm5Iypz32qDyflRhs3Py4UY
         ydGJBBqeTGYRSRCUNz4d9ohVOzETs0qxwTX9AEjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/717] s390/cio: fix use-after-free in ccw_device_destroy_console
Date:   Mon, 28 Dec 2020 13:46:24 +0100
Message-Id: <20201228125039.498060061@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 14d4c4fa46eeaa3922e8e1c4aa727eb0a1412804 ]

Use of sch->dev reference after the put_device() call could trigger
the use-after-free bugs.

Fix this by simply adjusting the position of put_device.

Fixes: 37db8985b211 ("s390/cio: add basic protected virtualization support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
[vneethv@linux.ibm.com: Slight modification in the commit-message]
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index b29fe8d50baf2..33280ca181e95 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1664,10 +1664,10 @@ void __init ccw_device_destroy_console(struct ccw_device *cdev)
 	struct io_subchannel_private *io_priv = to_io_private(sch);
 
 	set_io_private(sch, NULL);
-	put_device(&sch->dev);
-	put_device(&cdev->dev);
 	dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
 			  io_priv->dma_area, io_priv->dma_area_dma);
+	put_device(&sch->dev);
+	put_device(&cdev->dev);
 	kfree(io_priv);
 }
 
-- 
2.27.0



