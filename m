Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB449A911
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322014AbiAYDUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377325AbiAXUFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:05:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3533C061378;
        Mon, 24 Jan 2022 11:31:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5075661318;
        Mon, 24 Jan 2022 19:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225D0C340E5;
        Mon, 24 Jan 2022 19:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052700;
        bh=mgxWZWBc0Eucoc+hoIoXSz+Ix0iMdTBDwuB1PKnJCCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyQ/xIIPUL0fktyDtNXio+ounmH1MkzXxCs4tJm9BlrTF7OF1sse4HRO1inwNouc1
         n49/rCAqKQ1pAPXV3TeTBj6aDQ95UiA3ErYWZq+zWPxBKQc1iZK+sqClrBMILPiOtt
         kYSUA9HIHnDsdgaJf+46V4i3Yn+5H2CgqP6YdaA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/320] misc: lattice-ecp3-config: Fix task hung when firmware load failed
Date:   Mon, 24 Jan 2022 19:42:11 +0100
Message-Id: <20220124183958.645541290@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 884485c3f7232..3a0d2b052ed29 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -77,12 +77,12 @@ static void firmware_load(const struct firmware *fw, void *context)
 
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
@@ -104,7 +104,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 		dev_err(&spi->dev,
 			"Error: No supported FPGA detected (JEDEC_ID=%08x)!\n",
 			jedec_id);
-		return;
+		goto out;
 	}
 
 	dev_info(&spi->dev, "FPGA %s detected\n", ecp3_dev[i].name);
@@ -117,7 +117,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 	buffer = kzalloc(fw->size + 8, GFP_KERNEL);
 	if (!buffer) {
 		dev_err(&spi->dev, "Error: Can't allocate memory!\n");
-		return;
+		goto out;
 	}
 
 	/*
@@ -156,7 +156,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 			"Error: Timeout waiting for FPGA to clear (status=%08x)!\n",
 			status);
 		kfree(buffer);
-		return;
+		goto out;
 	}
 
 	dev_info(&spi->dev, "Configuring the FPGA...\n");
@@ -182,7 +182,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 	release_firmware(fw);
 
 	kfree(buffer);
-
+out:
 	complete(&data->fw_loaded);
 }
 
-- 
2.34.1



