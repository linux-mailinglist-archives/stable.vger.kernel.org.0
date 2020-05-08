Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53311CAB16
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgEHMjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbgEHMjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ACEE20731;
        Fri,  8 May 2020 12:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941581;
        bh=+Sp64hyyp7pP9nnZlHmICQofI6C8aT+oJZ9LVNIVlbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIh4urFKjbQtSzUTMOHxI1Msq22eOAXB6WkeS+qjD1ztFqt16XyMV05vc+ap9dnqy
         6WsWmkPZ87E2GroePFjWQmbW0YlpubZUIYLmy6TtGNQHsu40StUWidttKVr60dEpW7
         85HxC+uaaOCl3XPJJDbNa2K0rIP9BRSjWXgJpyBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 4.4 062/312] alpha/PCI: Call iomem_is_exclusive() for IORESOURCE_MEM, but not IORESOURCE_IO
Date:   Fri,  8 May 2020 14:30:53 +0200
Message-Id: <20200508123128.913524348@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit c20e128030caf0537d5e906753eac1c28fefdb75 upstream.

The alpha pci_mmap_resource() is used for both IORESOURCE_MEM and
IORESOURCE_IO resources, but iomem_is_exclusive() is only applicable for
IORESOURCE_MEM.

Call iomem_is_exclusive() only for IORESOURCE_MEM resources, and do it
earlier to match the generic version of pci_mmap_resource().

Fixes: 10a0ef39fbd1 ("PCI/alpha: pci sysfs resources")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/alpha/kernel/pci-sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/pci-sysfs.c
+++ b/arch/alpha/kernel/pci-sysfs.c
@@ -77,10 +77,10 @@ static int pci_mmap_resource(struct kobj
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
-	if (!__pci_mmap_fits(pdev, i, vma, sparse))
+	if (res->flags & IORESOURCE_MEM && iomem_is_exclusive(res->start))
 		return -EINVAL;
 
-	if (iomem_is_exclusive(res->start))
+	if (!__pci_mmap_fits(pdev, i, vma, sparse))
 		return -EINVAL;
 
 	pcibios_resource_to_bus(pdev->bus, &bar, res);


