Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A2421703F
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgGGPQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbgGGPQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:16:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8724D20663;
        Tue,  7 Jul 2020 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134977;
        bh=q+Vb6PiG6uvgYel3scfgNurMrlq03wxaoOPQh+gW0Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHfjKLcxl8FsYLpiyCaO6I8mv2FXuUn70tt6SBfgRWdrVNRtRPjIzm5UyOTWDOLhL
         /6gJ4cJOqxe6eJCByO7gvbKM21mkUsEQtnuJCB3snMt/h7MK5GlGwNhtSv4ROzbTG5
         mHJxlIuKmuzRIJ9K7q62Q71hM9ElApTRlk9oPkZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/27] hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()
Date:   Tue,  7 Jul 2020 17:15:42 +0200
Message-Id: <20200707145749.684144887@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
References: <20200707145748.944863698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

[ Upstream commit 8b97f9922211c44a739c5cbd9502ecbb9f17f6d1 ]

Although it rarely happens, we should call free_capabilities()
if error happens after read_capabilities() to free allocated strings.

Fixes: de584afa5e188 ("hwmon driver for ACPI 4.0 power meters")
Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Link: https://lore.kernel.org/r/20200625043242.31175-1-misono.tomohiro@jp.fujitsu.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index ba3af4505d8fb..e40d8907853bf 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -895,7 +895,7 @@ static int acpi_power_meter_add(struct acpi_device *device)
 
 	res = setup_attrs(resource);
 	if (res)
-		goto exit_free;
+		goto exit_free_capability;
 
 	resource->hwmon_dev = hwmon_device_register(&device->dev);
 	if (IS_ERR(resource->hwmon_dev)) {
@@ -908,6 +908,8 @@ static int acpi_power_meter_add(struct acpi_device *device)
 
 exit_remove:
 	remove_attrs(resource);
+exit_free_capability:
+	free_capabilities(resource);
 exit_free:
 	kfree(resource);
 exit:
-- 
2.25.1



