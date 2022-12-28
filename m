Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A133465789A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiL1Owq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiL1OwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D4D120AE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:52:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80F00B816D6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48D4C433EF;
        Wed, 28 Dec 2022 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239119;
        bh=OTzQ5ZHhTu9kDtqyQjOrJZWU9fI/zD6cMSkNShdbsks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgI8xpuk1KuBrICtfDGyCLUwiHv/6vRTHIFUW6niybD7KBQ71h2qbC++WQswBiPDT
         zg6BfFAR2G5o+YstlJZCdwD9MpTiNHOQ5mtxjUV8aWvJWmVxLPCdZpFHnvzUTcLdPr
         s/fzmOMzwEgQNWTpIunDP53WfMeFABM5rLZUDqbw=
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
Subject: [PATCH 5.15 135/731] rapidio: fix possible UAF when kfifo_alloc() fails
Date:   Wed, 28 Dec 2022 15:34:02 +0100
Message-Id: <20221228144300.462168394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 48cd9b7f3b89..b8c09eaa23b5 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1903,10 +1903,6 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 
 	priv->md = chdev;
 
-	mutex_lock(&chdev->file_mutex);
-	list_add_tail(&priv->list, &chdev->file_list);
-	mutex_unlock(&chdev->file_mutex);
-
 	INIT_LIST_HEAD(&priv->db_filters);
 	INIT_LIST_HEAD(&priv->pw_filters);
 	spin_lock_init(&priv->fifo_lock);
@@ -1925,6 +1921,9 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
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



