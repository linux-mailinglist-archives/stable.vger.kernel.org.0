Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A203CE523
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347308AbhGSPrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236215AbhGSPmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:42:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B50CB61376;
        Mon, 19 Jul 2021 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711709;
        bh=IMXjVUquktrG3q+4vQMwMY2LBFaGvm7PDZoGBRFpqBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYXwt3g6E1ru1yTzsfVL+0KrGAwcpeD0EVjOFOZpqjW04ZVM9GrUCCbw0ZhOePowc
         Wn8gSw/YKSIaC6rAHtVYCKz0r0b2vifFyeNscRS6OWibzLgkaOoZFDHy01FX/5ZB7G
         X4+oKgFLDlYe/+7sBZROG/YH905wXChP9J6jvNoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 103/292] habanalabs: set rc as valid in case of intentional func exit
Date:   Mon, 19 Jul 2021 16:52:45 +0200
Message-Id: <20210719144945.883858742@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



