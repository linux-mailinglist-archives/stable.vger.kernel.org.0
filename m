Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7E53CE20C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347373AbhGSP2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349215AbhGSP0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:26:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9877608FC;
        Mon, 19 Jul 2021 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710814;
        bh=lqt3SH4p4r111KwtXJpHwqGvKo1eeRBYvgubUMk13vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJVyWAr95vi4M2avmSbVR3xYj3//KId1GkeaCYGNyqSTuNJYLCNTxyWItAf+Z2yEV
         XFBclviD6I/T8AGsQnqV8twTTxJkrT0rhXaBb5p2eAZkDkhGUYfaS6uWHWqUQotklk
         Zp7QpgG3vyKD4BcDES/bnoBEALn7EfAnvUdijmbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Koby Elbaz <kelbaz@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 118/351] habanalabs: set rc as valid in case of intentional func exit
Date:   Mon, 19 Jul 2021 16:51:04 +0200
Message-Id: <20210719144948.384582914@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 00e92b678828..eea0d3e35b88 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -1334,8 +1334,9 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
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
index 0713b2c12d54..86efb9fa701c 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -1006,11 +1006,14 @@ int hl_fw_init_cpu(struct hl_device *hdev, u32 cpu_boot_status_reg,
 
 	if (!(hdev->fw_components & FW_TYPE_LINUX)) {
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



