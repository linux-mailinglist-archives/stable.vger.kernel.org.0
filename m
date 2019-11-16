Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA39FF34E
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfKPQYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbfKPPmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:23 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E4F2083E;
        Sat, 16 Nov 2019 15:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918943;
        bh=/ZJI/4gyijIuk0UAleXk9pAGE4qXIMVC+2rzUpbTqLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzJmfi2CzG2CktobJc+doFAUM/LtYcNj23X+2DrMgVT2kJaL78fv1SCrrQpQrInC0
         hS565mRugBtpJmYGmlPxRhKEqwvuGSNZYPIkmbUxCTGCesGQdXEEW451j7uIZ3Hztf
         BukeDzOL2xM2ZOagaZAHHDh4fUBK6HUTYXzwWTNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 065/237] scsi: zorro_esp: Limit DMA transfers to 65535 bytes
Date:   Sat, 16 Nov 2019 10:38:20 -0500
Message-Id: <20191116154113.7417-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit b7ded0e8b0d11b6df1c4e5aa23a26e6629c21985 ]

The core driver, esp_scsi, does not use the ESP_CONFIG2_FENAB bit, so the
chip's Transfer Counter register is only 16 bits wide (not 24).  A larger
transfer cannot work and will theoretically result in a failed command
and a "DMA length is zero" error.

Fixes: 3109e5ae0311 ("scsi: zorro_esp: New driver for Amiga Zorro NCR53C9x boards")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/zorro_esp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index bb70882e6b56e..be79127db5946 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -245,7 +245,7 @@ static int fastlane_esp_irq_pending(struct esp *esp)
 static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
 					u32 dma_len)
 {
-	return dma_len > 0xFFFFFF ? 0xFFFFFF : dma_len;
+	return dma_len > 0xFFFF ? 0xFFFF : dma_len;
 }
 
 static void zorro_esp_reset_dma(struct esp *esp)
@@ -484,7 +484,6 @@ static void zorro_esp_send_blz1230_dma_cmd(struct esp *esp, u32 addr,
 	scsi_esp_cmd(esp, ESP_CMD_DMA);
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	scsi_esp_cmd(esp, cmd);
 }
@@ -529,7 +528,6 @@ static void zorro_esp_send_blz1230II_dma_cmd(struct esp *esp, u32 addr,
 	scsi_esp_cmd(esp, ESP_CMD_DMA);
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	scsi_esp_cmd(esp, cmd);
 }
@@ -574,7 +572,6 @@ static void zorro_esp_send_blz2060_dma_cmd(struct esp *esp, u32 addr,
 	scsi_esp_cmd(esp, ESP_CMD_DMA);
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	scsi_esp_cmd(esp, cmd);
 }
@@ -599,7 +596,6 @@ static void zorro_esp_send_cyber_dma_cmd(struct esp *esp, u32 addr,
 
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	if (write) {
 		/* DMA receive */
@@ -649,7 +645,6 @@ static void zorro_esp_send_cyberII_dma_cmd(struct esp *esp, u32 addr,
 
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	if (write) {
 		/* DMA receive */
@@ -691,7 +686,6 @@ static void zorro_esp_send_fastlane_dma_cmd(struct esp *esp, u32 addr,
 
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	if (write) {
 		/* DMA receive */
-- 
2.20.1

