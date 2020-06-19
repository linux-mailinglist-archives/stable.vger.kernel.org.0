Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53770201715
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388771AbgFSQeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389047AbgFSOvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:51:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E1C206DB;
        Fri, 19 Jun 2020 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578275;
        bh=LKve3kRvNjn/XBpYeAq/fEYQEKfR38eu4arP2VpgTDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+RSOxJeUC/BQbVpc8GwiTuYA51snjK60bZU1k7QzZEtbgXQ2VtdjYv61KBaZzSGM
         g1EhExakX4WMuk78ILvMwt66omIyueg9e/j9ifADp/JPvckEU5oyZJzxuz4ChqKQrA
         QiU/nB1XcMjKVHRstKHMQBRe2ltg+nWART/4IRSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Buettner <kevinb@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 150/190] PCI: Avoid FLR for AMD Starship USB 3.0
Date:   Fri, 19 Jun 2020 16:33:15 +0200
Message-Id: <20200619141641.227065937@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
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
index 8d01c6d372fe..1bc7d4bcfea4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4873,6 +4873,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
  * FLR may cause the following to devices to hang:
  *
  * AMD Starship/Matisse HD Audio Controller 0x1487
+ * AMD Starship USB 3.0 Host Controller 0x148c
  * AMD Matisse USB 3.0 Host Controller 0x149c
  * Intel 82579LM Gigabit Ethernet Controller 0x1502
  * Intel 82579V Gigabit Ethernet Controller 0x1503
@@ -4883,6 +4884,7 @@ static void quirk_no_flr(struct pci_dev *dev)
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_FLR_RESET;
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
-- 
2.25.1



