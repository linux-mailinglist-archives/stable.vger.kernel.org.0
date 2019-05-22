Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7F526E27
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbfEVTqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731844AbfEVT1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:27:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48395217F9;
        Wed, 22 May 2019 19:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553268;
        bh=kY6nnKcNmJPO49Acu53z4ErLu6Vs+4a1pFHpsxCrX80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJmioQ084t7SwHH0HlON3MHamWSVLDcm477Kn54ZH4DUAB5dQxRK8Z27jQ4ew23Q0
         jTxxP47Lp7QISXCKN1j/ebMtjekX3FJvkU/WKert74T2qdXkrfTVMaug/Ye/zLmBci
         BXEFNKnDKMrNSPnj0D06Iz6EMKYf50NPXrbErusM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 044/244] rtc: 88pm860x: prevent use-after-free on device remove
Date:   Wed, 22 May 2019 15:23:10 -0400
Message-Id: <20190522192630.24917-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit f22b1ba15ee5785aa028384ebf77dd39e8e47b70 ]

The device's remove() attempts to shut down the delayed_work scheduled
on the kernel-global workqueue by calling flush_scheduled_work().

Unfortunately, flush_scheduled_work() does not prevent the delayed_work
from re-scheduling itself. The delayed_work might run after the device
has been removed, and touch the already de-allocated info structure.
This is a potential use-after-free.

Fix by calling cancel_delayed_work_sync() during remove(): this ensures
that the delayed work is properly cancelled, is no longer running, and
is not able to re-schedule itself.

This issue was detected with the help of Coccinelle.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-88pm860x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 01ffc0ef8033f..fbcf13bbbd8d1 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -414,7 +414,7 @@ static int pm860x_rtc_remove(struct platform_device *pdev)
 	struct pm860x_rtc_info *info = platform_get_drvdata(pdev);
 
 #ifdef VRTC_CALIBRATION
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&info->calib_work);
 	/* disable measurement */
 	pm860x_set_bits(info->i2c, PM8607_MEAS_EN2, MEAS2_VRTC, 0);
 #endif	/* VRTC_CALIBRATION */
-- 
2.20.1

