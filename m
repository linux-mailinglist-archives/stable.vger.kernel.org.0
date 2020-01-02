Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3591E12EC03
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgABWOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgABWOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C3BC2253D;
        Thu,  2 Jan 2020 22:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003263;
        bh=TkUG4d7OxeRxkXf03YFswXFkgNGW4fJrKL15eMH3sOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvDgBrgjcBjqRXUwU3c+8iHJR/y2bOlv2gV77XyLxyu0+AeZCuuszB5g/z4qJEIp4
         31kYN6LYHhVW2/PJpSy6ReozPEOCyooORVJzdLQs9QAvdt2+XgxIiF32tK1UwtkmAo
         tlMq0aoAEy5CxFgc3qIkH/Z5pwEOW8zLf9rIA35s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kars de Jong <jongk@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/191] scsi: zorro_esp: Limit DMA transfers to 65536 bytes (except on Fastlane)
Date:   Thu,  2 Jan 2020 23:05:44 +0100
Message-Id: <20200102215836.612045187@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>

[ Upstream commit 02f7e9f351a9de95577eafdc3bd413ed1c3b589f ]

When using this driver on a Blizzard 1260, there were failures whenever DMA
transfers from the SCSI bus to memory of 65535 bytes were followed by a DMA
transfer of 1 byte. This caused the byte at offset 65535 to be overwritten
with 0xff. The Blizzard hardware can't handle single byte DMA transfers.

Besides this issue, limiting the DMA length to something that is not a
multiple of the page size is very inefficient on most file systems.

It seems this limit was chosen because the DMA transfer counter of the ESP
by default is 16 bits wide, thus limiting the length to 65535 bytes.
However, the value 0 means 65536 bytes, which is handled by the ESP and the
Blizzard just fine. It is also the default maximum used by esp_scsi when
drivers don't provide their own dma_length_limit() function.

The limit of 65536 bytes can be used by all boards except the Fastlane. The
old driver used a limit of 65532 bytes (0xfffc), which is reintroduced in
this patch.

Fixes: b7ded0e8b0d1 ("scsi: zorro_esp: Limit DMA transfers to 65535 bytes")
Link: https://lore.kernel.org/r/20191112175523.23145-1-jongk@linux-m68k.org
Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
Reviewed-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/zorro_esp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index ca8e3abeb2c7..a23a8e5794f5 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -218,7 +218,14 @@ static int fastlane_esp_irq_pending(struct esp *esp)
 static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
 					u32 dma_len)
 {
-	return dma_len > 0xFFFF ? 0xFFFF : dma_len;
+	return dma_len > (1U << 16) ? (1U << 16) : dma_len;
+}
+
+static u32 fastlane_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
+					u32 dma_len)
+{
+	/* The old driver used 0xfffc as limit, so do that here too */
+	return dma_len > 0xfffc ? 0xfffc : dma_len;
 }
 
 static void zorro_esp_reset_dma(struct esp *esp)
@@ -604,7 +611,7 @@ static const struct esp_driver_ops fastlane_esp_ops = {
 	.esp_write8		= zorro_esp_write8,
 	.esp_read8		= zorro_esp_read8,
 	.irq_pending		= fastlane_esp_irq_pending,
-	.dma_length_limit	= zorro_esp_dma_length_limit,
+	.dma_length_limit	= fastlane_esp_dma_length_limit,
 	.reset_dma		= zorro_esp_reset_dma,
 	.dma_drain		= zorro_esp_dma_drain,
 	.dma_invalidate		= fastlane_esp_dma_invalidate,
-- 
2.20.1



