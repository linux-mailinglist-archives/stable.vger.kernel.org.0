Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF2BB14828B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391759AbgAXL3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391632AbgAXL27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:28:59 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74737206D4;
        Fri, 24 Jan 2020 11:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865339;
        bh=mEBtjnOv9q55DDiXNG4WRz39O6dyrPJhE1PzqYoUSSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdpgiIJraeJdbaNBvoAVvtvlsAbwmgP9kCtZ3csGfWEhVPbqgUX/BDyjtKv3+hqRb
         JYSZCFqCJYBnDg/rkxOBfPrCrf/4dbW1wGGHeEn73H2Pgfs1C2fgIVrADRsZM9KHRk
         2nSQ5jA4/89Os562Zge7K6kACsxLpFf630dLd6jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Kroupski <alexandre.kroupski@ingenico.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 519/639] media: atmel: atmel-isi: fix timeout value for stop streaming
Date:   Fri, 24 Jan 2020 10:31:29 +0100
Message-Id: <20200124093153.817176786@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e8db4df1e7c41..1a0e5233ae28e 100644
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



