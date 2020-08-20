Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA70424B216
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHTJXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgHTJXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:23:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D392222CA1;
        Thu, 20 Aug 2020 09:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915428;
        bh=+Nv6csKMBWGiy1e80R3z4GTu13tZAaLYToez1KLYUvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSymhzh1yPS8Xodu6Ebw98PWFdd76/eesMdjQJnTdKOwAKW5y7qsZpP0UL8UhSvBh
         2Oyl6MRGfALtz4m8YAlmWWC2+1uko2kg9IZHPmDNHLBdkC/m1ElNIR/aPk1o6WgNuv
         UFSfpWt20TlFSxwM0FdGq5h0qijc4Kj0UbMs1ZAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.8 010/232] PCI: Add device even if driver attach failed
Date:   Thu, 20 Aug 2020 11:17:41 +0200
Message-Id: <20200820091613.211090802@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajat Jain <rajatja@google.com>

commit 2194bc7c39610be7cabe7456c5f63a570604f015 upstream.

device_attach() returning failure indicates a driver error while trying to
probe the device. In such a scenario, the PCI device should still be added
in the system and be visible to the user.

When device_attach() fails, merely warn about it and keep the PCI device in
the system.

This partially reverts ab1a187bba5c ("PCI: Check device_attach() return
value always").

Link: https://lore.kernel.org/r/20200706233240.3245512-1-rajatja@google.com
Signed-off-by: Rajat Jain <rajatja@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org	# v4.6+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/bus.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -322,12 +322,8 @@ void pci_bus_add_device(struct pci_dev *
 
 	dev->match_driver = true;
 	retval = device_attach(&dev->dev);
-	if (retval < 0 && retval != -EPROBE_DEFER) {
+	if (retval < 0 && retval != -EPROBE_DEFER)
 		pci_warn(dev, "device attach failed (%d)\n", retval);
-		pci_proc_detach_device(dev);
-		pci_remove_sysfs_dev_files(dev);
-		return;
-	}
 
 	pci_dev_assign_added(dev, true);
 }


