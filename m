Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760884EF488
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348247AbiDAOv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348897AbiDAOpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:45:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D360B2963FA;
        Fri,  1 Apr 2022 07:35:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A049B824D8;
        Fri,  1 Apr 2022 14:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B4AC3410F;
        Fri,  1 Apr 2022 14:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823705;
        bh=dWrtl0p3lfTQeyzneUChNj+TkxqwMqD0fFCZ2g8vvJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS57cKcW+qWptlghJJX9e07CfrY7+yIWpQiodzXU5E30GXLM/fm1QO8PkfpUSc3YV
         QmOXap3mLwktKelkiCurmgTe3XBAkoU2SYBCbKjD7dLwzhRwh5rLqpgLITtwvgwUIf
         N8BxX6dLMZe2fEcolY5Cw29ITnj1sosyR0pEtjGI/CynVtLXjlVfHxRmMQ4/0JMsAz
         ztJ0fpOno2BRjq5O6ijUPXmcUInkszwYcX9FIEDuy9/xixtcwHMMyR0jwHT9DtLAEo
         FU0HyaBVqSWAp1v/N8REUYzAtcTccQoLstABMbduHXIJE/lCCml08ElzP+rVO+82R9
         4+dJRYCCELyPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, lukas@wunner.de,
        zhangliguang@linux.alibaba.com, mani@kernel.org,
        hdegoede@redhat.com, ameynarkhede03@gmail.com,
        naveennaidu479@gmail.com, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 045/109] PCI: pciehp: Add Qualcomm quirk for Command Completed erratum
Date:   Fri,  1 Apr 2022 10:31:52 -0400
Message-Id: <20220401143256.1950537-45-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
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
index 1d3108e6c128..dd6236ffa2fd 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1084,6 +1084,8 @@ static void quirk_cmd_compl(struct pci_dev *pdev)
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

