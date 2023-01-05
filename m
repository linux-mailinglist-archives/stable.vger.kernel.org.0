Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE7465EBE2
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbjAENDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbjAENDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:03:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5CF5BA0C
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:03:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A6EE619FF
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11288C433F0;
        Thu,  5 Jan 2023 13:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923802;
        bh=byrrzkFdnrakDP/6xlfs5DVAPH8WeA7C57W6w4gIBt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXuis1b0FH5qXltfpJbvAd4AsfxDFwcHwwCy8f26xEDpOycQDl896fwJdRIU10+EN
         Koz33FNLYodZ9h+vNKt1cLuD7k9cB0WBqgYkSqD9W9RaLl7P39h7pdpwaixbaCwXB4
         66ryy+hk/ZPisrQeeJi695wTsi28066qrqPJi3js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 138/251] cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()
Date:   Thu,  5 Jan 2023 13:54:35 +0100
Message-Id: <20230105125341.154380024@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

[ Upstream commit 02cd3032b154fa02fdf90e7467abaeed889330b2 ]

If device_register() fails in cxl_pci_afu|adapter(), the device
is not added, device_unregister() can not be called in the error
path, otherwise it will cause a null-ptr-deref because of removing
not added device.

As comment of device_register() says, it should use put_device() to give
up the reference in the error path. So split device_unregister() into
device_del() and put_device(), then goes to put dev when register fails.

Fixes: f204e0b8cedd ("cxl: Driver code for powernv PCIe based cards for userspace access")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111145440.2426970-2-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/pci.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index a5422f483ad5..f7417033a7a8 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -1187,10 +1187,10 @@ static int pci_init_afu(struct cxl *adapter, int slice, struct pci_dev *dev)
 	 * if it returns an error!
 	 */
 	if ((rc = cxl_register_afu(afu)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_afu_add(afu)))
-		goto err_put1;
+		goto err_del_dev;
 
 	adapter->afu[afu->slice] = afu;
 
@@ -1199,10 +1199,12 @@ static int pci_init_afu(struct cxl *adapter, int slice, struct pci_dev *dev)
 
 	return 0;
 
-err_put1:
+err_del_dev:
+	device_del(&afu->dev);
+err_put_dev:
 	pci_deconfigure_afu(afu);
 	cxl_debugfs_afu_remove(afu);
-	device_unregister(&afu->dev);
+	put_device(&afu->dev);
 	return rc;
 
 err_free_native:
@@ -1589,23 +1591,25 @@ static struct cxl *cxl_pci_init_adapter(struct pci_dev *dev)
 	 * even if it returns an error!
 	 */
 	if ((rc = cxl_register_adapter(adapter)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_adapter_add(adapter)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/* Release the context lock as adapter is configured */
 	cxl_adapter_context_unlock(adapter);
 
 	return adapter;
 
-err_put1:
+err_del_dev:
+	device_del(&adapter->dev);
+err_put_dev:
 	/* This should mirror cxl_remove_adapter, except without the
 	 * sysfs parts
 	 */
 	cxl_debugfs_adapter_remove(adapter);
 	cxl_deconfigure_adapter(adapter);
-	device_unregister(&adapter->dev);
+	put_device(&adapter->dev);
 	return ERR_PTR(rc);
 
 err_release:
-- 
2.35.1



