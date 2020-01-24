Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773E4147C25
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387811AbgAXJta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731650AbgAXJta (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:49:30 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E2321556;
        Fri, 24 Jan 2020 09:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859369;
        bh=46K0VE5yxeH0yjttC/EOtWHpEMUhqhBXZ0fviqaYDh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lV/0hP7nubUWvVJGH3sgMoaQ1h2SIbVpPMnT0O0DXa1HkYFy9zNry3NzhUDAN+Lfq
         AI1ngMfkJiDcQ1t7inmZHKCnqiGaZGUthImDPvoqkWYyy89+i7TSxgQPhNh5ZFwIYI
         SwNRA0cFBNVDWzhUQy+w3k3xoJ1CT51midRkpGSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/343] rtc: ds1672: fix unintended sign extension
Date:   Fri, 24 Jan 2020 10:28:27 +0100
Message-Id: <20200124092931.742902605@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f0c04c276739ed8acbb41b4868e942a55b128dca ]

Shifting a u8 by 24 will cause the value to be promoted to an integer. If
the top bit of the u8 is set then the following conversion to an unsigned
long will sign extend the value causing the upper 32 bits to be set in
the result.

Fix this by casting the u8 value to an unsigned long before the shift.

Detected by CoverityScan, CID#138801 ("Unintended sign extension")

Fixes: edf1aaa31fc5 ("[PATCH] RTC subsystem: DS1672 driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1672.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index 9caaccccaa575..b1ebca099b0df 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -58,7 +58,8 @@ static int ds1672_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 		"%s: raw read data - counters=%02x,%02x,%02x,%02x\n",
 		__func__, buf[0], buf[1], buf[2], buf[3]);
 
-	time = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	time = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+	       (buf[1] << 8) | buf[0];
 
 	rtc_time_to_tm(time, tm);
 
-- 
2.20.1



