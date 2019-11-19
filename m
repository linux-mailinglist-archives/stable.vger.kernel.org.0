Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE581018BE
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfKSF3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbfKSF3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 738D921939;
        Tue, 19 Nov 2019 05:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141353;
        bh=yXJ6Nbeh5e1xKhtBk4G9bNNBN67AaO4fXPVEf4EEI/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsKqK1ZlUhMTSlVUOcBkElQN44cpKKXQCnBaRpFROiItTTB7xQRDv0/s7Bv04Myno
         RlwRgmD3oAPCByQVI4KHrIuwvCrdOFqEVsjkcAVhGiEE2KrOb5AEUlyuChbol9Q//Z
         MTlJzvbKjRDjZMRiUI5KbBnMkBuIocwRF68/ozgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/422] RDMA/core: Follow correct unregister order between sysfs and cgroup
Date:   Tue, 19 Nov 2019 06:15:28 +0100
Message-Id: <20191119051407.383478759@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit c715a39541bb399eb03d728a996b224d90ce1336 ]

During register_device() init sequence is,
(a) register with rdma cgroup followed by
(b) register with sysfs

Therefore, unregister_device() sequence should follow the reverse order.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 6d8ac51a39cc0..6a585c3e21923 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -599,8 +599,8 @@ void ib_unregister_device(struct ib_device *device)
 	}
 	up_read(&lists_rwsem);
 
-	ib_device_unregister_rdmacg(device);
 	ib_device_unregister_sysfs(device);
+	ib_device_unregister_rdmacg(device);
 
 	mutex_unlock(&device_mutex);
 
-- 
2.20.1



