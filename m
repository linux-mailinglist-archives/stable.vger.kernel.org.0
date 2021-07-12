Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B2C3C5546
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355481AbhGLIJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353400AbhGLICH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31C1061C84;
        Mon, 12 Jul 2021 07:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076496;
        bh=Wa4eMO1q5HUA/p6YthAUDdzW4se/mICWOTp1JmKL9w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVrJB5H6ipwVRXR3QvRlG4eGMrP6pEUWSks43dvFneVv51vwX1yMc5QCDGyFVX1pw
         AAqcDx3M6l/tZOAspTsONbkIy0urSMj9vX7PGZghNNNocci8/qwKosBiMmdsuvE0dC
         XKkadKawobG/E9gm12Mi031e9uDEj6O8iCTrqe+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 669/800] mfd: Remove software node conditionally and locate at right place
Date:   Mon, 12 Jul 2021 08:11:32 +0200
Message-Id: <20210712061038.114689183@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5a23e8b0fd6010e25ae58362292235cc9213ca57 ]

Currently the software node is removed in error case and at ->remove()
stage unconditionally, that ruins the symmetry. Besides, in some cases,
when mfd_add_device() fails, the device_remove_software_node() call
may lead to NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 00000000
  ...
  EIP: strlen+0x12/0x20
  ...
  kernfs_name_hash+0x13/0x70
  kernfs_find_ns+0x32/0xc0
  kernfs_remove_by_name_ns+0x2a/0x90
  sysfs_remove_link+0x16/0x30
  software_node_notify.cold+0x34/0x6b
  device_remove_software_node+0x5a/0x90
  mfd_add_device.cold+0x30a/0x427

Fix all these by guarding device_remove_software_node() with a conditional
and locating it at the right place.

Fixes: 42e59982917a ("mfd: core: Add support for software nodes")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 6f02b8022c6d..79f5c6a18815 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -266,18 +266,18 @@ static int mfd_add_device(struct device *parent, int id,
 			if (has_acpi_companion(&pdev->dev)) {
 				ret = acpi_check_resource_conflict(&res[r]);
 				if (ret)
-					goto fail_of_entry;
+					goto fail_res_conflict;
 			}
 		}
 	}
 
 	ret = platform_device_add_resources(pdev, res, cell->num_resources);
 	if (ret)
-		goto fail_of_entry;
+		goto fail_res_conflict;
 
 	ret = platform_device_add(pdev);
 	if (ret)
-		goto fail_of_entry;
+		goto fail_res_conflict;
 
 	if (cell->pm_runtime_no_callbacks)
 		pm_runtime_no_callbacks(&pdev->dev);
@@ -286,13 +286,15 @@ static int mfd_add_device(struct device *parent, int id,
 
 	return 0;
 
+fail_res_conflict:
+	if (cell->swnode)
+		device_remove_software_node(&pdev->dev);
 fail_of_entry:
 	list_for_each_entry_safe(of_entry, tmp, &mfd_of_node_list, list)
 		if (of_entry->dev == &pdev->dev) {
 			list_del(&of_entry->list);
 			kfree(of_entry);
 		}
-	device_remove_software_node(&pdev->dev);
 fail_alias:
 	regulator_bulk_unregister_supply_alias(&pdev->dev,
 					       cell->parent_supplies,
@@ -358,11 +360,12 @@ static int mfd_remove_devices_fn(struct device *dev, void *data)
 	if (level && cell->level > *level)
 		return 0;
 
+	if (cell->swnode)
+		device_remove_software_node(&pdev->dev);
+
 	regulator_bulk_unregister_supply_alias(dev, cell->parent_supplies,
 					       cell->num_parent_supplies);
 
-	device_remove_software_node(&pdev->dev);
-
 	platform_device_unregister(pdev);
 	return 0;
 }
-- 
2.30.2



