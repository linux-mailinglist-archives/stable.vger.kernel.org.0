Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1432266C800
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbjAPQgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbjAPQfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE8530E89
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:23:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BCC8B81065
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F36EC433EF;
        Mon, 16 Jan 2023 16:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886211;
        bh=ExXX4NPP+/iSRI8flXLqrYMF47wf8fkrtShGuX5ILjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4EKQLauejIBC33bY56D4IkM6S3UEXE44xQq4FFH8VzpqXNeY/ZHr5Icj4fugp8E4
         2IDnn1VjRJYsA81wXzmYGiOPceD5971xiCkYSDuDGvvqsTXVK6FvRQQqcpDyMaWikt
         loWB6CL1sE9Act4kEedrIIWY49AGnBPBCAUz/6O4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 317/658] fbdev: pm2fb: fix missing pci_disable_device()
Date:   Mon, 16 Jan 2023 16:46:45 +0100
Message-Id: <20230116154924.064627960@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ed359a464846b48f76ea6cc5cd8257e545ac97f4 ]

Add missing pci_disable_device() in error path of probe() and remove() path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pm2fb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index 8ae010f07d7d..0ec4be2f2e8c 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1529,8 +1529,10 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	info = framebuffer_alloc(sizeof(struct pm2fb_par), &pdev->dev);
-	if (!info)
-		return -ENOMEM;
+	if (!info) {
+		err = -ENOMEM;
+		goto err_exit_disable;
+	}
 	default_par = info->par;
 
 	switch (pdev->device) {
@@ -1711,6 +1713,8 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	release_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len);
  err_exit_neither:
 	framebuffer_release(info);
+ err_exit_disable:
+	pci_disable_device(pdev);
 	return retval;
 }
 
@@ -1737,6 +1741,7 @@ static void pm2fb_remove(struct pci_dev *pdev)
 	fb_dealloc_cmap(&info->cmap);
 	kfree(info->pixmap.addr);
 	framebuffer_release(info);
+	pci_disable_device(pdev);
 }
 
 static const struct pci_device_id pm2fb_id_table[] = {
-- 
2.35.1



