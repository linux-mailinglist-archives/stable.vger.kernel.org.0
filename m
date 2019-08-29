Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D5A254C
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfH2S2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbfH2SPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 409A82189D;
        Thu, 29 Aug 2019 18:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102511;
        bh=ZRphFBhD0xKR03GxL0DcPOuwSe/QgK3Rp3TsN7hYc6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRCAPTdOFpF/5TZ7HCW6Ddf8MuF967EaKBjZ/KtOJv8ry3pVuQ+nGTNf27Z0c7XDq
         CkA3KMS7Nm7bW1u1vNo3yUaYNsg1bVVjn3xzpYOYKZGlJKVwF2mFouP2oimJr70DPC
         P/I1Y5ksc60hnBUddi80FaWqE4ZtCsuFZ56WIZI8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Parav Pandit <parav@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 59/76] RDMA/cma: fix null-ptr-deref Read in cma_cleanup
Date:   Thu, 29 Aug 2019 14:12:54 -0400
Message-Id: <20190829181311.7562-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit a7bfb93f0211b4a2f1ffeeb259ed6206bac30460 ]

In cma_init, if cma_configfs_init fails, need to free the
previously memory and return fail, otherwise will trigger
null-ptr-deref Read in cma_cleanup.

cma_cleanup
  cma_configfs_exit
    configfs_unregister_subsystem

Fixes: 045959db65c6 ("IB/cma: Add configfs for rdma_cm")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Link: https://lore.kernel.org/r/1566188859-103051-1-git-send-email-zhengbin13@huawei.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 19f1730a4f244..a68d0ccf67a43 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4724,10 +4724,14 @@ static int __init cma_init(void)
 	if (ret)
 		goto err;
 
-	cma_configfs_init();
+	ret = cma_configfs_init();
+	if (ret)
+		goto err_ib;
 
 	return 0;
 
+err_ib:
+	ib_unregister_client(&cma_client);
 err:
 	unregister_netdevice_notifier(&cma_nb);
 	ib_sa_unregister_client(&sa_client);
-- 
2.20.1

