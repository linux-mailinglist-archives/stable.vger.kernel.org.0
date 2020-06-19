Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFF120114B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391716AbgFSPjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393602AbgFSP2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782AD21924;
        Fri, 19 Jun 2020 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580532;
        bh=WZMaHur++RhpkhRGztBlS0TjHQSd7jczDBuY8HGaB+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1m1umflEpd0k1zAC5ZAq8TyDdZNgO12DTdrLdcpLwOsUmNZC5N0ySJqWynfQPvOR
         Z57l99YZhItp+QawQZKKZkv187Gtw9PlJrRh8Ix1hsKvV6NioGrDN7EkGMXplapiW1
         KzXXZ6f3L7H7mTokLeIwNmulUA2Z86ugwj8cvI/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Buettner <kevinb@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 286/376] PCI: Avoid FLR for AMD Starship USB 3.0
Date:   Fri, 19 Jun 2020 16:33:24 +0200
Message-Id: <20200619141723.869731037@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Buettner <kevinb@redhat.com>

[ Upstream commit 5727043c73fdfe04597971b5f3f4850d879c1f4f ]

The AMD Starship USB 3.0 host controller advertises Function Level Reset
support, but it apparently doesn't work.  Add a quirk to prevent use of FLR
on this device.

Without this quirk, when attempting to assign (pass through) an AMD
Starship USB 3.0 host controller to a guest OS, the system becomes
increasingly unresponsive over the course of several minutes, eventually
requiring a hard reset.  Shortly after attempting to start the guest, I see
these messages:

  vfio-pci 0000:05:00.3: not ready 1023ms after FLR; waiting
  vfio-pci 0000:05:00.3: not ready 2047ms after FLR; waiting
  vfio-pci 0000:05:00.3: not ready 4095ms after FLR; waiting
  vfio-pci 0000:05:00.3: not ready 8191ms after FLR; waiting

And then eventually:

  vfio-pci 0000:05:00.3: not ready 65535ms after FLR; giving up
  INFO: NMI handler (perf_event_nmi_handler) took too long to run: 0.000 msecs
  perf: interrupt took too long (642744 > 2500), lowering kernel.perf_event_max_sample_rate to 1000
  INFO: NMI handler (perf_event_nmi_handler) took too long to run: 82.270 msecs
  INFO: NMI handler (perf_event_nmi_handler) took too long to run: 680.608 msecs
  INFO: NMI handler (perf_event_nmi_handler) took too long to run: 100.952 msecs
  ...
  watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [qemu-system-x86:7487]

Tested on a Micro-Star International Co., Ltd. MS-7C59/Creator TRX40
motherboard with an AMD Ryzen Threadripper 3970X.

Link: https://lore.kernel.org/r/20200524003529.598434ff@f31-4.lan
Signed-off-by: Kevin Buettner <kevinb@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9d00ecb1f5b5..226a4c5b2b7a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5133,6 +5133,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
  * FLR may cause the following to devices to hang:
  *
  * AMD Starship/Matisse HD Audio Controller 0x1487
+ * AMD Starship USB 3.0 Host Controller 0x148c
  * AMD Matisse USB 3.0 Host Controller 0x149c
  * Intel 82579LM Gigabit Ethernet Controller 0x1502
  * Intel 82579V Gigabit Ethernet Controller 0x1503
@@ -5143,6 +5144,7 @@ static void quirk_no_flr(struct pci_dev *dev)
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_FLR_RESET;
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
-- 
2.25.1



