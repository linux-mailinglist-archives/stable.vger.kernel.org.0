Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ED32BC661
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKVPId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 10:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgKVPIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 10:08:32 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFD6C0613CF;
        Sun, 22 Nov 2020 07:08:32 -0800 (PST)
Received: from zn.tnic (p200300ec2f2c2e0055069f03ffcec7d5.dip0.t-ipconnect.de [IPv6:2003:ec:2f2c:2e00:5506:9f03:ffce:c7d5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 45E201EC0501;
        Sun, 22 Nov 2020 16:08:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1606057703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=/fCqI6TMThbTpUDiQGra8w90Ed/xwBB5K2rz4D6pVbY=;
        b=ATIA5nAjDz0hjyO8yY4GtJzr0wOc4NTNcjWmD4AdWytF1IYCPlbs9ji4CYX8I28bxjzkxH
        qKsmUqSAwlGFZLoQeLShFc+k4xBAY9aGFKyBkm7vIbb28SYzbcbcQucB3s0JGkTFCf8VqK
        vtbIvRmSLo3M0QK6Nja/DEbZedLom4g=
From:   Borislav Petkov <bp@alien8.de>
To:     Yazen Ghannam <Yazen.Ghannam@amd.com>
Cc:     linux-edac <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: [PATCH] EDAC/amd64: Fix PCI component registration
Date:   Sun, 22 Nov 2020 16:08:15 +0100
Message-Id: <20201122150815.13808-1-bp@alien8.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

In order to setup its PCI component, the driver needs any node private
instance in order to get a reference to the PCI device and hand that
into edac_pci_create_generic_ctl(). For convenience, it uses the 0th
memory controller descriptor under the assumption that if any, the 0th
will be always present.

However, this assumption goes wrong when the 0th node doesn't have
memory and the driver doesn't initialize an instance for it:

  EDAC amd64: F17h detected (node 0).
  ...
  EDAC amd64: Node 0: No DIMMs detected.

But looking up node instances is not really needed - all one needs is
the pointer to the proper device which gets discovered during instance
init.

So stash that pointer into a variable and use it when setting up the
EDAC PCI component.

Clear that variable when the driver needs to unwind due to some
instances failing init to avoid any registration imbalance.

Cc: <stable@vger.kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/amd64_edac.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4e36d8494563..f7087ddddb90 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -18,6 +18,9 @@ static struct amd64_family_type *fam_type;
 /* Per-node stuff */
 static struct ecc_settings **ecc_stngs;
 
+/* Device for the PCI component */
+static struct device *pci_ctl_dev;
+
 /*
  * Valid scrub rates for the K8 hardware memory scrubber. We map the scrubbing
  * bandwidth to a valid bit pattern. The 'set' operation finds the 'matching-
@@ -2675,6 +2678,9 @@ reserve_mc_sibling_devs(struct amd64_pvt *pvt, u16 pci_id1, u16 pci_id2)
 			return -ENODEV;
 		}
 
+		if (!pci_ctl_dev)
+			pci_ctl_dev = &pvt->F0->dev;
+
 		edac_dbg(1, "F0: %s\n", pci_name(pvt->F0));
 		edac_dbg(1, "F3: %s\n", pci_name(pvt->F3));
 		edac_dbg(1, "F6: %s\n", pci_name(pvt->F6));
@@ -2699,6 +2705,9 @@ reserve_mc_sibling_devs(struct amd64_pvt *pvt, u16 pci_id1, u16 pci_id2)
 		return -ENODEV;
 	}
 
+	if (!pci_ctl_dev)
+		pci_ctl_dev = &pvt->F2->dev;
+
 	edac_dbg(1, "F1: %s\n", pci_name(pvt->F1));
 	edac_dbg(1, "F2: %s\n", pci_name(pvt->F2));
 	edac_dbg(1, "F3: %s\n", pci_name(pvt->F3));
@@ -3615,21 +3624,10 @@ static void remove_one_instance(unsigned int nid)
 
 static void setup_pci_device(void)
 {
-	struct mem_ctl_info *mci;
-	struct amd64_pvt *pvt;
-
 	if (pci_ctl)
 		return;
 
-	mci = edac_mc_find(0);
-	if (!mci)
-		return;
-
-	pvt = mci->pvt_info;
-	if (pvt->umc)
-		pci_ctl = edac_pci_create_generic_ctl(&pvt->F0->dev, EDAC_MOD_STR);
-	else
-		pci_ctl = edac_pci_create_generic_ctl(&pvt->F2->dev, EDAC_MOD_STR);
+	pci_ctl = edac_pci_create_generic_ctl(pci_ctl_dev, EDAC_MOD_STR);
 	if (!pci_ctl) {
 		pr_warn("%s(): Unable to create PCI control\n", __func__);
 		pr_warn("%s(): PCI error report via EDAC not set\n", __func__);
@@ -3708,6 +3706,8 @@ static int __init amd64_edac_init(void)
 	return 0;
 
 err_pci:
+	pci_ctl_dev = NULL;
+
 	msrs_free(msrs);
 	msrs = NULL;
 
@@ -3737,6 +3737,8 @@ static void __exit amd64_edac_exit(void)
 	kfree(ecc_stngs);
 	ecc_stngs = NULL;
 
+	pci_ctl_dev = NULL;
+
 	msrs_free(msrs);
 	msrs = NULL;
 }
-- 
2.21.0

