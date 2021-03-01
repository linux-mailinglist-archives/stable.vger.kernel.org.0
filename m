Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8957D328A7A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbhCASRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239048AbhCASLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C9B964FAD;
        Mon,  1 Mar 2021 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620046;
        bh=DRL8Qftwm1Qrd2JQGS5Zl6XByw9sbS+8gog7OZHIZ1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDLTPkxpv38kNGe+J/SGaYThVaYKvLYwEPd09+yNN5U7aW10pUpdbsyvRH6ZEsRMo
         rfch9PeuznfdnV5j0H/Smd591rE5qwCXNxWRjplAWZosPVgUK9x3YQFc9ZpE7IQ9tr
         DPr12mwWNt5Gd2EeB4w1pvt8IVzHSKmYsQlG/ZHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.11 011/775] PCI: Decline to resize resources if boot config must be preserved
Date:   Mon,  1 Mar 2021 17:02:59 +0100
Message-Id: <20210301161202.265285771@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 729e3a669d1b62e9876a671ac03ccba399a23b68 upstream.

The _DSM #5 method in the ACPI host bridge object tells us whether the OS
must preserve the resource assignments done by firmware. If this is the
case, we should not permit drivers to resize BARs on the fly. Make
pci_resize_resource() take this into account.

Link: https://lore.kernel.org/r/20210109095353.13417-1-ardb@kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v5.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-res.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -410,10 +410,16 @@ EXPORT_SYMBOL(pci_release_resource);
 int pci_resize_resource(struct pci_dev *dev, int resno, int size)
 {
 	struct resource *res = dev->resource + resno;
+	struct pci_host_bridge *host;
 	int old, ret;
 	u32 sizes;
 	u16 cmd;
 
+	/* Check if we must preserve the firmware's resource assignment */
+	host = pci_find_host_bridge(dev->bus);
+	if (host->preserve_config)
+		return -ENOTSUPP;
+
 	/* Make sure the resource isn't assigned before resizing it. */
 	if (!(res->flags & IORESOURCE_UNSET))
 		return -EBUSY;


