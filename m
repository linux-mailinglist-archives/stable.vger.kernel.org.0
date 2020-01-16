Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFE813E7EC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404228AbgAPR27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404223AbgAPR25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E1B32470A;
        Thu, 16 Jan 2020 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195736;
        bh=ZcKXNiY389qwnVB97Nh5gg7j/uHqe5GQIQymUVX9+Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1cyz+9RhEz5BCCf/Uz544Z4+NHb9UcZWN/OmqXvtCbzHpvEgi9BKOW/kcz6sD9K3
         2otR4N5f2wN+gJTV4ICjGxZf4dE7J/WwkujLHd8UiwyBs8id6u/oUcP9xQiePAlRZA
         Kknpd8h63LiY/XywhiW2mGYg1PD5FWTGowZ7Fp8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Kroupski <alexandre.kroupski@ingenico.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 274/371] media: atmel: atmel-isi: fix timeout value for stop streaming
Date:   Thu, 16 Jan 2020 12:22:26 -0500
Message-Id: <20200116172403.18149-217-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Kroupski <alexandre.kroupski@ingenico.com>

[ Upstream commit 623fd246bb40234fe68dd4e7c1f1f081f9c45a3d ]

In case of sensor malfunction, stop streaming timeout takes much longer
than expected. This is due to conversion of time to jiffies: milliseconds
multiplied with HZ (ticks/second) gives out a value of jiffies with 10^3
greater. We need to also divide by 10^3 to obtain the right jiffies value.
In other words FRAME_INTERVAL_MILLI_SEC must be in seconds in order to
multiply by HZ and get the right jiffies value to add to the current
jiffies for the timeout expire time.

Fixes: 195ebc43bf76 ("[media] V4L: at91: add Atmel Image Sensor Interface (ISI) support")
Signed-off-by: Alexandre Kroupski <alexandre.kroupski@ingenico.com>
Reviewed-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 891fa2505efa..2f962a3418f6 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -496,7 +496,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irq(&isi->irqlock);
 
 	if (!isi->enable_preview_path) {
-		timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;
+		timeout = jiffies + (FRAME_INTERVAL_MILLI_SEC * HZ) / 1000;
 		/* Wait until the end of the current frame. */
 		while ((isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) &&
 				time_before(jiffies, timeout))
-- 
2.20.1

