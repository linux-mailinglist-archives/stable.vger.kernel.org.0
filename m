Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540391EA34
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 10:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfEOIee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 04:34:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53131 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbfEOIee (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 04:34:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CB52F2593A;
        Wed, 15 May 2019 04:34:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 15 May 2019 04:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=C8+ftm
        irWCQLKNZ3voVv1UcF7L7mHJXMuspS++VK7Vk=; b=lMQmftvwZT8tYoZF98hgFs
        PAH2VP9mkNYB4HUOiN462V+LsQZK0tvWd2SBQdzrIP5d7T+Z32w30uyhEYRRY0tY
        taMJ5KkB6gyl6LgQZITtUUR640w7zUgAyspk29xmQoq8iR7fXYAsM7z6IULJ+Hd+
        QlSdgjzQxWwihdPTce84d7fWRCRNHxXYMtQgawrveCF+NiBu7mXuBhJ5ZZgRwdq6
        vYnKJzm9tylF6Ybs6s5hWait5rKLTXXIspBVe3Vr8xCDteDptsxDgNb7AewKRrpj
        EIwEFegYaY1eFGoJiXyFCdWRz1rJ+OtrJ2N2PrlAcjCQQ8CZmEwc0iEOxYRywFKg
        ==
X-ME-Sender: <xms:GM_bXJiueUHdRjJX5RRTJq_3hPb53uvAEkb4DK-kbZMbUMm_nO0t2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:GM_bXPM57zSHcifw3uqB5eBwSqbn_fzcQ2G5fqQ8f2eSXvnN4raueg>
    <xmx:GM_bXJjoqoKZQbnvgwb5fErIPNqwD6v0gf9K3hccmrA4K7YT7lh6Tw>
    <xmx:GM_bXHocKegBfaEAXSAJb_kZdkAXrHmJOr8w7__j0GdCUQ4syquRVQ>
    <xmx:GM_bXNyd8zbPZB3-AR9wFhZwPJQ0lMz89Tpoxm7qcwXYuQGqk2VA4g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B422480063;
        Wed, 15 May 2019 04:34:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in hv_eject_device_work()" failed to apply to 4.14-stable tree
To:     decui@microsoft.com, lorenzo.pieralisi@arm.com,
        mikelley@microsoft.com, stephen@networkplumber.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 May 2019 10:34:30 +0200
Message-ID: <1557909270643@kroah.com>
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

From 05f151a73ec2b23ffbff706e5203e729a995cdc2 Mon Sep 17 00:00:00 2001
From: Dexuan Cui <decui@microsoft.com>
Date: Mon, 4 Mar 2019 21:34:48 +0000
Subject: [PATCH] PCI: hv: Fix a memory leak in hv_eject_device_work()

When a device is created in new_pcichild_device(), hpdev->refs is set
to 2 (i.e. the initial value of 1 plus the get_pcichild()).

When we hot remove the device from the host, in a Linux VM we first call
hv_pci_eject_device(), which increases hpdev->refs by get_pcichild() and
then schedules a work of hv_eject_device_work(), so hpdev->refs becomes
3 (let's ignore the paired get/put_pcichild() in other places). But in
hv_eject_device_work(), currently we only call put_pcichild() twice,
meaning the 'hpdev' struct can't be freed in put_pcichild().

Add one put_pcichild() to fix the memory leak.

The device can also be removed when we run "rmmod pci-hyperv". On this
path (hv_pci_remove() -> hv_pci_bus_exit() -> hv_pci_devices_present()),
hpdev->refs is 2, and we do correctly call put_pcichild() twice in
pci_devices_present_work().

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
[lorenzo.pieralisi@arm.com: commit log rework]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 95441a35eceb..30f16b882746 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1900,6 +1900,9 @@ static void hv_eject_device_work(struct work_struct *work)
 			 sizeof(*ejct_pkt), (unsigned long)&ctxt.pkt,
 			 VM_PKT_DATA_INBAND, 0);
 
+	/* For the get_pcichild() in hv_pci_eject_device() */
+	put_pcichild(hpdev);
+	/* For the two refs got in new_pcichild_device() */
 	put_pcichild(hpdev);
 	put_pcichild(hpdev);
 	put_hvpcibus(hpdev->hbus);

