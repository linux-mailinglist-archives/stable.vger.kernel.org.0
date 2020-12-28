Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613872E6527
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389313AbgL1P47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389350AbgL1Nf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:35:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DAFA207B2;
        Mon, 28 Dec 2020 13:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162488;
        bh=80ZIhablfgFDhoCd8GItsk7AQeVOjS7EoAnZDFIjXmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1a2KSM1JrVMTEq31I53tNfq4ekXrqUpAPE4sSlMNu0mjW27LYlek4fGG7LYUTxU7Y
         jd4mg1zk2u04GSUiSyVmkBi0+hBTGUVSXNuaDkSQhO4cF2006JjgvCnFF483ZSfcZW
         Lvc4LQkhMbev35i+ALHAHZQ3boCw+2wLnbU3KurI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.19 288/346] EDAC/amd64: Fix PCI component registration
Date:   Mon, 28 Dec 2020 13:50:07 +0100
Message-Id: <20201228124933.696729318@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 706657b1febf446a9ba37dc51b89f46604f57ee9 upstream.

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
Link: https://lkml.kernel.org/r/20201122150815.13808-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/amd64_edac.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -18,6 +18,9 @@ static struct msr __percpu *msrs;
 /* Per-node stuff */
 static struct ecc_settings **ecc_stngs;
 
+/* Device for the PCI component */
+static struct device *pci_ctl_dev;
+
 /*
  * Valid scrub rates for the K8 hardware memory scrubber. We map the scrubbing
  * bandwidth to a valid bit pattern. The 'set' operation finds the 'matching-
@@ -2563,6 +2566,9 @@ reserve_mc_sibling_devs(struct amd64_pvt
 			return -ENODEV;
 		}
 
+		if (!pci_ctl_dev)
+			pci_ctl_dev = &pvt->F0->dev;
+
 		edac_dbg(1, "F0: %s\n", pci_name(pvt->F0));
 		edac_dbg(1, "F3: %s\n", pci_name(pvt->F3));
 		edac_dbg(1, "F6: %s\n", pci_name(pvt->F6));
@@ -2587,6 +2593,9 @@ reserve_mc_sibling_devs(struct amd64_pvt
 		return -ENODEV;
 	}
 
+	if (!pci_ctl_dev)
+		pci_ctl_dev = &pvt->F2->dev;
+
 	edac_dbg(1, "F1: %s\n", pci_name(pvt->F1));
 	edac_dbg(1, "F2: %s\n", pci_name(pvt->F2));
 	edac_dbg(1, "F3: %s\n", pci_name(pvt->F3));
@@ -3441,21 +3450,10 @@ static void remove_one_instance(unsigned
 
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
@@ -3535,6 +3533,8 @@ static int __init amd64_edac_init(void)
 	return 0;
 
 err_pci:
+	pci_ctl_dev = NULL;
+
 	msrs_free(msrs);
 	msrs = NULL;
 
@@ -3566,6 +3566,8 @@ static void __exit amd64_edac_exit(void)
 	kfree(ecc_stngs);
 	ecc_stngs = NULL;
 
+	pci_ctl_dev = NULL;
+
 	msrs_free(msrs);
 	msrs = NULL;
 }


