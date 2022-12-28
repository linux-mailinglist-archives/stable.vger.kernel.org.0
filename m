Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C289657B84
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiL1PXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbiL1PWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68B413FB7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E244CE076E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9008C433EF;
        Wed, 28 Dec 2022 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240943;
        bh=hovzrAr0C5geGX7T8gSHxX0Zd5O0iepBHfxie7lVWCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYqQYkPe6PXc9vdNEC8o1PRaDfhiFx4X2IfK8ryZ2km7z5IicAvDO6AzpN8Hu8ViM
         rCieXESNdCDwrCnpVeJs2rL9W8tEQaWG7GsEf/UI7a7pgyNDj6YLWXnmF/KdjAFB3d
         MEqk3BpmAemHyAU6JmGPxFWu7iGQJ64/rgdBMAhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Weiyang <wangweiyang2@huawei.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0187/1146] rapidio: fix possible UAF when kfifo_alloc() fails
Date:   Wed, 28 Dec 2022 15:28:46 +0100
Message-Id: <20221228144335.230878561@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Weiyang <wangweiyang2@huawei.com>

[ Upstream commit 02d7d89f816951e0862147d751b1150d67aaebdd ]

If kfifo_alloc() fails in mport_cdev_open(), goto err_fifo and just free
priv. But priv is still in the chdev->file_list, then list traversal
may cause UAF. This fixes the following smatch warning:

drivers/rapidio/devices/rio_mport_cdev.c:1930 mport_cdev_open() warn: '&priv->list' not removed from list

Link: https://lkml.kernel.org/r/20221123095147.52408-1-wangweiyang2@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 3cc83997a1f8..fecf523f36d8 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1904,10 +1904,6 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 
 	priv->md = chdev;
 
-	mutex_lock(&chdev->file_mutex);
-	list_add_tail(&priv->list, &chdev->file_list);
-	mutex_unlock(&chdev->file_mutex);
-
 	INIT_LIST_HEAD(&priv->db_filters);
 	INIT_LIST_HEAD(&priv->pw_filters);
 	spin_lock_init(&priv->fifo_lock);
@@ -1926,6 +1922,9 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 	spin_lock_init(&priv->req_lock);
 	mutex_init(&priv->dma_lock);
 #endif
+	mutex_lock(&chdev->file_mutex);
+	list_add_tail(&priv->list, &chdev->file_list);
+	mutex_unlock(&chdev->file_mutex);
 
 	filp->private_data = priv;
 	goto out;
-- 
2.35.1



