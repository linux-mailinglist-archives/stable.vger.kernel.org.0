Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57ECF13EB01
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394257AbgAPRre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406808AbgAPRqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:46:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07B6D246DA;
        Thu, 16 Jan 2020 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196809;
        bh=66Uh4hQFwl8UL/i/f+/bSnuAUf2QPxZlPm6iSXIho1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzCV72sltKkh3ya4ObWRa8XSMHbCRI4Tq4LX6w5x1mS2qC54hXcIrzckAqPd/2c8T
         j5DbCLdsgBSF/O4LNiihH3mcE3P3Qkju+AR0r3ejtVAvCniXEdE/2VjlhhPKn+UuuC
         vHoKAw/6TJvyu0wFxepW5e9abSNpc01n4WajDLxI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kars de Jong <jongk@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 167/174] rtc: msm6242: Fix reading of 10-hour digit
Date:   Thu, 16 Jan 2020 12:42:44 -0500
Message-Id: <20200116174251.24326-167-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>

[ Upstream commit e34494c8df0cd96fc432efae121db3212c46ae48 ]

The driver was reading the wrong register as the 10-hour digit due to
a misplaced ')'. It was in fact reading the 1-second digit register due
to this bug.

Also remove the use of a magic number for the hour mask and use the define
for it which was already present.

Fixes: 4f9b9bba1dd1 ("rtc: Add an RTC driver for the Oki MSM6242")
Tested-by: Kars de Jong <jongk@linux-m68k.org>
Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
Link: https://lore.kernel.org/r/20191116110548.8562-1-jongk@linux-m68k.org
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-msm6242.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index c1c5c4e3b3b4..c981301efbe5 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -132,7 +132,8 @@ static int msm6242_read_time(struct device *dev, struct rtc_time *tm)
 		      msm6242_read(priv, MSM6242_SECOND1);
 	tm->tm_min  = msm6242_read(priv, MSM6242_MINUTE10) * 10 +
 		      msm6242_read(priv, MSM6242_MINUTE1);
-	tm->tm_hour = (msm6242_read(priv, MSM6242_HOUR10 & 3)) * 10 +
+	tm->tm_hour = (msm6242_read(priv, MSM6242_HOUR10) &
+		       MSM6242_HOUR10_HR_MASK) * 10 +
 		      msm6242_read(priv, MSM6242_HOUR1);
 	tm->tm_mday = msm6242_read(priv, MSM6242_DAY10) * 10 +
 		      msm6242_read(priv, MSM6242_DAY1);
-- 
2.20.1

