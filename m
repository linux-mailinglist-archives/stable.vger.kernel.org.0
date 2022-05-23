Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF165316C4
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240513AbiEWRYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240607AbiEWRTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8C173563;
        Mon, 23 May 2022 10:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECDFB6091F;
        Mon, 23 May 2022 17:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA64DC385A9;
        Mon, 23 May 2022 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326201;
        bh=DZk+WXcnW8g/8vZtd8VD3Srcm77n05xo5TSm9bOHfNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKQ4BmPCTbZ4EwWgS5vuzzzs8KFe1qbgTspRRWLywIDKhXB6E6ATHRgoDfEaQeluk
         I2HU9BmMCgy3Jo85bmZfgVTWo1YLk33+hEwZtox38RSbgzuEEUTddhqH8XqhHNLNgF
         V7h3iEL0XqvqYBYjqSI3fTwlVN7ad0aPIip4A1xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/97] s390/pci: improve zpci_dev reference counting
Date:   Mon, 23 May 2022 19:05:23 +0200
Message-Id: <20220523165815.319610610@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
References: <20220523165812.244140613@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit c122383d221dfa2f41cfe5e672540595de986fde ]

Currently zpci_dev uses kref based reference counting but only accounts
for one original reference plus one reference from an added pci_dev to
its underlying zpci_dev. Counting just the original reference worked
until the pci_dev reference was added in commit 2a671f77ee49 ("s390/pci:
fix use after free of zpci_dev") because once a zpci_dev goes away, i.e.
enters the reserved state, it would immediately get released. However
with the pci_dev reference this is no longer the case and the zpci_dev
may still appear in multiple availability events indicating that it was
reserved. This was solved by detecting when the zpci_dev is already on
its way out but still hanging around. This has however shown some light
on how unusual our zpci_dev reference counting is.

Improve upon this by modelling zpci_dev reference counting on pci_dev.
Analogous to pci_get_slot() increment the reference count in
get_zdev_by_fid(). Thus all users of get_zdev_by_fid() must drop the
reference once they are done with the zpci_dev.

Similar to pci_scan_single_device(), zpci_create_device() returns the
device with an initial count of 1 and the device added to the zpci_list
(analogous to the PCI bus' device_list). In turn users of
zpci_create_device() must only drop the reference once the device is
gone from the point of view of the zPCI subsystem, it might still be
referenced by the common PCI subsystem though.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c       | 1 +
 arch/s390/pci/pci_bus.h   | 3 ++-
 arch/s390/pci/pci_clp.c   | 9 +++++++--
 arch/s390/pci/pci_event.c | 7 ++++++-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index e14e4a3a647a..74799439b259 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -69,6 +69,7 @@ struct zpci_dev *get_zdev_by_fid(u32 fid)
 	list_for_each_entry(tmp, &zpci_list, entry) {
 		if (tmp->fid == fid) {
 			zdev = tmp;
+			zpci_zdev_get(zdev);
 			break;
 		}
 	}
diff --git a/arch/s390/pci/pci_bus.h b/arch/s390/pci/pci_bus.h
index 55c9488e504c..8d2fcd091ca7 100644
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -13,7 +13,8 @@ void zpci_bus_device_unregister(struct zpci_dev *zdev);
 void zpci_release_device(struct kref *kref);
 static inline void zpci_zdev_put(struct zpci_dev *zdev)
 {
-	kref_put(&zdev->kref, zpci_release_device);
+	if (zdev)
+		kref_put(&zdev->kref, zpci_release_device);
 }
 
 static inline void zpci_zdev_get(struct zpci_dev *zdev)
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 0a0e8b8293be..d1a5c80a41cb 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -22,6 +22,8 @@
 #include <asm/clp.h>
 #include <uapi/asm/clp.h>
 
+#include "pci_bus.h"
+
 bool zpci_unique_uid;
 
 void update_uid_checking(bool new)
@@ -372,8 +374,11 @@ static void __clp_add(struct clp_fh_list_entry *entry, void *data)
 		return;
 
 	zdev = get_zdev_by_fid(entry->fid);
-	if (!zdev)
-		zpci_create_device(entry->fid, entry->fh, entry->config_state);
+	if (zdev) {
+		zpci_zdev_put(zdev);
+		return;
+	}
+	zpci_create_device(entry->fid, entry->fh, entry->config_state);
 }
 
 int clp_scan_pci_devices(void)
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index b7cfde7e80a8..6ced44b5be8a 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -61,10 +61,12 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 	       pdev ? pci_name(pdev) : "n/a", ccdf->pec, ccdf->fid);
 
 	if (!pdev)
-		return;
+		goto no_pdev;
 
 	pdev->error_state = pci_channel_io_perm_failure;
 	pci_dev_put(pdev);
+no_pdev:
+	zpci_zdev_put(zdev);
 }
 
 void zpci_event_error(void *data)
@@ -76,6 +78,7 @@ void zpci_event_error(void *data)
 static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 {
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
+	bool existing_zdev = !!zdev;
 	enum zpci_state state;
 	struct pci_dev *pdev;
 	int ret;
@@ -161,6 +164,8 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 	default:
 		break;
 	}
+	if (existing_zdev)
+		zpci_zdev_put(zdev);
 }
 
 void zpci_event_availability(void *data)
-- 
2.35.1



