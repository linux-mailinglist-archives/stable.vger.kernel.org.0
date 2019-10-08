Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1480CCFFA7
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfJHRSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:18:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47239 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbfJHRSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:18:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5BF94215B2;
        Tue,  8 Oct 2019 13:18:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=e7nIqA
        GYTEHX3cnK504Y5tn0tQTLFB2V1flEamxbcPQ=; b=JkILFG7a0+uiZ7KGreYcAN
        Dne//MGz3kO8oDpxKh38aVd4h1rgYy74YF639OQe6VrD1HQLUSJTu0hRHjVw/koO
        7M8d3rCHXmnJRGYLCL9LlQPQrGgaFXO8cTobxACxPey/ucnckJVq0KcRO2YSiRhB
        gQOSRgdBGKocT3uYzprnqrQpitB6iQhxNyIw8e/z0WmtPpSzy7Qa1A1CsrcxnAVr
        Fmwk0XZTR6FAAkSjTVQj8TBnzjffwTwTZp+U0i3JYP1VJkf+dC77QtwZss5Wum+j
        sJQv2vbS9FgqShVZnUFPpMA1iPbSxwngnsE5/iHW4OTlSRtk90eb1qFa8qjTCBfA
        ==
X-ME-Sender: <xms:9cScXcmKut4M-jxOcJ4PA7mBkXcKr_UoWTsOe2KeOgEK1PDNgWItwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:9cScXdsVWBBAp77pQojQ3sbzvicq5aRqUG9mstqd6ExDeSrqGrUxCA>
    <xmx:9cScXfRMyDMeE0a7QC3kKoA7oM-E4VN45maVA46sQNvf7gUS7XPTog>
    <xmx:9cScXXFExR1igyWJiiiUGLDKOA3GHPuubOhF4CeAYS3UitJRxBNuDg>
    <xmx:9sScXUsO3WVKeUJ1_AKabJBp2RERgkROupMeh3ohbprVXa8KLvjv0Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9F85D60057;
        Tue,  8 Oct 2019 13:18:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it" failed to apply to 4.19-stable tree
To:     decui@microsoft.com, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:18:44 +0200
Message-ID: <157055512417249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 533ca1feed98b0bf024779a14760694c7cb4d431 Mon Sep 17 00:00:00 2001
From: Dexuan Cui <decui@microsoft.com>
Date: Fri, 2 Aug 2019 22:50:20 +0000
Subject: [PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it

The slot must be removed before the pci_dev is removed, otherwise a panic
can happen due to use-after-free.

Fixes: 15becc2b56c6 ("PCI: hv: Add hv_pci_remove_slots() when we unload the driver")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 40b625458afa..2b53976cd9f9 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2701,8 +2701,8 @@ static int hv_pci_remove(struct hv_device *hdev)
 		/* Remove the bus from PCI's point of view. */
 		pci_lock_rescan_remove();
 		pci_stop_root_bus(hbus->pci_bus);
-		pci_remove_root_bus(hbus->pci_bus);
 		hv_pci_remove_slots(hbus);
+		pci_remove_root_bus(hbus->pci_bus);
 		pci_unlock_rescan_remove();
 		hbus->state = hv_pcibus_removed;
 	}

