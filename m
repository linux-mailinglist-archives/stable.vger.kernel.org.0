Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE03658185
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbiL1Q3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiL1Q2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11983167FA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7F08B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B987DC433D2;
        Wed, 28 Dec 2022 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244692;
        bh=pUmOk+/0Cxv748eGMVKBCkBuUc34CYUoMToL6P/7IVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfEQEm6Hh44SjIr4dfzwU5HfV7Df1RN4moU7f4w1WXTCabN7A/bxShkVr3mm/atFQ
         F49EnH5wFREvvHUvVIt2rZexpCHgz4RyB1v3hhnXcYmXZ8Qcq7HmANQYVOdejxKOtC
         rUdrTeoXOEPHTi1QdqYPLyDVwJgb8aaMi7Gmr3rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0720/1146] cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()
Date:   Wed, 28 Dec 2022 15:37:39 +0100
Message-Id: <20221228144349.702132198@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 61c80d1c3833e196256fb060382db94f24d3d9a7 ]

If device_register() fails in cxl_register_afu|adapter(), the device
is not added, device_unregister() can not be called in the error path,
otherwise it will cause a null-ptr-deref because of removing not added
device.

As comment of device_register() says, it should use put_device() to give
up the reference in the error path. So split device_unregister() into
device_del() and put_device(), then goes to put dev when register fails.

Fixes: 14baf4d9c739 ("cxl: Add guest-specific code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111145440.2426970-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/guest.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
index 375f692ae9d6..fb95a2d5cef4 100644
--- a/drivers/misc/cxl/guest.c
+++ b/drivers/misc/cxl/guest.c
@@ -965,10 +965,10 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 	 * if it returns an error!
 	 */
 	if ((rc = cxl_register_afu(afu)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_afu_add(afu)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/*
 	 * pHyp doesn't expose the programming models supported by the
@@ -984,7 +984,7 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 		afu->modes_supported = CXL_MODE_DIRECTED;
 
 	if ((rc = cxl_afu_select_best_mode(afu)))
-		goto err_put2;
+		goto err_remove_sysfs;
 
 	adapter->afu[afu->slice] = afu;
 
@@ -1004,10 +1004,12 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 
 	return 0;
 
-err_put2:
+err_remove_sysfs:
 	cxl_sysfs_afu_remove(afu);
-err_put1:
-	device_unregister(&afu->dev);
+err_del_dev:
+	device_del(&afu->dev);
+err_put_dev:
+	put_device(&afu->dev);
 	free = false;
 	guest_release_serr_irq(afu);
 err2:
@@ -1141,18 +1143,20 @@ struct cxl *cxl_guest_init_adapter(struct device_node *np, struct platform_devic
 	 * even if it returns an error!
 	 */
 	if ((rc = cxl_register_adapter(adapter)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_adapter_add(adapter)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/* release the context lock as the adapter is configured */
 	cxl_adapter_context_unlock(adapter);
 
 	return adapter;
 
-err_put1:
-	device_unregister(&adapter->dev);
+err_del_dev:
+	device_del(&adapter->dev);
+err_put_dev:
+	put_device(&adapter->dev);
 	free = false;
 	cxl_guest_remove_chardev(adapter);
 err1:
-- 
2.35.1



