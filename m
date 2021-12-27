Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802244803E7
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhL0TGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbhL0TFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:05:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F405EC061373;
        Mon, 27 Dec 2021 11:05:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 948AF61129;
        Mon, 27 Dec 2021 19:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5933CC36AE7;
        Mon, 27 Dec 2021 19:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631919;
        bh=YhjDQhV+ug+6JBqANGxeFM7q1QNaC1Yc2Bs85/zXWXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehV8+Zag8KIewSU3EjhK5kAmm93P4HMxdDJNf4lYqroz6rLcjHfOSlSgwGHvbt+sP
         T81WtGMSQwPXQYFOG3nVx4J3OshtGflmPLrifIlSWG5LJ0vdwdepsTypp0f5j+LEKz
         Ma4eHJQlr+510G9FfltkykqG06ZCstXWc3NcGpfNqAxPtrfYfG4e8Fn899pYJIEapy
         C4l414HnTAUI5wvbRnoKYgHG8Bj54P+ERjWiIOYD5r/BZmfO8ed6YkW8J7+sko33QO
         HmI6o8VjTblLeKK3NziBLK8bV/eqrdTc7SQM9rK0rsFQAQknm8+5XPCsewXNnBARYb
         ePKpoQ41OTUEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/14] hwmon: (lm90) Do not report 'busy' status bit as alarm
Date:   Mon, 27 Dec 2021 14:04:43 -0500
Message-Id: <20211227190452.1042714-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190452.1042714-1-sashal@kernel.org>
References: <20211227190452.1042714-1-sashal@kernel.org>
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
index ebbfd5f352c06..12abb90ed2d17 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -192,6 +192,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 #define LM90_STATUS_RHIGH	(1 << 4) /* remote high temp limit tripped */
 #define LM90_STATUS_LLOW	(1 << 5) /* local low temp limit tripped */
 #define LM90_STATUS_LHIGH	(1 << 6) /* local high temp limit tripped */
+#define LM90_STATUS_BUSY	(1 << 7) /* conversion is ongoing */
 
 #define MAX6696_STATUS2_R2THRM	(1 << 1) /* remote2 THERM limit tripped */
 #define MAX6696_STATUS2_R2OPEN	(1 << 2) /* remote2 is an open circuit */
@@ -791,7 +792,7 @@ static int lm90_update_device(struct device *dev)
 		val = lm90_read_reg(client, LM90_REG_R_STATUS);
 		if (val < 0)
 			return val;
-		data->alarms = val;	/* lower 8 bit of alarms */
+		data->alarms = val & ~LM90_STATUS_BUSY;
 
 		if (data->kind == max6696) {
 			val = lm90_select_remote_channel(data, 1);
-- 
2.34.1

