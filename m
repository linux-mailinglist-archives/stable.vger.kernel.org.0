Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327101133AD
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfLDSKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:10:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731277AbfLDSKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:10:31 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73BA1206DF;
        Wed,  4 Dec 2019 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483030;
        bh=IPTb/noze68zxc4Ep0YinQYWP6168edJf7Te72FHfnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik0dD3H5/TxwwkJgWT2SCmkUnktvBYVfGQwy6uYlGCDQtHjvku1Gl45q9UP35Wpje
         WWoiWna2afvT5oua3SEK003NSpGp86/YypJQFCy/CtJFFR2z0C5YeB+qlfgp3NJwqS
         xl8kS5Zv+0zmeG4kW/2nhqc3j/OuUeGileuB9i6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 023/125] ACPI / LPSS: Ignore acpi_device_fix_up_power() return value
Date:   Wed,  4 Dec 2019 18:55:28 +0100
Message-Id: <20191204175319.121388614@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1a2fa02f7489dc4d746f2a15fb77b3ce1affade8 ]

Ignore acpi_device_fix_up_power() return value. If we return an error
we end up with acpi_default_enumeration() still creating a platform-
device for the device and we end up with the device still being used
but without the special LPSS related handling which is not useful.

Specicifically ignoring the error fixes the touchscreen no longer
working after a suspend/resume on a Prowise PT301 tablet.

This tablet has a broken _PS0 method on the touchscreen's I2C controller,
causing acpi_device_fix_up_power() to fail, causing fallback to standard
platform-dev handling and specifically causing acpi_lpss_save/restore_ctx
to not run.

The I2C controllers _PS0 method does actually turn on the device, but then
does some more nonsense which fails when run during early boot trying to
use I2C opregion handling on another not-yet registered I2C controller.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 8e38249311bdf..a9158858f54cd 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -448,12 +448,7 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
 	 * have _PS0 and _PS3 without _PSC (and no power resources), so
 	 * acpi_bus_init_power() will assume that the BIOS has put them into D0.
 	 */
-	ret = acpi_device_fix_up_power(adev);
-	if (ret) {
-		/* Skip the device, but continue the namespace scan. */
-		ret = 0;
-		goto err_out;
-	}
+	acpi_device_fix_up_power(adev);
 
 	adev->driver_data = pdata;
 	pdev = acpi_create_platform_device(adev, dev_desc->properties);
-- 
2.20.1



