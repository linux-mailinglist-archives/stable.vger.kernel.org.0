Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0ABD6AF11C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbjCGSjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbjCGSjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:39:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B4ABDD01
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:30:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 182B0B819D2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5ECC4339B;
        Tue,  7 Mar 2023 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213782;
        bh=Y0dlhixVMFmAVL3Bm+t6DceKYmg3fXaXPKzamL6SVM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3otatq+r6lOsRafP/9QugBIBmoSR2jQU2ObTgBedjACzqQuMtpgInxY9mbyfoyCx
         DKNp8IQVNkE0vVhpZMv3XvuEJMH3y1t+dnMTg/b8F6FaFRRjyvzFYt+p1WAlmkKg/z
         oZ2QZYhzZ5FNe8OU4pgjPouTcG6ozwqUAN3oGcwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moti Haimovski <mhaimovski@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 618/885] habanalabs: extend fatal messages to contain PCI info
Date:   Tue,  7 Mar 2023 17:59:12 +0100
Message-Id: <20230307170029.128177837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Moti Haimovski <mhaimovski@habana.ai>

[ Upstream commit 2a0a839b6a28f7c4c528bb75b740c7f38ef79a37 ]

This commit attaches the PCI device address to driver fatal messages
in order to ease debugging in multi-device setups.

Signed-off-by: Moti Haimovski <mhaimovski@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c | 38 ++++++++++++++++---------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 233d8b46c831f..e0dca445abf14 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -1458,7 +1458,8 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 		if (rc == -EBUSY) {
 			if (hdev->device_fini_pending) {
 				dev_crit(hdev->dev,
-					"Failed to kill all open processes, stopping hard reset\n");
+					"%s Failed to kill all open processes, stopping hard reset\n",
+					dev_name(&(hdev)->pdev->dev));
 				goto out_err;
 			}
 
@@ -1468,7 +1469,8 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 
 		if (rc) {
 			dev_crit(hdev->dev,
-				"Failed to kill all open processes, stopping hard reset\n");
+				"%s Failed to kill all open processes, stopping hard reset\n",
+				dev_name(&(hdev)->pdev->dev));
 			goto out_err;
 		}
 
@@ -1519,14 +1521,16 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 			 * ensure driver puts the driver in a unusable state
 			 */
 			dev_crit(hdev->dev,
-				"Consecutive FW fatal errors received, stopping hard reset\n");
+				"%s Consecutive FW fatal errors received, stopping hard reset\n",
+				dev_name(&(hdev)->pdev->dev));
 			rc = -EIO;
 			goto out_err;
 		}
 
 		if (hdev->kernel_ctx) {
 			dev_crit(hdev->dev,
-				"kernel ctx was alive during hard reset, something is terribly wrong\n");
+				"%s kernel ctx was alive during hard reset, something is terribly wrong\n",
+				dev_name(&(hdev)->pdev->dev));
 			rc = -EBUSY;
 			goto out_err;
 		}
@@ -1645,9 +1649,13 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 	hdev->reset_info.needs_reset = false;
 
 	if (hard_reset)
-		dev_info(hdev->dev, "Successfully finished resetting the device\n");
+		dev_info(hdev->dev,
+			 "Successfully finished resetting the %s device\n",
+			 dev_name(&(hdev)->pdev->dev));
 	else
-		dev_dbg(hdev->dev, "Successfully finished resetting the device\n");
+		dev_dbg(hdev->dev,
+			"Successfully finished resetting the %s device\n",
+			dev_name(&(hdev)->pdev->dev));
 
 	if (hard_reset) {
 		hdev->reset_info.hard_reset_cnt++;
@@ -1681,7 +1689,9 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 	hdev->reset_info.in_compute_reset = 0;
 
 	if (hard_reset) {
-		dev_err(hdev->dev, "Failed to reset! Device is NOT usable\n");
+		dev_err(hdev->dev,
+			"%s Failed to reset! Device is NOT usable\n",
+			dev_name(&(hdev)->pdev->dev));
 		hdev->reset_info.hard_reset_cnt++;
 	} else if (reset_upon_device_release) {
 		spin_unlock(&hdev->reset_info.lock);
@@ -2004,7 +2014,8 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 	}
 
 	dev_notice(hdev->dev,
-		"Successfully added device to habanalabs driver\n");
+		"Successfully added device %s to habanalabs driver\n",
+		dev_name(&(hdev)->pdev->dev));
 
 	hdev->init_done = true;
 
@@ -2053,11 +2064,11 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 		device_cdev_sysfs_add(hdev);
 	if (hdev->pdev)
 		dev_err(&hdev->pdev->dev,
-			"Failed to initialize hl%d. Device is NOT usable !\n",
-			hdev->cdev_idx);
+			"Failed to initialize hl%d. Device %s is NOT usable !\n",
+			hdev->cdev_idx, dev_name(&(hdev)->pdev->dev));
 	else
-		pr_err("Failed to initialize hl%d. Device is NOT usable !\n",
-			hdev->cdev_idx);
+		pr_err("Failed to initialize hl%d. Device %s is NOT usable !\n",
+			hdev->cdev_idx, dev_name(&(hdev)->pdev->dev));
 
 	return rc;
 }
@@ -2113,7 +2124,8 @@ void hl_device_fini(struct hl_device *hdev)
 
 		if (ktime_compare(ktime_get(), timeout) > 0) {
 			dev_crit(hdev->dev,
-				"Failed to remove device because reset function did not finish\n");
+				"%s Failed to remove device because reset function did not finish\n",
+				dev_name(&(hdev)->pdev->dev));
 			return;
 		}
 	}
-- 
2.39.2



