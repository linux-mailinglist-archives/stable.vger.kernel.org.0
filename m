Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D762F3BF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbfE3Ebx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbfE3DNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 791DA2456E;
        Thu, 30 May 2019 03:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186021;
        bh=i1Vi4hGrEFyWzIxeGsWxePBBNB1HBqFssvmMcgk/xcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2EPZY6yG07iAVWqrDS2jQJ2fVnWIG084Y+xlDKUfIAPR4vcgfpi5UwY5Hl8fduiM
         eqJO680TiCIlv4n5dHG0ruebH9rB44YpdWlr9YLKycI63GtnybpbcfHH+X7HRW+F2R
         3moZBURxLuy/m61SsTs5ncxZlcuFXaEaKFaJeSRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 091/346] rtc: 88pm860x: prevent use-after-free on device remove
Date:   Wed, 29 May 2019 20:02:44 -0700
Message-Id: <20190530030545.773595756@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



