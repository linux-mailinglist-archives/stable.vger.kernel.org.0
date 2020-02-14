Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA98E15EDF1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390107AbgBNQFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390104AbgBNQFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93F8B24676;
        Fri, 14 Feb 2020 16:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696313;
        bh=9/Od3Ngs/5RDyySrg0nbQ1N1XUHAPszVxWZksE5CG+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tO08dfPhdUVM9EPrF9fRx6lppnMlQUzcZwPQu/LGTkuOMdtxXUwhi30P5oXwkG8Sh
         zXVE6grXQHm09Q0J7S0VbM8igsWRoKM++8Y9tPeSjyDCOfa3pC2cyCM7UzeMgEbqbq
         O14qLQqaab4v2tJM6nzVhcFSh/iUx/7OvGmz86wE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 155/459] PCI/IOV: Fix memory leak in pci_iov_add_virtfn()
Date:   Fri, 14 Feb 2020 10:56:45 -0500
Message-Id: <20200214160149.11681-155-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index b3f972e8cfed6..deec9f9e0b616 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -187,10 +187,10 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
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
 
@@ -198,11 +198,10 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 
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

