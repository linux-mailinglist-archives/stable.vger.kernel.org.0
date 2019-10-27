Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B0AE6903
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfJ0VMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbfJ0VMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B6E20873;
        Sun, 27 Oct 2019 21:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210721;
        bh=Vs217nyuX17JcZ6U8pDY5uQaLoKbNfvaliz945kexRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpAcUycoWeuGRdI6+W/oGlZR0LWRqpvuNd55LSrLJMO0pxzsfk3NpCijBmQvIj1M1
         WyYdrOOWvP+KhifB3i9wrBCaq9nVuWEgQBy1tv0SdrsRLzgOa4EWukBs/Sd1pO6Hbc
         UORCpq80lOVrx0emAYjUZvQ/KTNy178XXhI98yVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.14 114/119] PCI: PM: Fix pci_power_up()
Date:   Sun, 27 Oct 2019 22:01:31 +0100
Message-Id: <20191027203349.766791277@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 45144d42f299455911cc29366656c7324a3a7c97 upstream.

There is an arbitrary difference between the system resume and
runtime resume code paths for PCI devices regarding the delay to
apply when switching the devices from D3cold to D0.

Namely, pci_restore_standard_config() used in the runtime resume
code path calls pci_set_power_state() which in turn invokes
__pci_start_power_transition() to power up the device through the
platform firmware and that function applies the transition delay
(as per PCI Express Base Specification Revision 2.0, Section 6.6.1).
However, pci_pm_default_resume_early() used in the system resume
code path calls pci_power_up() which doesn't apply the delay at
all and that causes issues to occur during resume from
suspend-to-idle on some systems where the delay is required.

Since there is no reason for that difference to exist, modify
pci_power_up() to follow pci_set_power_state() more closely and
invoke __pci_start_power_transition() from there to call the
platform firmware to power up the device (in case that's necessary).

Fixes: db288c9c5f9d ("PCI / PM: restore the original behavior of pci_set_power_state()")
Reported-by: Daniel Drake <drake@endlessm.com>
Tested-by: Daniel Drake <drake@endlessm.com>
Link: https://lore.kernel.org/linux-pm/CAD8Lp44TYxrMgPLkHCqF9hv6smEurMXvmmvmtyFhZ6Q4SE+dig@mail.gmail.com/T/#m21be74af263c6a34f36e0fc5c77c5449d9406925
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -749,19 +749,6 @@ void pci_update_current_state(struct pci
 }
 
 /**
- * pci_power_up - Put the given device into D0 forcibly
- * @dev: PCI device to power up
- */
-void pci_power_up(struct pci_dev *dev)
-{
-	if (platform_pci_power_manageable(dev))
-		platform_pci_set_power_state(dev, PCI_D0);
-
-	pci_raw_set_power_state(dev, PCI_D0);
-	pci_update_current_state(dev, PCI_D0);
-}
-
-/**
  * pci_platform_power_transition - Use platform to change device power state
  * @dev: PCI device to handle.
  * @state: State to put the device into.
@@ -940,6 +927,17 @@ int pci_set_power_state(struct pci_dev *
 EXPORT_SYMBOL(pci_set_power_state);
 
 /**
+ * pci_power_up - Put the given device into D0 forcibly
+ * @dev: PCI device to power up
+ */
+void pci_power_up(struct pci_dev *dev)
+{
+	__pci_start_power_transition(dev, PCI_D0);
+	pci_raw_set_power_state(dev, PCI_D0);
+	pci_update_current_state(dev, PCI_D0);
+}
+
+/**
  * pci_choose_state - Choose the power state of a PCI device
  * @dev: PCI device to be suspended
  * @state: target sleep state for the whole system. This is the value


