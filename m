Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C4115F39D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393103AbgBNSNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbgBNPwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 515812468A;
        Fri, 14 Feb 2020 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695566;
        bh=LKazQmzZFp6zCDU2QFhtNkSGnhQirky8emj0Km7yVus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcKiWLPXAxNcx52ot4tPGuRQpIaE0QNi5yH9XG11cgCPh7pWw33+XTHGmPYnmmEaB
         DyeJHgkaB7eEmMiV2NymGMrQvRRMcQKw5s3YqzHePWyQ5oCCLMkdU8fUp2JztMae93
         jXr16u2b5Ze2AdznqTnNyy+ui+/lYJAIWXijL53M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 178/542] PCI/IOV: Fix memory leak in pci_iov_add_virtfn()
Date:   Fri, 14 Feb 2020 10:42:50 -0500
Message-Id: <20200214154854.6746-178-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index 1e88fd4277578..4d1f392b05f9a 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -186,10 +186,10 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
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
 
@@ -197,11 +197,10 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 
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

