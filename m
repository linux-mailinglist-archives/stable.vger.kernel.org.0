Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887791CAB3D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbgEHMls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgEHMln (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 226AC24970;
        Fri,  8 May 2020 12:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941702;
        bh=o+EBxYd1jlD/bVmEFGJm1hf05//1H6q48EMuC3VG/c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7gCdwf46XsPRe2uSvgA1AZZ/u00mo7YcUbAKbD2MWTYBLxwirBIDtGFzHRSgegvA
         QC2RVKEvH1ZEBs9siscaYCO7OmlDDtG0V0QbU1BIFqEk3nNXhEwbNPxwfOvPI9gjFh
         c0WlFaXmVOXM1FooN8ENjfTwAXuZHvlz7qUOGSWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 137/312] Revert "ACPI / LPSS: allow to use specific PM domain during ->probe()"
Date:   Fri,  8 May 2020 14:32:08 +0200
Message-Id: <20200508123134.131597622@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b5f88dd1d6efc472e35ca1b21a44e662c5422088 upstream.

The specific power domain can't be used in a way provided by the commit
01ac170ba29a, i.e. pointer to platform device is a subject to change during
unbound / bind cycle.

This reverts commit 01ac170ba29a9903ee590e1ef2d8e6b27b49a16c.

Fixes: 3df2da968744 (Revert "ACPI / LPSS: introduce a 'proxy' device to power on LPSS for DMA")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -704,8 +704,13 @@ static int acpi_lpss_platform_notify(str
 	}
 
 	switch (action) {
-	case BUS_NOTIFY_ADD_DEVICE:
+	case BUS_NOTIFY_BOUND_DRIVER:
 		pdev->dev.pm_domain = &acpi_lpss_pm_domain;
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		pdev->dev.pm_domain = NULL;
+		break;
+	case BUS_NOTIFY_ADD_DEVICE:
 		if (pdata->dev_desc->flags & LPSS_LTR)
 			return sysfs_create_group(&pdev->dev.kobj,
 						  &lpss_attr_group);
@@ -713,7 +718,6 @@ static int acpi_lpss_platform_notify(str
 	case BUS_NOTIFY_DEL_DEVICE:
 		if (pdata->dev_desc->flags & LPSS_LTR)
 			sysfs_remove_group(&pdev->dev.kobj, &lpss_attr_group);
-		pdev->dev.pm_domain = NULL;
 		break;
 	default:
 		break;


