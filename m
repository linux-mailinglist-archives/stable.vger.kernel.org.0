Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368C24F3856
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359777AbiDELUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349076AbiDEJtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BF5A994E;
        Tue,  5 Apr 2022 02:40:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2957D61368;
        Tue,  5 Apr 2022 09:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C3AC385A3;
        Tue,  5 Apr 2022 09:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151609;
        bh=FGZclYLihe2uY2gGNy483xxhj8gpzginQPKgkKu7Nd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIEhWGJvVnYxaweWiA+OAbNAPcD5fSP3pMDxKRm0vq85s01SAuEH7fBUzaR/adCDy
         mVNhsDlBkib5MzBewzrtWKSX7nb4XR5bVMdLbJNAnVgd2NPBYghqmzCd/AXQHv+bE9
         /I1SXG/9yasH2LnFPgOKBT6MSZPdNUdoN35OERmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Sahu <abhsahu@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/913] vfio/pci: fix memory leak during D3hot to D0 transition
Date:   Tue,  5 Apr 2022 09:25:39 +0200
Message-Id: <20220405070354.153175102@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Abhishek Sahu <abhsahu@nvidia.com>

[ Upstream commit eadf88ecf6ac7d6a9f47a76c6055d9a1987a8991 ]

If 'vfio_pci_core_device::needs_pm_restore' is set (PCI device does
not have No_Soft_Reset bit set in its PMCSR config register), then
the current PCI state will be saved locally in
'vfio_pci_core_device::pm_save' during D0->D3hot transition and same
will be restored back during D3hot->D0 transition.
For saving the PCI state locally, pci_store_saved_state() is being
used and the pci_load_and_free_saved_state() will free the allocated
memory.

But for reset related IOCTLs, vfio driver calls PCI reset-related
API's which will internally change the PCI power state back to D0. So,
when the guest resumes, then it will get the current state as D0 and it
will skip the call to vfio_pci_set_power_state() for changing the
power state to D0 explicitly. In this case, the memory pointed by
'pm_save' will never be freed. In a malicious sequence, the state changing
to D3hot followed by VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be
run in a loop and it can cause an OOM situation.

This patch frees the earlier allocated memory first before overwriting
'pm_save' to prevent the mentioned memory leak.

Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
Link: https://lore.kernel.org/r/20220217122107.22434-2-abhsahu@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a03b5a99c2da..0c63091cc848 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -228,6 +228,19 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	if (!ret) {
 		/* D3 might be unsupported via quirk, skip unless in D3 */
 		if (needs_save && pdev->current_state >= PCI_D3hot) {
+			/*
+			 * The current PCI state will be saved locally in
+			 * 'pm_save' during the D3hot transition. When the
+			 * device state is changed to D0 again with the current
+			 * function, then pci_store_saved_state() will restore
+			 * the state and will free the memory pointed by
+			 * 'pm_save'. There are few cases where the PCI power
+			 * state can be changed to D0 without the involvement
+			 * of the driver. For these cases, free the earlier
+			 * allocated memory first before overwriting 'pm_save'
+			 * to prevent the memory leak.
+			 */
+			kfree(vdev->pm_save);
 			vdev->pm_save = pci_store_saved_state(pdev);
 		} else if (needs_restore) {
 			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
-- 
2.34.1



