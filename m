Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E755423FA3F
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHHXlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgHHXkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 180F92053B;
        Sat,  8 Aug 2020 23:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596930038;
        bh=BmFvSYOC5avABBb19lAm61NvJ0ZOipqaWWp6VsdLIJA=;
        h=From:To:Cc:Subject:Date:From;
        b=OYaztwnEfGFy9pVknc+6SozoJU0EOcBWD3MucdmEwc1BM4yYCXYof/YNLYL3OjQ7o
         Q4+IFFEjCvNxesocQN6h9sX5W3xHHlqGonqMrlAXQgtbSTXw3t+b8bknVyFk4VoyAi
         JKN9N5CODvEiuSjl2Zav0tdfSTZ9hpkJmKDTFlAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/9] EDAC: Fix reference count leaks
Date:   Sat,  8 Aug 2020 19:40:28 -0400
Message-Id: <20200808234037.3619732-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 17ed808ad243192fb923e4e653c1338d3ba06207 ]

When kobject_init_and_add() returns an error, it should be handled
because kobject_init_and_add() takes a reference even when it fails. If
this function returns an error, kobject_put() must be called to properly
clean up the memory associated with the object.

Therefore, replace calling kfree() and call kobject_put() and add a
missing kobject_put() in the edac_device_register_sysfs_main_kobj()
error path.

 [ bp: Massage and merge into a single patch. ]

Fixes: b2ed215a3338 ("Kobject: change drivers/edac to use kobject_init_and_add")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200528202238.18078-1-wu000273@umn.edu
Link: https://lkml.kernel.org/r/20200528203526.20908-1-wu000273@umn.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_device_sysfs.c | 1 +
 drivers/edac/edac_pci_sysfs.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index 93da1a45c7161..470b02fc2de96 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -275,6 +275,7 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 
 	/* Error exit stack */
 err_kobj_reg:
+	kobject_put(&edac_dev->kobj);
 	module_put(edac_dev->owner);
 
 err_out:
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 6e3428ba400f3..622d117e25335 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -386,7 +386,7 @@ static int edac_pci_main_kobj_setup(void)
 
 	/* Error unwind statck */
 kobject_init_and_add_fail:
-	kfree(edac_pci_top_main_kobj);
+	kobject_put(edac_pci_top_main_kobj);
 
 kzalloc_fail:
 	module_put(THIS_MODULE);
-- 
2.25.1

