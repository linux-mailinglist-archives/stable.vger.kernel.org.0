Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540EFCFFA8
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfJHRS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:18:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43895 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbfJHRSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:18:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D5DF721EA7;
        Tue,  8 Oct 2019 13:18:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HJoVVU
        XFPUI/uZZgkHEnoBz95bGyKx5CBLEWBusMIsI=; b=UfxAvJmFFYrYXxhP+5WcT1
        xCmrZ1pveM4TrtY7C+XghmqNHVeJQnpnXsd1k6C95wKlnWlJ4aTEtwKnTseuNDLq
        F5C7Ggar9ACr2Lhh4RXGOxpK7CIi7dDzGtzAEDLRUHfV6oE2esv1DoB7QFkq4IH7
        ZCd82HrsPKpbeVdZ8otyanwn7GsIW4nWn3EP7a01Kp58lCvpJjIam01ngNn8b58O
        4YBPDluRg2IdDF9Trctl4/Cv2eERvWFjjnZ5VYb+S1nTON6S/fMj/j1X2DL6cbqE
        /GgwAGF9uFTzGUxCouw8B2wK6g7zpWLYp59dlWA3lf1xG8bjRTojMBP8LAED+x4A
        ==
X-ME-Sender: <xms:_sScXSJ7DTl7NFD9AsC2k61iQ67cq_sgO1vgKo0d1Kgh_7nqCY2RaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:_sScXZQ0QS_sz2Kj-8nVO1wbrX_Pv3xSVXqHLA_NxpG959TvcfxOWg>
    <xmx:_sScXXtt7n4goMNoqoB5GXsjFeh_H9uHep3KmcEZ-C0tJkWCmwrCmA>
    <xmx:_sScXW8ySXM4QQOKWDJUgHPFemwFZJB7X9wuWE2aYpJBVHHZrw0BbA>
    <xmx:_sScXXF653slPs8lXmEsPYZgMhF9cABmoWtCgKjaNpVypt0geqP3ww>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 56B3D80060;
        Tue,  8 Oct 2019 13:18:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it" failed to apply to 4.14-stable tree
To:     decui@microsoft.com, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:18:44 +0200
Message-ID: <15705551249325@kroah.com>
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

