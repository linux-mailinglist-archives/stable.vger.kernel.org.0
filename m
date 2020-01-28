Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D783514BB82
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgA1OIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbgA1OIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:08:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11DDD2468D;
        Tue, 28 Jan 2020 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220524;
        bh=Ref7vl4SynHuwdwUhhrESDdEq+bEriMY5xQ/KL/wwxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZwgFBwF5rQtrh8NV0WDnbvJWzijqjOjmhtjg4kvLiQdYjvhhUbloHpyrxLfMjwI7
         k08DW7asfiKn6sbbGx1xB77B91HlGoNC2qbdLZ3NgPxA/1OkY4EUpAfkxhXOJ/8uam
         hHi4D3o5Php9UlxJ3pDwWvEqN6MpTKOmTGal2QOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 042/183] rtc: pm8xxx: fix unintended sign extension
Date:   Tue, 28 Jan 2020 15:04:21 +0100
Message-Id: <20200128135834.194956017@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
index 795fcbd02ea39..a0dae6271ff64 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -186,7 +186,8 @@ static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		}
 	}
 
-	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
+	secs = value[0] | (value[1] << 8) | (value[2] << 16) |
+	       ((unsigned long)value[3] << 24);
 
 	rtc_time_to_tm(secs, tm);
 
@@ -267,7 +268,8 @@ static int pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 		return rc;
 	}
 
-	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
+	secs = value[0] | (value[1] << 8) | (value[2] << 16) |
+	       ((unsigned long)value[3] << 24);
 
 	rtc_time_to_tm(secs, &alarm->time);
 
-- 
2.20.1



