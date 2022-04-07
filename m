Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB5B4F7104
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbiDGBXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238844AbiDGBSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:18:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C3D19FF46;
        Wed,  6 Apr 2022 18:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0EB01CE1379;
        Thu,  7 Apr 2022 01:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7B1C385A3;
        Thu,  7 Apr 2022 01:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294018;
        bh=92+NFS0k3PNxcxMEA45Y2iFX4nKAdzYI4g8D6reYW64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3hyWVH8VMu1h0cBBMMt2l3Ov5/LCmHCCduTOKXz9AY9YnG/+Q8vL2NTc7CmE679k
         IODHeFh33dvCqO3keOrd/Yd39nUJ0egH2mIVd+IhUNtSvPxz7VoojnPSPJ1I1/ddnS
         RIkSI2LTGCWJqgNL0inIyAcd6R+F5QK98f+LzrahpClDighJWSMB+CxHbDACb+KBED
         VQgXrmAeq55CinfWAH6zUAZIuAXz5O0QxNQPe5nRbY9dNsmllitS6WH8wpWkryaGqn
         nsMvNqM2Xz5YCa2hUAnJEbdPGTB6x3+j23IgzxihFXeq6BMUNlCMqOgX6OSZY7kArZ
         TGGVpCjyCkSTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/27] s390/pci: improve zpci_dev reference counting
Date:   Wed,  6 Apr 2022 21:12:45 -0400
Message-Id: <20220407011257.114287-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b833155ce838..639924d98331 100644
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
index e359d2686178..ecef3a9e16c0 100644
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -19,7 +19,8 @@ void zpci_bus_remove_device(struct zpci_dev *zdev, bool set_error);
 void zpci_release_device(struct kref *kref);
 static inline void zpci_zdev_put(struct zpci_dev *zdev)
 {
-	kref_put(&zdev->kref, zpci_release_device);
+	if (zdev)
+		kref_put(&zdev->kref, zpci_release_device);
 }
 
 static inline void zpci_zdev_get(struct zpci_dev *zdev)
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index be077b39da33..5011d27461fd 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -22,6 +22,8 @@
 #include <asm/clp.h>
 #include <uapi/asm/clp.h>
 
+#include "pci_bus.h"
+
 bool zpci_unique_uid;
 
 void update_uid_checking(bool new)
@@ -403,8 +405,11 @@ static void __clp_add(struct clp_fh_list_entry *entry, void *data)
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
index 5b8d647523f9..6d57625b8ed9 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -62,10 +62,12 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
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
@@ -94,6 +96,7 @@ static void zpci_event_hard_deconfigured(struct zpci_dev *zdev, u32 fh)
 static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 {
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
+	bool existing_zdev = !!zdev;
 	enum zpci_state state;
 
 	zpci_err("avail CCDF:\n");
@@ -156,6 +159,8 @@ static void __zpci_event_availability(struct zpci_ccdf_avail *ccdf)
 	default:
 		break;
 	}
+	if (existing_zdev)
+		zpci_zdev_put(zdev);
 }
 
 void zpci_event_availability(void *data)
-- 
2.35.1

