Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F047126D26
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfLSSlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbfLSSlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:41:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A9F7206D7;
        Thu, 19 Dec 2019 18:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780877;
        bh=2vz1lTBp9Krlp9jKW8W+bMuDkeHO+WBtwPp8GG0EyYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzSUessMxSCRNUNC4hJkQ6Er04ozmAKHzwghjcIMxO08XbpqucyuHGNpEHyMQuVKq
         Fx7SyCKAjEKFgt4llbDwSxr4f5LCAUPwg9L5GqDoji68o3BY46b5+oNlr6e1dNiuW3
         lyc2+liEnUMXx4tw0I+F+TV8ANMSd/Fti5FfKYEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 116/162] ACPI: PM: Avoid attaching ACPI PM domain to certain devices
Date:   Thu, 19 Dec 2019 19:33:44 +0100
Message-Id: <20191219183214.819142561@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit b9ea0bae260f6aae546db224daa6ac1bd9d94b91 upstream.

Certain ACPI-enumerated devices represented as platform devices in
Linux, like fans, require special low-level power management handling
implemented by their drivers that is not in agreement with the ACPI
PM domain behavior.  That leads to problems with managing ACPI fans
during system-wide suspend and resume.

For this reason, make acpi_dev_pm_attach() skip the affected devices
by adding a list of device IDs to avoid to it and putting the IDs of
the affected devices into that list.

Fixes: e5cc8ef31267 (ACPI / PM: Provide ACPI PM callback routines for subsystems)
Reported-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1094,9 +1094,19 @@ static void acpi_dev_pm_detach(struct de
  */
 int acpi_dev_pm_attach(struct device *dev, bool power_on)
 {
+	/*
+	 * Skip devices whose ACPI companions match the device IDs below,
+	 * because they require special power management handling incompatible
+	 * with the generic ACPI PM domain.
+	 */
+	static const struct acpi_device_id special_pm_ids[] = {
+		{"PNP0C0B", }, /* Generic ACPI fan */
+		{"INT3404", }, /* Fan */
+		{}
+	};
 	struct acpi_device *adev = ACPI_COMPANION(dev);
 
-	if (!adev)
+	if (!adev || !acpi_match_device_ids(adev, special_pm_ids))
 		return -ENODEV;
 
 	if (dev->pm_domain)


