Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C18166C9FE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjAPQ6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjAPQ5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:57:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E0E367DA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:40:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A976C6105A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96791C433EF;
        Mon, 16 Jan 2023 16:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887253;
        bh=/YBRRRwvGOfTLzCvvbaplaCryfZTfAKvspcw818Z5j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DK9HLHAOKZeP/C38CTXU1z6l5IA3tpkG+l8bDY3lINYwpsP6vbWqRUMTdmcYG+RSv
         SqfFDImxHvgFsyFZfXklSTH1XewPHM6799X3GMEA3aBM1XYM1KMJhORYSraZjt42WZ
         xKWHkUZgWla/5DZRb218FKlnLufAIKdZroF5aYaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cai Xinchen <caixinchen1@huawei.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Wang Weiyang <wangweiyang2@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/521] rapidio: devices: fix missing put_device in mport_cdev_open
Date:   Mon, 16 Jan 2023 16:45:41 +0100
Message-Id: <20230116154850.770540211@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Cai Xinchen <caixinchen1@huawei.com>

[ Upstream commit d5b6e6eba3af11cb2a2791fa36a2524990fcde1a ]

When kfifo_alloc fails, the refcount of chdev->dev is left incremental.
We should use put_device(&chdev->dev) to decrease the ref count of
chdev->dev to avoid refcount leak.

Link: https://lkml.kernel.org/r/20221203085721.13146-1-caixinchen1@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 1f4114b23f5a..ee19c511adce 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1917,6 +1917,7 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 			  sizeof(struct rio_event) * MPORT_EVENT_DEPTH,
 			  GFP_KERNEL);
 	if (ret < 0) {
+		put_device(&chdev->dev);
 		dev_err(&chdev->dev, DRV_NAME ": kfifo_alloc failed\n");
 		ret = -ENOMEM;
 		goto err_fifo;
-- 
2.35.1



