Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC80480403
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhL0TGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:06:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42760 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhL0TGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86965B810BA;
        Mon, 27 Dec 2021 19:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A53C36AEB;
        Mon, 27 Dec 2021 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631963;
        bh=wgn7kzBwixW5lbXiyqoiR3W0fh7gG+ZxsAP3Myvr0ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBPYd0it2AezVu7exPA0jf6tJw9vJWhIKqBqSD3aH+lwfB5hbzXlTfXcwJBhfd9hF
         L/Mo+C+OI0w0ma/Gj+4GxD0nCx26Sj8hJ501bnzzfNV92CejPT3QJPNSGmLqQ+8i03
         ZYDQyBzHMTfa6L2tgi5gowNg7sPrawobhK2p3aLsHBZRC6w30mAr/y7QEI1SdaUK6H
         YsmkvZKTwjM/ubUnau/34uvaA6vvZl4mpc2Mv1KbInlzf7qkledL608FDDT9Ef16IK
         7CFyKUW9zzT/Ei3s7Id6WbpEGwNsxGRAYOP9mULifnMFdi3iMFP4S/f1z1lvI2+Gv5
         ytqR72Q3KxwWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/9] hwmon: (lm90) Do not report 'busy' status bit as alarm
Date:   Mon, 27 Dec 2021 14:05:31 -0500
Message-Id: <20211227190536.1042975-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190536.1042975-1-sashal@kernel.org>
References: <20211227190536.1042975-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit cdc5287acad9ede121924a9c9313544b80d15842 ]

Bit 7 of the status register indicates that the chip is busy
doing a conversion. It does not indicate an alarm status.
Stop reporting it as alarm status bit.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 9b3c9f390ef81..c2a7fe6827915 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -184,6 +184,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 #define LM90_STATUS_RHIGH	(1 << 4) /* remote high temp limit tripped */
 #define LM90_STATUS_LLOW	(1 << 5) /* local low temp limit tripped */
 #define LM90_STATUS_LHIGH	(1 << 6) /* local high temp limit tripped */
+#define LM90_STATUS_BUSY	(1 << 7) /* conversion is ongoing */
 
 #define MAX6696_STATUS2_R2THRM	(1 << 1) /* remote2 THERM limit tripped */
 #define MAX6696_STATUS2_R2OPEN	(1 << 2) /* remote2 is an open circuit */
@@ -773,7 +774,7 @@ static int lm90_update_device(struct device *dev)
 		val = lm90_read_reg(client, LM90_REG_R_STATUS);
 		if (val < 0)
 			return val;
-		data->alarms = val;	/* lower 8 bit of alarms */
+		data->alarms = val & ~LM90_STATUS_BUSY;
 
 		if (data->kind == max6696) {
 			val = lm90_select_remote_channel(data, 1);
-- 
2.34.1

