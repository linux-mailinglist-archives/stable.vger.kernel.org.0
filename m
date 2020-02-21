Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB64F1672C3
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbgBUIGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731672AbgBUIGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:06:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CE2720578;
        Fri, 21 Feb 2020 08:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272381;
        bh=hbhqy1VIf4rqPgX/t0HvXSAoqhLM+FaG+qBst9hGctM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8JkZe3bn9q80waY7U2W23BNPSpdm9lt75B/3My4eiirIu5hTSNkpvr1kRwZQVC3A
         v/o95izAxOyVuBUAlqZo6cYMT6N62fFF814dWTV9wTL753sZAdroh2YOeOFPXY5rKW
         Sd1oi/O07IVvOntlPVSq+Vty7rLT6eLqNUOLLJI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/344] PCI: Increase D3 delay for AMD Ryzen5/7 XHCI controllers
Date:   Fri, 21 Feb 2020 08:38:41 +0100
Message-Id: <20200221072359.953191170@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Drake <drake@endlessm.com>

[ Upstream commit 3030df209aa8cf831b9963829bd9f94900ee8032 ]

On Asus UX434DA (AMD Ryzen7 3700U) and Asus X512DK (AMD Ryzen5 3500U), the
XHCI controller fails to resume from runtime suspend or s2idle, and USB
becomes unusable from that point.

  xhci_hcd 0000:03:00.4: Refused to change power state, currently in D3
  xhci_hcd 0000:03:00.4: enabling device (0000 -> 0002)
  xhci_hcd 0000:03:00.4: WARN: xHC restore state timeout
  xhci_hcd 0000:03:00.4: PCI post-resume error -110!
  xhci_hcd 0000:03:00.4: HC died; cleaning up

During suspend, a transition to D3cold is attempted, however the affected
platforms do not seem to cut the power to the PCI device when in this
state, so the device stays in D3hot.

Upon resume, the D3hot-to-D0 transition is successful only if the D3 delay
is increased to 20ms. The transition failure does not appear to be
detectable as a CRS condition. Add a PCI quirk to increase the delay on the
affected hardware.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205587
Link: http://lkml.kernel.org/r/CAD8Lp47Vh69gQjROYG69=waJgL7hs1PwnLonL9+27S_TcRhixA@mail.gmail.com
Link: https://lore.kernel.org/r/20191127053836.31624-2-drake@endlessm.com
Signed-off-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5c863af9452ec..7b6df2d8d6cde 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1889,6 +1889,22 @@ static void quirk_radeon_pm(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6741, quirk_radeon_pm);
 
+/*
+ * Ryzen5/7 XHCI controllers fail upon resume from runtime suspend or s2idle.
+ * https://bugzilla.kernel.org/show_bug.cgi?id=205587
+ *
+ * The kernel attempts to transition these devices to D3cold, but that seems
+ * to be ineffective on the platforms in question; the PCI device appears to
+ * remain on in D3hot state. The D3hot-to-D0 transition then requires an
+ * extended delay in order to succeed.
+ */
+static void quirk_ryzen_xhci_d3hot(struct pci_dev *dev)
+{
+	quirk_d3hot_delay(dev, 20);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e0, quirk_ryzen_xhci_d3hot);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e1, quirk_ryzen_xhci_d3hot);
+
 #ifdef CONFIG_X86_IO_APIC
 static int dmi_disable_ioapicreroute(const struct dmi_system_id *d)
 {
-- 
2.20.1



