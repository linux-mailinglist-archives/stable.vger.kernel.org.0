Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419A71EA35
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 10:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfEOIel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 04:34:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37093 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbfEOIel (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 04:34:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D637E25749;
        Wed, 15 May 2019 04:34:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 15 May 2019 04:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fmHslR
        xeRUtqECcn7t0vxX+zKcVSQsU3/bV1nfC/bxE=; b=WVhUO4nfwTXPfFKzvxXwCh
        cQwHCvJCAoxvoYKcr9pCNV3iE7dFNUcgWDhZ7mcHLR+syxZWaj/jyrkthINQJ1aj
        1VlUZC5mkWDv89ZTqx/dCu03O/JyRF8cvqHTsfY/hw6vNQAdn4zhqy+gcuiEjKDz
        LusE9JF4weFzJ5+jmrnBwI6n0VbCNNtfxiae/r3MTc/9FPJqihGFGyTfbKL0l4lU
        tDT+j9GtSYyzDUtEZEdwMbZtNLmEjk0Z79joIWXi/xSH6z0fl/wmDNFFBXE7tRnE
        0NfJFEQOMM83EcaSHbAQ3dRZznvKe9pt7UmWkY0ltT16bviwDS2uqtuh2HXzb6MQ
        ==
X-ME-Sender: <xms:IM_bXGxWwD2blfjERJvdXGeb4kuyBXUpgeFGZlwvAYFUvdRjs4U3Jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:IM_bXJ8D35mhQbQHH20k56FSTaqEBXIaT86h7Ng9ShUcRGzoLT2pkA>
    <xmx:IM_bXOL6Z1_LaK-bDmCrWSZrvjsKNuvOUNU8abtOIHpgbMvm10bclA>
    <xmx:IM_bXN4g1ymXC2v_oBl4566N9oYtlfdz2HNK1TW-Ab-vBSG6mALEKA>
    <xmx:IM_bXDrcFa-L1P5rd7U3QmXP_N-WaKeGrf7I75nru-xqyVvbcDO4GQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F55B80068;
        Wed, 15 May 2019 04:34:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in hv_eject_device_work()" failed to apply to 4.9-stable tree
To:     decui@microsoft.com, lorenzo.pieralisi@arm.com,
        mikelley@microsoft.com, stephen@networkplumber.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 May 2019 10:34:31 +0200
Message-ID: <1557909271235151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

