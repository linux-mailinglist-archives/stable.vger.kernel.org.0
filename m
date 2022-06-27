Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E613955E25D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbiF0L0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiF0L0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:26:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD49965C3;
        Mon, 27 Jun 2022 04:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EFBF61456;
        Mon, 27 Jun 2022 11:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E353C36AE2;
        Mon, 27 Jun 2022 11:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329151;
        bh=2CawkonEHZcFllPVwI2kBu3fA1mCMShdp09CEgSJfus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXjGgIcve4Vb3SZ+VymCT4pjeFZsdLOzU88+aRLfGx/WOGymLFDUCPmo4VruUtZQo
         EnS9n5o+xt18dJewrZRvkxzIf8Ta1MCoVCXaEMcJi3vn/8rOdf8oKoX1G5ZNTMh4mi
         zeh7MsR2ib6sJPWX3a3wBUWZVLzsvssWy7zIv9y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Tanveer Alam <tanveer1.alam@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 067/102] xhci-pci: Allow host runtime PM as default for Intel Raptor Lake xHCI
Date:   Mon, 27 Jun 2022 13:21:18 +0200
Message-Id: <20220627111935.458819907@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanveer Alam <tanveer1.alam@intel.com>

commit 7516da47a349e74de623243a27f9b8a91446bf4f upstream.

In the same way as Intel Alder Lake TCSS (Type-C Subsystem) the Raptor
Lake TCSS xHCI needs to be runtime suspended whenever possible to
allow the TCSS hardware block to enter D3cold and thus save energy.

Cc: stable@kernel.org
Signed-off-by: Tanveer Alam <tanveer1.alam@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220623111945.1557702-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -61,6 +61,7 @@
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI		0x464e
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI	0x51ed
+#define PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI		0xa71e
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -265,7 +266,8 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&


