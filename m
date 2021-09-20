Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799A4411AD0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245175AbhITQwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhITQuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9232B61352;
        Mon, 20 Sep 2021 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156550;
        bh=3aoe/YoOU1sRjQ8Os9P9/b5GuVMlXzYaF6tz5eVLXz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md+fK08IRkzp6DIo8gWtCmHOu0LbKx8OEzFwO4U7EMLPNlZG7hmym1SrDGEUdnr8H
         jQdtv/C2pIFhGLOJg3JNHA8Sl4oGiBaKg4ezR7nU0uomIR7hxWAOER0x7mPwIfvFno
         opnb5ZUuFNO2yqQgkIfjuVPX8U98bs/YuvjdMFC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 110/133] mmc: rtsx_pci: Fix long reads when clock is prescaled
Date:   Mon, 20 Sep 2021 18:43:08 +0200
Message-Id: <20210920163916.220980107@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hebb <tommyhebb@gmail.com>

[ Upstream commit 3ac5e45291f3f0d699a721357380d4593bc2dcb3 ]

For unexplained reasons, the prescaler register for this device needs to
be cleared (set to 1) while performing a data read or else the command
will hang. This does not appear to affect the real clock rate sent out
on the bus, so I assume it's purely to work around a hardware bug.

During normal operation, the prescaler is already set to 1, so nothing
needs to be done. However, in "initial mode" (which is used for sub-MHz
clock speeds, like the core sets while enumerating cards), it's set to
128 and so we need to reset it during data reads. We currently fail to
do this for long reads.

This has no functional affect on the driver's operation currently
written, as the MMC core always sets a clock above 1MHz before
attempting any long reads. However, the core could conceivably set any
clock speed at any time and the driver should still work, so I think
this fix is worthwhile.

I personally encountered this issue while performing data recovery on an
external chip. My connections had poor signal integrity, so I modified
the core code to reduce the clock speed. Without this change, I saw the
card enumerate but was unable to actually read any data.

Writes don't seem to work in the situation described above even with
this change (and even if the workaround is extended to encompass data
write commands). I was not able to find a way to get them working.

Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Link: https://lore.kernel.org/r/2fef280d8409ab0100c26c6ac7050227defd098d.1627818365.git.tommyhebb@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 36 ++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 93137483ecde..10ec88833889 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -553,9 +553,22 @@ static int sd_write_long_data(struct realtek_pci_sdmmc *host,
 	return 0;
 }
 
+static inline void sd_enable_initial_mode(struct realtek_pci_sdmmc *host)
+{
+	rtsx_pci_write_register(host->pcr, SD_CFG1,
+			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_128);
+}
+
+static inline void sd_disable_initial_mode(struct realtek_pci_sdmmc *host)
+{
+	rtsx_pci_write_register(host->pcr, SD_CFG1,
+			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_0);
+}
+
 static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 {
 	struct mmc_data *data = mrq->data;
+	int err;
 
 	if (host->sg_count < 0) {
 		data->error = host->sg_count;
@@ -564,22 +577,19 @@ static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 		return data->error;
 	}
 
-	if (data->flags & MMC_DATA_READ)
-		return sd_read_long_data(host, mrq);
+	if (data->flags & MMC_DATA_READ) {
+		if (host->initial_mode)
+			sd_disable_initial_mode(host);
 
-	return sd_write_long_data(host, mrq);
-}
+		err = sd_read_long_data(host, mrq);
 
-static inline void sd_enable_initial_mode(struct realtek_pci_sdmmc *host)
-{
-	rtsx_pci_write_register(host->pcr, SD_CFG1,
-			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_128);
-}
+		if (host->initial_mode)
+			sd_enable_initial_mode(host);
 
-static inline void sd_disable_initial_mode(struct realtek_pci_sdmmc *host)
-{
-	rtsx_pci_write_register(host->pcr, SD_CFG1,
-			SD_CLK_DIVIDE_MASK, SD_CLK_DIVIDE_0);
+		return err;
+	}
+
+	return sd_write_long_data(host, mrq);
 }
 
 static void sd_normal_rw(struct realtek_pci_sdmmc *host,
-- 
2.30.2



