Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBFF383186
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241005AbhEQOhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240830AbhEQOfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:35:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2AFA61407;
        Mon, 17 May 2021 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261018;
        bh=KXTQBfakH0BrCa8TE9zTPkNFh6ESzzSdqNu5g8TZeeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKGO2zI7cySQQwE4wTyymaRL+w9c/IATlUrNOl+1Aky7bc6d2l+HpWfiogPMA3UcI
         EZnH5opTd0L8K3uRifabTiEkMAOOWdlCO0fyY/Ts0hJYqFuArAe3xMAqK9Tg6/uK9f
         nZKJY2StgyU5kz62+sUSh8LHcD2Cwzsg39kI67Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 291/363] hwmon: (occ) Fix poll rate limiting
Date:   Mon, 17 May 2021 16:02:37 +0200
Message-Id: <20210517140312.437348221@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index 7a5e539b567b..580e63d7daa0 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -217,9 +217,9 @@ int occ_update_response(struct occ *occ)
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
@@ -1164,6 +1164,7 @@ int occ_setup(struct occ *occ, const char *name)
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



