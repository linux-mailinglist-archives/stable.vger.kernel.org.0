Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A4826FF1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbfEVTXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729965AbfEVTXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:23:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EB8121850;
        Wed, 22 May 2019 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552983;
        bh=jF0IG8seK5yfPVv0jnKmDcjfxxH3S6pb05UYr0vEJKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yX9Rjnw2qZJIJy90nvEgmPD3ZDtLRvy2wg99B3p6BkRX6GmssCe+vDc81fkebOhVi
         OZ1zvUJpv7PhxH+A+OeDcxxZyByYkFU7IpxUh/IgN6HcUnmLqCnIsCDeMKwdSwOjsd
         5PKoV9jGiF4MrgQ1ZdKdmVNQGoNJD5raOjWLU684=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 061/375] rtc: 88pm860x: prevent use-after-free on device remove
Date:   Wed, 22 May 2019 15:16:01 -0400
Message-Id: <20190522192115.22666-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
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
index d25282b4a7dd1..73697e4b18a9d 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -421,7 +421,7 @@ static int pm860x_rtc_remove(struct platform_device *pdev)
 	struct pm860x_rtc_info *info = platform_get_drvdata(pdev);
 
 #ifdef VRTC_CALIBRATION
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&info->calib_work);
 	/* disable measurement */
 	pm860x_set_bits(info->i2c, PM8607_MEAS_EN2, MEAS2_VRTC, 0);
 #endif	/* VRTC_CALIBRATION */
-- 
2.20.1

