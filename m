Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33142A53F0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbgKCVGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:06:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388098AbgKCVGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1268520658;
        Tue,  3 Nov 2020 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437561;
        bh=TOlrAhGQzu7ICQWJ38bWKmZt9tSLQ3MxzMWP0Ou4oxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJ/VQP1+XTiFkLky2KuorjnJKZIssTVvj/975mVwzOGotQWu9+yBtmsrWYrXd4ZBi
         4OiVPC4IVu9C2IsAylRa3udaUnanGDmTsFKXXQOUvg8gXZ4bDkpu9NOOrjwFcGIMe+
         81sL3it9HKRzIG6MYkGk4RazeeYyi6httPOZTecI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/191] power: supply: test_power: add missing newlines when printing parameters by sysfs
Date:   Tue,  3 Nov 2020 21:36:23 +0100
Message-Id: <20201103203242.461900821@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
index 57246cdbd0426..925abec45380f 100644
--- a/drivers/power/supply/test_power.c
+++ b/drivers/power/supply/test_power.c
@@ -344,6 +344,7 @@ static int param_set_ac_online(const char *key, const struct kernel_param *kp)
 static int param_get_ac_online(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_ac_online, ac_online, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -357,6 +358,7 @@ static int param_set_usb_online(const char *key, const struct kernel_param *kp)
 static int param_get_usb_online(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_ac_online, usb_online, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -371,6 +373,7 @@ static int param_set_battery_status(const char *key,
 static int param_get_battery_status(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_status, battery_status, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -385,6 +388,7 @@ static int param_set_battery_health(const char *key,
 static int param_get_battery_health(char *buffer, const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_health, battery_health, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -400,6 +404,7 @@ static int param_get_battery_present(char *buffer,
 					const struct kernel_param *kp)
 {
 	strcpy(buffer, map_get_key(map_present, battery_present, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
@@ -417,6 +422,7 @@ static int param_get_battery_technology(char *buffer,
 {
 	strcpy(buffer,
 		map_get_key(map_technology, battery_technology, "unknown"));
+	strcat(buffer, "\n");
 	return strlen(buffer);
 }
 
-- 
2.27.0



