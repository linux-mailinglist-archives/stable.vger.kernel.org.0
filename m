Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C13217221
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgGGP3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728266AbgGGPY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF7EE2082E;
        Tue,  7 Jul 2020 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135497;
        bh=/xjjT+s96wlfNil8hnKvalJ9n/2rmxOGa+riN1pjP/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fL4ysjwzbDFw7/53G1qh7G7QJk79K2gYUN9HwUd9RUGx1z3ip/QHQpnL/GpqhYBku
         dkgnAD4WeJ0xiGgV2Tt9Rp8FqoBaSZQTUtPeducKXdpUJhDGvVHbKJUcCpO4r4HVnH
         iLS4VzXmDOUcAKuAKE2NmC6TMm/ioOF94ChBHls0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 065/112] hwmon: (acpi_power_meter) Fix potential memory leak in acpi_power_meter_add()
Date:   Tue,  7 Jul 2020 17:17:10 +0200
Message-Id: <20200707145804.091912038@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
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
index 0db8ef4fd6e18..a270b975e90bb 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -883,7 +883,7 @@ static int acpi_power_meter_add(struct acpi_device *device)
 
 	res = setup_attrs(resource);
 	if (res)
-		goto exit_free;
+		goto exit_free_capability;
 
 	resource->hwmon_dev = hwmon_device_register(&device->dev);
 	if (IS_ERR(resource->hwmon_dev)) {
@@ -896,6 +896,8 @@ static int acpi_power_meter_add(struct acpi_device *device)
 
 exit_remove:
 	remove_attrs(resource);
+exit_free_capability:
+	free_capabilities(resource);
 exit_free:
 	kfree(resource);
 exit:
-- 
2.25.1



