Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE63515E3E4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406128AbgBNQZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406121AbgBNQZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0780124789;
        Fri, 14 Feb 2020 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697529;
        bh=1KRN5EPz1xFdEunECOo2lFHV5Qkwf1hIyBBEyNAKpHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXZC/01NfLK81vh+Z9xq67BYqQZja/8qf/D7cNqwjtuHYt3T8XerJu83SHrG2qCYw
         mV6yC+NMngoH9HMwd5FN8uJ3yxrcCs21WxF5ZEIU7gI6ePXQoVPxFpQJ5e48nMViL6
         EmHMFGPS4ImibmLC8/bR7L7DTy4MyHY1unQ95MvQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 052/100] rtc: hym8563: Return -EINVAL if the time is known to be invalid
Date:   Fri, 14 Feb 2020 11:23:36 -0500
Message-Id: <20200214162425.21071-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit f236a2a2ebabad0848ad0995af7ad1dc7029e895 ]

The current code returns -EPERM when the voltage loss bit is set.
Since the bit indicates that the time value is not valid, return
-EINVAL instead, which is the appropriate error code for this
situation.

Fixes: dcaf03849352 ("rtc: add hym8563 rtc-driver")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Link: https://lore.kernel.org/r/20191212153111.966923-1-paul.kocialkowski@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-hym8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index b1b4746a0eab5..dbec596494ebe 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -105,7 +105,7 @@ static int hym8563_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	if (!hym8563->valid) {
 		dev_warn(&client->dev, "no valid clock/calendar values available\n");
-		return -EPERM;
+		return -EINVAL;
 	}
 
 	ret = i2c_smbus_read_i2c_block_data(client, HYM8563_SEC, 7, buf);
-- 
2.20.1

