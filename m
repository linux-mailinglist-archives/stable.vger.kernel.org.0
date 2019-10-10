Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFDFD2490
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389442AbfJJIrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388211AbfJJIrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86EE02064A;
        Thu, 10 Oct 2019 08:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697234;
        bh=lLf2g9KCQK5PoHP2qYZDVggikNw887AYHXv+3PO2oMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCO9wyqz6/n1XL8gk6qEF9uW8SwHd9kWkYo8u9NNo3ghzfxCYAZIOHdiBFHAQOj45
         F+r1B06V5uSL4zXbPCUjWEYPS+jwqCvpdM/ofBknmndBDqPIEazQ6IerQzsmTsTFbW
         7ENROUuaLW2a+Ad51249eE6wf6LAv5qs09vjqvwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Mavrodiev <stefan@olimex.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/114] thermal_hwmon: Sanitize thermal_zone type
Date:   Thu, 10 Oct 2019 10:36:13 +0200
Message-Id: <20191010083610.525336156@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Mavrodiev <stefan@olimex.com>

[ Upstream commit 8c7aa184281c01fc26f319059efb94725012921d ]

When calling thermal_add_hwmon_sysfs(), the device type is sanitized by
replacing '-' with '_'. However tz->type remains unsanitized. Thus
calling thermal_hwmon_lookup_by_type() returns no device. And if there is
no device, thermal_remove_hwmon_sysfs() fails with "hwmon device lookup
failed!".

The result is unregisted hwmon devices in the sysfs.

Fixes: 409ef0bacacf ("thermal_hwmon: Sanitize attribute name passed to hwmon")

Signed-off-by: Stefan Mavrodiev <stefan@olimex.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_hwmon.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_hwmon.c b/drivers/thermal/thermal_hwmon.c
index 40c69a533b240..dd5d8ee379287 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -87,13 +87,17 @@ static struct thermal_hwmon_device *
 thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
 {
 	struct thermal_hwmon_device *hwmon;
+	char type[THERMAL_NAME_LENGTH];
 
 	mutex_lock(&thermal_hwmon_list_lock);
-	list_for_each_entry(hwmon, &thermal_hwmon_list, node)
-		if (!strcmp(hwmon->type, tz->type)) {
+	list_for_each_entry(hwmon, &thermal_hwmon_list, node) {
+		strcpy(type, tz->type);
+		strreplace(type, '-', '_');
+		if (!strcmp(hwmon->type, type)) {
 			mutex_unlock(&thermal_hwmon_list_lock);
 			return hwmon;
 		}
+	}
 	mutex_unlock(&thermal_hwmon_list_lock);
 
 	return NULL;
-- 
2.20.1



