Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DF52A51AF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgKCUnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbgKCUnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18BA6223BF;
        Tue,  3 Nov 2020 20:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436184;
        bh=gndrdZCvokFunPHCB9dpRJxgNF1A228dOJlPmx3/pqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PV+kQy5Uzh3OwjyxFT1cXIL83FRsl1xCXscWNjMYLzmfBsPHPxy90N8xopHxYmp0
         TLbSjYNRrK6zyadSQoucwG8lceK71PEBJyBXA0RNxXAcyKD5sFQjQdSHD0ti/pfBz7
         GxyWM2NGGETmEPJmPSNl44lCqVZ18gfjwG6Yws/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 137/391] power: supply: test_power: add missing newlines when printing parameters by sysfs
Date:   Tue,  3 Nov 2020 21:33:08 +0100
Message-Id: <20201103203356.075250041@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 04acd76bbaa12..4895ee5e63a9a 100644
--- a/drivers/power/supply/test_power.c
+++ b/drivers/power/supply/test_power.c
@@ -353,6 +353,7 @@ static int param_set_ac_online(const char *key, const struct kernel_param *kp)
 static int param_get_ac_online(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_ac_online, ac_online, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -366,6 +367,7 @@ static int param_set_usb_online(const char *key, const struct kernel_param *kp)
 static int param_get_usb_online(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_ac_online, usb_online, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -380,6 +382,7 @@ static int param_set_battery_status(const char *key,
 static int param_get_battery_status(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_status, battery_status, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -394,6 +397,7 @@ static int param_set_battery_health(const char *key,
 static int param_get_battery_health(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_health, battery_health, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -409,6 +413,7 @@ static int param_get_battery_present(char *buffer,
 					const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_present, battery_present, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -426,6 +431,7 @@ static int param_get_battery_technology(char *buffer,
 {
 	strcpy(buffer,
 		map_get_key(map_technology, battery_technology, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
-- 
2.27.0



