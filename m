Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC9299CC6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437354AbgJ0ABo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410228AbgJZX4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BB78221F8;
        Mon, 26 Oct 2020 23:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756580;
        bh=wwziiSXDrJ4ZSqsCYc5AsPt1tRDQKMXQ4wxvZr46z3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gevB0Jl/28FMaWV+iHOul9sXiCvEIOdWgjAawkZSnCZYr7JoCIAI5/Cr69bMg2Dqv
         RJjMYk3d//6/r6mmPjDfW7WsQHsQYLDJoXC6P/zgJVBWOZDtPSM2ldI7+hLu488YkW
         LogFHmHxmOEQEPR1mBNI2wHGcyvXC5QPKTqGGYRw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 53/80] power: supply: test_power: add missing newlines when printing parameters by sysfs
Date:   Mon, 26 Oct 2020 19:54:49 -0400
Message-Id: <20201026235516.1025100-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit c07fa6c1631333f02750cf59f22b615d768b4d8f ]

When I cat some module parameters by sysfs, it displays as follows.
It's better to add a newline for easy reading.

root@syzkaller:~# cd /sys/module/test_power/parameters/
root@syzkaller:/sys/module/test_power/parameters# cat ac_online
onroot@syzkaller:/sys/module/test_power/parameters# cat battery_present
trueroot@syzkaller:/sys/module/test_power/parameters# cat battery_health
goodroot@syzkaller:/sys/module/test_power/parameters# cat battery_status
dischargingroot@syzkaller:/sys/module/test_power/parameters# cat battery_technology
LIONroot@syzkaller:/sys/module/test_power/parameters# cat usb_online
onroot@syzkaller:/sys/module/test_power/parameters#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/test_power.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/power/supply/test_power.c b/drivers/power/supply/test_power.c
index c3cad2b6dabae..1139ca7251952 100644
--- a/drivers/power/supply/test_power.c
+++ b/drivers/power/supply/test_power.c
@@ -341,6 +341,7 @@ static int param_set_ac_online(const char *key, const struct kernel_param *kp)
 static int param_get_ac_online(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_ac_online, ac_online, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -354,6 +355,7 @@ static int param_set_usb_online(const char *key, const struct kernel_param *kp)
 static int param_get_usb_online(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_ac_online, usb_online, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -368,6 +370,7 @@ static int param_set_battery_status(const char *key,
 static int param_get_battery_status(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_status, battery_status, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -382,6 +385,7 @@ static int param_set_battery_health(const char *key,
 static int param_get_battery_health(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_health, battery_health, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -397,6 +401,7 @@ static int param_get_battery_present(char *buffer,
 					const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_present, battery_present, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -414,6 +419,7 @@ static int param_get_battery_technology(char *buffer,
 {
 	strcpy(buffer,
 		map_get_key(map_technology, battery_technology, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
-- 
2.25.1

