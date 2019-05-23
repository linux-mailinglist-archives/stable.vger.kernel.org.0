Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EC4288F2
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391545AbfEWT3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390192AbfEWT3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:29:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 052A820879;
        Thu, 23 May 2019 19:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639793;
        bh=vp3dV6KU5I8Ecj9+pNSDPdkRP5pMoMq3LJJQK1A4IZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAVA0jaMPSWNYPTnysEkkTM8PvClEfj/lJA+RHymSSkqvGWQfZ8lmuN6UUA226JCJ
         EL+tXPpX+tBlJYUDePIkeO3KcfEtAKBl3wq1UCUr6PqYhLdIYTiODlG0YGc5P1Z3yj
         2heCEHoOG56475iA6NIeplowzrRJQR1Cq5J1otCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolai Kostrigin <nickel@altlinux.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.1 094/122] PCI: Mark AMD Stoney Radeon R7 GPU ATS as broken
Date:   Thu, 23 May 2019 21:06:56 +0200
Message-Id: <20190523181717.581649950@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolai Kostrigin <nickel@altlinux.org>

commit d28ca864c493637f3c957f4ed9348a94fca6de60 upstream.

ATS is broken on the Radeon R7 GPU (at least for Stoney Ridge based laptop)
and causes IOMMU stalls and system failure.  Disable ATS on these devices
to make them usable again with IOMMU enabled.

Thanks to Joerg Roedel <jroedel@suse.de> for help.

[bhelgaas: In the email thread mentioned below, Alex suspects the real
problem is in sbios or iommu, so it may affect only certain systems, and it
may affect other devices in those systems as well.  However, per Joerg we
lack the ability to debug further, so this quirk is the best we can do for
now.]

Link: https://bugzilla.kernel.org/show_bug.cgi?id=194521
Link: https://lore.kernel.org/lkml/20190408103725.30426-1-nickel@altlinux.org
Fixes: 9b44b0b09dec ("PCI: Mark AMD Stoney GPU ATS as broken")
Signed-off-by: Nikolai Kostrigin <nickel@altlinux.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
CC: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4905,6 +4905,7 @@ static void quirk_no_ats(struct pci_dev
 
 /* AMD Stoney platform GPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x98e4, quirk_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6900, quirk_no_ats);
 #endif /* CONFIG_PCI_ATS */
 
 /* Freescale PCIe doesn't support MSI in RC mode */


