Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C732477A5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgHQTvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbgHQPSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:18:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5968B206FA;
        Mon, 17 Aug 2020 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677531;
        bh=U+gWfkrY3BsVuOe18g1jlpr8DJgrJunvSINNKdy/Hcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USt9A+jvJrvxS48wpOu0IaX/a0+2yvtoL5mRgNxMsbxehh1L0oZl1zlCzK5VvVudE
         zYF86UmsF2dC0BCYUuMAC4TXRxJSSDvOk9ThZsPekyaOFaUgMhD+I4FuqhObJNEufl
         /zh1qHL8kvV1tB2O4Rf0Mz9ReOkCXjDILSb945io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 017/464] EDAC: Fix reference count leaks
Date:   Mon, 17 Aug 2020 17:09:30 +0200
Message-Id: <20200817143834.582963824@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0e7ea3591b781..5e75937537997 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -275,6 +275,7 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 
 	/* Error exit stack */
 err_kobj_reg:
+	kobject_put(&edac_dev->kobj);
 	module_put(edac_dev->owner);
 
 err_out:
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 72c9eb9fdffbe..53042af7262e2 100644
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



