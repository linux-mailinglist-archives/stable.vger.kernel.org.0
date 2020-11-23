Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F662C0832
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbgKWMq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:46:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387435AbgKWMqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:46:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB73E20888;
        Mon, 23 Nov 2020 12:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135583;
        bh=aWaoXTOPcF2SKrL8xvTDs9+cNXUUJ/KARa5JBebKrhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtrpDGMC4psXR6XQQ3wnOjfeJ6DPjfKGsuULMyT/37aSdmQbn4QvSjRzfORR3NSZO
         GhGyYMpn/uiTLcRV/kN3O9uU0oV1laM4D99RU8lvqjU72Bo6f8rSLdQONIjdN1E5/3
         Tzs7FkU7SdhVqb/4ni+MBoxS/K6wBCYtsfBBJt0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 121/252] RMDA/sw: Dont allow drivers using dma_virt_ops on highmem configs
Date:   Mon, 23 Nov 2020 13:21:11 +0100
Message-Id: <20201123121841.432525176@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b1e678bf290db5a76f1b6a9f7c381310e03440d6 ]

dma_virt_ops requires that all pages have a kernel virtual address.
Introduce a INFINIBAND_VIRT_DMA Kconfig symbol that depends on !HIGHMEM
and make all three drivers depend on the new symbol.

Also remove the ARCH_DMA_ADDR_T_64BIT dependency, which has been obsolete
since commit 4965a68780c5 ("arch: define the ARCH_DMA_ADDR_T_64BIT config
symbol in lib/Kconfig")

Fixes: 551199aca1c3 ("lib/dma-virt: Add dma_virt_ops")
Link: https://lore.kernel.org/r/20201106181941.1878556-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/Kconfig           | 3 +++
 drivers/infiniband/sw/rdmavt/Kconfig | 3 ++-
 drivers/infiniband/sw/rxe/Kconfig    | 2 +-
 drivers/infiniband/sw/siw/Kconfig    | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 91b023341b779..58d1c91ffe51e 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -72,6 +72,9 @@ config INFINIBAND_ADDR_TRANS_CONFIGFS
 	  This allows the user to config the default GID type that the CM
 	  uses for each device, when initiaing new connections.
 
+config INFINIBAND_VIRT_DMA
+	def_bool !HIGHMEM
+
 if INFINIBAND_USER_ACCESS || !INFINIBAND_USER_ACCESS
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
index 9ef5f5ce1ff6b..c8e268082952b 100644
--- a/drivers/infiniband/sw/rdmavt/Kconfig
+++ b/drivers/infiniband/sw/rdmavt/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config INFINIBAND_RDMAVT
 	tristate "RDMA verbs transport library"
-	depends on X86_64 && ARCH_DMA_ADDR_T_64BIT
+	depends on INFINIBAND_VIRT_DMA
+	depends on X86_64
 	depends on PCI
 	select DMA_VIRT_OPS
 	help
diff --git a/drivers/infiniband/sw/rxe/Kconfig b/drivers/infiniband/sw/rxe/Kconfig
index a0c6c7dfc1814..8810bfa680495 100644
--- a/drivers/infiniband/sw/rxe/Kconfig
+++ b/drivers/infiniband/sw/rxe/Kconfig
@@ -2,7 +2,7 @@
 config RDMA_RXE
 	tristate "Software RDMA over Ethernet (RoCE) driver"
 	depends on INET && PCI && INFINIBAND
-	depends on !64BIT || ARCH_DMA_ADDR_T_64BIT
+	depends on INFINIBAND_VIRT_DMA
 	select NET_UDP_TUNNEL
 	select CRYPTO_CRC32
 	select DMA_VIRT_OPS
diff --git a/drivers/infiniband/sw/siw/Kconfig b/drivers/infiniband/sw/siw/Kconfig
index b622fc62f2cd6..3450ba5081df5 100644
--- a/drivers/infiniband/sw/siw/Kconfig
+++ b/drivers/infiniband/sw/siw/Kconfig
@@ -1,6 +1,7 @@
 config RDMA_SIW
 	tristate "Software RDMA over TCP/IP (iWARP) driver"
 	depends on INET && INFINIBAND && LIBCRC32C
+	depends on INFINIBAND_VIRT_DMA
 	select DMA_VIRT_OPS
 	help
 	This driver implements the iWARP RDMA transport over
-- 
2.27.0



