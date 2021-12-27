Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A562948042B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhL0THq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbhL0TGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE38FC061396;
        Mon, 27 Dec 2021 11:06:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ED5160FB3;
        Mon, 27 Dec 2021 19:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345D1C36AEA;
        Mon, 27 Dec 2021 19:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640632001;
        bh=3/bHUArtfA9kPI8eIXQoRUaDIyjxb4NxuVGOJC8ByD0=;
        h=From:To:Cc:Subject:Date:From;
        b=qiT3vC5/K8n+x2CSA/XaZv7be1lVN3/AKe8e2GopnMJOmCkCpd/KuU8L95elp1x+p
         U/Z+/livE5vI4sUB2sxO0vMTggEljxDKFL7Q+IkDlRPuykuWLAQen1kM0A2uc/TjDC
         bGo7B7H11rBIDaxZE2pZPIKrJ7xPVhuUZIHG3sDP7+PFRG0x7Ry7TUGGoAPeo2eiG4
         fDdwi3hVb2gmpiQTCxFGavPViKHJjcH3gZ9Xqdd/pQ67hjPEn93ZUBLtCs8g2tOBPf
         dZvhYVtQFtYKJgMAblsP7iphy0HWbi/WUbhNbO0D/mmIVTkWkzf3nlyVO8vqVbUw/c
         /3dD2FJRMGSeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/4] hwmon: (lm90) Do not report 'busy' status bit as alarm
Date:   Mon, 27 Dec 2021 14:06:26 -0500
Message-Id: <20211227190629.1043445-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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
index c187e557678ef..fee0783ef36e6 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -197,6 +197,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 #define LM90_STATUS_RHIGH	(1 << 4) /* remote high temp limit tripped */
 #define LM90_STATUS_LLOW	(1 << 5) /* local low temp limit tripped */
 #define LM90_STATUS_LHIGH	(1 << 6) /* local high temp limit tripped */
+#define LM90_STATUS_BUSY	(1 << 7) /* conversion is ongoing */
 
 #define MAX6696_STATUS2_R2THRM	(1 << 1) /* remote2 THERM limit tripped */
 #define MAX6696_STATUS2_R2OPEN	(1 << 2) /* remote2 is an open circuit */
@@ -786,7 +787,7 @@ static int lm90_update_device(struct device *dev)
 		val = lm90_read_reg(client, LM90_REG_R_STATUS);
 		if (val < 0)
 			return val;
-		data->alarms = val;	/* lower 8 bit of alarms */
+		data->alarms = val & ~LM90_STATUS_BUSY;
 
 		if (data->kind == max6696) {
 			val = lm90_select_remote_channel(client, data, 1);
-- 
2.34.1

