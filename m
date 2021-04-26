Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2F936AD83
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhDZHhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhDZHgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E9A7613AC;
        Mon, 26 Apr 2021 07:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422449;
        bh=EiHFpLuxW3ghO4GDZxL4kYQuqcCf8ky3ZOv7zoGn01E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaE/uNLQYyibS31mitOD8zmqKXVM2GdJDGFPVKKEMp8syyHvzbnLHKzgJ1P1nzFXz
         W0BSJ7/lsqxJMGHd6iW1B21fmEMpJW+hlvuMG4lW8ZQqCfrlHivLTGsGkFZv903PGs
         LXx2nwjB+Vceb67sQeqZH7pNsIi/q/SwIw7N1jTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/49] pcnet32: Use pci_resource_len to validate PCI resource
Date:   Mon, 26 Apr 2021 09:29:13 +0200
Message-Id: <20210426072820.304530054@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 66c3f05ddc538ee796321210c906b6ae6fc0792a ]

pci_resource_start() is not a good indicator to determine if a PCI
resource exists or not, since the resource may start at address 0.
This is seen when trying to instantiate the driver in qemu for riscv32
or riscv64.

pci 0000:00:01.0: reg 0x10: [io  0x0000-0x001f]
pci 0000:00:01.0: reg 0x14: [mem 0x00000000-0x0000001f]
...
pcnet32: card has no PCI IO resources, aborting

Use pci_resouce_len() instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pcnet32.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1548,8 +1548,7 @@ pcnet32_probe_pci(struct pci_dev *pdev,
 	}
 	pci_set_master(pdev);
 
-	ioaddr = pci_resource_start(pdev, 0);
-	if (!ioaddr) {
+	if (!pci_resource_len(pdev, 0)) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("card has no PCI IO resources, aborting\n");
 		return -ENODEV;
@@ -1561,6 +1560,8 @@ pcnet32_probe_pci(struct pci_dev *pdev,
 			pr_err("architecture does not support 32bit PCI busmaster DMA\n");
 		return err;
 	}
+
+	ioaddr = pci_resource_start(pdev, 0);
 	if (!request_region(ioaddr, PCNET32_TOTAL_SIZE, "pcnet32_probe_pci")) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("io address range already allocated\n");


