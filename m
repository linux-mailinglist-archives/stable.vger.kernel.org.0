Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1BA37CB75
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242719AbhELQfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241285AbhELQ07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5AB461DD7;
        Wed, 12 May 2021 15:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834679;
        bh=lxXnl5IoWMDvtkRW2GWMDJoHirGPsZ8xUb2fS5WIxEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+BTKslImGz8bhXcRh/uxJAP827ktTjiHayOpdk9m5buMITnN0zjVhb39GvW25FO3
         RYqnvt2vxCHYgR2DYMDN+E6EvmeW7HHjbKTI+Rqv5gIeUfwrsqWG1IxLaGvYwnrCOm
         iDQPeq4N61VdRqdBuDBZ1PveoRUvN65CQbDBd6TA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.12 033/677] PCI: Allow VPD access for QLogic ISP2722
Date:   Wed, 12 May 2021 16:41:19 +0200
Message-Id: <20210512144838.320654444@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit e00dc69b5f17c444a38cd9745a0f76bc989b3af4 upstream.

0d5370d1d852 ("PCI: Prevent VPD access for QLogic ISP2722") disabled access
to VPD of the ISP2722-based 16/32Gb Fibre Channel to PCIe Adapter because
reading past the end of the VPD caused NMIs.

104daa71b396 ("PCI: Determine actual VPD size on first access") limits
reads to the actual size of VPD, which should prevent these NMIs.

104daa71b396 was merged *before* 0d5370d1d852, but we think the testing
that prompted 0d5370d1d852 ("PCI: Prevent VPD access for QLogic ISP2722")
was done with a kernel that lacked 104daa71b396.  See [1, 2].

Remove the quirk added by 0d5370d1d852 ("PCI: Prevent VPD access for QLogic
ISP2722") so customers can read the HBA VPD.

[1] https://lore.kernel.org/linux-pci/alpine.LRH.2.21.9999.2012161641230.28924@irv1user01.caveonetworks.com/
[2] https://lore.kernel.org/linux-pci/alpine.LRH.2.21.9999.2104071535110.13940@irv1user01.caveonetworks.com/
[bhelgaas: commit log]
Link: https://lore.kernel.org/r/20210409215153.16569-2-aeasi@marvell.com
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org      # v4.6+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/vpd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -570,7 +570,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LS
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LSI_LOGIC, 0x005f, quirk_blacklist_vpd);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, PCI_ANY_ID,
 		quirk_blacklist_vpd);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_QLOGIC, 0x2261, quirk_blacklist_vpd);
 /*
  * The Amazon Annapurna Labs 0x0031 device id is reused for other non Root Port
  * device types, so the quirk is registered for the PCI_CLASS_BRIDGE_PCI class.


