Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25223DD977
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbhHBOAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236293AbhHBN7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6F3B61101;
        Mon,  2 Aug 2021 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912535;
        bh=fFTB295NzYOz/Rd+1HQBqf+CP7sbJaWkDqBX1gL9IvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rqTzuVwMBWaWNmu2rSxiSTLOWFBUkBR3rIwpVJMGAHq7Cx2DM22oTSXAIukoPYt6
         Adq2MahM3rehD9tirtb3IhFlos0N2y5THUW7ptDpOy6pZvBZ3D4G7e5/jgNZPRkj/n
         UXHZ1awggaw7RbpWP81gw3wucEYY2ZxcEzlwTClA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Raul E Rangel <rrangel@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 036/104] platform/x86: amd-pmc: Fix command completion code
Date:   Mon,  2 Aug 2021 15:44:33 +0200
Message-Id: <20210802134345.209372674@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 95e1b60f8dc8f225b14619e9aca9bdd7d99167db ]

The protocol to submit a job request to SMU is to wait for
AMD_PMC_REGISTER_RESPONSE to return 1,meaning SMU is ready to take
requests. PMC driver has to make sure that the response code is always
AMD_PMC_RESULT_OK before making any command submissions.

When we submit a message to SMU, we have to wait until it processes
the request. Adding a read_poll_timeout() check as this was missing in
the existing code.

Also, add a mutex to protect amd_pmc_send_cmd() calls to SMU.

Fixes: 156ec4731cb2 ("platform/x86: amd-pmc: Add AMD platform support for S2Idle")
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Raul E Rangel <rrangel@chromium.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210629084803.248498-2-Shyam-sundar.S-k@amd.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd-pmc.c | 38 ++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index b9da58ee9b1e..1b5f149932c1 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -68,6 +68,7 @@ struct amd_pmc_dev {
 	u32 base_addr;
 	u32 cpu_id;
 	struct device *dev;
+	struct mutex lock; /* generic mutex lock */
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbgfs_dir;
 #endif /* CONFIG_DEBUG_FS */
@@ -138,9 +139,10 @@ static int amd_pmc_send_cmd(struct amd_pmc_dev *dev, bool set)
 	u8 msg;
 	u32 val;
 
+	mutex_lock(&dev->lock);
 	/* Wait until we get a valid response */
 	rc = readx_poll_timeout(ioread32, dev->regbase + AMD_PMC_REGISTER_RESPONSE,
-				val, val > 0, PMC_MSG_DELAY_MIN_US,
+				val, val != 0, PMC_MSG_DELAY_MIN_US,
 				PMC_MSG_DELAY_MIN_US * RESPONSE_REGISTER_LOOP_MAX);
 	if (rc) {
 		dev_err(dev->dev, "failed to talk to SMU\n");
@@ -156,7 +158,37 @@ static int amd_pmc_send_cmd(struct amd_pmc_dev *dev, bool set)
 	/* Write message ID to message ID register */
 	msg = (dev->cpu_id == AMD_CPU_ID_RN) ? MSG_OS_HINT_RN : MSG_OS_HINT_PCO;
 	amd_pmc_reg_write(dev, AMD_PMC_REGISTER_MESSAGE, msg);
-	return 0;
+	/* Wait until we get a valid response */
+	rc = readx_poll_timeout(ioread32, dev->regbase + AMD_PMC_REGISTER_RESPONSE,
+				val, val != 0, PMC_MSG_DELAY_MIN_US,
+				PMC_MSG_DELAY_MIN_US * RESPONSE_REGISTER_LOOP_MAX);
+	if (rc) {
+		dev_err(dev->dev, "SMU response timed out\n");
+		goto out_unlock;
+	}
+
+	switch (val) {
+	case AMD_PMC_RESULT_OK:
+		break;
+	case AMD_PMC_RESULT_CMD_REJECT_BUSY:
+		dev_err(dev->dev, "SMU not ready. err: 0x%x\n", val);
+		rc = -EBUSY;
+		goto out_unlock;
+	case AMD_PMC_RESULT_CMD_UNKNOWN:
+		dev_err(dev->dev, "SMU cmd unknown. err: 0x%x\n", val);
+		rc = -EINVAL;
+		goto out_unlock;
+	case AMD_PMC_RESULT_CMD_REJECT_PREREQ:
+	case AMD_PMC_RESULT_FAILED:
+	default:
+		dev_err(dev->dev, "SMU cmd failed. err: 0x%x\n", val);
+		rc = -EIO;
+		goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&dev->lock);
+	return rc;
 }
 
 static int __maybe_unused amd_pmc_suspend(struct device *dev)
@@ -259,6 +291,7 @@ static int amd_pmc_probe(struct platform_device *pdev)
 
 	amd_pmc_dump_registers(dev);
 
+	mutex_init(&dev->lock);
 	platform_set_drvdata(pdev, dev);
 	amd_pmc_dbgfs_register(dev);
 	return 0;
@@ -269,6 +302,7 @@ static int amd_pmc_remove(struct platform_device *pdev)
 	struct amd_pmc_dev *dev = platform_get_drvdata(pdev);
 
 	amd_pmc_dbgfs_unregister(dev);
+	mutex_destroy(&dev->lock);
 	return 0;
 }
 
-- 
2.30.2



