Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A17F1FE3B0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgFRBU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730418AbgFRBU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B6020776;
        Thu, 18 Jun 2020 01:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443256;
        bh=PN7vZoxSs59VEpACrp8hT5rx0yazfNPxZPl7VMzESdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQ42ibHk8eyBsCSxF0JRyUTk7mDn99la3vi+p0BcBHV5Vo3vUGNt10wVVA7Fd32B1
         f6lz/Ikfp2MjnyuU9c2895AIbAcKZ+299HTy6cEifkgysxNOtLkfns9h7RFUuX0kAD
         jPFdsEoHr2B4fxpAMXAz5JK2Uk0Ce6on8cHWFUKk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Buettner <kevinb@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 204/266] PCI: Avoid FLR for AMD Starship USB 3.0
Date:   Wed, 17 Jun 2020 21:15:29 -0400
Message-Id: <20200618011631.604574-204-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3f89ba7fe7fb..de999f636a5f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5134,6 +5134,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
  * FLR may cause the following to devices to hang:
  *
  * AMD Starship/Matisse HD Audio Controller 0x1487
+ * AMD Starship USB 3.0 Host Controller 0x148c
  * AMD Matisse USB 3.0 Host Controller 0x149c
  * Intel 82579LM Gigabit Ethernet Controller 0x1502
  * Intel 82579V Gigabit Ethernet Controller 0x1503
@@ -5144,6 +5145,7 @@ static void quirk_no_flr(struct pci_dev *dev)
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_FLR_RESET;
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
-- 
2.25.1

