Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0E2667484
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjALOIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbjALOIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:08:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F9F574EF
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:04:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC5E962026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97207C433D2;
        Thu, 12 Jan 2023 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532280;
        bh=GPQqmx4jNPwa2xyzfJgojFn/OpoC/W1FiKLUnUWcDMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z735VC8M5CM8E5fe2Dhfm5kgn4EWg13mB68fJBC08DWHFTRKz2yTJYJMLAhkcG1lZ
         dp08l+IGsVA9yXweqOrLhHMz/bl15NxxrWQ/rShI/9AOzgl8Pb023L4HL2D03gBs6z
         YDEmi5H1WmgGN+UkAQ/x1wUYkcxX3JF6zi3BUhrU=
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
Subject: [PATCH 5.10 102/783] rapidio: devices: fix missing put_device in mport_cdev_open
Date:   Thu, 12 Jan 2023 14:46:58 +0100
Message-Id: <20230112135528.932483309@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index b8c09eaa23b5..5ac2dc1e2abd 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1911,6 +1911,7 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 			  sizeof(struct rio_event) * MPORT_EVENT_DEPTH,
 			  GFP_KERNEL);
 	if (ret < 0) {
+		put_device(&chdev->dev);
 		dev_err(&chdev->dev, DRV_NAME ": kfifo_alloc failed\n");
 		ret = -ENOMEM;
 		goto err_fifo;
-- 
2.35.1



