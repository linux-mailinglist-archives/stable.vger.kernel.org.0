Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAE125D706
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgIDLJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:09:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:10188 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgIDLJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 07:09:20 -0400
IronPort-SDR: nvkle6vDqTGU9Jaoia3fx8HukIkT5o/w5CETI2x4dKCvp7o3Wzc4OJDMjYy1FarShZq2d29iBI
 3ed+69QzUT4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="156988272"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="156988272"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 04:09:20 -0700
IronPort-SDR: w21heZ4GzWpcTT5oG3sEfPpvjElJK92gvCwEt4aQJcf66vxIgmzHnCGYO368WR7blJVibYRj/j
 4tdwD1FzS1MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="405791788"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 04 Sep 2020 04:09:18 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] usb: typec: ucsi: acpi: Check the _DEP dependencies
Date:   Fri,  4 Sep 2020 14:09:18 +0300
Message-Id: <20200904110918.51546-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Failing probe with -EPROBE_DEFER until all dependencies
listed in the _DEP (Operation Region Dependencies) object
have been met.

This will fix an issue where on some platforms UCSI ACPI
driver fails to probe because the address space handler for
the operation region that the UCSI ACPI interface uses has
not been loaded yet.

Fixes: 8243edf44152 ("usb: typec: ucsi: Add ACPI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index 9fc4f338e8700..c0aca2f0f23f0 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -112,11 +112,15 @@ static void ucsi_acpi_notify(acpi_handle handle, u32 event, void *data)
 
 static int ucsi_acpi_probe(struct platform_device *pdev)
 {
+	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
 	struct ucsi_acpi *ua;
 	struct resource *res;
 	acpi_status status;
 	int ret;
 
+	if (adev->dep_unmet)
+		return -EPROBE_DEFER;
+
 	ua = devm_kzalloc(&pdev->dev, sizeof(*ua), GFP_KERNEL);
 	if (!ua)
 		return -ENOMEM;
-- 
2.28.0

