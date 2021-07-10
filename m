Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0393C2E69
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhGJC1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhGJC0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED6F613D1;
        Sat, 10 Jul 2021 02:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883827;
        bh=IMXjVUquktrG3q+4vQMwMY2LBFaGvm7PDZoGBRFpqBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idczcJ86jA8o8TtFxDOQOwQ0qnm+c1Ts1czWuds6CGRXrEUkrJ0kINFUBX2B3CZAg
         DIDh8JdMghVxVOOG01DxyQfa3HjucY0b6TQcShtRXQcjBBKvAzEKJNTmA6wCz4vCf4
         EFnST4eAU8fs2ho7nFNUeKmOAXOgjrwESosPatVK9EKxBqLxCsb1KC0Usc0kB6QnH+
         BJCSBbk7pTEQBw1OsCbLw2m8Rwp3L3WoBQcbuGjzXRtmQvlfq/F32T3JNNPqAtThmG
         ILgTZw0jeG38F7PjSzo8z4qTrqelAcbx+n8d/KZ1WcjB/u2/pXSbDfUaPSka43cn3p
         nNTnawD0aNsgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koby Elbaz <kelbaz@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 075/104] habanalabs: set rc as 'valid' in case of intentional func exit
Date:   Fri,  9 Jul 2021 22:21:27 -0400
Message-Id: <20210710022156.3168825-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koby Elbaz <kelbaz@habana.ai>

[ Upstream commit 11d5cb8b95456e2432dfee2ffcebf0623998493a ]

fix the following smatch warnings:
hl_fw_static_init_cpu() warn: missing error code 'rc'

Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c      | 5 +++--
 drivers/misc/habanalabs/common/firmware_if.c | 5 ++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 334009e83823..b11e9830422e 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -1370,8 +1370,9 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 	}
 
 	/*
-	 * From this point, in case of an error, add char devices and create
-	 * sysfs nodes as part of the error flow, to allow debugging.
+	 * From this point, override rc (=0) in case of an error to allow
+	 * debugging (by adding char devices and create sysfs nodes as part of
+	 * the error flow).
 	 */
 	add_cdev_sysfs_on_err = true;
 
diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index 09706c571e95..7a96c9753dbf 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -803,11 +803,14 @@ int hl_fw_init_cpu(struct hl_device *hdev, u32 cpu_boot_status_reg,
 
 	if (!(hdev->fw_loading & FW_TYPE_LINUX)) {
 		dev_info(hdev->dev, "Skip loading Linux F/W\n");
+		rc = 0;
 		goto out;
 	}
 
-	if (status == CPU_BOOT_STATUS_SRAM_AVAIL)
+	if (status == CPU_BOOT_STATUS_SRAM_AVAIL) {
+		rc = 0;
 		goto out;
+	}
 
 	dev_info(hdev->dev,
 		"Loading firmware to device, may take some time...\n");
-- 
2.30.2

