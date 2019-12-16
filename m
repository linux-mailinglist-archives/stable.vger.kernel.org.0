Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67FC1215BC
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbfLPSTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731703AbfLPSTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:19:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5802207FF;
        Mon, 16 Dec 2019 18:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520364;
        bh=5j+6CsovKw99scUcvr+DpdunNczZoR/kosoKZyu7GQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovlz+DFfBw+PDU7zsrJ59v0XOU3Z0GgVZFNuPnI6sdYULeN9QcCpsG1D6mLDzqrph
         Kyd0GgORr/VKylZzRkwC40I5gqFtD7JGKZNWTzO+FYTbR0UKgjo7bwYLDvjmN5E8HS
         5B9w3YQo+6EGcO497n4oDeoRsK1RM3BHJQriVMCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 123/177] ACPI: LPSS: Add LNXVIDEO -> BYT I2C7 to lpss_device_links
Date:   Mon, 16 Dec 2019 18:49:39 +0100
Message-Id: <20191216174843.551564597@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit cc18735f208565343a9824adeca5305026598550 upstream.

So far on Bay Trail (BYT) we only have been adding a device_link adding
the iGPU (LNXVIDEO) device as consumer for the I2C controller for the
PMIC for I2C5, but the PMIC only uses I2C5 on BYT CR (cost reduced) on
regular BYT platforms I2C7 is used and we were not adding the device_link
sometimes causing resume ordering issues.

This commit adds LNXVIDEO -> BYT I2C7 to the lpss_device_links table,
fixing this.

Fixes: 2d71ee0ce72f ("ACPI / LPSS: Add a device link from the GPU to the BYT I2C5 controller")
Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -473,9 +473,14 @@ struct lpss_device_links {
  * the supplier is not enumerated until after the consumer is probed.
  */
 static const struct lpss_device_links lpss_device_links[] = {
+	/* CHT External sdcard slot controller depends on PMIC I2C ctrl */
 	{"808622C1", "7", "80860F14", "3", DL_FLAG_PM_RUNTIME},
+	/* CHT iGPU depends on PMIC I2C controller */
 	{"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
+	/* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
 	{"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
+	/* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
+	{"80860F41", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
 };
 
 static bool hid_uid_match(struct acpi_device *adev,


