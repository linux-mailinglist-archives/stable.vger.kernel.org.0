Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537766AEAC1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjCGRhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjCGRgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:36:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B390515CB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:32:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD976B817AE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169E3C433D2;
        Tue,  7 Mar 2023 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210364;
        bh=SM1GI1EP0XdNredmYV8rw9i5Ps7Z/TjaBcz2Bxa1uAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcpFOaVS77i8BCIrmmMrLFqOvXxfgu8Yp3CKJHItoJB1fvXnsb7ny1PmjLXp19YpM
         pSqqeSSkAZqSeQb3z8WBDRUUSF6lp0nXdqpbpK2ZM2Y0k4HurtDu7ZGrV4lgJ8HUJu
         8ke/InqpTPzClckMg/t9OVlbYNjlphWKCANmuqr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0517/1001] firmware: stratix10-svc: add missing gen_pool_destroy() in stratix10_svc_drv_probe()
Date:   Tue,  7 Mar 2023 17:54:49 +0100
Message-Id: <20230307170043.871938943@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9175ee1a99d57ec07d66ff572e1d5a724477ab37 ]

In error path in stratix10_svc_drv_probe(), gen_pool_destroy() should be called
to destroy the memory pool that created by svc_create_memory_pool().

Fixes: 7ca5ce896524 ("firmware: add Intel Stratix10 service layer driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20221129163602.462369-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index b4081f4d88a37..1a5640b3ab422 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1138,13 +1138,17 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 
 	/* allocate service controller and supporting channel */
 	controller = devm_kzalloc(dev, sizeof(*controller), GFP_KERNEL);
-	if (!controller)
-		return -ENOMEM;
+	if (!controller) {
+		ret = -ENOMEM;
+		goto err_destroy_pool;
+	}
 
 	chans = devm_kmalloc_array(dev, SVC_NUM_CHANNEL,
 				   sizeof(*chans), GFP_KERNEL | __GFP_ZERO);
-	if (!chans)
-		return -ENOMEM;
+	if (!chans) {
+		ret = -ENOMEM;
+		goto err_destroy_pool;
+	}
 
 	controller->dev = dev;
 	controller->num_chans = SVC_NUM_CHANNEL;
@@ -1159,7 +1163,7 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 	ret = kfifo_alloc(&controller->svc_fifo, fifo_size, GFP_KERNEL);
 	if (ret) {
 		dev_err(dev, "failed to allocate FIFO\n");
-		return ret;
+		goto err_destroy_pool;
 	}
 	spin_lock_init(&controller->svc_fifo_lock);
 
@@ -1221,6 +1225,8 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 
 err_free_kfifo:
 	kfifo_free(&controller->svc_fifo);
+err_destroy_pool:
+	gen_pool_destroy(genpool);
 	return ret;
 }
 
-- 
2.39.2



