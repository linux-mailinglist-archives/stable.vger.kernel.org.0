Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4046F68F5E
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388025AbfGOONw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388889AbfGOONv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:13:51 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8862D20651;
        Mon, 15 Jul 2019 14:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200029;
        bh=F0F2Q8KUGLU5KKPw844B94bWHqTSxq4X6WeqvKfZWDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8LQ5868JDN1qDcJ6vOppX73KRPP15XOtKhJKjabK6hH6VpzdbIxMPQPn4YwXAAx5
         wi0NrVIqxqa3ef0i6PSAoeXo74G2HvdkGHC6bBvNS9NgSwLCxAaVyVvCfa2Jvh5UE9
         SAx58nTAqkDPjZ2JCMb5jU0AwwJ91G5jyjQBxNIk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 163/219] PCI / ACPI: Use cached ACPI device state to get PCI device power state
Date:   Mon, 15 Jul 2019 10:02:44 -0400
Message-Id: <20190715140341.6443-163-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 83a16e3f6d70da99896c7a2639c0b60fff13afb8 ]

The ACPI power state returned by acpi_device_get_power() may depend on
the configuration of ACPI power resources in the system which may change
any time after acpi_device_get_power() has returned, unless the
reference counters of the ACPI power resources in question are set to
prevent that from happening. Thus it is invalid to use acpi_device_get_power()
in acpi_pci_get_power_state() the way it is done now and the value of
the ->power.state field in the corresponding struct acpi_device objects
(which reflects the ACPI power resources reference counting, among other
things) should be used instead.

As an example where this becomes an issue is Intel Ice Lake where the
Thunderbolt controller (NHI), two PCIe root ports (RP0 and RP1) and xHCI
all share the same power resources. The following picture with power
resources marked with [] shows the topology:

  Host bridge
    |
    +- RP0 ---\
    +- RP1 ---|--+--> [TBT]
    +- NHI --/   |
    |            |
    |            v
    +- xHCI --> [D3C]

Here TBT and D3C are the shared ACPI power resources. ACPI _PR3() method
of the devices in question returns either TBT or D3C or both.

Say we runtime suspend first the root ports RP0 and RP1, then NHI. Now
since the TBT power resource is still on when the root ports are runtime
suspended their dev->current_state is set to D3hot. When NHI is runtime
suspended TBT is finally turned off but state of the root ports remain
to be D3hot. Now when the xHCI is runtime suspended D3C gets also turned
off. PCI core thus has power states of these devices cached in their
dev->current_state as follows:

  RP0 -> D3hot
  RP1 -> D3hot
  NHI -> D3cold
  xHCI -> D3cold

If the user now runs lspci for instance, the result is all 1's like in
the below output (00:07.0 is the first root port, RP0):

00:07.0 PCI bridge: Intel Corporation Device 8a1d (rev ff) (prog-if ff)
    !!! Unknown header type 7f
    Kernel driver in use: pcieport

In short the hardware state is not in sync with the software state
anymore. The exact same thing happens with the PME polling thread which
ends up bringing the root ports back into D0 after they are runtime
suspended.

For this reason, modify acpi_pci_get_power_state() so that it uses the
ACPI device power state that was cached by the ACPI core. This makes the
PCI device power state match the ACPI device power state regardless of
state of the shared power resources which may still be on at this point.

Link: https://lore.kernel.org/r/20190618161858.77834-2-mika.westerberg@linux.intel.com
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-acpi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index bf32fde328c2..1591cd82bbc7 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -618,7 +618,8 @@ static pci_power_t acpi_pci_get_power_state(struct pci_dev *dev)
 	if (!adev || !acpi_device_power_manageable(adev))
 		return PCI_UNKNOWN;
 
-	if (acpi_device_get_power(adev, &state) || state == ACPI_STATE_UNKNOWN)
+	state = adev->power.state;
+	if (state == ACPI_STATE_UNKNOWN)
 		return PCI_UNKNOWN;
 
 	return state_conv[state];
-- 
2.20.1

