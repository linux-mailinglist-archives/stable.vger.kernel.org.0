Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC151EA3B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 10:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfEOIfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 04:35:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54055 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbfEOIfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 04:35:39 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 766E32593A;
        Wed, 15 May 2019 04:35:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 15 May 2019 04:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=j4nY2f
        Epi390QO/JwjHppZgea+x+H25bNMYGC0vipjE=; b=49HNtzRbjuqUt3SoUbA/YV
        J027+5oDm0vvefkI9LK0DGOpn+sScj8mNW2eTqgybUWWS6J75OcXcZijbvpkyspe
        qvuVJdCWEM6QollhYayd17c8e28cLOFPgNlpS3vwzo/AzzffsfOK0RKEgsCUjF+A
        oZtVG6Gjk1CzQJaIAEE2VxRnjrRecs/SY9xYyVcgq+F1mm7fuVWl2P9ucJh2K5qu
        qiDbGgfMSCi0WNnzcmx0GY1iponS2ksDRTnVf00blGTNxTa4RsMl3bZ18mqTSLST
        1Ry4bcXzltSk3gA7OABAE7/HSM0jKQEwufs0eCP1NTRXn3Z7nkVsPNaNXQpIa7Og
        ==
X-ME-Sender: <xms:Ws_bXFTkzufhaZeshW_HQIZxd4rCOig6Mf_nwNfFJVXWEuUY0I02rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleekgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Ws_bXLGcVat64ev1Jp_0mI8IyjY4c1B25_sm0aSvFG4cLzPFPpZc4w>
    <xmx:Ws_bXNnGZd4cNSt3DEHH1JzdQ9TzoqkNORo4lYn16LSt9xZ-Si8uDg>
    <xmx:Ws_bXO0_nHg8wtlLCgAMfl8a3JwVqCuftgcmf5lbtkHgud86Hg430A>
    <xmx:Ws_bXDx3BH9w42yy51_3GqShssKmmewXPmcBvv3RkOn5nDgJcyhW5Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA65110379;
        Wed, 15 May 2019 04:35:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: hv: Add pci_destroy_slot() in" failed to apply to 4.14-stable tree
To:     decui@microsoft.com, lorenzo.pieralisi@arm.com,
        mikelley@microsoft.com, stephen@networkplumber.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 May 2019 10:35:36 +0200
Message-ID: <155790933699245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 340d455699400f2c2c0f9b3f703ade3085cdb501 Mon Sep 17 00:00:00 2001
From: Dexuan Cui <decui@microsoft.com>
Date: Mon, 4 Mar 2019 21:34:49 +0000
Subject: [PATCH] PCI: hv: Add pci_destroy_slot() in
 pci_devices_present_work(), if necessary

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

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index b489412e3502..82acd6155adf 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1776,6 +1776,10 @@ static void pci_devices_present_work(struct work_struct *work)
 		hpdev = list_first_entry(&removed, struct hv_pci_dev,
 					 list_entry);
 		list_del(&hpdev->list_entry);
+
+		if (hpdev->pci_slot)
+			pci_destroy_slot(hpdev->pci_slot);
+
 		put_pcichild(hpdev);
 	}
 

