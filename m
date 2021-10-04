Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32260420E71
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbhJDNZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhJDNVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90BF261BFE;
        Mon,  4 Oct 2021 13:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352965;
        bh=A6OAFOoeE0GJwtRZrzNpPaX6O+RvyS3RqmRz6D0YbV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBxx/+zxwWIwGp/483R6jWc6bvih8QeIEyw+S3prejaftDfi0jjVry1ZvAlnUPm6s
         6Ptki+fToQ6kf/fq4JtD67xl6LhZKshayrHIIwn9ZPaFndE8bGbIl4Hq70W4ZgQMg6
         7Z585s0jhaRq+bSUWbjmBf26JM33pJSpyd/d6jEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/93] hwmon: (tmp421) report /PVLD condition as fault
Date:   Mon,  4 Oct 2021 14:52:35 +0200
Message-Id: <20211004125035.791866535@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Fertser <fercerpav@gmail.com>

[ Upstream commit 540effa7f283d25bcc13c0940d808002fee340b8 ]

For both local and remote sensors all the supported ICs can report an
"undervoltage lockout" condition which means the conversion wasn't
properly performed due to insufficient power supply voltage and so the
measurement results can't be trusted.

Fixes: 9410700b881f ("hwmon: Add driver for Texas Instruments TMP421/422/423 sensor chips")
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Link: https://lore.kernel.org/r/20210924093011.26083-2-fercerpav@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp421.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index 8fd8c3a94dfe..c9ef83627bb7 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -179,10 +179,10 @@ static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
 		return 0;
 	case hwmon_temp_fault:
 		/*
-		 * The OPEN bit signals a fault. This is bit 0 of the temperature
-		 * register (low byte).
+		 * Any of OPEN or /PVLD bits indicate a hardware mulfunction
+		 * and the conversion result may be incorrect
 		 */
-		*val = tmp421->temp[channel] & 0x01;
+		*val = !!(tmp421->temp[channel] & 0x03);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -195,9 +195,6 @@ static umode_t tmp421_is_visible(const void *data, enum hwmon_sensor_types type,
 {
 	switch (attr) {
 	case hwmon_temp_fault:
-		if (channel == 0)
-			return 0;
-		return 0444;
 	case hwmon_temp_input:
 		return 0444;
 	default:
-- 
2.33.0



