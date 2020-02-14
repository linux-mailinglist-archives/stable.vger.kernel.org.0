Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5F615EA0F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403888AbgBNQN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:13:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403879AbgBNQN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22222246B7;
        Fri, 14 Feb 2020 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696807;
        bh=QhMSiDaFxU/eFY7V8DeABZVM+LAdtNWFTzs+OeJHYFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgJpb4mbLEuez26OzYjIlGCLTr3I5W6STMrtkPLAjwoujGmgwhTIJ3Cn7L1DkrEHH
         ypY4PgpyD3HUJMLxsfMF43xpKNJV+wsfM2wRVx+eKEnPoypsJwqsjyKYN6856w3SjF
         FbgCZYq+W6dDObClWzmjYJ/QGwC58X3XuDvK4puE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 078/252] PCI/IOV: Fix memory leak in pci_iov_add_virtfn()
Date:   Fri, 14 Feb 2020 11:08:53 -0500
Message-Id: <20200214161147.15842-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 8c386cc817878588195dde38e919aa6ba9409d58 ]

In the implementation of pci_iov_add_virtfn() the allocated virtfn is
leaked if pci_setup_device() fails. The error handling is not calling
pci_stop_and_remove_bus_device(). Change the goto label to failed2.

Fixes: 156c55325d30 ("PCI: Check for pci_setup_device() failure in pci_iov_add_virtfn()")
Link: https://lore.kernel.org/r/20191125195255.23740-1-navid.emamdoost@gmail.com
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index c5f3cd4ed766f..c3b0b10f95cb6 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -188,10 +188,10 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
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
 
@@ -199,11 +199,10 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 
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
-- 
2.20.1

