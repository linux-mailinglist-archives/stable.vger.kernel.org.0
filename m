Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6074A38A475
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhETKFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhETKBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C40C16141C;
        Thu, 20 May 2021 09:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503555;
        bh=983Ah+4uJzy0J/+o/pgnIF8hsb2hAolKtyeeyHhuRTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bs16JvNrDbd+iLkVMv4sWiyW3XeQEkBJWGtDlUXbdO+0HstOiHKG+c0szHhxj6OYi
         oU1LwV8Uij63f8Ao2tNUFta3vqyvj6GpA97R/hgziSRdbQs9Y8/dGJm4gMPB82xqsX
         9GdzhqQOji92Ujrh8cR3BUnZTGAqEg1wuRvn5lhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 274/425] powerpc/pseries: extract host bridge from pci_bus prior to bus removal
Date:   Thu, 20 May 2021 11:20:43 +0200
Message-Id: <20210520092140.444797251@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 38d0b1c9cec71e6d0f3bddef0bbce41d05a3e796 ]

The pci_bus->bridge reference may no longer be valid after
pci_bus_remove() resulting in passing a bad value to device_unregister()
for the associated bridge device.

Store the host_bridge reference in a separate variable prior to
pci_bus_remove().

Fixes: 7340056567e3 ("powerpc/pci: Reorder pci bus/bridge unregistration during PHB removal")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210211182435.47968-1-tyreld@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/pci_dlpar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index 561917fa54a8..afca4b737e80 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -66,6 +66,7 @@ EXPORT_SYMBOL_GPL(init_phb_dynamic);
 int remove_phb_dynamic(struct pci_controller *phb)
 {
 	struct pci_bus *b = phb->bus;
+	struct pci_host_bridge *host_bridge = to_pci_host_bridge(b->bridge);
 	struct resource *res;
 	int rc, i;
 
@@ -92,7 +93,8 @@ int remove_phb_dynamic(struct pci_controller *phb)
 	/* Remove the PCI bus and unregister the bridge device from sysfs */
 	phb->bus = NULL;
 	pci_remove_bus(b);
-	device_unregister(b->bridge);
+	host_bridge->bus = NULL;
+	device_unregister(&host_bridge->dev);
 
 	/* Now release the IO resource */
 	if (res->flags & IORESOURCE_IO)
-- 
2.30.2



