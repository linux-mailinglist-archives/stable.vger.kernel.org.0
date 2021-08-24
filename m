Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1CB3F655D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbhHXRMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240217AbhHXRKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D2161A54;
        Tue, 24 Aug 2021 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824438;
        bh=m+7RuSKkmVUu1bWJksew/GfDwO9Wf6orU4muYIl8A14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J44vF1/IMYJ7tRn7aToeKzg8hQZhbihtqRv/Yj4a7EuFQuN4IyjXC2qwP11DU6U0A
         Mz2IdARIpY9cKeQUDlbAICyb8fgGXvW8VpiDmTE2RT+UAV9lqiYuDBgb7hw5KlTIqx
         uy8HETBjPGemRdw7z0FCiJMzDMcmrvPiMBz1UQTcmTjKeKACFMYATLE8fwLSN1ZTNQ
         g1OLHyrIpXxy3xhBN8khuegg3LWeKFB0lmoUAPBkFee/fDstwUKOpEwv5G6TYDSm/N
         ETpsSFofMjG1SN4vZ2Sx2yR6wSVzdRdWzDAfxe9YCZ5yt0UZ+a63UhhvfFxtAYY5sl
         TAJ/m0B2/3B9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 90/98] s390/pci: fix use after free of zpci_dev
Date:   Tue, 24 Aug 2021 12:59:00 -0400
Message-Id: <20210824165908.709932-91-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 2a671f77ee49f3e78997b77fdee139467ff6a598 ]

The struct pci_dev uses reference counting but zPCI assumed erroneously
that the last reference would always be the local reference after
calling pci_stop_and_remove_bus_device(). This is usually the case but
not how reference counting works and thus inherently fragile.

In fact one case where this causes a NULL pointer dereference when on an
SRIOV device the function 0 was hot unplugged before another function of
the same multi-function device. In this case the second function's
pdev->sriov->dev reference keeps the struct pci_dev of function 0 alive
even after the unplug. This bug was previously hidden by the fact that
we were leaking the struct pci_dev which in turn means that it always
outlived the struct zpci_dev. This was fixed in commit 0b13525c20fe
("s390/pci: fix leak of PCI device structure") exposing the broken
behavior.

Fix this by accounting for the long living reference a struct pci_dev
has to its underlying struct zpci_dev via the zbus->function[] array and
only release that in pcibios_release_device() ensuring that the struct
pci_dev is not left with a dangling reference. This is a minimal fix in
the future it would probably better to use fine grained reference
counting for struct zpci_dev.

Fixes: 05bc1be6db4b2 ("s390/pci: create zPCI bus")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c     | 6 ++++++
 arch/s390/pci/pci_bus.h | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 1ae7a76ae97b..ca1a105e3b5d 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -558,9 +558,12 @@ static void zpci_cleanup_bus_resources(struct zpci_dev *zdev)
 
 int pcibios_add_device(struct pci_dev *pdev)
 {
+	struct zpci_dev *zdev = to_zpci(pdev);
 	struct resource *res;
 	int i;
 
+	/* The pdev has a reference to the zdev via its bus */
+	zpci_zdev_get(zdev);
 	if (pdev->is_physfn)
 		pdev->no_vf_scan = 1;
 
@@ -580,7 +583,10 @@ int pcibios_add_device(struct pci_dev *pdev)
 
 void pcibios_release_device(struct pci_dev *pdev)
 {
+	struct zpci_dev *zdev = to_zpci(pdev);
+
 	zpci_unmap_resources(pdev);
+	zpci_zdev_put(zdev);
 }
 
 int pcibios_enable_device(struct pci_dev *pdev, int mask)
diff --git a/arch/s390/pci/pci_bus.h b/arch/s390/pci/pci_bus.h
index f8dfac0b5b71..55c9488e504c 100644
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -16,6 +16,11 @@ static inline void zpci_zdev_put(struct zpci_dev *zdev)
 	kref_put(&zdev->kref, zpci_release_device);
 }
 
+static inline void zpci_zdev_get(struct zpci_dev *zdev)
+{
+	kref_get(&zdev->kref);
+}
+
 int zpci_alloc_domain(int domain);
 void zpci_free_domain(int domain);
 int zpci_setup_bus_resources(struct zpci_dev *zdev,
-- 
2.30.2

