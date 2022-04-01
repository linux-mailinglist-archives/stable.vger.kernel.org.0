Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6BA4EF3E1
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349263AbiDAO4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351727AbiDAOtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:49:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63D62AD5C3;
        Fri,  1 Apr 2022 07:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 164A6B824D5;
        Fri,  1 Apr 2022 14:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3E8C2BBE4;
        Fri,  1 Apr 2022 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823976;
        bh=JhlCK4E1mu3yOPgCJV7utZ0/yQ80NcX7V3ZlF9qox6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7kjlmBRO7kIOhMZyJKOnT6iNyvIOxOdCR7LOytDZF2pTA1ajN/TjAjdMtIn+jEeR
         /foES2A1oWVgpm5GkRxJ0MxR6/4xVWTjaENWJbs4ROjnbf1Bix2woiBzqLVEDKlvMZ
         0uxRWalKz2nW6K+OcWFZb/miagX3YVxEv3aM7oCA+cm/95gsCTLFYymhYlrR1hJQcT
         QqASMh9omjYjzTLDVkPdh/Ihy9gEUQUethmXTOmglSyDeRIzncKGbPSfgoXHFjhok4
         oO5sQbKmx69PQ7pBRwSCBc6rbkKQwyMAd/enJSBH/DYUDKR0dC3Cl5Lf8wgIBTdChr
         Sg4kRPF5ZFemg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, lukas@wunner.de,
        zhangliguang@linux.alibaba.com, ameynarkhede03@gmail.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        naveennaidu479@gmail.com, mani@kernel.org, hdegoede@redhat.com,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 37/98] PCI: pciehp: Add Qualcomm quirk for Command Completed erratum
Date:   Fri,  1 Apr 2022 10:36:41 -0400
Message-Id: <20220401143742.1952163-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 9f72d4757cbe4d1ed669192f6d23817c9e437c4b ]

The Qualcomm PCI bridge device (Device ID 0x0110) found in chipsets such as
SM8450 does not set the Command Completed bit unless writes to the Slot
Command register change "Control" bits.

This results in timeouts like below:

  pcieport 0001:00:00.0: pciehp: Timeout on hotplug command 0x03c0 (issued 2020 msec ago)

Add the device to the Command Completed quirk to mark commands "completed"
immediately unless they change the "Control" bits.

Link: https://lore.kernel.org/r/20220210145003.135907-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index b0692f33b03a..2fb044bfaebe 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1058,6 +1058,8 @@ static void quirk_cmd_compl(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0110,
+			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0400,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0401,
-- 
2.34.1

