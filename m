Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5F71CAD84
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgEHNCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbgEHMug (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9DFE2495C;
        Fri,  8 May 2020 12:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942235;
        bh=dH39vX1jFQ/TFkb+BTCWZyIAmD9Vcg+f2I8YszPGVZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkYRF2hi27enzkp8d26mRWdCveNvNmRlaWgcCJufIpiq4Dalk48QJtU5m1B1OgPjs
         2Z/V3R5n3sImhQqpwGxkvNKQRGDGhHNw9dd5VyqbPThauEIyKaj0kOD/ojPoo1R1En
         vNVD3cfhb4g8skpVO5+5o54Vq+Aiu4bX3rz1Jyq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 02/22] powerpc/pci/of: Parse unassigned resources
Date:   Fri,  8 May 2020 14:35:14 +0200
Message-Id: <20200508123034.179234373@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123033.915895060@linuxfoundation.org>
References: <20200508123033.915895060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit dead1c845dbe97e0061dae2017eaf3bd8f8f06ee upstream.

The pseries platform uses the PCI_PROBE_DEVTREE method of PCI probing
which reads "assigned-addresses" of every PCI device and initializes
the device resources. However if the property is missing or zero sized,
then there is no fallback of any kind and the PCI resources remain
undiscovered, i.e. pdev->resource[] array remains empty.

This adds a fallback which parses the "reg" property in pretty much same
way except it marks resources as "unset" which later make Linux assign
those resources proper addresses.

This has an effect when:
1. a hypervisor failed to assign any resource for a device;
2. /chosen/linux,pci-probe-only=0 is in the DT so the system may try
assigning a resource.
Neither is likely to happen under PowerVM.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/pci_of_scan.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -82,10 +82,16 @@ static void of_pci_parse_addrs(struct de
 	const __be32 *addrs;
 	u32 i;
 	int proplen;
+	bool mark_unset = false;
 
 	addrs = of_get_property(node, "assigned-addresses", &proplen);
-	if (!addrs)
-		return;
+	if (!addrs || !proplen) {
+		addrs = of_get_property(node, "reg", &proplen);
+		if (!addrs || !proplen)
+			return;
+		mark_unset = true;
+	}
+
 	pr_debug("    parse addresses (%d bytes) @ %p\n", proplen, addrs);
 	for (; proplen >= 20; proplen -= 20, addrs += 5) {
 		flags = pci_parse_of_flags(of_read_number(addrs, 1), 0);
@@ -110,6 +116,8 @@ static void of_pci_parse_addrs(struct de
 			continue;
 		}
 		res->flags = flags;
+		if (mark_unset)
+			res->flags |= IORESOURCE_UNSET;
 		res->name = pci_name(dev);
 		region.start = base;
 		region.end = base + size - 1;


