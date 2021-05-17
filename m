Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518C438352C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243260AbhEQPQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243225AbhEQPNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF4D61444;
        Mon, 17 May 2021 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261901;
        bh=uvTrru9RW9pBYtGkjU8CgVX/FurJ6q4jeDK4fRM5lUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQEL1zqv6yeUMg7gQu8UEQuvmpfpsYyhbNo00+ES73TLO7S1urCpy8hYSCoOTnrKJ
         uR6C30NzHF0/wDg3w6q7clNsoFbhsHs4aP7h6lzNpRJ+LiHg4+mBzxhms6EWPSQKJH
         zc28Q1N7w6K16I+V1HmF4FJ6yf/FgMOyrWl6ZzHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/141] hwmon: (occ) Fix poll rate limiting
Date:   Mon, 17 May 2021 16:02:39 +0200
Message-Id: <20210517140246.394625648@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 5216dff22dc2bbbbe6f00335f9fd2879670e753b ]

The poll rate limiter time was initialized at zero. This breaks the
comparison in time_after if jiffies is large. Switch to storing the
next update time rather than the previous time, and initialize the
time when the device is probed.

Fixes: c10e753d43eb ("hwmon (occ): Add sensor types and versions")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20210429151336.18980-1-eajames@linux.ibm.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 5 +++--
 drivers/hwmon/occ/common.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index 30e18eb60da7..0b689ccbb793 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -209,9 +209,9 @@ int occ_update_response(struct occ *occ)
 		return rc;
 
 	/* limit the maximum rate of polling the OCC */
-	if (time_after(jiffies, occ->last_update + OCC_UPDATE_FREQUENCY)) {
+	if (time_after(jiffies, occ->next_update)) {
 		rc = occ_poll(occ);
-		occ->last_update = jiffies;
+		occ->next_update = jiffies + OCC_UPDATE_FREQUENCY;
 	} else {
 		rc = occ->last_error;
 	}
@@ -1089,6 +1089,7 @@ int occ_setup(struct occ *occ, const char *name)
 		return rc;
 	}
 
+	occ->next_update = jiffies + OCC_UPDATE_FREQUENCY;
 	occ_parse_poll_response(occ);
 
 	rc = occ_setup_sensor_attrs(occ);
diff --git a/drivers/hwmon/occ/common.h b/drivers/hwmon/occ/common.h
index 67e6968b8978..e6df719770e8 100644
--- a/drivers/hwmon/occ/common.h
+++ b/drivers/hwmon/occ/common.h
@@ -99,7 +99,7 @@ struct occ {
 	u8 poll_cmd_data;		/* to perform OCC poll command */
 	int (*send_cmd)(struct occ *occ, u8 *cmd);
 
-	unsigned long last_update;
+	unsigned long next_update;
 	struct mutex lock;		/* lock OCC access */
 
 	struct device *hwmon;
-- 
2.30.2



