Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32631DE9E2
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgEVOvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730951AbgEVOvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEC722409;
        Fri, 22 May 2020 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159075;
        bh=hu3+Cu1mobOMU0osGTqGMIyMafxT7FTy0kESiJ1M/lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkPHO2k4e2bXlRR9qq6KARoWbQ7DXt84iE6cXl973pOg55CD6fysbbSjE/ZOy9xbC
         lu3MbG2jCPHchjyxR61Yiqk6Xy2rkWJG6L0tYuQft6OcdbJk44Cb0r4N2AhBwG+xVq
         VM0T/JmfmxjBzZiZ5Vi73tzuToJoovya1LONvSds=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amy Shih <amy.shih@advantech.com.tw>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/32] hwmon: (nct7904) Fix incorrect range of temperature limit registers
Date:   Fri, 22 May 2020 10:50:40 -0400
Message-Id: <20200522145044.434677-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amy Shih <amy.shih@advantech.com.tw>

[ Upstream commit 7b2fd270af27edaf02acb41a7babe805a9441914 ]

The format of temperature limitation registers are 8-bit 2's complement
and the range is -128~127.
Converts the reading value to signed char to fix the incorrect range
of temperature limitation registers.

Signed-off-by: Amy Shih <amy.shih@advantech.com.tw>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct7904.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/nct7904.c b/drivers/hwmon/nct7904.c
index 281c81edabc6..dfb122b5e1b7 100644
--- a/drivers/hwmon/nct7904.c
+++ b/drivers/hwmon/nct7904.c
@@ -356,6 +356,7 @@ static int nct7904_read_temp(struct device *dev, u32 attr, int channel,
 	struct nct7904_data *data = dev_get_drvdata(dev);
 	int ret, temp;
 	unsigned int reg1, reg2, reg3;
+	s8 temps;
 
 	switch (attr) {
 	case hwmon_temp_input:
@@ -461,7 +462,8 @@ static int nct7904_read_temp(struct device *dev, u32 attr, int channel,
 
 	if (ret < 0)
 		return ret;
-	*val = ret * 1000;
+	temps = ret;
+	*val = temps * 1000;
 	return 0;
 }
 
-- 
2.25.1

