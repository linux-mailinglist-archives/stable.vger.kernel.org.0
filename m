Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3CE6948BB
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBMOw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBMOw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:52:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EC330E0
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:52:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D81716113E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF806C4339C;
        Mon, 13 Feb 2023 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676299963;
        bh=PBg7dbbU/kcCI7GVs9RhQ0En8UkpKZGqodV3wZIDA6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NN9m1n5GL8Q0PCjE6bJHI5AljC6uz3L8Ny65PA1QCa2uxLw076QfH0EbjHgc7tyoi
         b9F+3TYNAQ4adJwfrqhIF7SkIIbQW5zMxPITENQuXYfDZ7jJanLj5bEA7h/mxBhvZX
         K66gWEDVZV1uYY+sriYOVFCZ4lW7Loc6QmLvrB/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Witt <kernel@witt.link>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH 6.1 011/114] Revert "PCI/ASPM: Refactor L1 PM Substates Control Register programming"
Date:   Mon, 13 Feb 2023 15:47:26 +0100
Message-Id: <20230213144742.780518015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

commit ff209ecc376a2ea8dd106a1f594427a5d94b7dd3 upstream.

This reverts commit 5e85eba6f50dc288c22083a7e213152bcc4b8208.

Thomas Witt reported that 5e85eba6f50d ("PCI/ASPM: Refactor L1 PM Substates
Control Register programming") broke suspend/resume on a Tuxedo
Infinitybook S 14 v5, which seems to use a Clevo L140CU Mainboard.

The main symptom is:

  iwlwifi 0000:02:00.0: Unable to change power state from D3hot to D0, device inaccessible
  nvme 0000:03:00.0: Unable to change power state from D3hot to D0, device inaccessible

and the machine is only partially usable after resume.  It can't run dmesg
and can't do a clean reboot.  This happens on every suspend/resume cycle.

Revert 5e85eba6f50d until we can figure out the root cause.

Fixes: 5e85eba6f50d ("PCI/ASPM: Refactor L1 PM Substates Control Register programming")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216877
Reported-by: Thomas Witt <kernel@witt.link>
Tested-by: Thomas Witt <kernel@witt.link>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v6.1+
Cc: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aspm.c | 74 +++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 915cbd939dd9..4b4184563a92 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -470,31 +470,6 @@ static void pci_clear_and_set_dword(struct pci_dev *pdev, int pos,
 	pci_write_config_dword(pdev, pos, val);
 }
 
-static void aspm_program_l1ss(struct pci_dev *dev, u32 ctl1, u32 ctl2)
-{
-	u16 l1ss = dev->l1ss;
-	u32 l1_2_enable;
-
-	/*
-	 * Per PCIe r6.0, sec 5.5.4, T_POWER_ON in PCI_L1SS_CTL2 must be
-	 * programmed prior to setting the L1.2 enable bits in PCI_L1SS_CTL1.
-	 */
-	pci_write_config_dword(dev, l1ss + PCI_L1SS_CTL2, ctl2);
-
-	/*
-	 * In addition, Common_Mode_Restore_Time and LTR_L1.2_THRESHOLD in
-	 * PCI_L1SS_CTL1 must be programmed *before* setting the L1.2
-	 * enable bits, even though they're all in PCI_L1SS_CTL1.
-	 */
-	l1_2_enable = ctl1 & PCI_L1SS_CTL1_L1_2_MASK;
-	ctl1 &= ~PCI_L1SS_CTL1_L1_2_MASK;
-
-	pci_write_config_dword(dev, l1ss + PCI_L1SS_CTL1, ctl1);
-	if (l1_2_enable)
-		pci_write_config_dword(dev, l1ss + PCI_L1SS_CTL1,
-				       ctl1 | l1_2_enable);
-}
-
 /* Calculate L1.2 PM substate timing parameters */
 static void aspm_calc_l1ss_info(struct pcie_link_state *link,
 				u32 parent_l1ss_cap, u32 child_l1ss_cap)
@@ -504,6 +479,7 @@ static void aspm_calc_l1ss_info(struct pcie_link_state *link,
 	u32 t_common_mode, t_power_on, l1_2_threshold, scale, value;
 	u32 ctl1 = 0, ctl2 = 0;
 	u32 pctl1, pctl2, cctl1, cctl2;
+	u32 pl1_2_enables, cl1_2_enables;
 
 	if (!(link->aspm_support & ASPM_STATE_L1_2_MASK))
 		return;
@@ -552,21 +528,39 @@ static void aspm_calc_l1ss_info(struct pcie_link_state *link,
 	    ctl2 == pctl2 && ctl2 == cctl2)
 		return;
 
-	pctl1 &= ~(PCI_L1SS_CTL1_CM_RESTORE_TIME |
-		   PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
-		   PCI_L1SS_CTL1_LTR_L12_TH_SCALE);
-	pctl1 |= (ctl1 & (PCI_L1SS_CTL1_CM_RESTORE_TIME |
-			  PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
-			  PCI_L1SS_CTL1_LTR_L12_TH_SCALE));
-	aspm_program_l1ss(parent, pctl1, ctl2);
-
-	cctl1 &= ~(PCI_L1SS_CTL1_CM_RESTORE_TIME |
-		   PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
-		   PCI_L1SS_CTL1_LTR_L12_TH_SCALE);
-	cctl1 |= (ctl1 & (PCI_L1SS_CTL1_CM_RESTORE_TIME |
-			  PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
-			  PCI_L1SS_CTL1_LTR_L12_TH_SCALE));
-	aspm_program_l1ss(child, cctl1, ctl2);
+	/* Disable L1.2 while updating.  See PCIe r5.0, sec 5.5.4, 7.8.3.3 */
+	pl1_2_enables = pctl1 & PCI_L1SS_CTL1_L1_2_MASK;
+	cl1_2_enables = cctl1 & PCI_L1SS_CTL1_L1_2_MASK;
+
+	if (pl1_2_enables || cl1_2_enables) {
+		pci_clear_and_set_dword(child, child->l1ss + PCI_L1SS_CTL1,
+					PCI_L1SS_CTL1_L1_2_MASK, 0);
+		pci_clear_and_set_dword(parent, parent->l1ss + PCI_L1SS_CTL1,
+					PCI_L1SS_CTL1_L1_2_MASK, 0);
+	}
+
+	/* Program T_POWER_ON times in both ports */
+	pci_write_config_dword(parent, parent->l1ss + PCI_L1SS_CTL2, ctl2);
+	pci_write_config_dword(child, child->l1ss + PCI_L1SS_CTL2, ctl2);
+
+	/* Program Common_Mode_Restore_Time in upstream device */
+	pci_clear_and_set_dword(parent, parent->l1ss + PCI_L1SS_CTL1,
+				PCI_L1SS_CTL1_CM_RESTORE_TIME, ctl1);
+
+	/* Program LTR_L1.2_THRESHOLD time in both ports */
+	pci_clear_and_set_dword(parent,	parent->l1ss + PCI_L1SS_CTL1,
+				PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
+				PCI_L1SS_CTL1_LTR_L12_TH_SCALE, ctl1);
+	pci_clear_and_set_dword(child, child->l1ss + PCI_L1SS_CTL1,
+				PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
+				PCI_L1SS_CTL1_LTR_L12_TH_SCALE, ctl1);
+
+	if (pl1_2_enables || cl1_2_enables) {
+		pci_clear_and_set_dword(parent, parent->l1ss + PCI_L1SS_CTL1, 0,
+					pl1_2_enables);
+		pci_clear_and_set_dword(child, child->l1ss + PCI_L1SS_CTL1, 0,
+					cl1_2_enables);
+	}
 }
 
 static void aspm_l1ss_init(struct pcie_link_state *link)
-- 
2.39.1



