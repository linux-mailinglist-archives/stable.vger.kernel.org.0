Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AFB37C5F1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhELPoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236145AbhELPkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:40:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F6C861C78;
        Wed, 12 May 2021 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832864;
        bh=Yi7a76Xqz2dyROR/LuHq02uv2UfJ5IpCohE1rMnHwTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdmxaWmk6DFXiUfE3MGzvJF00XiUVRNtG2BPYinmsmuZvMTFNlV3a9Y1Vl5tBhv9U
         qq1unlmkqtG+UsAeO1K/841NJAj7adVDUJOcFwLyvpGvs9ujkynCdxnvEyv0mDsMjz
         ZHWj94CCVbG4tUeYtKXvbPWq10OTeHYrGoQ2xI68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 455/530] powerpc/pseries: extract host bridge from pci_bus prior to bus removal
Date:   Wed, 12 May 2021 16:49:25 +0200
Message-Id: <20210512144834.720456485@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index f9ae17e8a0f4..a8f9140a24fa 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -50,6 +50,7 @@ EXPORT_SYMBOL_GPL(init_phb_dynamic);
 int remove_phb_dynamic(struct pci_controller *phb)
 {
 	struct pci_bus *b = phb->bus;
+	struct pci_host_bridge *host_bridge = to_pci_host_bridge(b->bridge);
 	struct resource *res;
 	int rc, i;
 
@@ -76,7 +77,8 @@ int remove_phb_dynamic(struct pci_controller *phb)
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



