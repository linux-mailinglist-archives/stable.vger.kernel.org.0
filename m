Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6766E14804C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731815AbgAXLJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:09:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733099AbgAXLJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:09:41 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41C3D20663;
        Fri, 24 Jan 2020 11:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864180;
        bh=oQ11vGuMdMc8OwfxVPTsx1gMmZkeMJU6SkGKsRAoo5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNctvjM787RIiTuOxomLX3Tt+lyefF4j9gqOdyCMcHTaaul6sBf49xmVdZhknCgtk
         6JTczZfQbx1mP8mDRLwQmknCLT+ENM6PTs+UPawIQhzaZmws5p0uFDrJpaDYhowzdM
         gn/IZMsUhCzsjfD2IJEgbRkEz+OJwpQv8iAVnd1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 181/639] rtc: pm8xxx: fix unintended sign extension
Date:   Fri, 24 Jan 2020 10:25:51 +0100
Message-Id: <20200124093109.829440154@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e42280886018c6f77f0a90190f7cba344b0df3e0 ]

Shifting a u8 by 24 will cause the value to be promoted to an integer. If
the top bit of the u8 is set then the following conversion to an unsigned
long will sign extend the value causing the upper 32 bits to be set in
the result.

Fix this by casting the u8 value to an unsigned long before the shift.

Detected by CoverityScan, CID#1309693 ("Unintended sign extension")

Fixes: 9a9a54ad7aa2 ("drivers/rtc: add support for Qualcomm PMIC8xxx RTC")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pm8xxx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 29358a0459258..e03104b734fc9 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -213,7 +213,8 @@ static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		}
 	}
 
-	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
+	secs = value[0] | (value[1] << 8) | (value[2] << 16) |
+	       ((unsigned long)value[3] << 24);
 
 	rtc_time_to_tm(secs, tm);
 
@@ -288,7 +289,8 @@ static int pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 		return rc;
 	}
 
-	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
+	secs = value[0] | (value[1] << 8) | (value[2] << 16) |
+	       ((unsigned long)value[3] << 24);
 
 	rtc_time_to_tm(secs, &alarm->time);
 
-- 
2.20.1



