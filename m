Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4766A38DD
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjB0Ci5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjB0Cin (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:38:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBADBDCF;
        Sun, 26 Feb 2023 18:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF38D60CF7;
        Mon, 27 Feb 2023 02:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13847C433D2;
        Mon, 27 Feb 2023 02:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463366;
        bh=uE9WNHrTV3FuwZ9CpwC1jQf9+vqOrkg+ZiO25GDivfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRIWjebJnNMjNIHTZbKGLK2b+bYUCT/hA0BVGSQK7eEv9m33kjpmidZcdwy57vDIC
         95+aCFZrHNEwY5nSbiLXf8yNMM8+xVzTnU6ShTbTtpDEZJ2CvpRFbbYtPQE8Jp+L3c
         yFaKFGXzHgI+PBtBYwDqA75lNefjxF8shFMiRNJ7mMLWkToBlo6D8Nsx8NVFb4cP7S
         pW6QBotJSAhjrGS13C6xUJ+ZWc85+715umhqyi4ezunsx78J1ai83keKyLqDqv6XLD
         RFlfrYjRqQ794RXaykImTovTXOevowk68qwVUQfL2joCT26yQSkEvdI1xQu5TJYYKx
         SWZ1D5+k1MdoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moti Haimovski <mhaimovski@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        ttayar@habana.ai, dliberman@habana.ai, osharabi@habana.ai,
        obitton@habana.ai, dhirschfeld@habana.ai
Subject: [PATCH AUTOSEL 6.2 30/60] habanalabs: extend fatal messages to contain PCI info
Date:   Sun, 26 Feb 2023 21:00:15 -0500
Message-Id: <20230227020045.1045105-30-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 87ab329e65d49..f7b9c3871518b 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -1566,7 +1566,8 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 		if (rc == -EBUSY) {
 			if (hdev->device_fini_pending) {
 				dev_crit(hdev->dev,
-					"Failed to kill all open processes, stopping hard reset\n");
+					"%s Failed to kill all open processes, stopping hard reset\n",
+					dev_name(&(hdev)->pdev->dev));
 				goto out_err;
 			}
 
@@ -1576,7 +1577,8 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 
 		if (rc) {
 			dev_crit(hdev->dev,
-				"Failed to kill all open processes, stopping hard reset\n");
+				"%s Failed to kill all open processes, stopping hard reset\n",
+				dev_name(&(hdev)->pdev->dev));
 			goto out_err;
 		}
 
@@ -1627,14 +1629,16 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
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
@@ -1752,9 +1756,13 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
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
@@ -1789,7 +1797,9 @@ int hl_device_reset(struct hl_device *hdev, u32 flags)
 	hdev->reset_info.in_compute_reset = 0;
 
 	if (hard_reset) {
-		dev_err(hdev->dev, "Failed to reset! Device is NOT usable\n");
+		dev_err(hdev->dev,
+			"%s Failed to reset! Device is NOT usable\n",
+			dev_name(&(hdev)->pdev->dev));
 		hdev->reset_info.hard_reset_cnt++;
 	} else if (reset_upon_device_release) {
 		spin_unlock(&hdev->reset_info.lock);
@@ -2186,7 +2196,8 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 	}
 
 	dev_notice(hdev->dev,
-		"Successfully added device to habanalabs driver\n");
+		"Successfully added device %s to habanalabs driver\n",
+		dev_name(&(hdev)->pdev->dev));
 
 	hdev->init_done = true;
 
@@ -2235,11 +2246,11 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
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
@@ -2295,7 +2306,8 @@ void hl_device_fini(struct hl_device *hdev)
 
 		if (ktime_compare(ktime_get(), timeout) > 0) {
 			dev_crit(hdev->dev,
-				"Failed to remove device because reset function did not finish\n");
+				"%s Failed to remove device because reset function did not finish\n",
+				dev_name(&(hdev)->pdev->dev));
 			return;
 		}
 	}
-- 
2.39.0

