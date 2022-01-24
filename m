Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F99498A54
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiAXTCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345456AbiAXTAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C114C061345;
        Mon, 24 Jan 2022 10:57:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30218B81223;
        Mon, 24 Jan 2022 18:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5262FC340E7;
        Mon, 24 Jan 2022 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050650;
        bh=2C18HuDLscgc4+tKatxU9QstG6/auVKahETKdInN1gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFNSYsTL38dDAuKLIs67a22ws6vLC99frPvw2bE3pMtr+2IFCSZVthzclN2RFOygq
         9vfrKHSoGI9KjgUN2SSDwgXM6lvp4d7q/FX/jQgMdIhvFqY1MeoZbK8VQE6bChCRCi
         Y3wzFhTYyQPkedEe/g6kScFqvAPJpD+CYyu5mWG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/157] misc: lattice-ecp3-config: Fix task hung when firmware load failed
Date:   Mon, 24 Jan 2022 19:42:39 +0100
Message-Id: <20220124183934.983778839@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit fcee5ce50bdb21116711e38635e3865594af907e ]

When firmware load failed, kernel report task hung as follows:

INFO: task xrun:5191 blocked for more than 147 seconds.
      Tainted: G        W         5.16.0-rc5-next-20211220+ #11
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:xrun            state:D stack:    0 pid: 5191 ppid:   270 flags:0x00000004
Call Trace:
 __schedule+0xc12/0x4b50 kernel/sched/core.c:4986
 schedule+0xd7/0x260 kernel/sched/core.c:6369 (discriminator 1)
 schedule_timeout+0x7aa/0xa80 kernel/time/timer.c:1857
 wait_for_completion+0x181/0x290 kernel/sched/completion.c:85
 lattice_ecp3_remove+0x32/0x40 drivers/misc/lattice-ecp3-config.c:221
 spi_remove+0x72/0xb0 drivers/spi/spi.c:409

lattice_ecp3_remove() wait for signals from firmware loading, but when
load failed, firmware_load() does not send this signal. This cause
device remove hung. Fix it by sending signal even if load failed.

Fixes: 781551df57c7 ("misc: Add Lattice ECP3 FPGA configuration via SPI")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20211228125522.3122284-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lattice-ecp3-config.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index 626fdcaf25101..645d26536114f 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -81,12 +81,12 @@ static void firmware_load(const struct firmware *fw, void *context)
 
 	if (fw == NULL) {
 		dev_err(&spi->dev, "Cannot load firmware, aborting\n");
-		return;
+		goto out;
 	}
 
 	if (fw->size == 0) {
 		dev_err(&spi->dev, "Error: Firmware size is 0!\n");
-		return;
+		goto out;
 	}
 
 	/* Fill dummy data (24 stuffing bits for commands) */
@@ -108,7 +108,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 		dev_err(&spi->dev,
 			"Error: No supported FPGA detected (JEDEC_ID=%08x)!\n",
 			jedec_id);
-		return;
+		goto out;
 	}
 
 	dev_info(&spi->dev, "FPGA %s detected\n", ecp3_dev[i].name);
@@ -121,7 +121,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 	buffer = kzalloc(fw->size + 8, GFP_KERNEL);
 	if (!buffer) {
 		dev_err(&spi->dev, "Error: Can't allocate memory!\n");
-		return;
+		goto out;
 	}
 
 	/*
@@ -160,7 +160,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 			"Error: Timeout waiting for FPGA to clear (status=%08x)!\n",
 			status);
 		kfree(buffer);
-		return;
+		goto out;
 	}
 
 	dev_info(&spi->dev, "Configuring the FPGA...\n");
@@ -186,7 +186,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 	release_firmware(fw);
 
 	kfree(buffer);
-
+out:
 	complete(&data->fw_loaded);
 }
 
-- 
2.34.1



