Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A73A66C892
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjAPQkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbjAPQkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767902D140
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:28:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31A56B8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FA1C433D2;
        Mon, 16 Jan 2023 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886506;
        bh=Mhrg3v0lwqLPTxKdO7ns6AG/aZn7Eb9JpOuAWMOEh6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkbimxxIU1ct71pp+B1w/WKI0Jeq6mtij2b57bZViN6PdxJJyc5UhPxR8D+FoL37T
         tO1TawJo8ukJkWda5fJXYqfSMt94CE5281RZ4GcWLhpfznjVEveVqZ2QMhyX4+DSBm
         u0+obHt4oPA+UxD8W4nwUBlVouivuHQ++tpXgMFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adam Vodopjan <grozzly@protonmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 457/658] ata: ahci: Fix PCS quirk application for suspend
Date:   Mon, 16 Jan 2023 16:49:05 +0100
Message-Id: <20230116154930.401674855@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Vodopjan <grozzly@protonmail.com>

[ Upstream commit 37e14e4f3715428b809e4df9a9958baa64c77d51 ]

Since kernel 5.3.4 my laptop (ICH8M controller) does not see Kingston
SV300S37A60G SSD disk connected into a SATA connector on wake from
suspend.  The problem was introduced in c312ef176399 ("libata/ahci: Drop
PCS quirk for Denverton and beyond"): the quirk is not applied on wake
from suspend as it originally was.

It is worth to mention the commit contained another bug: the quirk is
not applied at all to controllers which require it. The fix commit
09d6ac8dc51a ("libata/ahci: Fix PCS quirk application") landed in 5.3.8.
So testing my patch anywhere between commits c312ef176399 and
09d6ac8dc51a is pointless.

Not all disks trigger the problem. For example nothing bad happens with
Western Digital WD5000LPCX HDD.

Test hardware:
- Acer 5920G with ICH8M SATA controller
- sda: some SATA HDD connnected into the DVD drive IDE port with a
  SATA-IDE caddy. It is a boot disk
- sdb: Kingston SV300S37A60G SSD connected into the only SATA port

Sample "dmesg --notime | grep -E '^(sd |ata)'" output on wake:

sd 0:0:0:0: [sda] Starting disk
sd 2:0:0:0: [sdb] Starting disk
ata4: SATA link down (SStatus 4 SControl 300)
ata3: SATA link down (SStatus 4 SControl 300)
ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata1: FORCE: cable set to 80c
ata5: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 4 SControl 300)
ata3: SATA link down (SStatus 4 SControl 300)
ata3.00: disabled
sd 2:0:0:0: rejecting I/O to offline device
ata3.00: detaching (SCSI 2:0:0:0)
sd 2:0:0:0: [sdb] Start/Stop Unit failed: Result: hostbyte=DID_NO_CONNECT
	driverbyte=DRIVER_OK
sd 2:0:0:0: [sdb] Synchronizing SCSI cache
sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
	hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 2:0:0:0: [sdb] Stopping disk
sd 2:0:0:0: [sdb] Start/Stop Unit failed: Result: hostbyte=DID_BAD_TARGET
	driverbyte=DRIVER_OK

Commit c312ef176399 dropped ahci_pci_reset_controller() which internally
calls ahci_reset_controller() and applies the PCS quirk if needed after
that. It was called each time a reset was required instead of just
ahci_reset_controller(). This patch puts the function back in place.

Fixes: c312ef176399 ("libata/ahci: Drop PCS quirk for Denverton and beyond")
Signed-off-by: Adam Vodopjan <grozzly@protonmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6f572967b555..4069c2a79daa 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -81,6 +81,7 @@ enum board_ids {
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void ahci_remove_one(struct pci_dev *dev);
 static void ahci_shutdown_one(struct pci_dev *dev);
+static void ahci_intel_pcs_quirk(struct pci_dev *pdev, struct ahci_host_priv *hpriv);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_avn_hardreset(struct ata_link *link, unsigned int *class,
@@ -639,6 +640,25 @@ static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 	ahci_save_initial_config(&pdev->dev, hpriv);
 }
 
+static int ahci_pci_reset_controller(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	int rc;
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		return rc;
+
+	/*
+	 * If platform firmware failed to enable ports, try to enable
+	 * them here.
+	 */
+	ahci_intel_pcs_quirk(pdev, hpriv);
+
+	return 0;
+}
+
 static void ahci_pci_init_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
@@ -841,7 +861,7 @@ static int ahci_pci_device_runtime_resume(struct device *dev)
 	struct ata_host *host = pci_get_drvdata(pdev);
 	int rc;
 
-	rc = ahci_reset_controller(host);
+	rc = ahci_pci_reset_controller(host);
 	if (rc)
 		return rc;
 	ahci_pci_init_controller(host);
@@ -876,7 +896,7 @@ static int ahci_pci_device_resume(struct device *dev)
 		ahci_mcp89_apple_enable(pdev);
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		rc = ahci_reset_controller(host);
+		rc = ahci_pci_reset_controller(host);
 		if (rc)
 			return rc;
 
@@ -1741,12 +1761,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
 
-	/*
-	 * If platform firmware failed to enable ports, try to enable
-	 * them here.
-	 */
-	ahci_intel_pcs_quirk(pdev, hpriv);
-
 	/* prepare host */
 	if (hpriv->cap & HOST_CAP_NCQ) {
 		pi.flags |= ATA_FLAG_NCQ;
@@ -1856,7 +1870,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = ahci_reset_controller(host);
+	rc = ahci_pci_reset_controller(host);
 	if (rc)
 		return rc;
 
-- 
2.35.1



