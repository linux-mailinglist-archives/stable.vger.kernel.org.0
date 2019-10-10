Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9E3D2581
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388584AbfJJImj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387910AbfJJImj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:42:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5AE12190F;
        Thu, 10 Oct 2019 08:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696958;
        bh=lLf2g9KCQK5PoHP2qYZDVggikNw887AYHXv+3PO2oMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gPhiCXjMVmiajjck1Ei6eMXm8PuC3l3A1HnRH4CLB01+jQ78X87/1LIhCWfa8eCa
         kiV5alLGx8qSnY+47uP1ee9qlL6mHfeVejRjKzq0ukH2z80zYRvtAj3HduQWxEMAYl
         JzPf9Sj8BpdvcC93q/j8HOPczlDOyqQYCaeDuJwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Mavrodiev <stefan@olimex.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 114/148] thermal_hwmon: Sanitize thermal_zone type
Date:   Thu, 10 Oct 2019 10:36:15 +0200
Message-Id: <20191010083618.018135079@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
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



