Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5763615C390
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgBMPmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:42:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729584AbgBMP2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:12 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5979E2168B;
        Thu, 13 Feb 2020 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607692;
        bh=qvBnAU59iaz2bSUSla1OP9QwwdKedb4s6k3Y0PMnntM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upCu77I56irHJkik3ZQHXdTHLD6gdyvPpXZDf2WTqEDsAzV5rsfHYNo2EFr63ESaQ
         ces2h8Q2L99aJMaVjcTctgtKoFKiGqCar6ZRcM3U740CfKE4rQg+JIutjDN97wJ6Hm
         XqsyP5bRuX1nmBLKUyESjiKm3b2L4ociXtlq1e0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.5 014/120] PCI/IOV: Fix memory leak in pci_iov_add_virtfn()
Date:   Thu, 13 Feb 2020 07:20:10 -0800
Message-Id: <20200213151906.648052496@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 8c386cc817878588195dde38e919aa6ba9409d58 upstream.

In the implementation of pci_iov_add_virtfn() the allocated virtfn is
leaked if pci_setup_device() fails. The error handling is not calling
pci_stop_and_remove_bus_device(). Change the goto label to failed2.

Fixes: 156c55325d30 ("PCI: Check for pci_setup_device() failure in pci_iov_add_virtfn()")
Link: https://lore.kernel.org/r/20191125195255.23740-1-navid.emamdoost@gmail.com
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/iov.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -186,10 +186,10 @@ int pci_iov_add_virtfn(struct pci_dev *d
 	sprintf(buf, "virtfn%u", id);
 	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
 	if (rc)
-		goto failed2;
+		goto failed1;
 	rc = sysfs_create_link(&virtfn->dev.kobj, &dev->dev.kobj, "physfn");
 	if (rc)
-		goto failed3;
+		goto failed2;
 
 	kobject_uevent(&virtfn->dev.kobj, KOBJ_CHANGE);
 
@@ -197,11 +197,10 @@ int pci_iov_add_virtfn(struct pci_dev *d
 
 	return 0;
 
-failed3:
-	sysfs_remove_link(&dev->dev.kobj, buf);
 failed2:
-	pci_stop_and_remove_bus_device(virtfn);
+	sysfs_remove_link(&dev->dev.kobj, buf);
 failed1:
+	pci_stop_and_remove_bus_device(virtfn);
 	pci_dev_put(dev);
 failed0:
 	virtfn_remove_bus(dev->bus, bus);


