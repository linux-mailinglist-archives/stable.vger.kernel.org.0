Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9DD3B628F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbhF1Os1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235093AbhF1OoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48FF961CFF;
        Mon, 28 Jun 2021 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890837;
        bh=wRJuFAUKBN9IqlvNRNlL4iFilXRpZrVKLPOlZFTk0FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKUpKTG3TvA9qtIdKUG0wf88OMsTWLm6lhcQnq7wnhJTerLW27tRXrju3cvrxHcwU
         3cvL6l7+JoVz75NVdEHpAixuYJe+8YwciMrmm7+RhJ3ZfxkUaYxI6QZr7VDioqN/mk
         sIHq8ca4lkFpvSw6mXp+FvMjABfELaEZH0bJA+SCerpn9p3JyBswHdF2139/5VnD6I
         IRhGcDH+UkBzdqTEZbMootet+/dkr7NulSrqWwUKDkok5tbmlvf3StoEmk+CkjgahX
         Z8J/8QABJSnWbixAS9qfqUN4nSH1f0+n3AlAgq96en7cyVtu4HMuQabqtOE26dt7zc
         vkUmtT7SAvwjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Riwen Lu <luriwen@kylinos.cn>, Xin Chen <chenxin@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/109] hwmon: (scpi-hwmon) shows the negative temperature properly
Date:   Mon, 28 Jun 2021 10:32:13 -0400
Message-Id: <20210628143305.32978-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riwen Lu <luriwen@kylinos.cn>

[ Upstream commit 78d13552346289bad4a9bf8eabb5eec5e5a321a5 ]

The scpi hwmon shows the sub-zero temperature in an unsigned integer,
which would confuse the users when the machine works in low temperature
environment. This shows the sub-zero temperature in an signed value and
users can get it properly from sensors.

Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Tested-by: Xin Chen <chenxin@kylinos.cn>
Link: https://lore.kernel.org/r/20210604030959.736379-1-luriwen@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/scpi-hwmon.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/scpi-hwmon.c b/drivers/hwmon/scpi-hwmon.c
index 7e49da50bc69..562f3e287297 100644
--- a/drivers/hwmon/scpi-hwmon.c
+++ b/drivers/hwmon/scpi-hwmon.c
@@ -107,6 +107,15 @@ scpi_show_sensor(struct device *dev, struct device_attribute *attr, char *buf)
 
 	scpi_scale_reading(&value, sensor);
 
+	/*
+	 * Temperature sensor values are treated as signed values based on
+	 * observation even though that is not explicitly specified, and
+	 * because an unsigned u64 temperature does not really make practical
+	 * sense especially when the temperature is below zero degrees Celsius.
+	 */
+	if (sensor->info.class == TEMPERATURE)
+		return sprintf(buf, "%lld\n", (s64)value);
+
 	return sprintf(buf, "%llu\n", value);
 }
 
-- 
2.30.2

