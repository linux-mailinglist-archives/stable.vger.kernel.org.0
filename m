Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A543D61CD
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhGZPdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232878AbhGZPaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 342776056B;
        Mon, 26 Jul 2021 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315883;
        bh=uPoPKBsjhLxRzU4uNbpppdSV3AAGDMad4RgMyiDG+bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFshEhb+6Bx16L1Gk0z7S08IM1jpB5uQt/B9dH5EP1gYb547D0AvT3gTvkAIy0sTY
         J0fYGsvG4nYr5jlWhrkHTTT7Zf2mp+Gni//JRbhvv71f7fUWC/PjGUBMpV/+kQzQcj
         CQdbeBqqSQdh3xV15/GfcsKnxYfsorC9tmKUQpmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Daniel Scally <djrscally@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 103/223] ACPI: utils: Fix reference counting in for_each_acpi_dev_match()
Date:   Mon, 26 Jul 2021 17:38:15 +0200
Message-Id: <20210726153849.647960503@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 71f6428332844f38c7cb10461d9f29e9c9b983a0 ]

Currently it's possible to iterate over the dangling pointer in case the device
suddenly disappears. This may happen becase callers put it at the end of a loop.

Instead, let's move that call inside acpi_dev_get_next_match_dev().

Fixes: 803abec64ef9 ("media: ipu3-cio2: Add cio2-bridge to ipu3-cio2 driver")
Fixes: bf263f64e804 ("media: ACPI / bus: Add acpi_dev_get_next_match_dev() and helper macro")
Fixes: edbd1bc4951e ("efi/dev-path-parser: Switch to use for_each_acpi_dev_match()")
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Daniel Scally <djrscally@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/utils.c                       | 7 +++----
 drivers/firmware/efi/dev-path-parser.c     | 1 -
 drivers/media/pci/intel/ipu3/cio2-bridge.c | 6 ++----
 include/acpi/acpi_bus.h                    | 5 -----
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 3b54b8fd7396..27ec9d57f3b8 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -846,11 +846,9 @@ EXPORT_SYMBOL(acpi_dev_present);
  * Return the next match of ACPI device if another matching device was present
  * at the moment of invocation, or NULL otherwise.
  *
- * FIXME: The function does not tolerate the sudden disappearance of @adev, e.g.
- * in the case of a hotplug event. That said, the caller should ensure that
- * this will never happen.
- *
  * The caller is responsible for invoking acpi_dev_put() on the returned device.
+ * On the other hand the function invokes  acpi_dev_put() on the given @adev
+ * assuming that its reference counter had been increased beforehand.
  *
  * See additional information in acpi_dev_present() as well.
  */
@@ -866,6 +864,7 @@ acpi_dev_get_next_match_dev(struct acpi_device *adev, const char *hid, const cha
 	match.hrv = hrv;
 
 	dev = bus_find_device(&acpi_bus_type, start, &match, acpi_dev_match_cb);
+	acpi_dev_put(adev);
 	return dev ? to_acpi_device(dev) : NULL;
 }
 EXPORT_SYMBOL(acpi_dev_get_next_match_dev);
diff --git a/drivers/firmware/efi/dev-path-parser.c b/drivers/firmware/efi/dev-path-parser.c
index 10d4457417a4..eb9c65f97841 100644
--- a/drivers/firmware/efi/dev-path-parser.c
+++ b/drivers/firmware/efi/dev-path-parser.c
@@ -34,7 +34,6 @@ static long __init parse_acpi_path(const struct efi_dev_path *node,
 			break;
 		if (!adev->pnp.unique_id && node->acpi.uid == 0)
 			break;
-		acpi_dev_put(adev);
 	}
 	if (!adev)
 		return -ENODEV;
diff --git a/drivers/media/pci/intel/ipu3/cio2-bridge.c b/drivers/media/pci/intel/ipu3/cio2-bridge.c
index 4657e99df033..59a36f922675 100644
--- a/drivers/media/pci/intel/ipu3/cio2-bridge.c
+++ b/drivers/media/pci/intel/ipu3/cio2-bridge.c
@@ -173,10 +173,8 @@ static int cio2_bridge_connect_sensor(const struct cio2_sensor_config *cfg,
 	int ret;
 
 	for_each_acpi_dev_match(adev, cfg->hid, NULL, -1) {
-		if (!adev->status.enabled) {
-			acpi_dev_put(adev);
+		if (!adev->status.enabled)
 			continue;
-		}
 
 		if (bridge->n_sensors >= CIO2_NUM_PORTS) {
 			acpi_dev_put(adev);
@@ -185,7 +183,6 @@ static int cio2_bridge_connect_sensor(const struct cio2_sensor_config *cfg,
 		}
 
 		sensor = &bridge->sensors[bridge->n_sensors];
-		sensor->adev = adev;
 		strscpy(sensor->name, cfg->hid, sizeof(sensor->name));
 
 		ret = cio2_bridge_read_acpi_buffer(adev, "SSDB",
@@ -215,6 +212,7 @@ static int cio2_bridge_connect_sensor(const struct cio2_sensor_config *cfg,
 			goto err_free_swnodes;
 		}
 
+		sensor->adev = acpi_dev_get(adev);
 		adev->fwnode.secondary = fwnode;
 
 		dev_info(&cio2->dev, "Found supported sensor %s\n",
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 3a82faac5767..bff6a11bb21f 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -698,11 +698,6 @@ acpi_dev_get_first_match_dev(const char *hid, const char *uid, s64 hrv);
  * @hrv: Hardware Revision of the device, pass -1 to not check _HRV
  *
  * The caller is responsible for invoking acpi_dev_put() on the returned device.
- *
- * FIXME: Due to above requirement there is a window that may invalidate @adev
- * and next iteration will use a dangling pointer, e.g. in the case of a
- * hotplug event. That said, the caller should ensure that this will never
- * happen.
  */
 #define for_each_acpi_dev_match(adev, hid, uid, hrv)			\
 	for (adev = acpi_dev_get_first_match_dev(hid, uid, hrv);	\
-- 
2.30.2



