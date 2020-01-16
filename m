Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF313EC7F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394513AbgAPR5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:57:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393971AbgAPRnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5394424748;
        Thu, 16 Jan 2020 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196621;
        bh=wktD1BteLyPPyytIdN3IcJavNeMlILjGaeCO9Oss1nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/iF/GoXI6Hk2YslHdzWWQCB+52mQ+KzqaTDfiy30km0LAFuqhMImRLlKt0Pf+FzZ
         NHYV4Z4SywYffFCmHOLKBMAl/8L6fzNz+9eba96UehRNAgNaoH2vvbTZU2hN8z1UB9
         H4/zBZcTQfhiAPNAcxcQ4NjJtrnNOWHJ/A7D+J+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 037/174] rtc: ds1672: fix unintended sign extension
Date:   Thu, 16 Jan 2020 12:40:34 -0500
Message-Id: <20200116174251.24326-37-sashal@kernel.org>
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
index 92b1cbf2c4a7..2bea733b1589 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -60,7 +60,8 @@ static int ds1672_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 		"%s: raw read data - counters=%02x,%02x,%02x,%02x\n",
 		__func__, buf[0], buf[1], buf[2], buf[3]);
 
-	time = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
+	time = ((unsigned long)buf[3] << 24) | (buf[2] << 16) |
+	       (buf[1] << 8) | buf[0];
 
 	rtc_time_to_tm(time, tm);
 
-- 
2.20.1

