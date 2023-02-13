Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC766948B9
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjBMOw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBMOw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:52:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F721C5A9
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5051B61134
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6432EC4339B;
        Mon, 13 Feb 2023 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676299960;
        bh=Yw2x4RvIKzQSRclV1sDxpZn61rbZ/jQVrZ2/2aWWzAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViwmRHpahICJqMHEM9TYWZ8/qLP0j5VvgnHOVEZ5g1vXhQAAx8m2z+boQSID9jVCd
         aKPLJMLM6Q/tQcHcKShviyt/CzMTjpAgLGE4ErxAnatixsknIKRYG8LkuAFb+Ix9zF
         d3m4LW/Zz/lpDAbxxrHFjznksueUVL4OrZCllz1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tasev Nikola <tasev.stefanoska@skynet.be>,
        Mark Enriquez <enriquezmark36@gmail.com>,
        Thomas Witt <kernel@witt.link>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH 6.1 010/114] Revert "PCI/ASPM: Save L1 PM Substates Capability for suspend/resume"
Date:   Mon, 13 Feb 2023 15:47:25 +0100
Message-Id: <20230213144742.726116979@linuxfoundation.org>
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

commit a7152be79b627428c628da2a887ca4b2512a78fd upstream.

This reverts commit 4ff116d0d5fd8a025604b0802d93a2d5f4e465d1.

Tasev Nikola and Mark Enriquez reported that resume from suspend was broken
in v6.1-rc1.  Tasev bisected to a47126ec29f5 ("PCI/PTM: Cache PTM
Capability offset"), but we can't figure out how that could be related.

Mark saw the same symptoms and bisected to 4ff116d0d5fd ("PCI/ASPM: Save L1
PM Substates Capability for suspend/resume"), which does have a connection:
it restores L1 Substates configuration while ASPM L1 may be enabled:

  pci_restore_state
    pci_restore_aspm_l1ss_state
      aspm_program_l1ss
        pci_write_config_dword(PCI_L1SS_CTL1, ctl1)         # L1SS restore
    pci_restore_pcie_state
      pcie_capability_write_word(PCI_EXP_LNKCTL, cap[i++])  # L1 restore

which is a problem because PCIe r6.0, sec 5.5.4, requires that:

  If setting either or both of the enable bits for ASPM L1 PM
  Substates, both ports must be configured as described in this
  section while ASPM L1 is disabled.

Separately, Thomas Witt reported that 5e85eba6f50d ("PCI/ASPM: Refactor L1
PM Substates Control Register programming") broke suspend/resume, and it
depends on 4ff116d0d5fd.

Revert 4ff116d0d5fd ("PCI/ASPM: Save L1 PM Substates Capability for
suspend/resume") to fix the resume issue and enable revert of 5e85eba6f50d
to fix the issue Thomas reported.

Note that reverting 4ff116d0d5fd means L1 Substates config may be lost on
suspend/resume.  As far as we know the system will use more power but will
still *work* correctly.

Fixes: 4ff116d0d5fd ("PCI/ASPM: Save L1 PM Substates Capability for suspend/resume")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216782
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216877
Reported-by: Tasev Nikola <tasev.stefanoska@skynet.be>
Reported-by: Mark Enriquez <enriquezmark36@gmail.com>
Reported-by: Thomas Witt <kernel@witt.link>
Tested-by: Mark Enriquez <enriquezmark36@gmail.com>
Tested-by: Thomas Witt <kernel@witt.link>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v6.1+
Cc: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c       |    7 -------
 drivers/pci/pci.h       |    4 ----
 drivers/pci/pcie/aspm.c |   37 -------------------------------------
 3 files changed, 48 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1665,7 +1665,6 @@ int pci_save_state(struct pci_dev *dev)
 		return i;
 
 	pci_save_ltr_state(dev);
-	pci_save_aspm_l1ss_state(dev);
 	pci_save_dpc_state(dev);
 	pci_save_aer_state(dev);
 	pci_save_ptm_state(dev);
@@ -1772,7 +1771,6 @@ void pci_restore_state(struct pci_dev *d
 	 * LTR itself (in the PCIe capability).
 	 */
 	pci_restore_ltr_state(dev);
-	pci_restore_aspm_l1ss_state(dev);
 
 	pci_restore_pcie_state(dev);
 	pci_restore_pasid_state(dev);
@@ -3465,11 +3463,6 @@ void pci_allocate_cap_save_buffers(struc
 	if (error)
 		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
 
-	error = pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_L1SS,
-					    2 * sizeof(u32));
-	if (error)
-		pci_err(dev, "unable to allocate suspend buffer for ASPM-L1SS\n");
-
 	pci_allocate_vc_save_buffers(dev);
 }
 
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -565,14 +565,10 @@ bool pcie_wait_for_link(struct pci_dev *
 void pcie_aspm_init_link_state(struct pci_dev *pdev);
 void pcie_aspm_exit_link_state(struct pci_dev *pdev);
 void pcie_aspm_powersave_config_link(struct pci_dev *pdev);
-void pci_save_aspm_l1ss_state(struct pci_dev *dev);
-void pci_restore_aspm_l1ss_state(struct pci_dev *dev);
 #else
 static inline void pcie_aspm_init_link_state(struct pci_dev *pdev) { }
 static inline void pcie_aspm_exit_link_state(struct pci_dev *pdev) { }
 static inline void pcie_aspm_powersave_config_link(struct pci_dev *pdev) { }
-static inline void pci_save_aspm_l1ss_state(struct pci_dev *dev) { }
-static inline void pci_restore_aspm_l1ss_state(struct pci_dev *dev) { }
 #endif
 
 #ifdef CONFIG_PCIE_ECRC
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -757,43 +757,6 @@ static void pcie_config_aspm_l1ss(struct
 				PCI_L1SS_CTL1_L1SS_MASK, val);
 }
 
-void pci_save_aspm_l1ss_state(struct pci_dev *dev)
-{
-	struct pci_cap_saved_state *save_state;
-	u16 l1ss = dev->l1ss;
-	u32 *cap;
-
-	if (!l1ss)
-		return;
-
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_L1SS);
-	if (!save_state)
-		return;
-
-	cap = (u32 *)&save_state->cap.data[0];
-	pci_read_config_dword(dev, l1ss + PCI_L1SS_CTL2, cap++);
-	pci_read_config_dword(dev, l1ss + PCI_L1SS_CTL1, cap++);
-}
-
-void pci_restore_aspm_l1ss_state(struct pci_dev *dev)
-{
-	struct pci_cap_saved_state *save_state;
-	u32 *cap, ctl1, ctl2;
-	u16 l1ss = dev->l1ss;
-
-	if (!l1ss)
-		return;
-
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_L1SS);
-	if (!save_state)
-		return;
-
-	cap = (u32 *)&save_state->cap.data[0];
-	ctl2 = *cap++;
-	ctl1 = *cap;
-	aspm_program_l1ss(dev, ctl1, ctl2);
-}
-
 static void pcie_config_aspm_dev(struct pci_dev *pdev, u32 val)
 {
 	pcie_capability_clear_and_set_word(pdev, PCI_EXP_LNKCTL,


