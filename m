Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B51113E31D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387640AbgAPRAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733287AbgAPRAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC8AB2192A;
        Thu, 16 Jan 2020 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193999;
        bh=DD5b3OtEOuYFjYuUz0V1Ew0UTKdSxEIPHB7MzvFpuk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3X2VsQn9VyHoxn0z9YVEelw3CWM2EmTGNdJc9YdBQgtssMYS3OufUbNYaXO5wm6l
         YS+2nKmYALZ8WEhzl4qONZLvNY8TFBYbWP8gUwfEmv1x2pCYXZ2+lhu8mSt3ZKREqm
         r4ItZuXwGb3vMDdJmLdC273HJAcce850vyIi7HaM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Wong <e@80x24.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sylvain Chouleur <sylvain.chouleur@intel.com>,
        Patrick McDermott <patrick.mcdermott@libiquity.com>,
        linux-rtc@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 127/671] rtc: cmos: ignore bogus century byte
Date:   Thu, 16 Jan 2020 11:50:36 -0500
Message-Id: <20200116165940.10720-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Wong <e@80x24.org>

[ Upstream commit 2a4daadd4d3e507138f8937926e6a4df49c6bfdc ]

Older versions of Libreboot and Coreboot had an invalid value
(`3' in my case) in the century byte affecting the GM45 in
the Thinkpad X200.  Not everybody's updated their firmwares,
and Linux <= 4.2 was able to read the RTC without problems,
so workaround this by ignoring invalid values.

Fixes: 3c217e51d8a272b9 ("rtc: cmos: century support")

Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sylvain Chouleur <sylvain.chouleur@intel.com>
Cc: Patrick McDermott <patrick.mcdermott@libiquity.com>
Cc: linux-rtc@vger.kernel.org
Signed-off-by: Eric Wong <e@80x24.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 2f1772a358ca..18a6f15e313d 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -82,7 +82,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	time->tm_year += real_year - 72;
 #endif
 
-	if (century)
+	if (century > 20)
 		time->tm_year += (century - 19) * 100;
 
 	/*
-- 
2.20.1

