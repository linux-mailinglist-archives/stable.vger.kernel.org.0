Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C5B6E643E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjDRMrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjDRMrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:47:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AED98
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:47:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8F09633C3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8B4C433D2;
        Tue, 18 Apr 2023 12:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822043;
        bh=N+4i+yZYMRbWxZzRVTcYVu7G1SPVlXOuYNmOjLBduZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqmUo0nM1Kq6Cp3ytU+P3iAQCXwtVMMTtyAN2f7QOkokfKhFYMR2aYndU4nPNjtaQ
         7JsiTwKf59WCY9T8BPGkYOLG9SM/fr6ZM/KTi0yOedU4Tt9wHW2jVRI7XBlmHHxE4y
         3kauHUg+0gdslqn2zt0XG5IzADctWELiN42cOAbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Glanzmann <thomas@glanzmann.de>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 110/134] x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot
Date:   Tue, 18 Apr 2023 14:22:46 +0200
Message-Id: <20230418120317.030192692@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit f195fc1e9715ba826c3b62d58038f760f66a4fe9 upstream.

The AMD [1022:15b8] USB controller loses some internal functional MSI-X
context when transitioning from D0 to D3hot. BIOS normally traps D0->D3hot
and D3hot->D0 transitions so it can save and restore that internal context,
but some firmware in the field can't do this because it fails to clear the
AMD_15B8_RCC_DEV2_EPF0_STRAP2 NO_SOFT_RESET bit.

Clear AMD_15B8_RCC_DEV2_EPF0_STRAP2 NO_SOFT_RESET bit before USB controller
initialization during boot.

Link: https://lore.kernel.org/linux-usb/Y%2Fz9GdHjPyF2rNG3@glanzmann.de/T/#u
Link: https://lore.kernel.org/r/20230329172859.699743-1-Basavaraj.Natikar@amd.com
Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Tested-by: Thomas Glanzmann <thomas@glanzmann.de>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/fixup.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -7,6 +7,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/vgaarb.h>
+#include <asm/amd_nb.h>
 #include <asm/hpet.h>
 #include <asm/pci_x86.h>
 
@@ -824,3 +825,23 @@ static void rs690_fix_64bit_dma(struct p
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7910, rs690_fix_64bit_dma);
 
 #endif
+
+#ifdef CONFIG_AMD_NB
+
+#define AMD_15B8_RCC_DEV2_EPF0_STRAP2                                  0x10136008
+#define AMD_15B8_RCC_DEV2_EPF0_STRAP2_NO_SOFT_RESET_DEV2_F0_MASK       0x00000080L
+
+static void quirk_clear_strap_no_soft_reset_dev2_f0(struct pci_dev *dev)
+{
+	u32 data;
+
+	if (!amd_smn_read(0, AMD_15B8_RCC_DEV2_EPF0_STRAP2, &data)) {
+		data &= ~AMD_15B8_RCC_DEV2_EPF0_STRAP2_NO_SOFT_RESET_DEV2_F0_MASK;
+		if (amd_smn_write(0, AMD_15B8_RCC_DEV2_EPF0_STRAP2, data))
+			pci_err(dev, "Failed to write data 0x%x\n", data);
+	} else {
+		pci_err(dev, "Failed to read data\n");
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15b8, quirk_clear_strap_no_soft_reset_dev2_f0);
+#endif


