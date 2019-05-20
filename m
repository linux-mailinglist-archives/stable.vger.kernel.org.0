Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 728542339A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbfETMSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387725AbfETMSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:18:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14E36208C3;
        Mon, 20 May 2019 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354716;
        bh=ofEIYAS8+rvPfYlANzMOn0TgjZ0h4w0AB+vYOudGgtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v81g+zm+KjoM2/7suwioOoBlqz3Wq8LidTX9hB5ALljZzPoRbAm3vA75mQAx9lQYU
         7SXOALMavJVq1jibTePGaMTqxWkzcxt548vnkNqqr4GdR8iVn3wmXhUZrtecrKCpuf
         uvb7X9v3tASC4DkVndpiCbtz8J2jKtWhFALUpAXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/63] PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if necessary
Date:   Mon, 20 May 2019 14:13:44 +0200
Message-Id: <20190520115231.834981202@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 340d455699400f2c2c0f9b3f703ade3085cdb501 ]

When we hot-remove a device, usually the host sends us a PCI_EJECT message,
and a PCI_BUS_RELATIONS message with bus_rel->device_count == 0.

When we execute the quick hot-add/hot-remove test, the host may not send
us the PCI_EJECT message if the guest has not fully finished the
initialization by sending the PCI_RESOURCES_ASSIGNED* message to the
host, so it's potentially unsafe to only depend on the
pci_destroy_slot() in hv_eject_device_work() because the code path

create_root_hv_pci_bus()
 -> hv_pci_assign_slots()

is not called in this case. Note: in this case, the host still sends the
guest a PCI_BUS_RELATIONS message with bus_rel->device_count == 0.

In the quick hot-add/hot-remove test, we can have such a race before
the code path

pci_devices_present_work()
 -> new_pcichild_device()

adds the new device into the hbus->children list, we may have already
received the PCI_EJECT message, and since the tasklet handler

hv_pci_onchannelcallback()

may fail to find the "hpdev" by calling

get_pcichild_wslot(hbus, dev_message->wslot.slot)

hv_pci_eject_device() is not called; Later, by continuing execution

create_root_hv_pci_bus()
 -> hv_pci_assign_slots()

creates the slot and the PCI_BUS_RELATIONS message with
bus_rel->device_count == 0 removes the device from hbus->children, and
we end up being unable to remove the slot in

hv_pci_remove()
 -> hv_pci_remove_slots()

Remove the slot in pci_devices_present_work() when the device
is removed to address this race.

pci_devices_present_work() and hv_eject_device_work() run in the
singled-threaded hbus->wq, so there is not a double-remove issue for the
slot.

We cannot offload hv_pci_eject_device() from hv_pci_onchannelcallback()
to the workqueue, because we need the hv_pci_onchannelcallback()
synchronously call hv_pci_eject_device() to poll the channel
ringbuffer to work around the "hangs in hv_compose_msi_msg()" issue
fixed in commit de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in
hv_compose_msi_msg()")

Fixes: a15f2c08c708 ("PCI: hv: support reporting serial number as slot information")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
[lorenzo.pieralisi@arm.com: rewritten commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pci-hyperv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
index a5825bbcded72..f591de23f3d35 100644
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -1824,6 +1824,10 @@ static void pci_devices_present_work(struct work_struct *work)
 		hpdev = list_first_entry(&removed, struct hv_pci_dev,
 					 list_entry);
 		list_del(&hpdev->list_entry);
+
+		if (hpdev->pci_slot)
+			pci_destroy_slot(hpdev->pci_slot);
+
 		put_pcichild(hpdev, hv_pcidev_ref_initial);
 	}
 
-- 
2.20.1



